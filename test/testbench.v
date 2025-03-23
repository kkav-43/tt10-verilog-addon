`default_nettype none
`timescale 1ns / 1ps

/* Testbench for Pythagorean Theorem Chip (Tiny Tapeout) */
module tb_pythagoras ();

  // Dump the signals to a VCD file for waveform analysis.
  initial begin
    $dumpfile("tb_pythagoras.vcd");
    $dumpvars(0, tb_pythagoras);
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  `ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
  `endif

  // Generate Clock (10ns period -> 100MHz)
  always #5 clk = ~clk;

  // Instantiate Design Under Test (DUT)
  tt_um_addon user_project (
      `ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
      `endif
      .ui_in  (ui_in),    // x input
      .uio_in (uio_in),   // y input
      .uo_out (uo_out),   // Output sqrt(x² + y²)
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  // Initialize signals
  initial begin
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    // Initialize outputs (to avoid X/Z states in some simulators)
    #1;
    
    // Apply Reset
    repeat (2) @(posedge clk);
    rst_n = 1;  // Release reset

    // Apply Test Cases
    repeat (2) @(posedge clk);
    ui_in = 8'd3; uio_in = 8'd4;  // sqrt(3² + 4²) = 5
    repeat (4) @(posedge clk);
    $display("Time=%0t | x=%d, y=%d, sqrt(x² + y²)=%d", $time, ui_in, uio_in, uo_out);

    repeat (2) @(posedge clk);
    ui_in = 8'd6; uio_in = 8'd8;  // sqrt(6² + 8²) = 10
    repeat (4) @(posedge clk);
    $display("Time=%0t | x=%d, y=%d, sqrt(x² + y²)=%d", $time, ui_in, uio_in, uo_out);

    repeat (2) @(posedge clk);
    ui_in = 8'd10; uio_in = 8'd10; // sqrt(10² + 10²) = 14
    repeat (4) @(posedge clk);
    $display("Time=%0t | x=%d, y=%d, sqrt(x² + y²)=%d", $time, ui_in, uio_in, uo_out);

    repeat (2) @(posedge clk);
    ui_in = 8'd12; uio_in = 8'd16; // sqrt(12² + 16²) = 20
    repeat (4) @(posedge clk);
    $display("Time=%0t | x=%d, y=%d, sqrt(x² + y²)=%d", $time, ui_in, uio_in, uo_out);

    // Finish simulation
    #50;
    $finish;
  end

endmodule
