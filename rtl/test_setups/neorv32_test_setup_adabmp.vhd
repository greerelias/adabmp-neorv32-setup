-- ================================================================================ --
-- NEORV32 - Test Setup Using The UART-Bootloader To Upload And Run Executables     --
-- -------------------------------------------------------------------------------- --
-- The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32              --
-- Copyright (c) NEORV32 contributors.                                              --
-- Copyright (c) 2020 - 2025 Stephan Nolting. All rights reserved.                  --
-- Licensed under the BSD-3-Clause license, see LICENSE for details.                --
-- SPDX-License-Identifier: BSD-3-Clause                                            --
-- ================================================================================ --
-- Test setup for AdaBMP includes SPI and JTAG for Basys3 board.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity neorv32_test_setup_adabmp is
  generic (
    -- adapt these for your setup --
    CLOCK_FREQUENCY : natural := 100000000; -- clock frequency of clk_i in Hz
    IMEM_SIZE       : natural := 64*1024;   -- size of processor-internal instruction memory in bytes
    DMEM_SIZE       : natural := 64*1024     -- size of processor-internal data memory in bytes
  );
  port (
    -- Global control --
    clk_i        : in  std_ulogic; -- global clock, rising edge
    rstn_i       : in  std_ulogic; -- global reset, low-active, async
    -- GPIO --
    gpio_o       : out std_ulogic_vector(7 downto 0); -- parallel output
    -- UART0 --
    uart0_txd_o  : out std_ulogic; -- UART0 send data
    uart0_rxd_i  : in  std_ulogic;  -- UART0 receive data
    spi_csn_o    : out std_ulogic;
    spi_dat_o    : out std_ulogic;
    spi_dat_i    : in  std_ulogic;
    flash_wp_o   : out std_ulogic;
    flash_hold_o : out std_ulogic; 

    jtag_tck_i   : in std_ulogic;
    jtag_tdi_i   : in std_ulogic; 
    jtag_tms_i   : in std_ulogic;
    jtag_tdo_o   : out std_ulogic
  );
end entity;

architecture neorv32_test_setup_adabmp_rtl of neorv32_test_setup_adabmp is

  signal con_gpio_out : std_ulogic_vector(31 downto 0);
  signal spi_clk_internal : std_ulogic;

begin
  flash_wp_o   <= '1';
  flash_hold_o <= '1';
  -- The Core Of The Problem ----------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  neorv32_top_inst: neorv32_top
  generic map (
    -- Clocking --
    CLOCK_FREQUENCY  => CLOCK_FREQUENCY,   -- clock frequency of clk_i in Hz
    -- Boot Configuration --
    BOOT_MODE_SELECT => 0,                 -- boot via internal bootloader
    -- RISC-V CPU Extensions --
    RISCV_ISA_C      => true,              -- implement compressed extension?
    RISCV_ISA_M      => true,              -- implement mul/div extension?
    RISCV_ISA_Zicntr => true,              -- implement base counters?
    -- Internal Instruction memory --
    IMEM_EN          => true,              -- implement processor-internal instruction memory
    IMEM_SIZE        => IMEM_SIZE, -- size of processor-internal instruction memory in bytes
    -- Internal Data memory --
    DMEM_EN          => true,              -- implement processor-internal data memory
    DMEM_SIZE        => DMEM_SIZE, -- size of processor-internal data memory in bytes
    -- Processor peripherals --
    IO_GPIO_NUM      => 8,                 -- number of GPIO input/output pairs (0..32)
    IO_CLINT_EN      => true,              -- implement core local interruptor (CLINT)?
    IO_UART0_EN      => true,               -- implement primary universal asynchronous receiver/transmitter (UART0)?
    IO_SPI_EN        => true,
    -- JEDEC Code
    OCD_EN           => true,
    OCD_JEDEC_ID     => "10011001100"      -- Made up JEDEC idcode 0x787 / dec 1927

  )
  port map (
    -- Global control --
    clk_i       => clk_i,        -- global clock, rising edge
    rstn_i      => not(rstn_i),       -- global reset, high-active, async
    -- GPIO (available if IO_GPIO_NUM > 0) --
    gpio_o      => con_gpio_out, -- parallel output
    -- primary UART0 (available if IO_UART0_EN = true) --
    uart0_txd_o => uart0_txd_o,  -- UART0 send data
    uart0_rxd_i => uart0_rxd_i,   -- UART0 receive data
    -- SPI ports
    spi_clk_o                  => spi_clk_internal, -- Goes to STARTUPE2
    spi_dat_o                  => spi_dat_o,        -- Goes to top-level port (MOSI)
    spi_dat_i                  => spi_dat_i,        -- Comes from top-level port (MISO)
    spi_csn_o(0)               => spi_csn_o,        -- Goes to top-level port (CS#)
    spi_csn_o(7 downto 1)      => open,             -- Leave the unused CS pins open
    --JTAG
    jtag_tck_i => jtag_tck_i,  -- JTAG clock
    jtag_tdi_i => jtag_tdi_i,  -- JTAG data in
    jtag_tms_i => jtag_tms_i,  -- JTAG mode select
    jtag_tdo_o => jtag_tdo_o  -- JTAG data out
  );

  STARTUPE2_inst : STARTUPE2
    generic map (
      PROG_USR => "FALSE",
      SIM_CCLK_FREQ => 0.0
    )
    port map (
      CFGCLK    => open,
      CFGMCLK   => open,
      EOS       => open,
      PREQ      => open,
      CLK       => '0',
      GSR       => '0',
      GTS       => '0',
      KEYCLEARB => '1',
      PACK      => '0',
      USRCCLKO  => spi_clk_internal, -- Connected to the internal NEORV32 clock signal
      USRCCLKTS => '0',
      USRDONEO  => '1',
      USRDONETS => '1'
    );


  -- GPIO output --
  gpio_o <= con_gpio_out(7 downto 0);


end architecture;
