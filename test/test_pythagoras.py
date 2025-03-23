# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_pythagorean_calculator(dut):
    """Test the Pythagorean Calculator with various input cases."""
    
    dut._log.info("Starting Pythagorean Calculator Test")

    # Set up 10 MHz clock (100ns period)
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())

    # Reset sequence
    dut._log.info("Applying reset")
    dut.ena.value = 1  # Enable the module
    dut.ui_in.value = 0  # X input
    dut.uio_in.value = 0  # Y input
    dut.rst_n.value = 0  # Active-low reset

    await ClockCycles(dut.clk, 20)  # Hold reset for stability
    dut.rst_n.value = 1  # Release reset
    await ClockCycles(dut.clk, 5)  # Allow stabilization

    dut._log.info("Reset complete")

    # Test cases: (X, Y, Expected sqrt(X² + Y²))
    test_cases = [
        (3, 4, 5),    # sqrt(3² + 4²) = 5
        (6, 8, 10),   # sqrt(6² + 8²) = 10
        (5, 12, 13),  # sqrt(5² + 12²) = 13
        (8, 15, 17),  # sqrt(8² + 15²) = 17
        (12, 16, 20), # sqrt(12² + 16²) = 20
    ]

    dut._log.info("Starting test cases...")

    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y

        await ClockCycles(dut.clk, 15)  # Wait for square root computation

        actual = int(dut.uo_out.value)
        dut._log.info(f"Testing: x={x}, y={y}, Expected sqrt(x² + y²)={expected}, Got={actual}")

        assert actual == expected, \
            f"Test failed for x={x}, y={y}: Expected {expected}, Got {actual}"

    dut._log.info("✅ All test cases passed successfully!")
