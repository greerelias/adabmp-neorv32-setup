# Simple bitstream programming script for Basys3
# Usage: vivado -mode batch -source program_bitstream.tcl

open_hw
connect_hw_server
open_hw_target

# Select device
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device [current_hw_device]

# Program bitstream
set bitfile "work/basys3-test-setup.runs/impl_1/neorv32_test_setup_adabmp.bit"
set_property PROGRAM.FILE $bitfile [current_hw_device]
program_hw_devices [current_hw_device]

# Close connection
refresh_hw_device [current_hw_device]
close_hw_target
disconnect_hw_server
