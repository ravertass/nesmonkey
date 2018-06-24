;;;;;;;; Game logic -- Monkey ;;;;;;;;
;; Game logic related to the monkey goes here.

;; Checks the controller input and updates the monkey accordingly.
UpdateMonkey:
    LDA #LOW(monkeyEntity)
    STA currentEntity
    LDY #$01
    LDA #HIGH(monkeyEntity)
    STA currentEntity,Y

    ; Start by setting Monkey's speed to 0
    LDA #$00
    LDY #entityDY
    STA [currentEntity],Y
    INY
    STA [currentEntity],Y
    LDY #entityDX
    STA [currentEntity],Y
    INY
    STA [currentEntity],Y

; Is monkey moving?
    LDA controller1
    AND #BUTTON_DIRS
    BEQ .UpdateMonkeyNotMoving ; if monkey isn't moving, skip most of the code below

    LDA #MOVING
    LDY #entityState
    STA [currentEntity],Y

; Is monkey going down?
    LDA controller1
    AND #BUTTON_DOWN
    BEQ .UpdateMonkeyDownDone
    JSR .UpdateMonkeyGoDown
.UpdateMonkeyDownDone:

; Is monkey going left?
    LDA controller1
    AND #BUTTON_LEFT
    BEQ .UpdateMonkeyLeftDone
    JSR .UpdateMonkeyGoLeft
.UpdateMonkeyLeftDone:

; Is monkey going right?
    LDA controller1
    AND #BUTTON_RIGHT
    BEQ .UpdateMonkeyRightDone
    JSR .UpdateMonkeyGoRight
.UpdateMonkeyRightDone:

; Is monkey going up?
; Up is put last, to make the up animation prioritized.
    LDA controller1
    AND #BUTTON_UP
    BEQ .UpdateMonkeyUpDone
    JSR .UpdateMonkeyGoUp
.UpdateMonkeyUpDone:
    JMP .UpdateMonkeyNotMovingDone

.UpdateMonkeyNotMoving:
    LDA #IDLE
    LDY #entityState
    STA [currentEntity],Y
    LDA #$00
    LDY #entityAnimationCount
    STA [currentEntity],Y
    LDY #entityAnimationFrame
    STA [currentEntity],Y
.UpdateMonkeyNotMovingDone:

    ; TODO: This should be done for every entity, every loop.
    ;       Thus, it should be moved to somewhere where all entities are handled.
    JSR .UpdateEntityMoving

    RTS


.UpdateMonkeyGoDown:
    LDA #MONKEY_SPEED_LOW
    LDY #entityDY
    STA [currentEntity],Y
    LDA #MONKEY_SPEED_HIGH
    LDY #entityDY
    INY
    STA [currentEntity],Y

    LDA #DIR_DOWN
    LDY #entityDir
    STA [currentEntity],Y

    RTS

.UpdateMonkeyGoLeft:
    LDA #MONKEY_NEG_SPEED_LOW
    LDY #entityDX
    STA [currentEntity],Y
    LDA #MONKEY_NEG_SPEED_HIGH
    LDY #entityDX
    INY
    STA [currentEntity],Y

    LDA #DIR_LEFT
    LDY #entityDir
    STA [currentEntity],Y

    RTS

.UpdateMonkeyGoRight:
    LDA #MONKEY_SPEED_LOW
    LDY #entityDX
    STA [currentEntity],Y
    LDA #MONKEY_SPEED_HIGH
    LDY #entityDX
    INY
    STA [currentEntity],Y

    LDA #DIR_RIGHT
    LDY #entityDir
    STA [currentEntity],Y

    RTS

.UpdateMonkeyGoUp:
    LDA #MONKEY_NEG_SPEED_LOW
    LDY #entityDY
    STA [currentEntity],Y
    LDA #MONKEY_NEG_SPEED_HIGH
    LDY #entityDY
    INY
    STA [currentEntity],Y

    LDA #DIR_UP
    LDY #entityDir
    STA [currentEntity],Y

    RTS



;;; The code below is more general entity moving code,
;;; and should be moved to somewhere where it can be
;;; run for every entity every loop.

.UpdateEntityMoving:
    JSR .UpdateEntityMoveCounter
    JSR .UpdateEntityPosition

    RTS

.UpdateEntityMoveCounter:
    LDY #entityAnimationCount
    LDA [currentEntity],Y
    CLC
    ADC #$01
    LDY #entityAnimationMax
    CMP [currentEntity],Y
    BEQ .UpdateEntityMoveCounterReset
    LDY #entityAnimationCount
    STA [currentEntity],Y
    JMP .UpdateEntityMoveCounterDone
.UpdateEntityMoveCounterReset:
    LDA #$00
    LDY #entityAnimationCount
    STA [currentEntity],Y
    JSR .UpdateEntityAnimationFrame
.UpdateEntityMoveCounterDone:
    RTS

.UpdateEntityAnimationFrame:
    LDY #entityAnimationFrame
    LDA [currentEntity],Y
    CLC
    ADC #$01
    LDY #entityAnimationLength
    CMP [currentEntity],Y
    BEQ .UpdateEntityAnimationFrameReset
    LDY #entityAnimationFrame
    STA [currentEntity],Y
    JMP .UpdateEntityAnimationFrameDone
.UpdateEntityAnimationFrameReset:
    LDA #$00
    LDY #entityAnimationFrame
    STA [currentEntity],Y
.UpdateEntityAnimationFrameDone:
    RTS

; TODO: Handle negative numbers correctly...
.UpdateEntityPosition:
    ; Add lower DY to lower Y byte
    LDY #entityY
    LDA [currentEntity],Y
    CLC
    LDY #entityDY
    ADC [currentEntity],Y
    LDY #entityY
    STA [currentEntity],Y

    ; Add higher DY with carry to higher Y byte
    LDY #entityY
    INY
    LDA [currentEntity],Y
    LDY #entityDY
    INY
    ADC [currentEntity],Y
    LDY #entityY
    INY
    STA [currentEntity],Y

    ; Add lower DX to lower X byte
    LDY #entityX
    LDA [currentEntity],Y
    CLC
    LDY #entityDX
    ADC [currentEntity],Y
    LDY #entityX
    STA [currentEntity],Y

    ; Add higher DX with carry to higher X byte
    LDY #entityX
    INY
    LDA [currentEntity],Y
    LDY #entityDX
    INY
    ADC [currentEntity],Y
    LDY #entityX
    INY
    STA [currentEntity],Y

    RTS
