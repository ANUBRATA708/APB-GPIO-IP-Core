# APB Interfaced GPIO IP Core — RTL Design

A General Purpose Input Output (GPIO) IP core with an APB (Advanced Peripheral Bus) slave interface, designed in Verilog HDL as part of a VLSI Design Internship at Maven Silicon.

**Author:** Anubrata Majumdar
**College:** Vellore Institute of Technology, Chennai
**Batch:** B2B DI 07 — APB Based GPIO

---

## 📌 About the Project

In SoC designs, GPIO is one of the most essential peripheral blocks, enabling the processor to communicate with external hardware such as LEDs, switches, and sensors. This project implements a GPIO IP core connected to the processor through the APB protocol (part of the AMBA family), which is optimized for low-power, low-complexity peripheral communication.

The design includes dedicated registers for GPIO output data and output-enable (direction) control, along with an auxiliary input interface for external data synchronization. The full design was implemented at RTL using Verilog, simulated in ModelSim, and synthesized in Quartus Prime.

## 🎯 Features Implemented

- APB Slave interface for processor communication
- GPIO Output Register (`RGPIO_OUT`, address `0x4`)
- GPIO Output Enable Register (`RGPIO_OE`, address `0x8`)
- GPIO input read capability through the APB interface
- Auxiliary input interface support
- Bidirectional GPIO pads via tri-state buffers
- Synchronous reset operation
- APB read and write transactions
- Interrupt output provision (currently tied to logic 0)

## 🧩 Architecture

The design is split into four sub-blocks under a top-level `apb_gpio_top` module:

| Block | Function |
|---|---|
| **APB Slave** | Decodes APB read/write transactions, generates internal control signals (`gpio_we`, `gpio_addr`, etc.) and returns read data / interrupts to the master |
| **GPIO Registers** | Stores `RGPIO_OUT` and `RGPIO_OE`, handles APB read/write and GPIO direction control |
| **Auxiliary Interface** | Synchronizes external auxiliary input (`aux_in`) into the core (`aux_i`) |
| **IO Interface** | Implements tri-state behavior, drives/reads the physical bidirectional `io_pad` bus, generates the external GPIO clock |

### Top-Level Ports

| Signal | Width | Direction | Description |
|---|---|---|---|
| `PCLK_i` | 1 | in | System clock |
| `PRESETn_i` | 1 | in | Active-low reset |
| `PWRITE_i` | 1 | in | Write (1) / Read (0) |
| `PADDR_i` | 4 | in | Register address |
| `PWDATA_i` | 32 | in | Write data |
| `PSEL_i` | 1 | in | Peripheral select |
| `PENABLE_i` | 1 | in | APB enable phase |
| `USER_AUX_IN` | 32 | in | Auxiliary input bus |
| `PRDATA_o` | 32 | out | Read data |
| `PREADY_o` | 1 | out | Transfer-ready handshake |
| `INT_REQ_o` | 1 | out | Interrupt request |
| `EXTERNAL_IO_PAD` | 32 | inout | Bidirectional physical I/O pins |
| `REF_CLK_IN` | 1 | in | External reference clock |

## 🔌 APB Protocol

APB transactions complete in two phases:

1. **Setup phase** — `PSEL = 1`, address/data/`PWRITE` driven, `PENABLE = 0`.
2. **Enable phase** — `PENABLE = 1` asserted on the next clock edge, completing the transfer.

**Example write:** address `0x4`, data `0xAAAAAAAA` → `RGPIO_OUT = 0xAAAAAAAA`
**Example read:** address `0x4` → `PRDATA = 0xAAAAAAAA`

## 🧪 Verification

Verified in ModelSim across 6 test cases, all passing:

1. Reset check — registers reset successfully
2. APB write to `RGPIO_OUT`
3. APB write to `RGPIO_OE`
4. GPIO output reflected on `io_pad`
5. APB read of `RGPIO_OUT`
6. Auxiliary input transferred correctly

```
TESTCASE 1 : RESET CHECK              -> PASS
TESTCASE 2 : APB WRITE RGPIO_OUT      -> PASS
TESTCASE 3 : APB WRITE RGPIO_OE       -> PASS
TESTCASE 4 : GPIO OUTPUT CHECK        -> PASS
TESTCASE 5 : APB READ RGPIO_OUT       -> PASS
TESTCASE 6 : AUXILIARY INPUT CHECK    -> PASS
ALL TESTCASES COMPLETED
```

## 🛠️ Tools Used

- **RTL Design:** Verilog HDL
- **Simulation:** ModelSim (Intel FPGA Starter Edition 2020.1)
- **Synthesis / Implementation:** Quartus Prime Lite Edition (target device: Cyclone V, `5CGXFC7C7F23C8`)

## 📊 Synthesis Summary

| Metric | Value |
|---|---|
| Logic utilization (ALMs) | 36 / 56,480 (< 1%) |
| Total registers | 97 |
| Total pins | 140 / 268 (52%) |
| Total DSP blocks | 0 |
| Compilation status | Successful, 0 errors |

## 📂 Repository Contents

- `apb_gpio_top.v` — Top-level module
- `apb_slave.v` — APB slave interface
- `gpio_registers.v` — GPIO register block
- `aux_interface.v` — Auxiliary input interface
- `io_interface.v` — Tri-state IO interface
- `tb_apb_gpio.v` — Testbench
- Report / waveform screenshots (RTL schematic, post-mapping, post-fitting, simulation waveforms)

## ✅ Conclusion

The APB-based GPIO IP core was successfully designed in Verilog HDL and verified in ModelSim. APB read/write operations, GPIO output control, direction control, and auxiliary interface functionality were all validated through simulation, with all test cases passing.

---

*Internship project completed at Maven Silicon — Centre of Excellence in VLSI, as part of BECE curriculum, Vellore Institute of Technology, Chennai.*
