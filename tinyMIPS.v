`include "macro.v"
module tinyMIPS(
	input wire	clk,
	input wire	rst_n
);

//wires
wire[`InstAddrBus]		inst_addr;
wire[`InstBus]		inst;
wire			rom_ce;
//openmips
openmips openmips0(
	.clk		(clk),
	.rst_n		(rst_n),
	.rom_addr_o	(inst_addr),
	.rom_data_i	(inst),
	.rom_ce_o	(rom_ce)
);
//roms
inst_rom inst_rom0(
	.ce			(rom_ce),
	.addr			(inst_addr),
	.inst			(inst)
);

endmodule