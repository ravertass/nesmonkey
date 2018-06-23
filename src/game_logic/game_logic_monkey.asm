;;;;;;;; Game logic -- Monkey ;;;;;;;;
;; Game logic related to the monkey goes here.

;;TODO:
;; - Code not related to the monkey (animation counter/frame handling + actual movement)
;;   should be generalized.
;; - The number of frames in the current animation must be taken from the current animation
;;   data, not from an arbitrary constant.
;; - Just make sure to be very clear with what code is controller-related and what is not.
;; - entityDX and entityDY should not be used the way they are now. Instead, they should
;;   be set dynamically when the entity actually moves.
;; - Come up with some good way to handle negative entityDX/entityDY values...

UpdateMonkey:
    LDA #LOW(monkeyEntity)
    STA currentEntity
    LDY #$01
    LDA #HIGH(monkeyEntity)
    STA currentEntity,Y

; Is monkey moving?
    LDA controller1
    AND #BUTTON_DIRS
    BEQ .UpdateMonkeyNotMoving
    JSR .UpdateMonkeyMoving
    JMP .UpdateMonkeyMovingDone
.UpdateMonkeyNotMoving:
    LDA #IDLE
    LDY #entityState
    STA [currentEntity],Y
    LDA #$00
    LDY #entityAnimationCount
    STA [currentEntity],Y
    LDY #entityAnimationFrame
    STA [currentEntity],Y
.UpdateMonkeyMovingDone:

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

    RTS

;TODO This should not be hard-coded here...
MAX_MONKEY_FRAMES = $02

.UpdateMonkeyMoving:
    LDA #MOVING
    LDY #entityState
    STA [currentEntity],Y

    JSR .UpdateMonkeyMoveCounter

    RTS

.UpdateMonkeyMoveCounter:
    LDY #entityAnimationCount
    LDA [currentEntity],Y
    CLC
    ADC #$01
    LDY #entityAnimationMax
    CMP [currentEntity],Y
    BEQ .UpdateMonkeyMoveCounterReset
    LDY #entityAnimationCount
    STA [currentEntity],Y
    JMP .UpdateMonkeyMoveCounterDone
.UpdateMonkeyMoveCounterReset:
    LDA #$00
    LDY #entityAnimationCount
    STA [currentEntity],Y
    JSR .UpdateMonkeyAnimationFrame
.UpdateMonkeyMoveCounterDone:
    RTS

.UpdateMonkeyAnimationFrame:
    LDY #entityAnimationFrame
    LDA [currentEntity],Y
    CLC
    ADC #$01
    CMP #MAX_MONKEY_FRAMES ; TODO: This is no good
    BEQ .UpdateMonkeyAnimationFrameReset
    STA [currentEntity],Y
    JMP .UpdateMonkeyAnimationFrameDone
.UpdateMonkeyAnimationFrameReset:
    LDA #$00
    STA [currentEntity],Y
.UpdateMonkeyAnimationFrameDone:
    RTS

.UpdateMonkeyGoDown:
    LDY #entityY
    LDA [currentEntity],Y
    CLC
    LDY #entityDY
    ADC [currentEntity],Y
    LDY #entityY
    STA [currentEntity],Y

    LDA #DIR_DOWN
    LDY #entityDir
    STA [currentEntity],Y

    RTS

.UpdateMonkeyGoLeft:
    LDY #entityX
    LDA [currentEntity],Y
    SEC
    LDY #entityDX
    SBC [currentEntity],Y
    LDY #entityX
    STA [currentEntity],Y

    LDA #DIR_LEFT
    LDY #entityDir
    STA [currentEntity],Y

    RTS

.UpdateMonkeyGoRight:
    LDY #entityX
    LDA [currentEntity],Y
    CLC
    LDY #entityDX
    ADC [currentEntity],Y
    LDY #entityX
    STA [currentEntity],Y

    LDA #DIR_RIGHT
    LDY #entityDir
    STA [currentEntity],Y

    RTS

.UpdateMonkeyGoUp:
    LDY #entityY
    LDA [currentEntity],Y
    SEC
    LDY #entityDY
    SBC [currentEntity],Y
    LDY #entityY
    STA [currentEntity],Y

    LDA #DIR_UP
    LDY #entityDir
    STA [currentEntity],Y

    RTS
