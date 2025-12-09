<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## Overview

**For a quick-start guide just see the "How to test" heading below. I intend to have results collected in the [TTIHP25a-ring-osc3](https://docs.google.com/spreadsheets/d/1ijWdzJL9L4ZYqBhKCiZMeHCRW9pjFe_lTgYaaWa5nSQ/edit?gid=1271931838#gid=1271931838) sheet of my "Anton's Tiny Tapeout silicon testing" Google Sheet.**

This is a ring oscillator of configurable length, allowing selection from 0 (shortest, 11 inverters) to 7 (longest, 1001 inverters), with both raw oscillator output and counter-divided outputs.

It is implemented using the IHP SG13G2 open PDK and was fabricated on TTIHP25a, though it was originally intended for TT09.

Originally this project was submitted to TT09 (commit [5786e93](https://github.com/algofoogle/tt09-ring-osc3/commit/5786e93f3615bafefbf220597621b8ff69d89f86)). It was later [rehardened](https://github.com/TinyTapeout/tt09-ttihp25a-reharden/tree/main/hdl/tt_um_algofoogle_tt09_ring_osc3) for resubmission to TTIHP25a (wherein some minor changes were required).

*See also: [tt09-ring-osc](https://github.com/algofoogle/tt09-ring-osc) and [tt09-ring-osc2](https://github.com/algofoogle/tt09-ring-osc2) for my other ring oscillator experiments on the same shuttle.*



## How does it work?

Verilog instantiates a chain of 1001 inverters (made up of smaller chain segments). `ui_in[2:0]` ("`tap[2:0]`") selects one of 8 tap points to loop back and hence make a ring oscillator of configurable length.

The output of the ring oscillator is presented on `uo_out[0]`, but it also drives a 7-bit counter which is presented on `uo_out[7:1]`.

At power-up, the state of the ring is expected to be random/chaotic. The `ena` signal gates the loopback, i.e. while `ena` is low, the chain should stabilise itself after a while (~40ns est.) but it won't loop back and hence won't oscillate. This is good, because designs are not power-gated on TTIHP25a: since the design is powered from the get-go, with `ena` initially low the chain will stabilise, and then as `ena` goes high (i.e. as the design is selected/enabled) the ring should be able to start oscillating cleanly. At least, this is what it looked like in simulation.


## How to test

1.  Attach an oscilloscope to `uo_out[0]` (raw oscillator output) and `uo_out[7]` (7th stage of a counter, i.e. divide-by-128).
2.  Set `ui_in=0` -- this is the shortest ring (11 inverters), hence the fastest.
3.  Activate (i.e. select) the design.
4.  `uo_out[0]` will probably be attenuated to nothing, but hopefully `uo_out[7]` will show a clean oscillation (and lower bits will hopefully show it at higher frequencies) -- though with the shortest ring even the div-128 frequency on `uo_out[7]` could be quite high (28~65MHz?) and may even be erratic if the counter's lower bits are being clocked too fast?
5.  Try setting `ui_in=7` -- this is the longest ring (1001 inverters).
6.  Hopefully observe `uo_out[0]` is now slow enough to be measured, and `uo_out[7]` is a 128th of that frequency (and probably about 91 times slower than it was in step 4).

Setting `tap` (`ui_in[2:0]`) to one of the following values sets the ring oscillator to the respective length:

0.  11 inverters
1.  21 inverters
2.  31 inverters
3.  41 inverters
4.  51 inverters
5.  101 inverters
6.  301 inverters
7.  1001 inverters

Note that changing `ui_in` *while* the design is active might introduce a repeating glitch. Ideally, `ui_in` should assert the desired value (0..7) before the design is selected/activated, but I think the TT Commander by default always sets `ui_in` to 0 when selecting a design. If that's the case, setting `ui_in` and deactivating/activating the design might need to be done manually in the Commander with MicroPython code.
