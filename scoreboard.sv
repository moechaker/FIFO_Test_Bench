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
