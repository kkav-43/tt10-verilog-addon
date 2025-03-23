// Code your design here
/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`timescale 1ns / 1ps
`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // 8-bit input: side a
    input  wire [7:0] uio_in,   // 8-bit input: side b
    output reg  [7:0] uo_out,   // 8-bit output: sqrt(a² + b²)
    output wire [7:0] uio_out,  // IOs: Output path (not used)
    output wire [7:0] uio_oe,   // IOs: Enable path (not used)
    input  wire       ena,      // Enable signal
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset (active low)
);

    reg [15:0] sum_squares;
    reg [15:0] square_a, square_b;
    reg [7:0] sqrt_result;
    
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_a      <= 0;
            square_b      <= 0;
            sum_squares   <= 0;
            uo_out        <= 0;
        end else begin
            // Compute a^2 and b^2
            square_a = ui_in * ui_in;
            square_b = uio_in * uio_in;

            // Compute sum of squares
            sum_squares = square_a + square_b;

            // Compute integer square root using bitwise method
            sqrt_result = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                if ((sqrt_result | (1 << i)) * (sqrt_result | (1 << i)) <= sum_squares)
                    sqrt_result = sqrt_result | (1 << i);
            end

            // Output the result
            uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs to zero
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
