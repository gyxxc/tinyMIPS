`include "macro.v"
module tinyMIPS(
	input wire	clk,
	input wire	rst_n
);

//wires
wire[`InstAddrBus]		inst_addr;
wire[`InstBus]				inst;
wire	rom_ce;

wire	mem_we_i;
wire[`RegBus]	mem_addr_i;
wire[`RegBus]	mem_data_i;
wire[`RegBus]	mem_data_o;
wire[3:0]		mem_sel_i;

wire[5:0] int;
wire timer_int;
wire	mem_ce_i;

assign int={5'b00000,timer_int};
//openmips
openmips openmips0(
	.clk			(clk),
	.rst_n		(rst_n),
	.rom_addr_o	(inst_addr),
	.rom_data_i	(inst),
	.rom_ce_o	(rom_ce),
	.ram_addr_o		(mem_addr_i),
	.ram_data_o		(mem_data_i),
	.ram_sel_o		(mem_sel_i),
	.ram_we_o		(mem_we_i),
	.ram_ce_o		(mem_ce_i),
	.int_i			(int),
	.timer_int_o	(timer_int)
);
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