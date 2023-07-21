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