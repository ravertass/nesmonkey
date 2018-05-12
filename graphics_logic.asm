;;;;;;;; Graphics logic ;;;;;;;;
;; Logic related to drawing graphics goes here.

    .include "graphics_logic_monkey.asm"

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


UpdateEntitySprites:
    LDY #$00

    ; if currentAnimationFrame == 0
    ; then we will NOT have to loop through so we draw the next frame
    LDA currentAnimationFrame
    BEQ UpdateEntitySpritesFrameFound


UpdateEntitySpritesFindFrame:
    LDA currentAnimationFrame
    STA frameCounter
UpdateEntitySpritesFindFrameLoop:
    LDA [currentMetaSpritePointer], y
    CMP #$FE
    BEQ UpdateEntitySpritesFrameEnded
    INY
    JMP UpdateEntitySpritesFindFrameLoop
UpdateEntitySpritesFrameEnded:
    INY
    LDA frameCounter
    SEC
    SBC #$01
    BEQ UpdateEntitySpritesFrameFound
    JMP UpdateEntitySpritesFindFrameLoop

UpdateEntitySpritesFrameFound:
UpdateEntitySpritesLoop:
    ; Y coordinate
    LDA [currentMetaSpritePointer], y
    AND #$FE
    CMP #$FE ; No more sprites of frame!
    BEQ UpdateEntitySpritesDone
    CLC
    ADC currentEntityY
    STA $0200, x
    INX
    INY

    ; Tile
    LDA [currentMetaSpritePointer], y
    STA $0200, x
    INX
    INY

    ; Attribute
    LDA [currentMetaSpritePointer], y
    STA $0200, x
    INX
    INY

    ; X coordinate
    LDA [currentMetaSpritePointer], y
    CLC
    ADC currentEntityX
    STA $0200, x
    INX
    INY

    JMP UpdateEntitySpritesLoop

UpdateEntitySpritesDone:
    RTS
