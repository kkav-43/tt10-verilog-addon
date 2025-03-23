# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_pythagoras(dut):
    dut._log.info("Start")

    # Set the clock period to 10ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Testing Pythagorean theorem implementation")

    # Test cases
    test_cases = [
        (3, 4, 5),    # sqrt(3² + 4²) = 5
        (6, 8, 10),   # sqrt(6² + 8²) = 10
        (10, 10, 14), # sqrt(10² + 10²) = 14
        (12, 16, 20), # sqrt(12² + 16²) = 20
    ]

    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"Testing: x={x}, y={y}, Expected sqrt(x² + y²)={expected}, Got={int(dut.uo_out.value)}")
        assert int(dut.uo_out.value) == expected, f"Test failed for x={x}, y={y}"

    dut._log.info("All tests passed!")
