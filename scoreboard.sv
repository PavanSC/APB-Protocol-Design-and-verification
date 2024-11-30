class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp#(apb_trans, scoreboard) mon_export;
  
  apb_trans exp_queue[$];
  
  bit [31:0] sc_mem [0:256];
  
 bit [31:0] addr;
  bit [31:0] data;
  
  covergroup apb_cover;
    coverpoint addr {
      bins a[16] = {[0:15]};
    }
    
  endgroup



  function new(string name, uvm_component parent);
    super.new(name,parent);
    mon_export = new("mon_export", this);
    apb_cover = new;
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach(sc_mem[i]) sc_mem[i] = i;
  endfunction
  
  function void write(apb_trans tr);
    //tr.print();
    addr = tr.paddr;
    data = tr.data;
    apb_cover.sample();
    exp_queue.push_back(tr);
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    //super.run_phase(phase);
    apb_trans expdata;
    
    forever begin
      wait(exp_queue.size() > 0);
      expdata = exp_queue.pop_front();
      
      if(expdata.pwrite == 1) begin
        sc_mem[expdata.paddr] = expdata.data;
        `uvm_info("APB_SCOREBOARD",$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
        `uvm_info("",$sformatf("Addr: %0h",expdata.paddr),UVM_LOW)
        `uvm_info("",$sformatf("WData: %0h",expdata.data),UVM_LOW)        
      end


      else if(expdata.pwrite == 0) begin
        if(sc_mem[expdata.paddr] == expdata.data) begin
          `uvm_info("APB_SCOREBOARD",$sformatf("------ :: READ DATA Match :: ------"),UVM_LOW)
          `uvm_info("",$sformatf("Addr: %0h",expdata.paddr),UVM_LOW)
          `uvm_info("",$sformatf("Expected RData: %0h Actual Data: %0h",sc_mem[expdata.paddr],expdata.data),UVM_LOW)
        end
        else begin
          `uvm_error("APB_SCOREBOARD","------ :: READ DATA MisMatch :: ------")
          `uvm_info("",$sformatf("Addr: %0h",expdata.paddr),UVM_LOW)
          `uvm_info("",$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[expdata.paddr],expdata.data),UVM_LOW)
        end
      end
    end
  endtask 
  
endclass