`timescale 1ns/1ps

module tt_um_4b_tiny_cpu (
    input        clk,
    input        rst_n,
    input  [7:0] ui_in,
    input  [7:0] uio_in,
    output [7:0] uo_out
);

   //  Registers
    reg [3:0] pc;
    reg [3:0] acc;

    wire [7:0] instr;
    wire [3:0] opcode = ui_in[7:4];
    reg [3:0] imm;
    wire [3:0] alu_out;

   //  Instantiate ROM & ALU
    rom u_rom (.addr(pc), .instr(instr));
    alu u_alu (.acc(acc), .imm(imm), .opcode(opcode), .result(alu_out));

   //  Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc  <= 4'd0;
            acc <= 4'd0;
			imm <= 4'd0;
        end 
		else begin	
			if(uio_in[0] == 0) begin
				imm <= 5;
				acc <= ui_in[3:0];
			end
			else if(uio_in[0] == 1) begin
				imm <= instr[3:0];
				acc <= alu_out;
				pc <= (pc < 4'd5) ? pc + 1 : 4'd0;
			end
		end
	end
    //  Output ACC and PC
    assign uo_out = {uio_in[3:0], alu_out};
endmodule
