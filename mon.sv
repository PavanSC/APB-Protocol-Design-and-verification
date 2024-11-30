class mon extends uvm_monitor;
    `uvm_component_utils(mon)

    // Virtual interface
    virtual apb_intf vif;


    uvm_analysis_port #(apb_trans) mp;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        mp = new("mp", this);
    endfunction



    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual apb_intf)::get(this, "", "apb", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction



    task run_phase(uvm_phase phase);
  forever begin
	apb_trans tr;

	do begin
 	 @(vif.mon_cb);
        end
        while (vif.mon_cb.psel == 0 || vif.mon_cb.penable == 1);
  
        tr = apb_trans::type_id::create("tr",this);

        tr.pwrite = vif.mon_cb.pwrite;
        tr.paddr = vif.mon_cb.paddr;

        @(vif.mon_cb);
	if(vif.mon_cb.penable==0) 
         `uvm_error("APB", "Protocol violation:Setup not followed by enable cycle");

	if(tr.pwrite==1) begin
          tr.data = vif.mon_cb.pwdata;
        end
	else begin
	  tr.data = vif.mon_cb.prdata;
	end

	uvm_report_info("APB_MON", $psprintf("Transaction obtained %s",tr.convert2string()));

	mp.write(tr);
end
endtask

    endclass