# NEORV32 Test Setup for AdaBMP Project Guidelines

## Overview
This repository contains a NEORV32 test setup for the Ada Baremetal Programmer (AdaBMP) project, adapted for the Xilinx Artix-7 on the Basys3 FPGA board.

## Build and Hardware Setup
- **Target environment**: Vivado with Xilinx Artix-7 (Basys3 board)
- **Build command**: To set up and build the Vivado project, navigate to the `setup/` directory and run: 
  `vivado -mode batch -source create_project.tcl`
- **Programming command**: Use `setup/program_bitstream.tcl` to program the device.
- **Simulation**: Found in the `sim/` directory (use `ghdl.sh` for GHDL simulation).

## Hardware Details
- **Connectivity**: Primarily SPI and JTAG.
- **Bootloader**: UART Bootloader Baud Rate is `115200`.
- **Flash Address**: Flash Firmware Address is `0x300000`.

## Architecture & Code Organization
- **RTL**: VHDL source files for the NEORV32 processor and peripherals are located in `rtl/`.
- **Setup**: XDC constraint files and Vivado TCL scripts are located in `setup/`.
- **Software**: Firmware, bootloader, libs, and examples are located in `sw/`.
- **Documentation**: Extensive Asciidoctor (`.adoc`) and doxygen documentation is detailed in `docs/`.

## General Conventions
- Maintain compatibility with the NEORV32 upstream where possible.
- Use explicit VHDL-93/VHDL-2008 syntax consistently as established in the current `rtl/` codebase.
