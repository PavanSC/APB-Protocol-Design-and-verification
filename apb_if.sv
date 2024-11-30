interface apb_intf(input bit pclk);
    // APB signals
    logic [31:0]  paddr;
    logic         pwrite;
    logic         psel;
    logic         penable;
    logic [31:0]  pwdata;
    logic [31:0]  prdata;
    logic         pready;
    logic         pslverr;
    logic presetn;

    // Clocking block for synchronization
    clocking drv_cb @(posedge pclk);
        output paddr, pwrite, psel, penable, pwdata;
        input  prdata, pready, pslverr;
    endclocking
	
	clocking mon_cb @(posedge pclk);
         input paddr,psel,penable,prdata,pwrite,pwdata;
        endclocking

modport DRV_MP(clocking drv_cb);
modport MON_mp(clocking mon_cb);

endinterface



