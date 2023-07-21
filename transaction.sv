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