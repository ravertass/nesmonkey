;;;;;;;; Graphics logic -- Sprites ;;;;;;;;
;; General logic for loading sprites into memory goes here.

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
