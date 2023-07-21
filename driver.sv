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