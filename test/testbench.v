`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file for waveform analysis.
  initial begin
    $dumpfile("tb_pythagoras.vcd");
    $dumpvars(0, tb);
    #1;
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

  // Generate Clock (10ns period)
  always #5 clk = ~clk;

  // Instantiate Design Under Test (DUT)
  tt_um_pythagoras user_project (
      // Include power ports for the Gate Level test:
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

  // Test sequence
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;
    
    #10 rst_n = 1;  // Release reset
    
    // Test cases
    #10 ui_in = 8'd3; uio_in = 8'd4;  // sqrt(3² + 4²) = 5
    #20 $display("Time=%0t | x=%d, y=%d, sqrt(x² + y²)=%d", $time, ui_in, uio_in, uo_out);

    #10 ui_in = 8'd6; uio_in = 8'd8;  // sqrt(6² + 8²) = 10
    #20 $display("Time=%0t | x=%d, y=%d, sqrt(x² + y²)=%d", $time, ui_in, uio_in, uo_out);

    #10 ui_in = 8'd10; uio_in = 8'd10; // sqrt(10² + 10²) = 14
    #20 $display("Time=%0t | x=%d, y=%d, sqrt(x² + y²)=%d", $time, ui_in, uio_in, uo_out);

    #10 ui_in = 8'd12; uio_in = 8'd16; // sqrt(12² + 16²) = 20
    #20 $display("Time=%0t | x=%d, y=%d, sqrt(x² + y²)=%d", $time, ui_in, uio_in, uo_out);

    #50 $finish;
  end

endmodule
