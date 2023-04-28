`include "macro.v"
module tinyMIPS(
	input wire	clk,
	input wire	rst_n
	
	input wire	uart_in,
	output wire	uart_out,
	
	input wire[15:0]	 	gpio_i,
	output wire[31:0]		gpio_o,
	
	input wire[7:0]	flash_data_i,
	output wire[21:0]	flash_addr_o,
	output wire			flash_we_o,
	output wire			flash_rst_o,
	output wire			flash_oe_o,
	output wire			flash_ce_o,
	
	output wire			sdr_clk_o,
	output wire			sdr_sc_n_o,
	output wire			sdr_cke_o,
	output wire			sdr_ras_n_o,
	output wire			sdr_cas_n_o,
	output wire			sdr_we_n_o,
	output wire[1:0]	sdr_dqm_o,
	output wire[1:0]	sdr_ba_o,
	output wire[12:0]	sdr_addr_o,
	inout wire[15:0]	sdr_dq_io
	*/
);

/*

*/

//wires
wire[7:0] 	intr;
wire			timer_int;
wire 			gpio_int;
wire 			uart_int;
wire[31:0] 	gpio_i_temp;

wire[31:0] 	m0_data_i;
wire[31:0] 	m0_data_o;
wire[31:0] 	m0_addr_i;
wire[3:0] 	m0_sel_i;
wire 			m0_we_i;
wire 			m0_cyc_i;
wire 			m0_stb_i;
wire			m0_ack_o;

wire[31:0] 	m1_data_i;
wire[31:0] 	m1_data_o;
wire[31:0] 	m1_addr_i;
wire[3:0] 	m1_sel_i;
wire 			m1_we_i;
wire 			m1_cyc_i;
wire 			m1_stb_i;
wire			m1_ack_o;

wire[31:0] 	s0_data_i;
wire[31:0] 	s0_data_o;
wire[31:0] 	s0_addr_o;
wire[3:0] 	s0_sel_o;
wire 			s0_we_o;
wire 			s0_cyc_o;
wire 			s0_stb_o;
wire			s0_ack_i;

wire[31:0] 	s1_data_i;
wire[31:0] 	s1_data_o;
wire[31:0] 	s1_addr_o;
wire[3:0] 	s1_sel_o;
wire 			s1_we_o;
wire 			s1_cyc_o;
wire 			s1_stb_o;
wire			s1_ack_i;

wire[31:0] 	s2_data_i;
wire[31:0] 	s2_data_o;
wire[31:0] 	s2_addr_o;
wire[3:0] 	s2_sel_o;
wire 			s2_we_o;
wire 			s2_cyc_o;
wire 			s2_stb_o;
wire			s2_ack_i;

wire[31:0] 	s3_data_i;
wire[31:0] 	s3_data_o;
wire[31:0] 	s3_addr_o;
wire[3:0] 	s3_sel_o;
wire 			s3_we_o;
wire 			s3_cyc_o;
wire 			s3_stb_o;
wire			s3_ack_i;

wire sdram_init_done;

assign sdr_clk_o=clk;
/*

*/

//openmips
openmips openmips0(
	.clk			(clk),
	.rst_n		(rst_n),

	.iwishbone_data_i	(m1_data_o),
	.iwishbone_ack_i	(m1_ack_o),
	.iwishbone_addr_o	(m1_addr_i),
	.iwishbone_data_o	(m1_data_i),
	.iwishbone_we_o	(m1_we_i),
	.iwishbone_sel_o	(m1_sel_i),
	.iwishbone_stb_o	(m1_stb_i),
	.iwishbone_cyc_o	(m1_cyc_i),
	
	.dwishbone_data_i	(m0_data_o),
	.dwishbone_ack_i	(m0_ack_o),
	.dwishbone_addr_o	(m0_addr_i),
	.dwishbone_data_o	(m0_data_i),
	.dwishbone_we_o	(m0_we_i),
	.dwishbone_sel_o	(m0_sel_i),
	.dwishbone_stb_o	(m0_stb_i),
	.dwishbone_cyc_o	(m0_cyc_i),
	
	.int_i			(intr),
	.timer_int_o	(timer_int)
);

assign intr={3'b000,gpio_int,uart_int,timer_int};
//roms
inst_rom inst_rom0(
	.ce			(rom_ce),
	.addr			(inst_addr),
	.inst			(inst)
);
//rams
data_ram	data_ram0(
	.addr		(mem_addr_i),
	.data_i	(mem_data_i),
	.sel		(mem_sel_i),
	.we		(mem_we_i),
	.ce		(mem_ce_i),
	.clk		(clk),
	.data_o	(mem_data_o)
);
endmodule