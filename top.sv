module top ();

import uvm_pkg::*;
import apb_pkg::*;

bit pclk;

always #5 pclk = ~pclk;

apb_intf if1(pclk);
apb_slave DUT(.pclk(pclk), .presetn(if1.presetn), .penable(if1.penable), .pready(if1.pready), .pwrite(if1.pwrite), .paddr(if1.paddr), .pwdata(if1.pwdata), .prdata(if1.prdata), .pslverr(if1.pslverr), .psel(if1.psel)) ;

initial begin
 uvm_config_db#(virtual apb_intf)::set(null,"*","apb", if1);

run_test();
end

initial begin
        // Initialize signals
        if1.presetn = 0;
        pclk = 0;

        // Generate reset
        #10 if1.presetn = 1;
    end

 

property enable;
@(posedge pclk) $rose(if1.pwrite) |=> $rose(if1.psel) |=> $rose(if1.penable);
endproperty

assert property (enable);


 property write_stable;
        @(posedge pclk) disable iff(!if1.presetn)
        (if1.psel && if1.penable) |-> $stable(if1.pwrite);
    endproperty

 assert property(write_stable);

endmodule