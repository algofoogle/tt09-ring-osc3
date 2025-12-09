![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Another simple ~~TT09~~ TTIHP25a ring oscillator experiment implemented with Verilog: Configurable-length ring oscillator (ring-osc3)

Originally this project was submitted to TT09 (commit [5786e93](https://github.com/algofoogle/tt09-ring-osc3/commit/5786e93f3615bafefbf220597621b8ff69d89f86)). It was later [rehardened](https://github.com/TinyTapeout/tt09-ttihp25a-reharden/tree/main/hdl/tt_um_algofoogle_tt09_ring_osc3) for resubmission to TTIHP25a (wherein some minor changes were required).

The design implements a long chain of 1001 inverters, and has a selectable tap point to set the length of the ring to one of 8 lengths ranging from 11 inverters all the way up to 1001 inverters.

The ring oscillates, driving `uo_out[0]` but also driving a 7-bit counter, which is output on `uo_out[7:1]`.

> [!NOTE]
> See also: [tt09-ring-osc](https://github.com/algofoogle/tt09-ring-osc) and [tt09-ring-osc2](https://github.com/algofoogle/tt09-ring-osc2)

- [Read the documentation for project](docs/info.md)

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://www.tinytapeout.com/guides/local-hardening/)

