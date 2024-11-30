class env extends uvm_env;
    // UVM Utility Macro
    `uvm_component_utils(env)

    agent       agth;
    scoreboard      sbh;
 
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agth = agent::type_id::create("agth", this);

            sbh = scoreboard::type_id::create("sbh", this);
        endfunction

    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

            agth.monh.mp.connect(sbh.mon_export);
    endfunction


endclass


