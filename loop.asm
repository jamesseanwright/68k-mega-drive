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
Loop:
    move.l #0xF, d0 ; Move 15 into register d0
    move.l d0, d1   ; Move contents of register d0 into d1
    jmp Loop        ; Jump back up to 'Loop'
 
HBlankInterrupt:
VBlankInterrupt:
  rte   ; Return from Exception
 
Exception:
  rte   ; Return from Exception
 
__end    ; Very last line, end of ROM address
