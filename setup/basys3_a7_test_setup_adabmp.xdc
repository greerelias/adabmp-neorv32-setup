## ===============================================================
## Basys3 Minimal Constraints for NEORV32 Bootloader Test Setup
## ===============================================================

## Clock input (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk_i]
set_property IOSTANDARD LVCMOS33 [get_ports clk_i]
create_clock -period 10.000 -name sys_clk_pin [get_ports clk_i]

## Reset button (BTNC)
set_property PACKAGE_PIN U18 [get_ports rstn_i]
set_property IOSTANDARD LVCMOS33 [get_ports rstn_i]

## UART0 (USB-UART bridge on Basys3)
# J1 = RX from FTDI to FPGA (uart0_rxd_i)
# L2 = TX from FPGA to FTDI (uart0_txd_o)
# set_property PACKAGE_PIN B18 [get_ports uart0_rxd_i]
set_property PACKAGE_PIN J1 [get_ports uart0_rxd_i]
set_property IOSTANDARD LVCMOS33 [get_ports uart0_rxd_i]
# set_property PACKAGE_PIN A18 [get_ports uart0_txd_o]
set_property PACKAGE_PIN L2 [get_ports uart0_txd_o]
set_property IOSTANDARD LVCMOS33 [get_ports uart0_txd_o]

## Optional GPIO outputs (connect to on-board LEDs LD0–LD7)
set_property PACKAGE_PIN U16 [get_ports {gpio_o[0]}]
set_property PACKAGE_PIN E19 [get_ports {gpio_o[1]}]
set_property PACKAGE_PIN U19 [get_ports {gpio_o[2]}]
set_property PACKAGE_PIN V19 [get_ports {gpio_o[3]}]
set_property PACKAGE_PIN W18 [get_ports {gpio_o[4]}]
set_property PACKAGE_PIN U15 [get_ports {gpio_o[5]}]
set_property PACKAGE_PIN U14 [get_ports {gpio_o[6]}]
set_property PACKAGE_PIN V14 [get_ports {gpio_o[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_o[*]}]

## Bitstream configuration
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## ===============================================================
## SPI Flash Signals (Macronix MX25L3233F on Basys3)
## ===============================================================

## SPI Chip Select (CS#)
set_property PACKAGE_PIN K19 [get_ports spi_csn_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_csn_o]

## SPI Master Out Slave In (MOSI / DQ0)
set_property PACKAGE_PIN D18 [get_ports spi_dat_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_dat_o]

## SPI Master In Slave Out (MISO / DQ1)
set_property PACKAGE_PIN D19 [get_ports spi_dat_i]
set_property IOSTANDARD LVCMOS33 [get_ports spi_dat_i]

## SPI Write Protect (WP# / DQ2) - Driven HIGH in VHDL
set_property PACKAGE_PIN G18 [get_ports flash_wp_o]
set_property IOSTANDARD LVCMOS33 [get_ports flash_wp_o]

## SPI Hold (HOLD# / DQ3) - Driven HIGH in VHDL
set_property PACKAGE_PIN F18 [get_ports flash_hold_o]
set_property IOSTANDARD LVCMOS33 [get_ports flash_hold_o]

## ===============================================================
## JTAG Signals on Pmod JA (JA7-JA10)
## ===============================================================

## JA7 - TMS
set_property PACKAGE_PIN H1 [get_ports jtag_tms_i]
set_property IOSTANDARD LVCMOS33 [get_ports jtag_tms_i]

## JA8 - TDI
set_property PACKAGE_PIN K2 [get_ports jtag_tdi_i]
set_property IOSTANDARD LVCMOS33 [get_ports jtag_tdi_i]

## JA9 - TDO
set_property PACKAGE_PIN H2 [get_ports jtag_tdo_o]
set_property IOSTANDARD LVCMOS33 [get_ports jtag_tdo_o]

## JA10 - TCK
set_property PACKAGE_PIN G3 [get_ports jtag_tck_i]
set_property IOSTANDARD LVCMOS33 [get_ports jtag_tck_i]