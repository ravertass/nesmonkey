;;;;;;;; Graphics logic -- Monkey ;;;;;;;;
;; Logic related to drawing the monkey goes here.

UpdateMonkeySprites:
    LDA monkeyY
    STA currentEntityY
    LDA monkeyX
    STA currentEntityX

    LDA monkeyAnimationFrame
    STA currentAnimationFrame

    LDA monkeyDir
    CMP #DIR_UP
    BEQ SetMonkeySpritesUp

    LDA monkeyDir
    CMP #DIR_DOWN
    BEQ SetMonkeySpritesDown

    LDA monkeyDir
    CMP #DIR_LEFT
    BEQ SetMonkeySpritesLeft

    LDA monkeyDir
    CMP #DIR_RIGHT
    BEQ SetMonkeySpritesRight

MonkeySpritesSet:
    JSR UpdateEntitySprites
    RTS


SetMonkeySpritesUp:
    LDA monkeyState
    CMP #IDLE
    BEQ SetMonkeySpritesUpIdle
    ; Else: monkeyState == #MOVING
SetMonkeySpritesUpMoving:
    LDA #LOW(sprMonkeyUpMoving)
    STA currentMetaSpritePointer

    LDA #HIGH(sprMonkeyUpMoving)
    LDY #$01
    STA currentMetaSpritePointer, y

    JMP MonkeySpritesSet
SetMonkeySpritesUpIdle:
    LDA #LOW(sprMonkeyUpIdle)
    STA currentMetaSpritePointer

    LDA #HIGH(sprMonkeyUpIdle)
    LDY #$01
    STA currentMetaSpritePointer, y

    JMP MonkeySpritesSet


SetMonkeySpritesDown:
    LDA monkeyState
    CMP #IDLE
    BEQ SetMonkeySpritesDownIdle
    ; Else: monkeyState == #MOVING
SetMonkeySpritesDownMoving:
    LDA #LOW(sprMonkeyDownMoving)
    STA currentMetaSpritePointer

    LDA #HIGH(sprMonkeyDownMoving)
    LDY #$01
    STA currentMetaSpritePointer, y

    JMP MonkeySpritesSet
SetMonkeySpritesDownIdle:
    LDA #LOW(sprMonkeyDownIdle)
    STA currentMetaSpritePointer

    LDA #HIGH(sprMonkeyDownIdle)
    LDY #$01
    STA currentMetaSpritePointer, y

    JMP MonkeySpritesSet


SetMonkeySpritesLeft:
    LDA monkeyState
    CMP #IDLE
    BEQ SetMonkeySpritesLeftIdle
    ; Else: monkeyState == #MOVING
SetMonkeySpritesLeftMoving:
    LDA #LOW(sprMonkeyLeftMoving)
    STA currentMetaSpritePointer

    LDA #HIGH(sprMonkeyLeftMoving)
    LDY #$01
    STA currentMetaSpritePointer, y

    JMP MonkeySpritesSet
SetMonkeySpritesLeftIdle:
    LDA #LOW(sprMonkeyLeftIdle)
    STA currentMetaSpritePointer

    LDA #HIGH(sprMonkeyLeftIdle)
    LDY #$01
    STA currentMetaSpritePointer, y

    JMP MonkeySpritesSet

SetMonkeySpritesRight:
    LDA monkeyState
    CMP #IDLE
    BEQ SetMonkeySpritesRightIdle
    ; Else: monkeyState == #MOVING
SetMonkeySpritesRightMoving:
    LDA #LOW(sprMonkeyRightMoving)
    STA currentMetaSpritePointer

    LDA #HIGH(sprMonkeyRightMoving)
    LDY #$01
    STA currentMetaSpritePointer, y

    JMP MonkeySpritesSet
SetMonkeySpritesRightIdle:
    LDA #LOW(sprMonkeyRightIdle)
    STA currentMetaSpritePointer

    LDA #HIGH(sprMonkeyRightIdle)
    LDY #$01
    STA currentMetaSpritePointer, y

    JMP MonkeySpritesSet
