`include "macro.v"
module LLbit_reg(
	input wire clk,
	input wire rst_n,
	input wire flush,//isException
	
	input wire LLbit_i,
	input wire we,
	
	output reg LLbit_o
);

always @(posedge clk) begin
	if(rst_n==`RstEnable)
		LLbit_o<=1'b0;
	else if(flush==1'b1)	
		LLbit_o<=1'b0;
	else if(we==`WriteEnable) begin
		LLbit_o<=LLbit_i;
	end
end
endmodule