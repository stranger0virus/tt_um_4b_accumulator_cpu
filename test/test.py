# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)
    
    dut._log.info("Test project behavior")

    # Helper to apply signals and wait N cycles
    async def apply(ui, uio, cycles=1):
        dut.ui_in.value = ui
        dut.uio_in.value = uio
        await ClockCycles(dut.clk, cycles)

        dut._log.info(
            f"ui_in={ui:08b} uio_in={uio:08b}  ->  uo_out={dut.uo_out.value.integer:02X}"
        )

    # ui_in = 8'b00100001; uio_in = 0;
    await apply(0b00100001, 0b00000000, 1)

    # ui_in = 8'b00110001; uio_in = 0;
    await apply(0b00110001, 0b00000000, 1)

    # ui_in = 8'b01000010; uio_in = 0;
    await apply(0b01000010, 0b00000000, 1)

    # ui_in = 8'b01010010; uio_in = 0;
    await apply(0b01010010, 0b00000000, 1)

    # ui_in = 8'b00100001; uio_in = 1; (repeat for ~300 ns)
    await apply(0b00100001, 0b00000001, 30)

    dut._log.info("Simulation Complete.")

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
