; NOTE: these instructions have to be indented by one tab
; so the assembler can treat the initial content as a label

; ******************************************************************
; Sega Megadrive ROM header
; ******************************************************************
    dc.l   0x00FFE000      ; Initial stack pointer value
    dc.l   EntryPoint      ; Start of program
    dc.l   Exception       ; Bus error
    dc.l   Exception       ; Address error
    dc.l   Exception       ; Illegal instruction
    dc.l   Exception       ; Division by zero
    dc.l   Exception       ; CHK exception
    dc.l   Exception       ; TRAPV exception
    dc.l   Exception       ; Privilege violation
    dc.l   Exception       ; TRACE exception
    dc.l   Exception       ; Line-A emulator
    dc.l   Exception       ; Line-F emulator
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Spurious exception
    dc.l   Exception       ; IRQ level 1
    dc.l   Exception       ; IRQ level 2
    dc.l   Exception       ; IRQ level 3
    dc.l   HBlankInterrupt ; IRQ level 4 (horizontal retrace interrupt)
    dc.l   Exception       ; IRQ level 5
    dc.l   VBlankInterrupt ; IRQ level 6 (vertical retrace interrupt)
    dc.l   Exception       ; IRQ level 7
    dc.l   Exception       ; TRAP #00 exception
    dc.l   Exception       ; TRAP #01 exception
    dc.l   Exception       ; TRAP #02 exception
    dc.l   Exception       ; TRAP #03 exception
    dc.l   Exception       ; TRAP #04 exception
    dc.l   Exception       ; TRAP #05 exception
    dc.l   Exception       ; TRAP #06 exception
    dc.l   Exception       ; TRAP #07 exception
    dc.l   Exception       ; TRAP #08 exception
    dc.l   Exception       ; TRAP #09 exception
    dc.l   Exception       ; TRAP #10 exception
    dc.l   Exception       ; TRAP #11 exception
    dc.l   Exception       ; TRAP #12 exception
    dc.l   Exception       ; TRAP #13 exception
    dc.l   Exception       ; TRAP #14 exception
    dc.l   Exception       ; TRAP #15 exception
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    dc.l   Exception       ; Unused (reserved)
    
    dc.b "SEGA GENESIS    "                                 ; Console name
    dc.b "(C)SEGA 1992.SEP"                                 ; Copyrght holder and release date
    dc.b "Hello World                                     " ; Domestic name
    dc.b "Hello world                                     " ; International name
    dc.b "GM XXXXXXXX-XX"                                   ; Version number
    dc.w 0x0000                                             ; Checksum
    dc.b "J               "                                 ; I/O support
    dc.l 0x00000000                                         ; Start address of ROM
    dc.l __end                                              ; End address of ROM
    dc.l 0x00FF0000                                         ; Start address of RAM
    dc.l 0x00FFFFFF                                         ; End address of RAM
    dc.l 0x00000000                                         ; SRAM enabled
    dc.l 0x00000000                                         ; Unused
    dc.l 0x00000000                                         ; Start address of SRAM
    dc.l 0x00000000                                         ; End address of SRAM
    dc.l 0x00000000                                         ; Unused
    dc.l 0x00000000                                         ; Unused
    dc.b "                                        "         ; Notes (unused)
    dc.b "JUE             "                                 ; Country codes

EntryPoint:
    tst.w 0x00A10008        ; Tests expansion port reset. TODO: address with label?
    bne Main                ; If non-zero, skip init
    tst.w 0x00A1000C        ; Tests main reset button
    bne Main

    move.l #0x00000000, d0  ; Zero value for clearing RAM
    move.l #0x00000000, a0  ; Start from address 0
    move.l #0x00003FFF, d1

.Clear: ; Loop to clear all RAM addresses
    move.l d0, -(a0)
    dbra d1, .Clear

    move.b 0x00A10001, d0       ; This address holds Mega Drive hardware version
    andi.b #0x0F, d0            ; Bitwise and on d0 with immediate value
    beq .Skip                   ; TMSS check not required for model 1
    move.l #'SEGA', 0x00A14000

.Skip: 
    move.w #0x0100, 0x00A11100  ; Request Z80 bus access (address === BUSREQ)
    move.w #0x0100, 0x00A11200  ; Holds Z80 in reset state (addresss ==== RESET)
.Wait:
    btst #0x0, 0x00A11100       ; Does 68k have Z80 access?
    bne .Wait                   ; Try again...

    move.l #Z80Data, a0
    move.l #0x00A00000, a1      ; Copy Z80 RAM address into a1
    move.l #0x29, d0            ; Init data bytes

.CopyZ80:
    move.b (a0)+, (a1)+         ; Copy data and increment addresses
    dbra d0, .CopyZ80

    move.w #0x0000, 0x00A11200  ; Release Z80 reset
    move.w #0x0000, 0x00A11100  ; Release Z80 bus

    move.l #PSGData, a0         ; Programmable Sound Generator (PSG) init
    move.l #0x03, d0

.CopyPSG:
    move.b (a0)+, 0x00C00011
    dbra d0, .CopyPSG

    move.l #VDPRegisters, a0 ; Load address of register table into a0
    move.l #0x18, d0         ; 24 registers to write
    move.l #0x00008000, d1   ; 'Set register 0' command (and clear the rest of d1 ready)

.CopyVDP:
    move.b (a0)+, d1         ; Move register value to lower byte of d1
    move.w d1, 0x00C00004    ; Write command and value to VDP control port
    add.w #0x0100, d1        ; Increment register #
    dbra d0, .CopyVDP

    move.b #0x00, 0x000A10009 ; Controller port 1 CTRL
    move.b #0x00, 0x000A1000B ; Controller port 2 CTRL
    move.b #0x00, 0x000A1000D ; EXP port CTRL

    move.l #0x00000000, a0    ; Move 0x0 to a0
    movem.l (a0), d0-d7/a1-a7 ; Multiple move 0 to all registers

    ; Init status register (no trace, A7 is Interrupt Stack Pointer, no interrupts, clear condition code bits)
    move #0x2700, sr

Main:
    jmp __main        ; Game's entry point
 
HBlankInterrupt:
VBlankInterrupt:
    rte   ; Return from Exception
 
Exception:
    rte   ; Return from Exception

Z80Data:
    dc.w 0xaf01, 0xd91f
    dc.w 0x1127, 0x0021
    dc.w 0x2600, 0xf977
    dc.w 0xedb0, 0xdde1
    dc.w 0xfde1, 0xed47
    dc.w 0xed4f, 0xd1e1
    dc.w 0xf108, 0xd9c1
    dc.w 0xd1e1, 0xf1f9
    dc.w 0xf3ed, 0x5636
    dc.w 0xe9e9, 0x8104
    dc.w 0x8f01

VDPRegisters:
    dc.b 0x20 ; 0: Horiz. interrupt on, plus bit 2 (unknown, but docs say it needs to be on)
    dc.b 0x74 ; 1: Vert. interrupt on, display on, DMA on, V28 mode (28 cells vertically), + bit 2
    dc.b 0x30 ; 2: Pattern table for Scroll Plane A at 0xC000 (bits 3-5)
    dc.b 0x40 ; 3: Pattern table for Window Plane at 0x10000 (bits 1-5)
    dc.b 0x05 ; 4: Pattern table for Scroll Plane B at 0xA000 (bits 0-2)
    dc.b 0x70 ; 5: Sprite table at 0xE000 (bits 0-6)
    dc.b 0x00 ; 6: Unused
    dc.b 0x00 ; 7: Background colour - bits 0-3 = colour, bits 4-5 = palette
    dc.b 0x00 ; 8: Unused
    dc.b 0x00 ; 9: Unused
    dc.b 0x00 ; 10: Frequency of Horiz. interrupt in Rasters (number of lines travelled by the beam)
    dc.b 0x08 ; 11: External interrupts on, V/H scrolling on
    dc.b 0x81 ; 12: Shadows and highlights off, interlace off, H40 mode (40 cells horizontally)
    dc.b 0x34 ; 13: Horiz. scroll table at 0xD000 (bits 0-5)
    dc.b 0x00 ; 14: Unused
    dc.b 0x00 ; 15: Autoincrement off
    dc.b 0x01 ; 16: Vert. scroll 32, Horiz. scroll 64
    dc.b 0x00 ; 17: Window Plane X pos 0 left (pos in bits 0-4, left/right in bit 7)
    dc.b 0x00 ; 18: Window Plane Y pos 0 up (pos in bits 0-4, up/down in bit 7)
    dc.b 0x00 ; 19: DMA length lo byte
    dc.b 0x00 ; 20: DMA length hi byte
    dc.b 0x00 ; 21: DMA source address lo byte
    dc.b 0x00 ; 22: DMA source address mid byte
    dc.b 0x00 ; 23: DMA source address hi byte, memory-to-VRAM mode (bits 6-7)

PSGData:
    dc.w 0x9fbf, 0xdfff

__end    ; Very last line, end of ROM address