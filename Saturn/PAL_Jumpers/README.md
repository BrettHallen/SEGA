# PAL Jumper Settings (VA PAL SD)
The jumper settings on my Australian PAL Saturn, identified as "PC BD SATURN MAIN VA PAL SD 837-12135".<br>

If modiyfing jumpers, ensure you open jumpers first and verify they are open before bridging the alternate to ensure you don't accidentally short +5V to GND.<br>

## Jumpers
| JP   | Setting | Purpose                                   | Location  |
|------|---------|-------------------------------------------|-----------|
| JP1  | Open    | Ties video line to +5V -> 60Hz            | Underside |
| JP2  | 100KΩ   | Ties video line to GND -> 50Hz            | Underside |
| JP3  | Closed  | Option on 315-5746 clock chip             | Topside   |
| JP6  | Open    | Ties SMPC AC1 (315-5744 p5) to +5V        | Underside |
| JP7  | Closed  | Ties SMPC AC1 (p5) to GND                 | Underside |
| JP8  | Open    | Ties SMPC AC2 (p7) to +5V                 | Topside   |
| JP9  | Closed  | Ties SMPC AC2 (p7) to GND                 | Topside   |
| JP10 | Closed  | Ties SMPC AC3 (p8) to +5V                 | Topside   |
| JP11 | Open    | Ties SMPC AC3 (p8) to GND                 | Topside   |
| JP12 | Closed  | Ties SMPC AC4 (p9) to +5v                 | Topside   |
| JP13 | Open    | Ties SMPC AC4 (p9) to GND                 | Topside   |
| JP17 | Open    | Unpopulated SW4 p2                        | Underside |
| JP18 | Closed  | Unpopulated SW4 p4, tied to GND           | Underside |
| JP19 | Open    | Unpopulated SW4 p3                        | Underside |
| JP20 | Open    | Clock/crystal option for IC20             | Topside   |
| JP21 | Closed  | Clock/crystal option for IC20             | Topside   |

## Region (SMPC area code)

The four common pads of JP6/7, JP8/9, JP10/11 and JP12/13 go to the SMPC (Sega 315-5744) pins 5, 7, 8 and 9. Each pair is "+5 V pad / GND pad".

| Region        | Pin 5 (AC1) | Pin 7 (AC2) | Pin 8 (AC3) | Pin 9 (AC4) | Code         |
|---------------|-------------|-------------|-------------|-------------|--------------|
| Japan         | JP6 (1)     | JP9 (0)     | JP11 (0)    | JP13 (0)    | 0001 = 1     |
| North America | JP7 (0)     | JP9 (0)     | JP10 (1)    | JP13 (0)    | 0100 = 4     |
| Europe / PAL  | JP7 (0)     | JP9 (0)     | JP10 (1)    | JP12 (1)    | 1100 = **C** |

## Video Mode Switch
To switch a PAL 50Hz to 60Hz, move the 100KΩ (104) resistor from R29 to JP1.