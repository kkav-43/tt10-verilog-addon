<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# Pythagorean Theorem Calculator (Tiny Tapeout)

## How It Works

This project implements a **Pythagorean theorem calculator** in hardware using Verilog. Given two 8-bit inputs, `x` and `y`, the design computes the hypotenuse using the formula:

\[
c = \sqrt{x^2 + y^2}
\]

### Features:
- **8-bit inputs (`x`, `y`)** and **8-bit output (`c`)**.
- **No multiplications (`*`)** – uses shift-and-add for squaring.
- **Bitwise approximation for square root**.
- **Designed for Tiny Tapeout constraints**.

### Inputs:
- `ui_in[7:0]` → Input `x`
- `uio_in[7:0]` → Input `y`
- `clk` → Clock signal  
- `rst_n` → Active-low reset  

### Processing:
- Computes **x²** and **y²** using iterative addition.
- Approximates **sqrt(x² + y²)** using a bitwise method.

### Output:
- `uo_out[7:0]` → Outputs computed **hypotenuse** (`c`).

---

## How to Test

### 1. Run the Testbench

#### **Prerequisites**
- Install **Icarus Verilog** (`iverilog`) and **GTKWave**:
  ```sh
  sudo apt install iverilog gtkwave
  ```

#### **Compile and Simulate**
Run the following command to compile and execute the testbench:
```sh
iverilog -g2012 -Wall src/tt_um_pythagoras.sv test/testbench.sv -o sim.out
vvp sim.out
```

#### **Test Cases**
| Test Case | Input `x` | Input `y` | Expected Output `c` |
|-----------|----------|----------|----------------|
| 1         | 3        | 4        | 5              |
| 2         | 6        | 8        | 10             |
| 3         | 5        | 12       | 13             |
| 4         | 7        | 24       | 25             |
| 5         | 10       | 10       | 14             |
| 6         | 15       | 20       | 25             |

#### **View Waveform**
To visualize the simulation waveforms, use:
```sh
gtkwave tb_pythagoras.vcd
```

---

## External Hardware

- **Seven-segment display** for output visualization.
- **PMODs** for interactive input.
- **Serial UART interface** for debugging.

---

