`timescale 1ns / 1ps

module alu (
    input  [3:0] acc,
    input  [3:0] imm,
    input  [3:0] opcode,
    output reg [3:0] result
);

always @(*) begin
    case (opcode)
        4'h2: result = acc + imm;  // ADD
        4'h3: result = acc - imm;  // SUB
        4'h4: result = acc & imm;  // AND
        4'h5: result = acc | imm;  // OR
        default: result = acc;     // keep ACC for other ops
    endcase
end

endmodule
