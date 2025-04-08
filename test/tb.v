`default_nettype none
`timescale 1ns / 1ps

module tb;

  // Clock and Reset
  reg clk;
  reg rst_n;
  reg ena;

  // Inputs and Outputs
  reg  [7:0] ui_in;
  reg  [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Power pins for gate-level sim (optional)
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate DUT
  tt_um_mag_calctr uut (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in   (ui_in),
      .uio_in  (uio_in),
      .uo_out  (uo_out),
      .uio_out (uio_out),
      .uio_oe  (uio_oe),
      .ena     (ena),
      .clk     (clk),
      .rst_n   (rst_n)
  );

  // Clock generator: 10ns period
  always #5 clk = ~clk;

  // VCD dump
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // Test stimulus
  initial begin
    // Init
    clk    = 0;
    rst_n  = 0;
    ena    = 1;
    ui_in  = 0;
    uio_in = 0;

    // Apply reset
    #10 rst_n = 1;

    // Wait for reset deassertion
   

    // Test Case 2: (6,8) → sqrt(100) ≈ 10
    ui_in  = 8'd6;
    uio_in = 8'd8;
    #10;
    $display("Output (should be ~10):  %d", uo_out);

    // Test Case 3: (10,10) → sqrt(200) ≈ 14
    ui_in  = 8'd10;
    uio_in = 8'd10;
    #10;
    $display("Output (should be ~14):  %d", uo_out);

    // Test Case 4: (5,10) → sqrt(125) ≈ 11
    ui_in  = 8'd5;
    uio_in = 8'd10;
    #10;
    $display("Output (should be ~11):  %d", uo_out);

    #20;
    $finish;
  end

endmodule
