`timescale 1ns / 1ps
module rom (
    input  [3:0] addr,
    output reg [7:0] instr
);

always @(*) begin
    case (addr)
        4'd0: instr = 8'h12; //  2
        4'd1: instr = 8'h22; //  2
        4'd2: instr = 8'h23; //  3
        4'd3: instr = 8'h70; //  0  
        4'd4: instr = 8'h64; //  4
        default: instr = 8'h00; // NOP
    endcase
end

endmodule
