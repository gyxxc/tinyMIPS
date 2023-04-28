`include "macro.v"
module ctrl(
	input wire			rst_n,
	input wire			stallreq_from_id,
	input wire			stallreq_from_ex,
	
	input wire			stallreq_from_if,
	input wire			stallreq_from_mem,
	
	input wire[31:0]		excepttype_i,
	input wire[`RegBus]	cp0_epc_i,
	output reg[5:0]		stall,
	
	output reg[`RegBus]	new_pc,
	output reg				flush
);

always @(*) begin
	if(rst_n==`RstEnable) begin
		stall	<=6'b000000;
		flush<=1'b0;
		new_pc<=`ZeroWord;
	end else if(excepttype_i!=`ZeroWord) begin
		flush<=1'b1;
		stall	<=6'b000000;
		case(excepttype_i)
		32'h00000001:new_pc<=32'h00000020;//interrupt
		32'h00000008:new_pc<=32'h00000040;//syscall
		32'h0000000a:new_pc<=32'h00000040;//instvalid
		32'h0000000d:new_pc<=32'h00000040;//trap
		32'h0000000c:new_pc<=32'h00000040;//ov
		32'h0000000e:new_pc<=cp0_epc_i;//eret
		default: ;
		endcase
	end
	else if(stallreq_from_mem==`Stop) begin
		stall<=6'b011111;
		flush<=1'b0;
	end
	else if(stallreq_from_if==`Stop) begin
		stall<=6'b000111;
		flush<=1'b0;
	end
	else if(stallreq_from_ex==`Stop) begin
		stall	<=6'b001111;
		flush<=1'b0;
	end
	else if(stallreq_from_id==`Stop) begin
		stall	<=6'b000111;
		flush<=1'b0;
	end
	else begin
		stall	<=6'b000000;
		flush	<=1'b0;
		new_pc<=`ZeroWord;
	end
end
endmodule
