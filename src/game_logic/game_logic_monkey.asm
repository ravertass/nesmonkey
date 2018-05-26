;;;;;;;; Game logic -- Monkey ;;;;;;;;
;; Game logic related to the monkey goes here.

UpdateMonkey:
; Monkey is standing still: this will be written over if he is actually going somewhere

; Is monkey moving?
    LDA controller1
    AND #BUTTON_DIRS
    BEQ UpdateMonkeyNotMoving
    JSR UpdateMonkeyMoving
    JMP UpdateMonkeyMovingDone
UpdateMonkeyNotMoving:
    LDA #IDLE
    STA monkeyState
    LDA #$00
    STA monkeyMoveCounter
    STA monkeyAnimationFrame
UpdateMonkeyMovingDone:

; Is monkey going down?
    LDA controller1
    AND #BUTTON_DOWN
    BEQ UpdateMonkeyDownDone
    JSR UpdateMonkeyGoDown
UpdateMonkeyDownDone:

; Is monkey going left?
    LDA controller1
    AND #BUTTON_LEFT
    BEQ UpdateMonkeyLeftDone
    JSR UpdateMonkeyGoLeft
UpdateMonkeyLeftDone:

; Is monkey going right?
    LDA controller1
    AND #BUTTON_RIGHT
    BEQ UpdateMonkeyRightDone
    JSR UpdateMonkeyGoRight
UpdateMonkeyRightDone:

; Is monkey going up?
; Up is put last, to make the up animation prioritized.
    LDA controller1
    AND #BUTTON_UP
    BEQ UpdateMonkeyUpDone
    JSR UpdateMonkeyGoUp
UpdateMonkeyUpDone:

    RTS

;TODO These should not be hard-coded here...
MAX_MONKEY_FRAMES = $02
MOVE_COUNTS_PER_ANIMATION_FRAME = $08

UpdateMonkeyMoving:
    LDA #MOVING
    STA monkeyState

    JSR UpdateMonkeyMoveCounter

    RTS

UpdateMonkeyMoveCounter:
    LDA monkeyMoveCounter
    CLC
    ADC #$01
    CMP #MOVE_COUNTS_PER_ANIMATION_FRAME
    BEQ UpdateMonkeyMoveCounterReset
    STA monkeyMoveCounter
    JMP UpdateMonkeyMoveCounterDone
UpdateMonkeyMoveCounterReset:
    LDA #$00
    STA monkeyMoveCounter
    JSR UpdateMonkeyAnimationFrame
UpdateMonkeyMoveCounterDone:
    RTS

UpdateMonkeyAnimationFrame:
    LDA monkeyAnimationFrame
    CLC
    ADC #$01
    CMP #MAX_MONKEY_FRAMES
    BEQ UpdateMonkeyAnimationFrameReset
    STA monkeyAnimationFrame
    JMP UpdateMonkeyAnimationFrameDone
UpdateMonkeyAnimationFrameReset:
    LDA #$00
    STA monkeyAnimationFrame
UpdateMonkeyAnimationFrameDone:
    RTS

MONKEY_SPEED = $01

UpdateMonkeyGoDown:
    LDA monkeyY
    CLC
    ADC #MONKEY_SPEED
    STA monkeyY

    LDA #DIR_DOWN
    STA monkeyDir

    RTS

UpdateMonkeyGoLeft:
    LDA monkeyX
    SEC
    SBC #MONKEY_SPEED
    STA monkeyX

    LDA #DIR_LEFT
    STA monkeyDir

    RTS

UpdateMonkeyGoRight:
    LDA monkeyX
    CLC
    ADC #MONKEY_SPEED
    STA monkeyX

    LDA #DIR_RIGHT
    STA monkeyDir

    RTS

UpdateMonkeyGoUp:
    LDA monkeyY
    SEC
    SBC #MONKEY_SPEED
    STA monkeyY

    LDA #DIR_UP
    STA monkeyDir

    RTS
