--DE1 SOC board

--freeze 1
--based on the MAX1000 freeze 6

--freeze 2
--added avalon-mm pipeline

--freeze 3
--NIOS draws on the screen

--06.03.2020 add camera support
--09.03.2020 add full RGB 565 colour

--freeze 4 12.03.2020
--ov7670 is working properly

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_vga_sdram is
	port (
		CLOCK_50								: in		std_logic;

		DRAM_ADDR							: out		std_logic_vector(12 downto 0);
		DRAM_BA								: out		std_logic_vector(1 downto 0);
		DRAM_CAS_N							: out		std_logic;
		DRAM_CKE								: out		std_logic;
		DRAM_CS_N							: out		std_logic;
		DRAM_DQ								: inout	std_logic_vector(15 downto 0);
		DRAM_LDQM							: out		std_logic;
		DRAM_UDQM							: out		std_logic;
		DRAM_RAS_N							: out		std_logic;
		DRAM_WE_N							: out		std_logic;
		DRAM_CLK								: out		std_logic;

		VGA_BLANK_N : out STD_LOGIC;
		VGA_B : out STD_LOGIC_VECTOR(7 downto 0);
		VGA_CLK : out STD_LOGIC;
		VGA_G : out STD_LOGIC_VECTOR(7 downto 0);
		VGA_HS : out STD_LOGIC;
		VGA_R : out STD_LOGIC_VECTOR(7 downto 0);
		VGA_SYNC_N : out STD_LOGIC;
		VGA_VS : out STD_LOGIC;

		CAM_D		: in std_logic_vector(7 downto 0);
		CAM_RESET : out std_logic;
		CAM_HS : in std_logic;
		CAM_VS : in std_logic;
		CAM_SDA : inout std_logic;
		CAM_SCL : inout std_logic;
		CAM_MCLK : out std_logic;
		CAM_PCLK : in std_logic;
		
		KEY : in std_logic_vector(3 downto 0);
		LEDR : out std_logic_vector(9 downto 0);
		SW : in std_logic_vector(9 downto 0)
	);
end entity;

architecture Behavioral of top_vga_sdram is
	signal clk_int80						: std_logic;
	signal pll_sys_locked				: std_logic;
	signal reset_int_n					: std_logic;
	signal led_int							: std_logic_vector(9 downto 0);
	signal vga_clk_int 					: std_logic;
	
	component PLL_SYS is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;        -- clk
			outclk_1 : out std_logic;        -- clk
			outclk_2 : out std_logic;        -- clk
			outclk_3 : out std_logic;        -- clk
			locked   : out std_logic         -- export
		);
	end component PLL_SYS;
	
	component RESET_GEN
		port (
			clk_in								: in		std_logic;
			reset_n_1							: in		std_logic;
			reset_n_2							: in		std_logic;
			reset_out_n							: out		std_logic
		);
	end component;
	
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
            i2c_0_serial_sda_in           : in    std_logic                     := 'X';             -- sda_in
            i2c_0_serial_scl_in           : in    std_logic                     := 'X';             -- scl_in
            i2c_0_serial_sda_oe           : out   std_logic;                                        -- sda_oe
            i2c_0_serial_scl_oe           : out   std_logic;                                        -- scl_oe
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
            sdram_controller_0_wire_we_n  : out   std_logic                                         -- we_n
        );
    end component NIOS;
	
	component camera_fifo
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		wrfull		: OUT STD_LOGIC 
	);
	end component;

	signal i2c_0_serial_sda_in : std_logic;
	signal i2c_0_serial_scl_in : std_logic;
	signal i2c_0_serial_sda_oe : std_logic;
	signal i2c_0_serial_scl_oe : std_logic;
	
	component vga_fifo
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdfull		: OUT STD_LOGIC ;
		wrempty		: OUT STD_LOGIC ;
		wrfull		: OUT STD_LOGIC ;
		wrusedw		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
	end component;

	component vga_gen
    port ( 
	 	PIXEL_CLOCK : in std_logic; 
		RESET_N : in std_logic;
		VGA_HSYNC_OUT : out  STD_LOGIC;
		VGA_VSYNC_OUT : out  STD_LOGIC;
		VGA_R_OUT : out  STD_LOGIC_VECTOR(4 downto 0);
		VGA_G_OUT : out  STD_LOGIC_VECTOR(5 downto 0);
		VGA_B_OUT : out  STD_LOGIC_VECTOR(4 downto 0);

		--FIFO interface
		FIFO_RDREQ		: out STD_LOGIC ;
		FIFO_Q			: in STD_LOGIC_VECTOR (15 DOWNTO 0);
		FIFO_RDEMPTY		: in STD_LOGIC ;
		FIFO_RDFULL		: in STD_LOGIC	
	);
	end component;

signal vga_fifo_data		   : STD_LOGIC_VECTOR (15 DOWNTO 0);
signal vga_fifo_rdreq		: STD_LOGIC ;
signal vga_fifo_wrreq		: STD_LOGIC ;
signal vga_fifo_q			   : STD_LOGIC_VECTOR (15 DOWNTO 0);
signal vga_fifo_rdempty		: STD_LOGIC ;
signal vga_fifo_rdfull		: STD_LOGIC ;
signal vga_fifo_wrempty		: STD_LOGIC ;
signal vga_fifo_wrfull		: STD_LOGIC ;

signal avalon_mm_address             : std_logic_vector(31 downto 0) := (others => 'X'); -- address
signal avalon_mm_writedata           : std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
signal avalon_mm_read                : std_logic                     := 'X';             -- read_n
signal avalon_mm_write               : std_logic                     := 'X';             -- write_n
signal avalon_mm_readdata            : std_logic_vector(15 downto 0);                    -- readdata
signal avalon_mm_readdatavalid       : std_logic;                                        -- readdatavalid
signal avalon_mm_waitrequest         : std_logic;                                       -- waitrequest

signal read_addr : std_logic_vector(31 downto 0) := (others => '0');
signal write_addr : std_logic_vector(31 downto 0) := (others => '0');
signal read_addr_next : std_logic_vector(31 downto 0) := (others => '0');
signal write_addr_next : std_logic_vector(31 downto 0) := (others => '0');

signal sdram_write : std_logic := '0';

signal vga_fifo_wrusedw : std_logic_vector(9 downto 0);
signal vga_fifo_almost_empty : std_logic;
signal vga_fifo_almost_full : std_logic;

signal vga_fifo_feed_enabled : std_logic;

signal fifo_wr_allowed : std_logic;
signal fifo_flag_sel			: std_logic;
signal fifo_flag_sel_next	: std_logic;

signal DRAM_DQM : std_logic_vector(1 downto 0);

signal framebuffer_start_addr : std_logic_vector(31 downto 0) := (others=>'0');

signal pio_0_ext_out : std_logic_vector(31 downto 0);
signal pio_1_ext_in : std_logic_vector(7 downto 0);
--signal enable_vga : std_logic;

signal cam_clk : std_logic;
signal cam_data_reg : std_logic_vector(7 downto 0);
signal cam_fifo_wrfull : std_logic;
signal cam_fifo_wrreq : std_logic;
signal cam_fifo_wrdata : std_logic_vector(15 downto 0);
signal cam_fifo_rdreq : std_logic;
signal cam_fifo_rdempty : std_logic;
signal cam_fifo_rddata : std_logic_vector(15 downto 0);
signal cam_pixel_half : std_logic;
signal cam_frame_done : std_logic;
signal cam_start_capture : std_logic;

type CAM_ST is (CAM_ST_IDLE, CAM_ST_WAIT_FOR_SYNC, CAM_ST_CAPTURE, CAM_ST_DONE);
signal cam_state : CAM_ST;

signal avalon_write_reg : std_logic;
signal write_addr_max : integer;

begin
	--enable_vga <= pio_0_ext_out(0);
	cam_start_capture <= pio_0_ext_out(0);
	pio_1_ext_in <= SW(7 downto 0);

	framebuffer_start_addr <= X"00000000";

	DRAM_LDQM<=DRAM_DQM(0);
	DRAM_UDQM<=DRAM_DQM(1);
	VGA_BLANK_N<='1';
	VGA_SYNC_N<='0';
	VGA_CLK <= vga_clk_int;
					
		u0 : component PLL_SYS
		port map (
			refclk		=> CLOCK_50,
			rst			=> '0',
			outclk_0		=> clk_int80,
			outclk_1		=> DRAM_CLK,
			outclk_2		=> vga_clk_int,
			outclk_3		=> CAM_MCLK,
			locked		=> pll_sys_locked
		);
			
		u1 : component RESET_GEN
		port map (
			clk_in								=> clk_int80,
			reset_n_1							=> KEY(0),
			reset_n_2							=> pll_sys_locked,
			reset_out_n							=> reset_int_n
		);
		
		u2 : component NIOS
		port map (
			clk_clk								=> clk_int80,
			reset_reset_n						=> reset_int_n,
			sdram_controller_0_wire_addr	=> DRAM_ADDR(12 downto 0),						-- comment this line, if the full address width of 14 bits is required
			sdram_controller_0_wire_ba		=> DRAM_BA,
			sdram_controller_0_wire_cas_n	=> DRAM_CAS_N,
			sdram_controller_0_wire_cke	=> DRAM_CKE,
			sdram_controller_0_wire_cs_n	=> DRAM_CS_N,
			sdram_controller_0_wire_dq		=> DRAM_DQ,
			sdram_controller_0_wire_dqm	=> DRAM_DQM,
			sdram_controller_0_wire_ras_n	=> DRAM_RAS_N,
			sdram_controller_0_wire_we_n	=> DRAM_WE_N,
			avalon_mm_1_address             => avalon_mm_address,             --               avalon_mm.address
			avalon_mm_1_byteenable        => "11",        --                        .byteenable_n
			avalon_mm_1_writedata           => avalon_mm_writedata,           --                        .writedata
			avalon_mm_1_read              => avalon_mm_read,              --                        .read_n
			avalon_mm_1_write             => avalon_mm_write,             --                        .write_n
			avalon_mm_1_readdata            => avalon_mm_readdata,            --                        .readdata
			avalon_mm_1_readdatavalid       => avalon_mm_readdatavalid,       --                        .readdatavalid
			avalon_mm_1_waitrequest         => avalon_mm_waitrequest,          --                        .waitrequest
			avalon_mm_1_burstcount				=> "1",
			avalon_mm_1_debugaccess 		=> '0',
			pio_0_ext_out_export				=> pio_0_ext_out,
			pio_1_ext_in_export				=> pio_1_ext_in,
			i2c_0_serial_sda_in => i2c_0_serial_sda_in,
			i2c_0_serial_scl_in => i2c_0_serial_scl_in,
			i2c_0_serial_sda_oe => i2c_0_serial_sda_oe,
			i2c_0_serial_scl_oe => i2c_0_serial_scl_oe
			);
			
	
		vga_fifo_inst : vga_fifo 
		PORT MAP (
			aclr => not reset_int_n,
		
			data	 => vga_fifo_data,
			wrclk	 => clk_int80,
			wrreq	 => vga_fifo_wrreq,
			wrempty	 => vga_fifo_wrempty,
			wrfull	 => vga_fifo_wrfull,

			q	 => vga_fifo_q,
			rdclk	 => vga_clk_int,
			rdreq	 => vga_fifo_rdreq,
			rdempty	 => vga_fifo_rdempty,
			rdfull	 => vga_fifo_rdfull,
			wrusedw	=> vga_fifo_wrusedw
		);
		
		
		led_int <= cam_start_capture&cam_frame_done&
						avalon_mm_write & avalon_mm_waitrequest & cam_fifo_rdreq & cam_fifo_rdempty &
						sdram_write & "000";
						--sdram_write&avalon_mm_read&avalon_mm_readdatavalid&avalon_mm_waitrequest&
					--vga_fifo_rdempty&vga_fifo_wrreq&vga_fifo_almost_full&vga_fifo_almost_empty;

		vga_fifo_feed_enabled <= not sdram_write and SW(9);
		
		vga_fifo_almost_empty <= '1' when to_integer(unsigned(vga_fifo_wrusedw))<64 else '0';
		vga_fifo_almost_full <= '1' when to_integer(unsigned(vga_fifo_wrusedw))>1000 else '0';
		fifo_wr_allowed <= (not vga_fifo_almost_full) when fifo_flag_sel='1' else vga_fifo_almost_empty;

      avalon_mm_read <= fifo_wr_allowed when sdram_write='0' else '0';

		vga_fifo_feed_comb: process (read_addr, avalon_mm_read, fifo_wr_allowed, avalon_mm_readdatavalid, avalon_mm_waitrequest, vga_fifo_feed_enabled, framebuffer_start_addr) is
			variable read_addr_max : integer;
		begin
			read_addr_max := to_integer(unsigned(framebuffer_start_addr))+640*480-1;
			
			if vga_fifo_feed_enabled='1' then
				if fifo_wr_allowed='1' and avalon_mm_waitrequest='0' and avalon_mm_read='1' then
					--address increment when read asserted and sdram controller is ready to queue request
					if to_integer(unsigned(read_addr)) < read_addr_max then
						read_addr_next <= std_logic_vector(to_unsigned(to_integer(unsigned(read_addr)) + 1, 32));
					else
						read_addr_next <= framebuffer_start_addr;
					end if;
				else
					read_addr_next <= read_addr;
				end if;
			else
				read_addr_next <= framebuffer_start_addr;				
			end if;
		end process;

		vga_fifo_feed_flag_switch_comb: process (fifo_flag_sel, vga_fifo_almost_full, vga_fifo_almost_empty)
		begin
			if vga_fifo_almost_full='0' and vga_fifo_almost_empty='1' then
				fifo_flag_sel_next <= '1';
			elsif fifo_flag_sel <= '1' and vga_fifo_almost_full='1' then
				fifo_flag_sel_next <= '0';
			else
				fifo_flag_sel_next <= fifo_flag_sel;
			end if;
		end process;
		
		vga_fifo_feed_seq: process (clk_int80, reset_int_n) is
		begin
			if reset_int_n = '0' then
				fifo_flag_sel <= '1';		
				read_addr <= (others=>'0');		
			elsif rising_edge(clk_int80) then
				fifo_flag_sel <= fifo_flag_sel_next;
				read_addr <= read_addr_next;
			end if;
		end process;
	
		vga_fifo_wrreq <= avalon_mm_readdatavalid;
		vga_fifo_data <= avalon_mm_readdata;

			
		avalon_mm_address <= write_addr when sdram_write='1' else read_addr;
		avalon_mm_writedata <= cam_fifo_rddata;
		avalon_mm_write <= avalon_write_reg when sdram_write='1' else '0';

		write_addr_max <= to_integer(unsigned(framebuffer_start_addr)) + 640*480 - 1;
			
		-- WRITE PART
		--sdram_write <= '1' when (to_integer(unsigned(write_addr)) < write_addr_max) else '0';
		sdram_write <= not cam_frame_done;
		
		fifo_read_control_comb : process (cam_fifo_rdempty, avalon_write_reg, avalon_mm_waitrequest) is
		begin
			cam_fifo_rdreq<='0';
			if cam_fifo_rdempty='0' then
				if avalon_write_reg='0' then
					--avalon write not yet asserted
					cam_fifo_rdreq<='1';
				elsif avalon_write_reg='1' and avalon_mm_waitrequest='0' then
					--avalon write already asserted
					--avalon waitrequest deasserted by slave
					cam_fifo_rdreq<='1';
				end if;			
			end if;
		end process;
		
		sdram_addr_inc_comb: process (cam_start_capture, write_addr, avalon_write_reg, avalon_mm_waitrequest, framebuffer_start_addr, cam_frame_done, cam_fifo_rdreq) is
		begin
			if cam_start_capture='0' then
				write_addr_next <= framebuffer_start_addr;
			elsif cam_start_capture='1' and cam_frame_done='0' and avalon_write_reg='1' and avalon_mm_waitrequest='0' then -- and cam_fifo_rdreq='1' then
				write_addr_next <= std_logic_vector(to_unsigned(to_integer(unsigned(write_addr)) + 1, 32));
			else
				write_addr_next <= write_addr;
			end if;
		end process;
		
		sdram_write_seq: process (clk_int80, reset_int_n, framebuffer_start_addr) is
		begin
			if reset_int_n = '0' then
				write_addr <= framebuffer_start_addr;
				avalon_write_reg <= '0';
			elsif rising_edge(clk_int80) then
				write_addr <= write_addr_next;
				
				if avalon_write_reg='1' and avalon_mm_waitrequest='1' then
					avalon_write_reg <= '1';
				else
					avalon_write_reg <= not cam_fifo_rdempty;
				end if;					
			end if;
		end process;
	
-- =================================================
	
		vga_gen_inst : component vga_gen
		port map ( 
			PIXEL_CLOCK => vga_clk_int,
			RESET_N => reset_int_n,
			VGA_HSYNC_OUT => VGA_HS,
			VGA_VSYNC_OUT => VGA_VS,
			VGA_R_OUT => VGA_R(7 downto 3),
			VGA_G_OUT => VGA_G(7 downto 2),
			VGA_B_OUT => VGA_B(7 downto 3),
			FIFO_RDREQ => vga_fifo_rdreq,
			FIFO_Q => vga_fifo_q,
			FIFO_RDEMPTY => vga_fifo_rdempty,
			FIFO_RDFULL	=>	vga_fifo_rdfull
		);
		VGA_R(2 downto 0) <= "000";
		VGA_G(1 downto 0) <= "00";
		VGA_B(2 downto 0) <= "000";
		

	LEDR <= led_int;

	CAM_RESET <= reset_int_n;

	i2c_0_serial_scl_in <= CAM_SCL;
	CAM_SCL <= '0' when i2c_0_serial_scl_oe = '1' else 'Z';

	i2c_0_serial_sda_in <= CAM_SDA;
	CAM_SDA <= '0' when i2c_0_serial_SDA_oe = '1' else 'Z';
		
	--https://github.com/westonb/OV7670-Verilog/blob/master/src/camera_read.v
	--http://embeddedprogrammer.blogspot.com/2012/07/hacking-ov7670-camera-module-sccb-cheat.html
	
	cam_clk <= CAM_PCLK;

	camera_fifo_inst : camera_fifo PORT MAP (
		aclr => not reset_int_n,
		
		wrclk	 => cam_clk,
		wrreq	 => cam_fifo_wrreq,
		data	 => cam_fifo_wrdata,
		wrfull	=> cam_fifo_wrfull,

		rdclk	 => clk_int80,
		rdreq	 => cam_fifo_rdreq,
		q	 		=> cam_fifo_rddata,
		rdempty	=> cam_fifo_rdempty
	);

	cam_fifo_wrdata <= cam_data_reg & CAM_D;
	cam_fifo_wrreq <= cam_pixel_half;

	process (cam_clk, reset_int_n) is
	begin
		if reset_int_n = '0' then
			cam_state <= CAM_ST_IDLE;
			cam_frame_done <= '0';
			cam_pixel_half <= '0';
		elsif rising_edge(cam_clk) then
			cam_frame_done <= '0';
			cam_pixel_half <= '0';
			
			case cam_state is
			when CAM_ST_IDLE =>
				if cam_start_capture='1' and CAM_VS='1' then --controlled by NIOS PIO
					cam_state <= CAM_ST_WAIT_FOR_SYNC;
				end if;
				
			when CAM_ST_WAIT_FOR_SYNC =>
				if CAM_VS='0' then
					cam_state <= CAM_ST_CAPTURE;
				end if;
				
			when CAM_ST_CAPTURE =>
				if CAM_HS='1' then
					if cam_pixel_half='0' then --register top half
						cam_data_reg <= CAM_D;
					end if;
					cam_pixel_half <= not cam_pixel_half;
				end if;
				if CAM_VS='1' then
					cam_state <= CAM_ST_DONE;
				end if;
				
			when CAM_ST_DONE =>
				cam_frame_done <= '1';
				
			when others =>
				cam_state <= CAM_ST_IDLE;
				
			end case;
		end if;
	end process;

end architecture;