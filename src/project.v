/*
 * Copyright (c) 2024 Anton Maurovic
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_algofoogle_tt09_ring_osc2 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


  // Ring of 125 inverters, output on uo_out[0] ~ 112MHz, if it makes it out?
  ring_osc #(.DEPTH(62)) ring_125 (.osc_out(uo_out[0]));
  // Ring of 251 inverters, output on uo_out[1] ~ 56MHz?
  ring_osc #(.DEPTH(125)) ring_251 (.osc_out(uo_out[1]));
  // Ring of 501 inverters, output on uo_out[2] ~ 28MHz?
  ring_osc #(.DEPTH(250)) ring_501 (.osc_out(uo_out[2]));
  // Ring of 1001 inverters, output on uo_out[3] ~ 14MHz?
  ring_osc #(.DEPTH(500)) ring_1001 (.osc_out(uo_out[3]));

  assign uo_out[6:4] = 3'b000;

  // List all unused inputs to prevent warnings
  wire dummy = &{ui_in, uio_in, ena, rst_n};
  assign uo_out[7] = dummy;
  wire _unused = &{clk, 1'b0};

  assign uio_oe = 8'b0000_0000; // UIOs unused but make them inputs by default.
  assign uio_out = 8'b0000_0000;

endmodule
