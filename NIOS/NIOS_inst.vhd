	component NIOS is
		port (
			avalon_mm_1_waitrequest       : out   std_logic;                                        -- waitrequest
			avalon_mm_1_readdata          : out   std_logic_vector(15 downto 0);                    -- readdata
			avalon_mm_1_readdatavalid     : out   std_logic;                                        -- readdatavalid
			avalon_mm_1_burstcount        : in    std_logic_vector(0 downto 0)  := (others => 'X'); -- burstcount
			avalon_mm_1_writedata         : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			avalon_mm_1_address           : in    std_logic_vector(31 downto 0) := (others => 'X'); -- address
			avalon_mm_1_write             : in    std_logic                     := 'X';             -- write
			avalon_mm_1_read              : in    std_logic                     := 'X';             -- read
			avalon_mm_1_byteenable        : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			avalon_mm_1_debugaccess       : in    std_logic                     := 'X';             -- debugaccess
			clk_clk                       : in    std_logic                     := 'X';             -- clk
			pio_0_ext_out_export          : out   std_logic_vector(31 downto 0);                    -- export
			pio_1_ext_in_export           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			reset_reset_n                 : in    std_logic                     := 'X';             -- reset_n
			sdram_controller_0_wire_addr  : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_controller_0_wire_ba    : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_controller_0_wire_cas_n : out   std_logic;                                        -- cas_n
			sdram_controller_0_wire_cke   : out   std_logic;                                        -- cke
			sdram_controller_0_wire_cs_n  : out   std_logic;                                        -- cs_n
			sdram_controller_0_wire_dq    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_controller_0_wire_dqm   : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_controller_0_wire_ras_n : out   std_logic;                                        -- ras_n
			sdram_controller_0_wire_we_n  : out   std_logic;                                        -- we_n
			i2c_0_serial_sda_in           : in    std_logic                     := 'X';             -- sda_in
			i2c_0_serial_scl_in           : in    std_logic                     := 'X';             -- scl_in
			i2c_0_serial_sda_oe           : out   std_logic;                                        -- sda_oe
			i2c_0_serial_scl_oe           : out   std_logic                                         -- scl_oe
		);
	end component NIOS;

	u0 : component NIOS
		port map (
			avalon_mm_1_waitrequest       => CONNECTED_TO_avalon_mm_1_waitrequest,       --             avalon_mm_1.waitrequest
			avalon_mm_1_readdata          => CONNECTED_TO_avalon_mm_1_readdata,          --                        .readdata
			avalon_mm_1_readdatavalid     => CONNECTED_TO_avalon_mm_1_readdatavalid,     --                        .readdatavalid
			avalon_mm_1_burstcount        => CONNECTED_TO_avalon_mm_1_burstcount,        --                        .burstcount
			avalon_mm_1_writedata         => CONNECTED_TO_avalon_mm_1_writedata,         --                        .writedata
			avalon_mm_1_address           => CONNECTED_TO_avalon_mm_1_address,           --                        .address
			avalon_mm_1_write             => CONNECTED_TO_avalon_mm_1_write,             --                        .write
			avalon_mm_1_read              => CONNECTED_TO_avalon_mm_1_read,              --                        .read
			avalon_mm_1_byteenable        => CONNECTED_TO_avalon_mm_1_byteenable,        --                        .byteenable
			avalon_mm_1_debugaccess       => CONNECTED_TO_avalon_mm_1_debugaccess,       --                        .debugaccess
			clk_clk                       => CONNECTED_TO_clk_clk,                       --                     clk.clk
			pio_0_ext_out_export          => CONNECTED_TO_pio_0_ext_out_export,          --           pio_0_ext_out.export
			pio_1_ext_in_export           => CONNECTED_TO_pio_1_ext_in_export,           --            pio_1_ext_in.export
			reset_reset_n                 => CONNECTED_TO_reset_reset_n,                 --                   reset.reset_n
			sdram_controller_0_wire_addr  => CONNECTED_TO_sdram_controller_0_wire_addr,  -- sdram_controller_0_wire.addr
			sdram_controller_0_wire_ba    => CONNECTED_TO_sdram_controller_0_wire_ba,    --                        .ba
			sdram_controller_0_wire_cas_n => CONNECTED_TO_sdram_controller_0_wire_cas_n, --                        .cas_n
			sdram_controller_0_wire_cke   => CONNECTED_TO_sdram_controller_0_wire_cke,   --                        .cke
			sdram_controller_0_wire_cs_n  => CONNECTED_TO_sdram_controller_0_wire_cs_n,  --                        .cs_n
			sdram_controller_0_wire_dq    => CONNECTED_TO_sdram_controller_0_wire_dq,    --                        .dq
			sdram_controller_0_wire_dqm   => CONNECTED_TO_sdram_controller_0_wire_dqm,   --                        .dqm
			sdram_controller_0_wire_ras_n => CONNECTED_TO_sdram_controller_0_wire_ras_n, --                        .ras_n
			sdram_controller_0_wire_we_n  => CONNECTED_TO_sdram_controller_0_wire_we_n,  --                        .we_n
			i2c_0_serial_sda_in           => CONNECTED_TO_i2c_0_serial_sda_in,           --            i2c_0_serial.sda_in
			i2c_0_serial_scl_in           => CONNECTED_TO_i2c_0_serial_scl_in,           --                        .scl_in
			i2c_0_serial_sda_oe           => CONNECTED_TO_i2c_0_serial_sda_oe,           --                        .sda_oe
			i2c_0_serial_scl_oe           => CONNECTED_TO_i2c_0_serial_scl_oe            --                        .scl_oe
		);

