;;;;;;;; Game logic -- Water collisions ;;;;;;;;
;; Logic making an entity stay on land goes here.

;  ____ ____
; |    | ^ ^|
; |    |    |
; |   __ ^ ^|
; |__('')___|
; |  -[]-^ ^|
; |   /\    |
; |    | ^ ^|
; |____|____|
;
; We need to check four tiles:
; - x,   y
; - x+w, y
; - x,   y+h
; - x+w, y+h
;
; We find the correct tile offset using this formula:
; tile_offset = x // 8 + (y // 8)*32
;
; More CPU-appropriate math:
; a // 8 = 3 >> a
; a * 32 = a << 5
; (a // 8) * 32 = (a - a%8) * 4 = (a AND %11111000) << 2

; SUBROUTINE ;
; Checks if the current entity collides with a water tile.
; If so, it is moved in the Y direction.
; Input:
;     currentEntity
; Output:
;     currentEntity.y
; Clobbers:
;     ...
WaterCollisionY:
    EReadMemberToA #entityDY
    BEQ .Done
    BMI .NegativeY

;PositiveY:
    JSR WaterCollision
    BNE .Done

    ; Push the entity up
    LDY #entityY
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityHeight
    AND #%11111000
    ESubtractMemberToA #entityHeight
    LDY #entityY
    JSR CoordinateToGameSpace

    JMP .Done

.NegativeY:
    JSR WaterCollision
    BNE .Done

    ; Push the entity down
    LDY #entityY
    JSR CoordinateToPixelSpace
    CLC
    ADC #$08
    AND #%11111000
    LDY #entityY
    JSR CoordinateToGameSpace

.Done:
    RTS

; SUBROUTINE ;
; Checks if the current entity collides with a water tile.
; If so, it is moved in the X direction.
; Input:
;     currentEntity
; Output:
;     currentEntity.x
; Clobbers:
;     ...
WaterCollisionX:
    EReadMemberToA #entityDX
    BEQ .Done
    BMI .NegativeX

;PositiveX:
    JSR WaterCollision
    BNE .Done

    ; Push the entity left
    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityWidth
    AND #%11111000
    ESubtractMemberToA #entityWidth
    LDY #entityX
    JSR CoordinateToGameSpace

    JMP .Done

.NegativeX:
    JSR WaterCollision
    BNE .Done

    ; Push the entity right
    LDY #entityX
    JSR CoordinateToPixelSpace
    CLC
    ADC #$08
    AND #%11111000
    LDY #entityX
    JSR CoordinateToGameSpace

.Done:
    RTS


; SUBROUTINE ;
; Checks if the current entity collides with a water tile.
; Input:
;     currentEntity
; Output:
;     A: 0 if collides with water,
;        >0 otherwise
; Clobbers:
;     ...
WaterCollision:
;TopLeftCorner:
    LDY #entityX
    JSR CoordinateToPixelSpace
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    TAY

    JSR .IsWater
    BNE .TopRightCorner
    RTS

.TopRightCorner:
    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityWidth
    SEC
    SBC #$01
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    TAY

    JSR .IsWater
    BNE .EightDownLeft
    RTS

    ; TODO: This is a hack to make this work for the monkey.
    ;       Really, this should be rewritten as a two-depth loop,
    ;       checking every eighth pixel in both X and Y directions,
    ;       and finally checking the positions at x+width-1 and
    ;       y+height-1.
.EightDownLeft: ; TODO: Remove when the loop has been implemented...
    LDY #entityX
    JSR CoordinateToPixelSpace
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    CLC
    ADC #$08
    TAY

    JSR .IsWater
    BNE .EightDownRight
    RTS

.EightDownRight: ; TODO: Remove when the loop has been implemented...
    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityWidth
    SEC
    SBC #$01
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    CLC
    ADC #$08
    TAY

    JSR .IsWater
    BNE .BottomLeftCorner
    RTS

.BottomLeftCorner:
    LDY #entityX
    JSR CoordinateToPixelSpace
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityHeight
    SEC
    SBC #$01
    TAY

    JSR .IsWater
    BNE .BottomRightCorner
    RTS

.BottomRightCorner:
    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityWidth
    SEC
    SBC #$01
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityHeight
    SEC
    SBC #$01
    TAY

    JSR .IsWater
    RTS

; SUBROUTINE
; Checks if tile at X, Y (in pixel space) is a water tile.
; Input:
;     X, Y
; Output:
;     A: 0 if water,
;        >0 otherwise
; Clobbers:
;     X, Y, tempTilePointer
.IsWater:
    LDA #LOW(background)
    STA tempTilePointer
    LDA #HIGH(background)
    STA tempTilePointer+1

    ; Add the offset for the X coordinate.
    ; Only requires one byte.
    ; x offset = x_t tile coord = x // 8 = 3 >> x
    TXA ; x coord
    LSR A
    LSR A
    LSR A ; x/8 = x tile coord
    CLC
    ADC tempTilePointer
    STA tempTilePointer
    LDA #$00
    ADC tempTilePointer+1

    ; Add the offset for the Y coordinate.
    ; NOTE: Requires two bytes!
    ; y offset = (y tile coord)*32 =
    ;     (y // 8) * 32 = (y - y%8) * 4 = (y AND %11111000) << 2

    ; Y offset lower byte.
    TYA ; y coord
    AND #%11111000 ; y - y%8
    ASL A
    ASL A ; y*8 = (y tile coord)*32 = y tile offset (low)
    CLC
    ADC tempTilePointer
    STA tempTilePointer
    LDA #$00
    ADC tempTilePointer+1
    STA tempTilePointer+1

    ; Y offset higher byte.
    TYA ; y coord
    ASL A ; y*2
    LDA #$00
    ROL A ; high/2
    TAX

    TYA ; y coord
    ASL A
    ASL A ; y*4
    TXA ; high/2
    ROL A ; high
    CLC
    ADC tempTilePointer+1
    STA tempTilePointer+1

    LDX #$00
    LDA [tempTilePointer,X]

    ; Water tile happens to be $00.
    ; Thus, we're happy with returning with the tile value
    ; in the a register.

    RTS
