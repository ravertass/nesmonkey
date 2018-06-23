;;;;;;;; Graphics logic -- Animation ;;;;;;;;
;; General logic for animations and loading sprites into memory goes here.

AnimateEntitySprites:
    LDA #$00
    STA currentMetaSpriteOffset

    ; if currentAnimationFrame == 0
    ; then we will NOT have to loop through so we draw the next frame
    LDY #entityAnimationFrame
    LDA [currentEntity],Y

    BEQ .UpdateEntitySpritesFrameFound

.UpdateEntitySpritesFindFrame:
    LDY #entityAnimationFrame
    LDA [currentEntity],Y
    STA frameCounter
.UpdateEntitySpritesFindFrameLoop:
    LDY currentMetaSpriteOffset
    LDA [currentMetaSpritePointer],Y
    CMP #$FE
    BEQ .UpdateEntitySpritesFrameEnded
    INY
    STY currentMetaSpriteOffset
    JMP .UpdateEntitySpritesFindFrameLoop
.UpdateEntitySpritesFrameEnded:
    INY
    STY currentMetaSpriteOffset
    LDA frameCounter
    SEC
    SBC #$01
    BEQ .UpdateEntitySpritesFrameFound
    STA frameCounter
    JMP .UpdateEntitySpritesFindFrameLoop

.UpdateEntitySpritesFrameFound:
.UpdateEntitySpritesLoop:
    ; Y coordinate
    LDY currentMetaSpriteOffset
    LDA [currentMetaSpritePointer],Y
    AND #$FE
    CMP #$FE ; No more sprites of frame!
    BEQ .UpdateEntitySpritesDone
    CLC
    LDY #entityY
    ADC [currentEntity],Y
    STA $0200,X
    INX
    LDY currentMetaSpriteOffset
    INY

    ; Tile
    LDA [currentMetaSpritePointer],Y
    STA $0200,X
    INX
    INY

    ; Attribute
    LDA [currentMetaSpritePointer],Y
    STA $0200,X
    INX
    INY

    STY currentMetaSpriteOffset

    ; X coordinate
    LDA [currentMetaSpritePointer],Y
    CLC
    LDY #entityX
    ADC [currentEntity],Y
    STA $0200,X
    INX
    LDY currentMetaSpriteOffset
    INY
    STY currentMetaSpriteOffset

    JMP .UpdateEntitySpritesLoop

.UpdateEntitySpritesDone:
    RTS
