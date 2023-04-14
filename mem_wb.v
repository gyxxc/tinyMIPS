//`include "macro.v"
module mem_wb(
	input wire	clk,
	input wire	rst_n,
	//
	input wire[`RegAddrBus]	mem_wd,
	input wire					mem_wreg,
	input wire[`RegBus]		mem_wdata,
	input wire					mem_whilo,
	input wire[`RegBus]		mem_hi,
	input wire[`RegBus]		mem_lo,
	//
	output reg					wb_whilo,
	output reg[`RegBus]		wb_hi,
	output reg[`RegBus]		wb_lo,
	output reg[`RegAddrBus]	wb_wd,
	output reg					wb_wreg,
	output reg[`RegBus]		wb_wdata
);

always @(posedge clk) begin
	if(rst_n==`RstEnable) begin
		wb_wd		<= `NOPRegAddr;
		wb_wreg	<= `WriteDisable;
		wb_wdata	<= `ZeroWord;
		wb_hi		<= `ZeroWord;
		wb_lo		<= `ZeroWord;
		wb_whilo	<= `WriteDisable;
	end
	else begin
		wb_wd		<= mem_wd;
		wb_wreg	<= mem_wreg;
		wb_wdata	<= mem_wdata;
		wb_hi		<= mem_hi;
		wb_lo		<= mem_lo;
		wb_whilo	<= mem_whilo;
	end
end
endmodule