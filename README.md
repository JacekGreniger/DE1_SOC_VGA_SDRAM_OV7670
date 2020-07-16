Project description:
Gets one shot from camera and continously displays it over VGA. Picture is stored in SDRAM. Softcore NIOS is used just for initializing camera over I2C but has access to VGA framebuffer so picture analysis is possible in SW.

Pixel data flow:
OV7670 (INPUT) -> cam_fifo -> AVALON_MM -> SDRAM (frame buffer) -> AVALON_MM -> vga_fifo -> vga_gen -> VGA (OUTPUT)

HW: DE1 SOC board and OV7670 camera
SW: Quartus Lite 18.1 (QSYS and Eclipse)

![alt text](https://github.com/JacekGreniger/DE1_SOC_VGA_SDRAM_OV7670/blob/master/its_working.jpg)
