class transaction;

rand bit rd , wr;
bit full, empty;
rand bit [7:0] data_in;
bit [7:0] data_out;

constraint wr_rd {
    wr != rd;
  	wr dist {0 :/ 1, 1 :/ 99};
    rd dist {0 :/ 50, 1 :/ 50};
}
  
/*constraint wr_rd {
    wr != rd;
  	wr dist {0 :/ 50, 1 :/ 50};
    rd dist {0 :/ 50, 1 :/ 50};
}*/

constraint data_con {
  data_in inside {[0:255]};  
}

function void display(string tag);
  $display("[%0s] wr = %0b \t rd = %0b \t datawritten = %0d \t dataread = %0d \t full = %0b \t empty = %0b \t @ %0t", tag,wr,rd,data_in,data_out,full,empty,$time);
endfunction

function transaction copy();
    copy = new();
    copy.wr = this.wr;
    copy.rd = this.rd;
    copy.full = this.full;
    copy.empty = this.empty;
    copy.data_in = this.data_in;
    copy.data_out = this.data_out;
endfunction

endclass

class generator;
    transaction trans;
    mailbox #(transaction) mbx;

    int count = 0;

    event next;
    event done;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        trans = new();
    endfunction

    task run();
        repeat(count)
        begin
            assert(trans.randomize()) else $error("Randomization Failed!");
            mbx.put(trans.copy);
            trans.display("GEN");
            @(next);
        end

        -> done;
    endtask
endclass

class driver;
    virtual fifo_if fif;
    transaction trans;
    mailbox #(transaction) mbx;
    
    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task reset();
        fif.rst <= 1'b1;
        fif.rd <= 1'b0;
        fif.wr <= 1'b0;
        fif.data_in <= 0;
        repeat(5) @(posedge fif.clock);
        fif.rst <= 1'b0;
        $display("DUT RESET");
    endtask

    task run();
        forever begin
            mbx.get(trans);
            trans.display("DRV");
            fif.wr <= trans.wr;
            fif.rd <= trans.rd;
            fif.data_in <= trans.data_in;
            repeat(2) @(posedge fif.clock);
        end
    endtask
endclass

class monitor;
    virtual fifo_if fif;
    transaction trans;
    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        trans = new();

        forever begin
            repeat(2) @(posedge fif.clock);
            trans.rd = fif.rd;
            trans.wr = fif.wr;
            trans.data_in = fif.data_in;
            trans.data_out = fif.data_out;
            trans.full = fif.full;
            trans.empty = fif.empty;
            mbx.put(trans);
            trans.display("MON");
        end

    endtask
endclass

class scoreboard;
    transaction trans;
    mailbox #(transaction) mbx;
    event next;
    bit [7:0] din [$];
    bit [7:0] temp;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

    task run();
        forever begin
            mbx.get(trans);
            trans.display("SCO");

            if (trans.wr == 1'b1) begin

                if(trans.full == 1'b0)begin
                    din.push_front(trans.data_in);
                    $display("[SOC] %0d pushed in front of the queue", trans.data_in);
                end
                else $error("MEMORY FULL!");
            end

          if(trans.rd == 1'b1) begin

                if(trans.empty == 1'b1) 
                    $display("MEMORY EMPTY!");
                else begin

                        temp = din.pop_back();
                        if(trans.data_out == temp)
                            $display("DATA MATCH!");
                        else    
                            $error("DATA MISMATCH!");
                     end

            end
            
            -> next;
        end
    endtask
endclass


class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco;
    mailbox #(transaction) gdmbx;
    mailbox #(transaction) msmbx;
    event nextgs;
    virtual fifo_if fif;

  function new(virtual fifo_if fif);
        gdmbx = new();
        gen = new(gdmbx);
        drv = new(gdmbx);

        msmbx = new();
        mon = new(msmbx);
        sco = new(msmbx);

        this.fif = fif;

        drv.fif = this.fif;
        mon.fif = this.fif;

        gen.next = nextgs;
        sco.next = nextgs;
    endfunction


    task pre_test();
        drv.reset();
    endtask

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            sco.run();
        join_any
    endtask

    task post_test();
        wait(gen.done.triggered);
        $finish;
    endtask

    task run();
        pre_test();
        test();
        post_test();
    endtask

endclass


module tb;
    environment env;
    fifo_if fif();

    fifo dut (fif.clock, fif.rd, fif.wr, fif.full, fif.empty, fif.data_in, fif.data_out, fif.rst);

    initial begin
        fif.clock <= 0;
    end

    always #10 fif.clock <= ~fif.clock;

    initial begin
        env = new(fif);
        env.gen.count = 20;
        env.run();
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule