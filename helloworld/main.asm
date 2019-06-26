    include 'init.asm'

__main:
    move.w #0x8F02, 0x00C00004   ; Set autoincrement to 2 bytes(???)
    move.l #0xC0000003, 0x00C00004 ; Set up VDP to write to CRAM address 0x0000
    lea Palette, a0 ; Load palette address into a0
    move.l #0x07, d0 ; Store palette longword size into d0

.PortTransfer:
    move.l (a0)+, 0x00C00000    ; Move data to VDP port and increment source address
    dbra d0, .PortTransfer  ; stop iterating if all of palette has been sent

    move.w #0x8708, 0x00C00004  ; Set BG to Palette colour 9

Palette:
    dc.w 0x0000 ; transparent
    dc.w 0x000E ; red
    dc.w 0x00E0 ; green
    dc.w 0x0E00 ; blue
    dc.w 0x0000 ; black
    dc.w 0x0EEE ; white
    dc.w 0x00EE ; yellow
    dc.w 0x008E ; orange
    dc.w 0x0E0E ; pink
    dc.w 0x0808 ; purple
    dc.w 0x0444 ; dark grey
    dc.w 0x0888 ; light grey
    dc.w 0x0EE0 ; turquoise
    dc.w 0x000A ; maroon
    dc.w 0x0600 ; navy blue
    dc.w 0x0060 ; dark green