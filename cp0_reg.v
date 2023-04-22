`include "macro.v"
module cp0_reg(	
input wire	clk,
input wire	rst_n,
input wire	we_i,
input wire[4:0]		waddr_i,
input wire[4:0]		raddr_i,
input wire[`RegBus]	data_i,

input wire[5:0]		int_i,

output reg[`RegBus]	data_o,
output reg[`RegBus]	count_o,
output reg[`RegBus]	compare_o,
output reg[`RegBus]	status_o,
output reg[`RegBus]	cause_o,
output reg[`RegBus]	epc_o,
output reg[`RegBus]	config_o,
output reg[`RegBus]	prid_o,

output reg	timer_int_o
);

always @(posedge clk) begin
	if(rst_n==`RstEnable) begin
		count_o<=`ZeroWord;
		compare_o<=`ZeroWord;
		status_o<=32'b00010000000000000000000000000000;
		cause_o<=`ZeroWord;
		epc_o<=`ZeroWord;
		config_o<=32'b00000000000000001000000000000000;
		//
		timer_int_o<=`InterruptNotAssert;
	end else begin
		count_o<=count_o+1'b1;
		cause_o[15:10]<=int_i;
		if(compare_o!=`ZeroWord && count_o==compare_o) begin
			timer_int_o<=`InterruptAssert;
		end
		if(we_i==`WriteEnable) begin
			case(waddr_i)
			`CP0_REG_COUNT: begin
				count_o<=data_i;
			end
			`CP0_REG_COMPARE: begin
				compare_o<=data_i;
				timer_int_o<=`InterruptNotAssert;
			end
			`CP0_REG_STATUS: begin
				status_o<=data_i;
			end
			`CP0_REG_EPC: begin
				epc_o<=data_i;
			end
			`CP0_REG_CAUSE: begin
				cause_o[9:8]<=data_i[9:8];
				cause_o[23]<=data_i[23];
				cause_o[22]<=data_i[22];
			end
			
			default: ;
			endcase
		end
	end
end

always @(*) begin
	if(rst_n==`RstEnable) begin
		data_o<=`ZeroWord;
	end else begin
		case(raddr_i)
			`CP0_REG_COUNT: begin
				data_o<=count_o;
			end
			`CP0_REG_COMPARE: begin
				data_o<=compare_o;
			end
			`CP0_REG_STATUS: begin
				data_o<=status_o;
			end
			`CP0_REG_CAUSE: begin
				data_o<=cause_o;
			end
			`CP0_REG_EPC: begin
				data_o<=epc_o;
			end
			`CP0_REG_PRID: begin
				data_o<=prid_o;
			end
			`CP0_REG_CONFIG: begin
				data_o<=config_o;
			end
			
			default: ;
		endcase
	end
end
endmodule