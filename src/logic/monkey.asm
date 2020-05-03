;;;;;;;; Game logic -- Monkey ;;;;;;;;
;; Game logic related to the monkey goes here.

;; Checks the controller input and updates the monkey accordingly.
UpdateMonkey:
    ; Start by setting Monkey's speed to 0
    EWriteMember16 entityDX, #$0000
    EWriteMember16 entityDY, #$0000

; Is monkey moving?
    LDA controller1
    AND #BUTTON_DIRS
    BEQ .UpdateMonkeyNotMoving ; if monkey isn't moving, skip most of the code below

    ESetFlag #FLAG_IS_MOVING

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
    EUnsetFlag #FLAG_IS_MOVING
    EWriteMember entityAnimationCount, #$00
    EWriteMember entityAnimationFrame, #$00
    RTS


.UpdateMonkeyGoDown:
    EWriteMember16 entityDY, MONKEY_SPEED
    EWriteMember entityDir, #DIR_DOWN

    RTS

.UpdateMonkeyGoLeft:
    EWriteMember16 entityDX, MONKEY_NEG_SPEED
    EWriteMember entityDir, #DIR_LEFT

    RTS

.UpdateMonkeyGoRight:
    EWriteMember16 entityDX, MONKEY_SPEED
    EWriteMember entityDir, #DIR_RIGHT

    RTS

.UpdateMonkeyGoUp:
    EWriteMember16 entityDY, MONKEY_NEG_SPEED
    EWriteMember entityDir, #DIR_UP

    RTS
