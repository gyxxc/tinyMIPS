`include "macro.v"
module ex(
//input wire	clk,
input wire	rst_n,
//
input wire[`AluOpBus]	aluop_i,
input wire[`AluSelBus]	alusel_i,
input wire[`RegBus]		reg1_i,
input wire[`RegBus]		reg2_i,
input wire[`RegAddrBus]	wd_i,
input wire					wreg_i,
//
output reg[`RegAddrBus]	wd_o,
output reg					wreg_o,
output reg[`RegBus]		wdata_o 
);	
	
//registers
reg[`RegBus]	logicout;
reg[`RegBus]	shiftres;
always @(*) begin
	if(rst_n== `RstEnable) begin
		logicout	<= `ZeroWord;
	end
	else begin
		case(aluop_i)
			`EXE_OR_OP: begin
				logicout	<= reg1_i | reg2_i;
			end
			`EXE_AND_OP: begin
				logicout	<= reg1_i & reg2_i;
			end
			`EXE_NOR_OP: begin
				logicout <= ~(reg1_i | reg2_i);
			end
			`EXE_XOR_OP: begin
				logicout <= reg1_i ^ reg2_i;
			end
			default: begin
				logicout	<= `ZeroWord;
			end
		endcase
	end
end
//
always @(*) begin
	if(rst_n==`RstEnable)
		shiftres	<=`ZeroWord;
	else begin
		case(aluop_i)
			`EXE_SLL_OP: begin
				shiftres	<= reg2_i<<reg1_i[4:0];
			end
			default: begin
			end
		endcase
	end//if
end//always
//
always @(*) begin
	wd_o	 <= wd_i;
	wreg_o <= wreg_i;
	//wdata_o<=wdata_i;
	case(aluop_i)
			`EXE_RES_LOGIC: begin
				wdata_o	<= logicout;
			end
			`EXE_RES_SHIFT:
				wdata_o	<= shiftres;
			default: begin
				wdata_o	<= `ZeroWord;
			end
	endcase
	
end
endmodule