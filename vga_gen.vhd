library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity vga_gen is
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
		FIFO_RDEMPTY	: in STD_LOGIC ;
		FIFO_RDFULL		: in STD_LOGIC
	);
end vga_gen;


architecture Behavioral of vga_gen is

signal vga_enabled : std_logic := '0';
signal hsync : std_logic;
signal vsync : std_logic;
signal active_area : std_logic;
signal hcounter : integer range 0 to 1023;
signal vcounter : integer range 0 to 1023;
signal pixel_colors : std_logic_vector(8 downto 0);
signal line_cnt : integer range 0 to 31;
signal idle_cnt : integer range 0 to 4095;
signal fifo_read_en : std_logic;

begin

	enable_fifo_fetch: process (pixel_clock, RESET_N) is
	begin
		if (RESET_N = '0') then
			vga_enabled <= '0';
			idle_cnt <= 0;
		elsif rising_edge(pixel_clock) then
			if idle_cnt=0 and FIFO_RDEMPTY='0' then --there are first data in the fifo so start counter
				idle_cnt <= 1;
			elsif idle_cnt>=1 and idle_cnt < 1024 then
				idle_cnt <= idle_cnt + 1;
			elsif idle_cnt >= 1024 and vsync = '0' then --enable vga when vertical sync occures and counter expires
				vga_enabled <= '1';
			end if;
		end if;
	end process;

	generate_idle_image: process (pixel_clock) is
	begin
		if rising_edge(pixel_clock) then
			if vsync = '0' then
				line_cnt <= 0;
				pixel_colors <= "000000000";
			elsif hsync = '0' and hcounter=10 then
--				if line_cnt < 20 then
--					line_cnt <= line_cnt + 1;
--				else
					pixel_colors <= std_logic_vector(to_unsigned(to_integer(unsigned(pixel_colors)) + 1, 9));
--					line_cnt <= 0;
--				end if;
			end if;
		end if;
	end process;

	process(pixel_clock)
	begin
		if rising_edge(pixel_clock) then
			if hcounter = 799 then --800 us
				hcounter <= 0;
				if vcounter = 520 then --521 lines
					vcounter <= 0;
				else
					vcounter <= vcounter+1;
				end if;
			else
				hcounter <= hcounter+1;
			end if;
		end if;
	end process;


	process(hcounter, vcounter)
	begin
		hsync <= '1';
		vsync <= '1';

		if vcounter >= (2+29) and vcounter < (2+29+480) and hcounter >= (96+48) and hcounter < (96+48+640) then
			active_area <= '1';
		else
			active_area <= '0';
		end if;

		if hcounter < 96 then
			hsync <= '0';
		end if;

		if vcounter < 2 then
			vsync <= '0';
		end if;
	end process;

	VGA_HSYNC_OUT <= hsync;
	VGA_VSYNC_OUT<= vsync;
	VGA_R_OUT <= FIFO_Q(15 downto 11) when vga_enabled='1' and active_area='1' else
					pixel_colors(8 downto 6)&"00" when vga_enabled='0' and active_area='1' else 
					"00000";
	VGA_G_OUT <= FIFO_Q(10 downto 5) when vga_enabled='1' and active_area='1' else
					pixel_colors(5 downto 3)&"000" when vga_enabled='0' and active_area='1' else 
					"000000";
	VGA_B_OUT <= FIFO_Q(4 downto 0) when vga_enabled='1' and active_area='1' else 
					pixel_colors(2 downto 0)&"00" when vga_enabled='0' and active_area='1' else 
					"00000";

	fifo_read_en <= '1' when vcounter >= (2+29) and vcounter < (2+29+480) and hcounter >= (95+48) and hcounter < (95+48+640) else '0';
					
	FIFO_RDREQ <= vga_enabled and fifo_read_en and not FIFO_RDEMPTY;

end Behavioral;

