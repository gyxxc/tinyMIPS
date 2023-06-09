`include "macro.v"
module wishbone_bus_if(
	input wire clk,
	input wire rst_n,
	input wire[5:0]	stall_i,
	input wire			flush_i,

	input wire				cpu_ce_i,
	input wire[`RegBus]	cpu_data_i,
	input wire[`RegBus]	cpu_addr_i,
	input wire				cpu_we_i,
	input wire[3:0]		cpu_sel_i,
	output reg[`RegBus] 	cpu_data_o,
	
	input wire[`RegBus]	wishbone_data_i,
	input wire				wishbone_ack_i,
	output reg[`RegBus] 	wishbone_addr_o,
	output reg[`RegBus] 	wishbone_data_o,
	output reg		 	wishbone_we_o,
	output reg[3:0] 	wishbone_sel_o,
	output reg 			wishbone_stb_o,
	output reg 			wishbone_cyc_o,
	
	output reg			stallreq
);

//registers
reg[1:0]	wishbone_state;
reg[`RegBus]	rd_buf;

always @(posedge clk) begin
if(rst_n==`RstEnable) begin
	wishbone_state<=`WB_IDLE;
	wishbone_addr_o<=`ZeroWord;
	wishbone_data_o<=`ZeroWord;
	wishbone_we_o<=`WriteDisable;
	wishbone_sel_o<=4'b0000;
	wishbone_stb_o<=1'b0;
	wishbone_cyc_o<=1'b0;
	rd_buf	<=`ZeroWord;
end else begin
	case(wishbone_state)
	`WB_IDLE: begin
		if(cpu_ce_i==1'b1 && flush_i==`False) begin
			wishbone_stb_o	<=1'b1;
			wishbone_cyc_o	<=1'b1;
			wishbone_addr_o<=cpu_addr_i;
			wishbone_data_o<=cpu_data_i;
			wishbone_we_o	<=cpu_we_i;
			wishbone_sel_o	<=cpu_sel_i;
			wishbone_state	<=`WB_BUSY;
			rd_buf	<=`ZeroWord;
		end
	end
	`WB_BUSY: begin
		if(wishbone_ack_i==1'b1) begin
			wishbone_stb_o	<=1'b0;
			wishbone_cyc_o	<=1'b0;
			wishbone_addr_o<=`ZeroWord;
			wishbone_data_o<=`ZeroWord;
			wishbone_we_o	<=`WriteDisable;
			wishbone_sel_o	<=4'b0000;
			wishbone_state	<=`WB_IDLE;
			if(cpu_we_i==`WriteDisable)
				rd_buf	<=wishbone_data_i;
			if(stall_i!=6'b000000)
				wishbone_state<=`WB_WAIT_FOR_STALL;
			
		end else if(flush_i==`True) begin
			wishbone_stb_o	<=1'b0;
			wishbone_cyc_o	<=1'b0;
			wishbone_addr_o<=`ZeroWord;
			wishbone_data_o<=`ZeroWord;
			wishbone_we_o	<=`WriteDisable;
			wishbone_sel_o	<=4'b0000;
			wishbone_state	<=`WB_IDLE;
			rd_buf	<=`ZeroWord;
		end
	end
	`WB_WAIT_FOR_STALL: begin
		if(stall_i==6'b000000)
			wishbone_state<=`WB_IDLE;
		
	end
	default: ;
	endcase
end//if
end//always

always @(*) begin
if(rst_n==`RstEnable) begin
	stallreq<=`NoStop;
	cpu_data_o<=`ZeroWord;
end else begin
	stallreq<=`NoStop;
	case(wishbone_state)
	`WB_IDLE: begin
		if(cpu_ce_i==1'b1 && flush_i==`False) begin
			stallreq<=`Stop;
			cpu_data_o<=`ZeroWord;
		end
	end
	`WB_BUSY: begin
		if(wishbone_ack_i==1'b1) begin
			stallreq<=`NoStop;
			if(wishbone_we_o==`WriteDisable)
				cpu_data_o<=wishbone_data_i;
			else
				cpu_data_o<=`ZeroWord;
			
		end else begin
			stallreq<=`Stop;
			cpu_data_o<=`ZeroWord;
		end
	end
	`WB_WAIT_FOR_STALL: begin
		stallreq<=`NoStop;
		cpu_data_o<=rd_buf;
	end
	default: ;
	endcase
end//if
end//always
endmodule