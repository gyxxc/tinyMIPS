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

reg[`RegBus] regis[0:`RegNum-1];

always @(posedge clk) begin
	if(rst_n==`RstDisable) begin
		if((we==`WriteEnable) && (waddr!=`RegNumLog2'h0))
			regis[waddr] <= wdata;
	end
end

always @(posedge clk) begin
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

always @(posedge clk) begin
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
endmodule