class test extends uvm_test;
    `uvm_component_utils(test)

    env envh;
function new(string name="test",uvm_component parent =null);
 super.new(name,parent);
endfunction

    function void build_phase(uvm_phase phase);
       super.build_phase(phase);
         envh = env::type_id::create("envh", this);
    endfunction

    task run_phase(uvm_phase phase);
        // Create and start sequences
seq seqh;
        seqh = seq::type_id::create("seqh");
        
        phase.raise_objection(this);
        seqh.start(envh.agth.seqrh);
        phase.drop_objection(this);
    endtask
endclass



class wtest extends uvm_test;
    `uvm_component_utils(wtest)

    env envh;

function new(string name="wtest",uvm_component parent =null);
 super.new(name,parent);
endfunction

    function void build_phase(uvm_phase phase);
       super.build_phase(phase);
         envh = env::type_id::create("envh", this);
    endfunction

    task run_phase(uvm_phase phase);
        // Create and start sequences
wseq seqh;
         seqh = wseq::type_id::create("seqh");
        
        phase.raise_objection(this);
        seqh.start(envh.agth.seqrh);
        phase.drop_objection(this);
    endtask
endclass



class rtest extends uvm_test;
    `uvm_component_utils(rtest)

    env envh;

function new(string name="rtest",uvm_component parent =null);
 super.new(name,parent);
endfunction

    function void build_phase(uvm_phase phase);
       super.build_phase(phase);
         envh = env::type_id::create("envh", this);
    endfunction

    task run_phase(uvm_phase phase);
        // Create and start sequences
rseq seqh;
        seqh = rseq::type_id::create("seqh");
        
        phase.raise_objection(this);
        seqh.start(envh.agth.seqrh);
        phase.drop_objection(this);
    endtask

endclass