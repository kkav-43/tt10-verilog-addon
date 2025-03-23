# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_pythagoras(dut):
    dut._log.info("Starting Pythagoras Chip Test")

    # Set up 100 MHz clock (10ns period)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset sequence
    dut._log.info("Applying reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 20)  # Hold reset for 20 cycles
    dut.rst_n.value = 1
    dut._log.info("Reset complete")

    # Test cases
    test_cases = [
        (3, 4, 5),    # sqrt(3² + 4²) = 5
        (6, 8, 10),   # sqrt(6² + 8²) = 10
        (10, 10, 14), # sqrt(10² + 10²) = 14
        (12, 16, 20), # sqrt(12² + 16²) = 20
    ]

    dut._log.info("Starting test cases...")
    
    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y

        await ClockCycles(dut.clk, 5)  # Allow computation time

        actual = int(dut.uo_out.value)
        dut._log.info(f"Testing: x={x}, y={y}, Expected sqrt(x² + y²)={expected}, Got={actual}")

        assert actual == expected, \
            f"Test failed for x={x}, y={y}: Expected {expected}, Got {actual}"

    dut._log.info("✅ All tests passed successfully!")
