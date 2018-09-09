;;;;;;;; Graphics logic ;;;;;;;;
;; Logic related to drawing graphics goes here.

    .include "graphics_logic/graphics_logic_animations.asm"
    .include "graphics_logic/graphics_logic_entities.asm"

UpdateGraphics:
    ; Start DMA transfer from $0200
    LDA #$00
    STA $2003
    LDA #$02
    STA $4014

    ; X will be the offset used to store all sprites at the correct
    ; place in memory.
    LDX #$00

    JSR UpdateMonkeySprites

    RTS
