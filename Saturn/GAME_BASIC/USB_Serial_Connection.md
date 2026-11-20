# Connecting the Sega Saturn to a Modern Computer via USB

GAME BASIC for SEGA SATURN shipped with the [Windows Communication Cable](../Windows_Communication_Cable/README.MD), which connects the Saturn's rear communication port to a PC's RS232 serial port. Modern Macs and PCs no longer have RS232 ports, but we don't need RS232 at all: the Saturn speaks plain TTL serial, so it can connect straight to USB.

## How the original cable works

The cable is just a level shifter. Inside is an [NEC µPD4711B](../Windows_Communication_Cable/Documentation/NEC_UPD4711BGS_Datasheet.pdf) RS232 driver/receiver, a few charge-pump capacitors, and some ferrite beads and capacitors for EMI filtering. See the [schematic](../Windows_Communication_Cable/Saturn_Windows_Comm_Cable_Schematic.pdf).

What this tells us:

- **The Saturn side is a plain, non-inverted TTL UART** (idle high). Only three signals are used: TX, RX and GND. There is **no hardware handshaking**, so any USB-UART adapter will do.
- **The Saturn powers the cable.** The µPD4711B gets its power from the Saturn's +5V (pin 2), and the chip only runs at 4.5–5.5V.
- **Saturn RX is driven at 5V.** The chip's receiver output swings to its VCC (5V), so the original cable drives the Saturn's RX pin with 5V CMOS levels.
- **Saturn TX only needs to be above 2.0V.** The chip's driver input is TTL-threshold (VIH 2.0V, VIL 0.8V), so the Saturn's TX could be 3.3V or 5V logic.

A **5V-logic USB-to-TTL serial adapter** is therefore an exact electrical replacement for the original cable plus the PC's RS232 port. A 3.3V adapter may work too, but the Saturn's RX threshold can only be measured on the hardware, so 5V is the safe choice.

## Saturn communication port pinout

This uses the numbering from the [cable README](../Windows_Communication_Cable/README.MD), looking into the cable's plug, with odd pins on top and even pins on the bottom. This numbering isn't confirmed against an official Sega document.

```
   11          1
 _________________
/  | | | | | | | |
|_|_|_|_|_|_|_|__|
 12           2
```

| Pin | Function | Original cable wire |
|---|---|---|
| 2 | +5V from Saturn | Red (アカ) |
| 5 | Saturn TX (TTL out) | White (シロ) |
| 6 | Saturn RX (TTL in) | Black (クロ) |
| 8, 12 | Ground | Shield (シールド) |

## USB wiring

| Saturn port | Function | USB-UART adapter | FTDI TTL-232R wire colour |
|---|---|---|---|
| 5 | Saturn TX | RXD | Yellow |
| 6 | Saturn RX | TXD, through a **1kΩ series resistor** | Orange |
| 8 + 12 | GND | GND | Black |
| 2 | +5V | **Leave unconnected** | (Red: leave unconnected) |

Notes:

- **Leave the +5V lines unconnected on both sides.** The Saturn and USB both supply 5V, and they shouldn't be tied together.
- **The 1kΩ resistor** on the adapter's TX limits current into the Saturn's RX pin if the adapter is plugged in while the Saturn is off. Without it, the adapter could back-power the Saturn's serial circuitry through the pin's protection diodes.
- **CTS/RTS/DTR aren't used.** Leave them unconnected.
- **Optional:** a ferrite bead in series with each signal (like FB1–FB4 in the original cable) helps reduce EMI on longer leads.

## Parts

| Option | Notes |
|---|---|
| **FTDI TTL-232R-5V** cable (recommended) | 5V logic levels. macOS, Linux and Windows all have drivers built in. Handles non-standard baud rates well. |
| FT232RL breakout board | Cheaper. Set the voltage jumper to **5V**. |
| CH340G breakout board | Cheapest. Set the jumper to **5V**. Recent macOS and Linux include drivers. On Windows, a driver usually installs automatically. |
| CP2102 boards | **Avoid.** These usually have 3.3V logic only. |

### The connector

The Saturn's 12-pin communication port is the awkward part. Options:

- **Don't cut the original Windows Communication Cable.** It's rare, and it's the reference for everything here.
- **Cut a Saturn link cable or a reproduction cable.** I believe these use the same rear-port plug, but check before you buy one.
- **Design or 3D-print a plug,** or fit your own 3-pin (TX/RX/GND) port to the Saturn.

## Build options, from easiest to most work

1. **Nothing to build.** Use the original Windows Communication Cable, a straight-through RS232 extension cable and an FTDI-based USB-to-RS232 adapter.
2. **Simple build.** Splice a 5V USB-TTL cable onto a link-cable plug, wired as in the table above.
3. **Neat build.** Re-spin the [KiCad board](../Windows_Communication_Cable/Original/) with a CH340 or FT231X and a USB-C connector, sized to fit inside the original plug shell, so it's a true drop-in modern cable.
4. **Later, if needed.** A microcontroller bridge (Raspberry Pi Pico, ESP32) only adds value for wireless uploads or a standalone uploader. It would also need level shifting to 5V on its TX.

## Check before wiring

The pin numbering and the logic levels are electrical facts that only a meter can confirm on your Saturn. With the Saturn **on** and nothing plugged into the port, check:

- **Pin 2 reads about +5V** relative to pin 8/12. This confirms the pin numbering and ground.
- **Pin 5 idles high.** The idle voltage shows whether the Saturn's TX is 3.3V or 5V logic.

## Serial settings

- **Baud rate: 9600 (default) or 19200.** Set on the Saturn in GAME BASIC's system settings screen: from the edit screen hold **L+R+Z** on a pad in port 1, or **Q+E+D** on the Saturn keyboard; change **Baudrate**, then move to **Exit** and press **C** (Reference Manual pp. 19–20). The PC must use the same rate. Use 9600 if 19200 gives errors.
- The setting is saved in the Saturn's backup RAM as `GBASICSS_01` (comment `Config`). Deleting it in the Saturn's memory manager puts GAME BASIC back to its defaults, including 9600.
- **Faster rates.** After the undocumented `OPTION HD352` the Saturn runs at its 28.6 MHz clock and the settings screen also offers 14400, 28800, 38400, 57600 and 115200. The Saturn's rate generator is within about 1% of each, so whether they work depends on the adapter and the cable; an FTDI adapter is the best bet. `OPTION HD320` returns to the normal list.
- **Data format: 8 data bits, no parity, 1 stop bit, no flow control.** Both ends agree: `Basterm.exe` sets it up this way, and the GAME BASIC interpreter programs the Saturn's serial port for 8N1. See `BASTERM/BASTERM_serial_protocol.md` for the transfer protocol and `Documentation/GAME_BASIC_CD_analysis.md` for the Saturn side.
- **Without BASTERM** the port is a plain serial line, and the Saturn sends XON/XOFF to pace incoming text. A terminal program used that way should have XON/XOFF turned on.
- The FTDI cable and the tools in `tools/` and `vscode-game-basic/` handle 9600 and 19200.
