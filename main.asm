;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;; Mr. Monkey's Boomerang Bonanza! ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Made by sfabian                                                             ;;
;; Some code adapted from Nerdy Nights tutorial by bunnyboy @ NintendoAge.com  ;;
;; Contact: fabian.sorensson@gmail.com                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Header ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .include "header.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Constants ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Logic constants

DIR_UP    = $00
DIR_DOWN  = $01
DIR_LEFT  = $02
DIR_RIGHT = $03

IDLE   = $00
MOVING = $01

; Graphics constants


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; RAM variables ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .rsset $0000

monkeyY              .rs 1  ; Current Y coordinate of monkey.
monkeyX              .rs 1  ; Current X coordinate of monkey.
monkeyState          .rs 1  ; Current monkey state (idle/walking).
monkeyDir            .rs 1  ; Current monkey direction.
monkeyMoveCounter    .rs 1  ; Counter used to update animation frame counter.
monkeyAnimationFrame .rs 1  ; Current frame in monkey's animation.

controller1 .rs 1  ; Last input from controller 1.


; Variables set before updating sprites
currentEntityY           .rs 1
currentEntityX           .rs 1
currentMetaSpritePointer .rs 2
currentAnimationFrame    .rs 1

; Counter used during animation (due to lack of registers...)
frameCounter .rs 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Setup ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .bank 0
    .org $C000
RESET:
    .include "general_setup.asm"

; Load palettes
    LDA $2002    ; read PPU status to reset the high/low latch
    LDA #$3F
    STA $2006    ; write the high byte of $3F00 address
    LDA #$00
    STA $2006    ; write the low byte of $3F00 address
    LDX #$00
LoadPalettesLoop:
    LDA palette, x        ;load palette byte
    STA $2007             ;write to PPU
    INX                   ;set index to next byte
    CPX #$20
    BNE LoadPalettesLoop  ;if x = $20, 32 bytes copied, all done

    LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
    STA $2000
    LDA #%00011110   ; Enable sprites, enable background, no clipping on left side.
    STA $2001

; Initial monkey values
    LDA #$80
    STA monkeyX
    STA monkeyY
    LDA #DIR_DOWN
    STA monkeyDir
    LDA #IDLE
    STA monkeyState
    LDA #$00
    STA monkeyAnimationFrame
    LDA #$00
    STA monkeyMoveCounter

Forever:
    JMP Forever

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Graphics logic ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdateGraphics:
    ; Start DMA transfer from $0200
    LDA #$00
    STA $2003
    LDA #$02
    STA $4014

    ; X will be the offset used to store all sprites at the correct
    ; place in memory.
    LDX #$00

    JSR UpdateMonkeySprites

    RTS

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Input logic ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; At the end of GetInput, controller1 will contain
; the button presses from the first controller.
GetInput:
    ; This tells the controller's to latch the buttons' current status.
    LDA #$01
    STA $4016
    LDA #$00
    STA $4016

    LDX #$08
GetInputLoop:
    LDA $4016
    LSR A            ; bit0 -> carry
    ROL controller1  ; controller1 <- carry
    DEX
    BNE GetInputLoop

    RTS

; Bit order: A- B- Se St Up Do Le Ri
BUTTON_A      = %10000000
BUTTON_B      = %01000000
BUTTON_SELECT = %00100000
BUTTON_START  = %00010000
BUTTON_UP     = %00001000
BUTTON_DOWN   = %00000100
BUTTON_LEFT   = %00000010
BUTTON_RIGHT  = %00000001
BUTTON_DIRS   = %00001111

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Game logic ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdateGame:
    JSR UpdateMonkey

    RTS

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; VBlank ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

NMI:
    JSR UpdateGraphics
    JSR GetInput
    JSR UpdateGame

    RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Background and sprites ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .bank 1
    .org $E000
palette:
    ; Background palette
    .db $22,$32,$02,$12,  $22,$37,$07,$17,  $22,$00,$00,$00,  $22,$00,$00,$00

    ; Sprite palette
    .db $22,$17,$37,$0F,  $22,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00

; Sprite attribute bits:
; 76543210
; ||||||||
; ||||||++- Palette (4 to 7) of sprite
; |||+++--- Unimplemented
; ||+------ Priority (0: in front of background; 1: behind background)
; |+------- Flip sprite horizontally
; +-------- Flip sprite vertically

sprMonkeyUpIdle:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $16, %00000000, $00
    ; Lower sprite
    .db $08, $26, %00000000, $00
    ; End of sprites
    .db $FF

sprMonkeyDownIdle:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $14, %00000000, $00
    ; Lower sprite
    .db $08, $24, %00000000, $00
    ; End of sprites
    .db $FF

sprMonkeyLeftIdle:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $18, %01000000, $00
    ; Lower sprite
    .db $08, $28, %01000000, $00
    ; End of sprites
    .db $FF

sprMonkeyRightIdle:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $18, %00000000, $00
    ; Lower sprite
    .db $08, $28, %00000000, $00
    ; End of sprites
    .db $FF

sprMonkeyUpMoving:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $17, %00000000, $00
    ; Lower sprite
    .db $08, $27, %00000000, $00
    ; End of animation frame
    .db $FE
    ; Upper sprite
    .db $00, $17, %01000000, $00
    ; Lower sprite
    .db $08, $27, %01000000, $00
    ; End of sprites
    .db $FF

sprMonkeyDownMoving:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $15, %00000000, $00
    ; Lower sprite
    .db $08, $25, %00000000, $00
    ; End of animation frame
    .db $FE
    ; Upper sprite
    .db $00, $15, %01000000, $00
    ; Lower sprite
    .db $08, $25, %01000000, $00
    ; End of sprites
    .db $FF

sprMonkeyLeftMoving:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $19, %01000000, $00
    ; Lower sprite
    .db $08, $29, %01000000, $00
    ; End of animation frame
    .db $FE
    ; Upper sprite
    .db $00, $1A, %01000000, $00
    ; Lower sprite
    .db $08, $2A, %01000000, $00
    ; End of sprites
    .db $FF

sprMonkeyRightMoving:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $19, %00000000, $00
    ; Lower sprite
    .db $08, $29, %00000000, $00
    ; End of animation frame
    .db $FE
    ; Upper sprite
    .db $00, $1A, %00000000, $00
    ; Lower sprite
    .db $08, $2A, %00000000, $00
    ; End of sprites
    .db $FF

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Interrupt vectors ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .org $FFFA     ; Where the interrupt vectors should be.
    .dw NMI        ; When it is time for vblank.
    .dw RESET      ; When the processor first turns on or is reset.
    .dw 0          ; External interrupt IRQ are deactivated.

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Graphics memory ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .bank 2
    .org $0000
    .incbin "monkey.chr"
