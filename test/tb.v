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

 

endmodule
