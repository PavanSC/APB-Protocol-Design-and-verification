class seq extends uvm_sequence #(apb_trans);
    `uvm_object_utils(seq)

    // Sequence configuration
    int num_transactions = 100;

    // Constructor
    function new(string name = "seq");
        super.new(name);
    endfunction

    // Sequence body
    task body();
        repeat(num_transactions) begin
            `uvm_do_with(req, {
                // Randomize within constraints
                paddr inside {[0:15]};
                pwrite dist {0:=50, 1:=50};
            })
        end
    endtask
endclass

// Write sequence
class wseq extends seq;
    `uvm_object_utils(wseq)

    function new(string name = "wseq");
        super.new(name);
    endfunction

    task body();
        repeat(num_transactions) begin
            `uvm_do_with(req, {
                pwrite == 1'b1;
                paddr inside {[0:3]};
            })
        end
    endtask
endclass

// Read sequence
class rseq extends seq;
    `uvm_object_utils(rseq)

    function new(string name = "rseq");
        super.new(name);
    endfunction

    task body();
        repeat(num_transactions) begin
            `uvm_do_with(req, {
                pwrite == 1'b0;
                paddr inside {[0:3]};
            })
        end
    endtask
endclass