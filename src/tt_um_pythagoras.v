// Code your design here
/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`timescale 1ns / 1ps
`default_nettype none

module tt_um_pythagoras (
    input  wire [7:0] ui_in,    // 8-bit input: x
    input  wire [7:0] uio_in,   // 8-bit input: y
    output reg  [7:0] uo_out,   // 8-bit output: sqrt(x² + y²)
    output wire [7:0] uio_out,  // IOs: Output path (not used)
    output wire [7:0] uio_oe,   // IOs: Enable path (not used)
    input  wire       ena,      // Always 1 when powered
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset (active low)
);

    reg [15:0] sum_squares;
    reg [15:0] square_x, square_y;
    reg [7:0] result;
    reg [15:0] temp, temp_square;
    integer i, j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_x <= 0;
            square_y <= 0;
            sum_squares <= 0;
            uo_out <= 0;
        end else begin
            // Compute x^2 using repeated addition
            square_x = 0;
            for (j = 0; j < 8; j = j + 1) begin
                if (ui_in[j]) square_x = square_x + (ui_in << j);
            end

            // Compute y^2 using repeated addition
            square_y = 0;
            for (j = 0; j < 8; j = j + 1) begin
                if (uio_in[j]) square_y = square_y + (uio_in << j);
            end

            sum_squares = square_x + square_y;

            // Compute square root using bitwise method (no multiplication)
            result = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                temp = result + (1 << i);

                // Compute temp^2 using repeated addition
                temp_square = 0;
                for (j = 0; j < 8; j = j + 1) begin
                    if (temp[j]) temp_square = temp_square + (temp << j);
                end

                if (temp_square <= sum_squares)
                    result = temp;
            end

            uo_out <= result;
        end
    end

    // Assign unused outputs to zero
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
