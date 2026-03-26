# NEORV32 Test Setup for Ada Baremetal Programmer

This is a NEORV32 test setup for the AdaBMP (Ada Baremetal Programmer) project. 

It is based on `neorv32_test_setup_bootloader.vhd` but has been adapted for the Xilinx Artix-7 on the Basys3 board, providing SPI and JTAG connectivity.

## Overview of Changes
- **Target Board:** Basys3
- **Connectivity:** SPI and JTAG
- **UART Bootloader Baud Rate:** 115200
- **Flash Firmware Address:** `0x300000`

## Build Instructions

To build navigate to `/setup` and execute the following command:

`vivado -mode batch -source create_project.tcl`

Bitstream will be written to:

`/setup/work/basys3-test-setup.runs/impl_1/neorv32_test_setup_adabmp.bit`