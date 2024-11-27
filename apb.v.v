module apb_slave(
    input wire          pclk,
    input wire          presetn,
    input wire [31:0]   paddr,
    input wire          pwrite,
    input wire          psel,
    input wire          penable,
    input wire [31:0]   pwdata,
    
    output reg [31:0]   prdata,
    output reg          pready,
    output reg          pslverr
);

    // Internal Memory Registers
    reg [31:0] reg [0:3];
    
    // State Machine States
    reg [1:0] state;
    parameter IDLE   = 2'b00;
    parameter SETUP  = 2'b01;
    parameter ACCESS = 2'b10;

    // State and Register Management
    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            // Reset State
            state <= IDLE;
            prdata <= 32'h0;
            pready <= 1'b0;
            pslverr <= 1'b0;
            
            // Clear Registers
            reg[0] <= 32'h0;
            reg[1] <= 32'h0;
            reg[2] <= 32'h0;
            reg[3] <= 32'h0;
        end else begin
            // State Machine
            case (state)
                IDLE: begin
                    if (psel && !penable) begin
                        state <= SETUP;
                        pready <= 1'b0;
                        pslverr <= 1'b0;
                    end
                end
                
                SETUP: begin
                    if (psel && penable) begin
                        state <= ACCESS;
                        
                        // Check Address Range
                        if (paddr[31:4] == 28'h0) begin
                            // Valid Address Range
                            if (pwrite) begin
                                // Write Operation
                                reg[paddr[3:2]] <= pwdata;
                                pready <= 1'b1;
                            end else begin
                                // Read Operation
                                prdata <= reg[paddr[3:2]];
                                pready <= 1'b1;
                            end
                            pslverr <= 1'b0;
                        end else begin
                            // Invalid Address
                            pslverr <= 1'b1;
                            pready <= 1'b1;
                        end
                    end
                end
                
                ACCESS: begin
                    // Return to IDLE when transaction completes
                    if (!psel) begin
                        state <= IDLE;
                        pready <= 1'b0;
                        pslverr <= 1'b0;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule