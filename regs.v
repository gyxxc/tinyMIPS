`include "macro.v"
module regs(
	input wire	clk,
	input wire	rst_n,
	//
	input wire	we,
	input wire[`RegAddrBus]	waddr,
	input wire[`RegBus]		wdata,
	//
	input wire					re1,
	input wire[`RegAddrBus]	raddr1,
	output reg[`RegBus]		rdata1,
	//
	input wire					re2,
	input wire[`RegAddrBus]	raddr2,
	output reg[`RegBus]		rdata2
);
//32*32-bit registers
reg[`RegBus] regis[0:`RegNum-1];
//writing ops
always @(posedge clk) begin
	if(rst_n==`RstDisable) begin
		if((we==`WriteEnable) && (waddr!=`RegNumLog2'h0))
			regis[waddr] <= wdata;
	end
end
//reading ops on port1
always @(*) begin
	if(rst_n==`RstDisable) begin
		rdata1 <= `ZeroWord;
	end
	else if(raddr1==`RegNumLog2'h0) begin
		rdata1 <= `ZeroWord;
	end
	else if((raddr1==waddr) && (we==`WriteEnable) && (re1==`ReadEnable)) begin
		rdata1 <= wdata;
	end
	else if(re1==`ReadEnable) begin
		rdata1 <= regis[raddr1];
	end
	else
		rdata1 <= `ZeroWord;
end
//reading port2
always @(*) begin
	if(rst_n==`RstDisable) begin
		rdata2 <= `ZeroWord;
	end
	else if(raddr2==`RegNumLog2'h0) begin
		rdata2 <= `ZeroWord;
	end
	else if((raddr2==waddr) && (we==`WriteEnable) && (re2==`ReadEnable)) begin
		rdata2 <= wdata;
	end
	else if(re2==`ReadEnable) begin
		rdata2 <= regis[raddr2];
	end
	else
		rdata2 <= `ZeroWord;
end
//
endmodule
