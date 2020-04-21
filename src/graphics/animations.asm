;;;;;;;; Graphics logic -- Animation ;;;;;;;;
;; General logic for animations and loading sprites into memory goes here.

AnimateEntitySprites:
    ; First check if the entity even has an animation: if not, return early.
    EReadMemberToA entityAnimationLength
    BNE .DoAnimate
    RTS

.DoAnimate:
    LDA #$00
    STA currentMetaSpriteOffset

    ; if currentAnimationFrame == 0
    ; then we will NOT have to loop through so we draw the next frame
    EReadMemberToA entityAnimationFrame
    BEQ .UpdateEntitySpritesFrameFound

;UpdateEntitySpritesFindFrame:
    EReadMemberToA entityAnimationFrame
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
    LDY currentMetaSpriteOffset
    LDA [currentMetaSpritePointer],Y
    AND #$FE
    CMP #$FE ; No more sprites of frame!
    BEQ .UpdateEntitySpritesDone

    ; Y coordinate
    LDY #entityY
    JSR .DivideByFour ; Will put 2-byte y coordinate divided by four into A register
    CLC
    LDY currentMetaSpriteOffset
    ADC [currentMetaSpritePointer],Y

    STA DMA_GRAPHICS,X
    INX
    LDY currentMetaSpriteOffset
    INY

    ; Tile
    LDA [currentMetaSpritePointer],Y
    STA DMA_GRAPHICS,X
    INX
    INY

    ; Attribute
    LDA [currentMetaSpritePointer],Y
    STA DMA_GRAPHICS,X
    INX
    INY

    STY currentMetaSpriteOffset

    ; X coordinate
    LDY #entityX
    JSR .DivideByFour ; Will put 2-byte y coordinate divided by four into A register
    CLC
    LDY currentMetaSpriteOffset
    ADC [currentMetaSpritePointer],Y

    STA DMA_GRAPHICS,X
    INX
    LDY currentMetaSpriteOffset
    INY
    STY currentMetaSpriteOffset

    JMP .UpdateEntitySpritesLoop

.UpdateEntitySpritesDone:
    RTS

;; SUBROUTINE
;; Input:
;;     Y register: Pointer to least significant byte of 2-byte value that should be divided by 4.
;; Output:
;;     A register: The value divided by four (least significant bytes).
.DivideByFour:
    ; This mess should divide the 2 byte coordinate by 4, taking the least significant byte as
    ; the actual coordinate.
    INY
    LDA [currentEntity],Y
    LSR A
    DEY
    LDA [currentEntity],Y
    ROR A
    STA tempCoordinate
    INY
    LDA [currentEntity],Y
    LSR A
    LSR A
    LDA tempCoordinate
    ROR A
    ADC #$00 ; add the carry for more correct rounding

    RTS
