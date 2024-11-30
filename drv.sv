class drv extends uvm_driver #(apb_trans);
    `uvm_component_utils(drv)

    // Virtual interface
    virtual apb_intf vif;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Get interface from configuration database
        if(!uvm_config_db#(virtual apb_intf)::get(this, "", "apb", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);

    	vif.drv_cb.psel <=0 ;
        vif.drv_cb.penable <= 0 ;
        // Wait for reset
        @(posedge vif.presetn);

        // Main driver loop
        forever begin
 	    @(vif.drv_cb)
          
             // Get next transaction
            seq_item_port.get_next_item(req);
            @ (vif.drv_cb);
             uvm_report_info("APB_DRIVER ", $psprintf("Got Transaction %s",req.convert2string()));
           
         if(req.pwrite==0)
           read(req.paddr, req.data);
         else
           write(req.paddr, req.data);
  
          seq_item_port.item_done();

	end
endtask


task read(input bit [31:0] paddr, output logic [31:0] data);
	vif.drv_cb.paddr <= paddr ;
	vif.drv_cb.pwrite <= 0 ;
	vif.drv_cb.psel <= 1 ;
        @(vif.drv_cb);
	vif.drv_cb.penable <= 1 ;
        @(vif.drv_cb);
	data = vif.drv_cb.prdata ;
	vif.drv_cb.psel <= 0 ;
        vif.drv_cb.penable <= 0 ;
endtask

task write(input bit [31:0] paddr, input bit [31:0] data);

	vif.drv_cb.paddr <= paddr ;
	vif.drv_cb.pwdata <= data ;
	vif.drv_cb.pwrite <= 1 ;
	vif.drv_cb.psel <= 1 ;
        @(vif.drv_cb);
	vif.drv_cb.penable <= 1 ;
        @(vif.drv_cb);
	vif.drv_cb.psel <= 0 ;
        vif.drv_cb.penable <= 0 ;
endtask


endclass
