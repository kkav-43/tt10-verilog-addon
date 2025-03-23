# Makefile for Pythagorean Theorem Chip (Tiny Tapeout)
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# Defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src

# Update the project source file name to match your Verilog module
PROJECT_SOURCES = tt_um_pythagoras.v

ifneq ($(GATES),yes)

# RTL Simulation:
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# Gate Level Simulation:
SIM_BUILD = sim_build/gl
COMPILE_ARGS += -DGL_TEST
COMPILE_ARGS += -DFUNCTIONAL
COMPILE_ARGS += -DUSE_POWER_PINS
COMPILE_ARGS += -DSIM
COMPILE_ARGS += -DUNIT_DELAY=\#1

# Add Sky130 standard cell library for gate-level simulation
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# Include gate-level netlist generated from synthesis
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Allow sharing configuration between design and testbench via `include`:
COMPILE_ARGS += -I$(SRC_DIR)

# Include the testbench sources
VERILOG_SOURCES += $(PWD)/testbench.v  # Update to match testbench file

# Set the top-level module for simulation
TOPLEVEL = tb_pythagoras  # Update to match testbench module name

# MODULE is the basename of the Python test file
MODULE = test_pythagoras  # Update to match your testbench script

# Include cocotb's make rules to handle the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
