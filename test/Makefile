# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

# Default simulator (Icarus Verilog)
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Define project directories
SRC_DIR = $(PWD)/../src
TEST_DIR = $(PWD)

# Update source files to match your folder structure
PROJECT_SOURCES = tt_um_addon.v

ifneq ($(GATES),yes)

# RTL Simulation:
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(SRC_DIR)/$(PROJECT_SOURCES)

else

# Gate-Level Simulation:
SIM_BUILD = sim_build/gl
COMPILE_ARGS += -DGL_TEST
COMPILE_ARGS += -DFUNCTIONAL
COMPILE_ARGS += -DUSE_POWER_PINS
COMPILE_ARGS += -DSIM
COMPILE_ARGS += -DUNIT_DELAY=\#1

# Sky130 PDK library paths (update PDK_ROOT if needed)
PDK_ROOT ?= /path/to/sky130
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# Include synthesized gate-level netlist
VERILOG_SOURCES += $(SRC_DIR)/gate_level_netlist.v

endif

# Include testbench and other sources
VERILOG_SOURCES += $(TEST_DIR)/tb_pythagoras.v

# Set the top-level module for simulation
TOPLEVEL = tb_pythagoras

# Python testbench script
MODULE = test_pythagoras

# Include cocotb's make rules
include $(shell cocotb-config --makefiles)/Makefile.sim
