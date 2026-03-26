# Create Vivado project and generate bitstream
# Usage: vivado -mode batch -source create_project.tcl

set board "basys3"

# Create and clear output directory
set outputdir work
file mkdir $outputdir

set files [glob -nocomplain "$outputdir/*"]
if {[llength $files] != 0} {
    puts "deleting contents of $outputdir"
    file delete -force {*}[glob -directory $outputdir *]; # clear folder contents
} else {
    puts "$outputdir is empty"
}

switch $board {
  "basys3" {
    set a7part "xc7a35tcpg236-1"
    set a7prj ${board}-test-setup
  }
}

# Create project
create_project -part $a7part $a7prj $outputdir

#set_property board_part digilentinc.com:${board}:part0:1.1 [current_project]
set_property target_language VHDL [current_project]

# Define filesets

## Core: NEORV32
add_files [glob ./../rtl/core/*.vhd]
set_property library neorv32 [get_files [glob ./../rtl/core/*.vhd]]

## Design: processor subsystem template (local version with modified reset polarity)
set fileset_design "./../rtl/test_setups/neorv32_test_setup_adabmp.vhd"

## Constraints
set fileset_constraints [glob ./basys3_a7_test_setup_adabmp.xdc]

## Simulation-only sources
set fileset_sim [list ./../sim/neorv32_tb.vhd ./../sim/sim_uart_rx.vhd]

## Design
add_files $fileset_design

## Constraints
add_files -fileset constrs_1 $fileset_constraints

## Simulation-only
add_files -fileset sim_1 $fileset_sim

# Run synthesis, implementation and bitstream generation
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
