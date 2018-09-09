;;;;;;;; Game logic -- Monkey ;;;;;;;;
;; Game logic related to the monkey goes here.

;; Checks the controller input and updates the monkey accordingly.
UpdateMonkey:
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
    RTS

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
