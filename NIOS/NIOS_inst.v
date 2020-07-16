	NIOS u0 (
		.avalon_mm_1_waitrequest       (<connected-to-avalon_mm_1_waitrequest>),       //             avalon_mm_1.waitrequest
		.avalon_mm_1_readdata          (<connected-to-avalon_mm_1_readdata>),          //                        .readdata
		.avalon_mm_1_readdatavalid     (<connected-to-avalon_mm_1_readdatavalid>),     //                        .readdatavalid
		.avalon_mm_1_burstcount        (<connected-to-avalon_mm_1_burstcount>),        //                        .burstcount
		.avalon_mm_1_writedata         (<connected-to-avalon_mm_1_writedata>),         //                        .writedata
		.avalon_mm_1_address           (<connected-to-avalon_mm_1_address>),           //                        .address
		.avalon_mm_1_write             (<connected-to-avalon_mm_1_write>),             //                        .write
		.avalon_mm_1_read              (<connected-to-avalon_mm_1_read>),              //                        .read
		.avalon_mm_1_byteenable        (<connected-to-avalon_mm_1_byteenable>),        //                        .byteenable
		.avalon_mm_1_debugaccess       (<connected-to-avalon_mm_1_debugaccess>),       //                        .debugaccess
		.clk_clk                       (<connected-to-clk_clk>),                       //                     clk.clk
		.pio_0_ext_out_export          (<connected-to-pio_0_ext_out_export>),          //           pio_0_ext_out.export
		.pio_1_ext_in_export           (<connected-to-pio_1_ext_in_export>),           //            pio_1_ext_in.export
		.reset_reset_n                 (<connected-to-reset_reset_n>),                 //                   reset.reset_n
		.sdram_controller_0_wire_addr  (<connected-to-sdram_controller_0_wire_addr>),  // sdram_controller_0_wire.addr
		.sdram_controller_0_wire_ba    (<connected-to-sdram_controller_0_wire_ba>),    //                        .ba
		.sdram_controller_0_wire_cas_n (<connected-to-sdram_controller_0_wire_cas_n>), //                        .cas_n
		.sdram_controller_0_wire_cke   (<connected-to-sdram_controller_0_wire_cke>),   //                        .cke
		.sdram_controller_0_wire_cs_n  (<connected-to-sdram_controller_0_wire_cs_n>),  //                        .cs_n
		.sdram_controller_0_wire_dq    (<connected-to-sdram_controller_0_wire_dq>),    //                        .dq
		.sdram_controller_0_wire_dqm   (<connected-to-sdram_controller_0_wire_dqm>),   //                        .dqm
		.sdram_controller_0_wire_ras_n (<connected-to-sdram_controller_0_wire_ras_n>), //                        .ras_n
		.sdram_controller_0_wire_we_n  (<connected-to-sdram_controller_0_wire_we_n>),  //                        .we_n
		.i2c_0_serial_sda_in           (<connected-to-i2c_0_serial_sda_in>),           //            i2c_0_serial.sda_in
		.i2c_0_serial_scl_in           (<connected-to-i2c_0_serial_scl_in>),           //                        .scl_in
		.i2c_0_serial_sda_oe           (<connected-to-i2c_0_serial_sda_oe>),           //                        .sda_oe
		.i2c_0_serial_scl_oe           (<connected-to-i2c_0_serial_scl_oe>)            //                        .scl_oe
	);

