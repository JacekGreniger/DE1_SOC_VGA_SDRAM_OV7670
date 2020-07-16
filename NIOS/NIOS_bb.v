
module NIOS (
	avalon_mm_1_waitrequest,
	avalon_mm_1_readdata,
	avalon_mm_1_readdatavalid,
	avalon_mm_1_burstcount,
	avalon_mm_1_writedata,
	avalon_mm_1_address,
	avalon_mm_1_write,
	avalon_mm_1_read,
	avalon_mm_1_byteenable,
	avalon_mm_1_debugaccess,
	clk_clk,
	pio_0_ext_out_export,
	pio_1_ext_in_export,
	reset_reset_n,
	sdram_controller_0_wire_addr,
	sdram_controller_0_wire_ba,
	sdram_controller_0_wire_cas_n,
	sdram_controller_0_wire_cke,
	sdram_controller_0_wire_cs_n,
	sdram_controller_0_wire_dq,
	sdram_controller_0_wire_dqm,
	sdram_controller_0_wire_ras_n,
	sdram_controller_0_wire_we_n,
	i2c_0_serial_sda_in,
	i2c_0_serial_scl_in,
	i2c_0_serial_sda_oe,
	i2c_0_serial_scl_oe);	

	output		avalon_mm_1_waitrequest;
	output	[15:0]	avalon_mm_1_readdata;
	output		avalon_mm_1_readdatavalid;
	input	[0:0]	avalon_mm_1_burstcount;
	input	[15:0]	avalon_mm_1_writedata;
	input	[31:0]	avalon_mm_1_address;
	input		avalon_mm_1_write;
	input		avalon_mm_1_read;
	input	[1:0]	avalon_mm_1_byteenable;
	input		avalon_mm_1_debugaccess;
	input		clk_clk;
	output	[31:0]	pio_0_ext_out_export;
	input	[7:0]	pio_1_ext_in_export;
	input		reset_reset_n;
	output	[12:0]	sdram_controller_0_wire_addr;
	output	[1:0]	sdram_controller_0_wire_ba;
	output		sdram_controller_0_wire_cas_n;
	output		sdram_controller_0_wire_cke;
	output		sdram_controller_0_wire_cs_n;
	inout	[15:0]	sdram_controller_0_wire_dq;
	output	[1:0]	sdram_controller_0_wire_dqm;
	output		sdram_controller_0_wire_ras_n;
	output		sdram_controller_0_wire_we_n;
	input		i2c_0_serial_sda_in;
	input		i2c_0_serial_scl_in;
	output		i2c_0_serial_sda_oe;
	output		i2c_0_serial_scl_oe;
endmodule
