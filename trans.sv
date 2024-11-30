class apb_trans extends uvm_sequence_item;
`uvm_object_utils(apb_trans)


    // Transaction attributes
    randc bit [31:0]  paddr;
    rand bit [31:0]  data;
    rand bit         pwrite;  // 1 for write, 0 for read
    
    
    // Constraints
    constraint addr_range {
        // Constrain address to be within the 4 register range (0x0 to 0xF)
        paddr[31:4] == 28'h0;
    }

    // Constructor
    function new(string name = "apb_transaction");
        super.new(name);
    endfunction

    // Print method
    function string convert2string();
        return $sformatf("Type: %s, Addr: 0x%0h, Data: 0x%0h", 
                         pwrite ? "WRITE" : "READ", paddr, data);
    endfunction


  endclass