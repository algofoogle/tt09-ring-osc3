`default_nettype none

// Originally this was designed for TT09 on sky130, using the sky130_fd_sc_hd__inv_2 cell.
// See: https://github.com/algofoogle/tt09-ring-osc3/commit/7ab74a7173a7754cd86e31105095c43051cb8716
// It was rehardened for TTIHP25a using a sky130 "polyfill" (mapping sky130 cells to equivalent
// cells or logic in the IHP PDK).
// See: https://github.com/TinyTapeout/tt09-ttihp25a-reharden/blob/cfa0e6adf57c4bb4c5f6ec924ec0cc5bfb1fdfe2/hdl/tt_um_algofoogle_tt09_ring_osc3/src/sky130_polyfill.v#L389
// Hence, where you see sky130_fd_sc_hd__inv_2 below, it maps instead to a logical complement, which in turn
// maps to some IHP inverter cell.

module amm_inverter (
    input   wire a,
    output  wire y
);

    (* keep_hierarchy *) sky130_fd_sc_hd__inv_2   sky_inverter (
        .A  (a),
        .Y  (y)
    );

endmodule

// A chain of inverters.
module inv_chain #(
    parameter N = 10 // SHOULD BE EVEN.
) (
    input a,
    output y
);

    wire [N-1:0] ins;
    wire [N-1:0] outs;
    assign ins[0] = a;
    assign ins[N-1:1] = outs[N-2:0];
    assign y = outs[N-1];
    (* keep_hierarchy *) amm_inverter inv_array [N-1:0] ( .a(ins), .y(outs) );

endmodule

module tapped_ring (
    input wire ena,
    input [2:0] tap,
    output y
);
    wire b0, b1, b11, b21, b31, b41, b51, b101, b301, b1001;
    (* keep_hierarchy *) amm_inverter      start ( .a(  b0), .y(     b1) ); // If all the counts below are even, this makes it odd.
    (* keep_hierarchy *) inv_chain #(.N(10))  c0 ( .a(  b1), .y(    b11) );
    (* keep_hierarchy *) inv_chain #(.N(10))  c1 ( .a( b11), .y(    b21) );
    (* keep_hierarchy *) inv_chain #(.N(10))  c2 ( .a( b21), .y(    b31) );
    (* keep_hierarchy *) inv_chain #(.N(10))  c3 ( .a( b31), .y(    b41) );
    (* keep_hierarchy *) inv_chain #(.N(10))  c4 ( .a( b41), .y(    b51) );
    (* keep_hierarchy *) inv_chain #(.N(50))  c5 ( .a( b51), .y(   b101) );
    (* keep_hierarchy *) inv_chain #(.N(200)) c6 ( .a(b101), .y(   b301) );
    (* keep_hierarchy *) inv_chain #(.N(700)) c7 ( .a(b301), .y(  b1001) );
    assign y =  tap == 0 ?   b11:
                tap == 1 ?   b21:
                tap == 2 ?   b31:
                tap == 3 ?   b41:
                tap == 4 ?   b51:
                tap == 5 ?  b101:
                tap == 6 ?  b301:
                /*tap==7*/ b1001;
    assign b0 = y & ena;
endmodule
