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

IDLE    = $00
WALKING = $01

; Graphics constants


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; RAM variables ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .rsset $0000

monkeyY     .rs 1  ; Current Y coordinate of monkey.
monkeyX     .rs 1  ; Current X coordinate of monkey.
monkeyState .rs 1  ; Current monkey state (idle/walking).
monkeyDir   .rs 1  ; Current monkey direction.

controller1 .rs 1  ; Last input from controller 1.


; Variables set before updating sprites
currentEntityY    .rs 2
currentEntityX    .rs 2
currentMetaSprite .rs 2

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
    LDY monkeyY
    STY currentEntityY
    LDY monkeyX
    STY currentEntityX

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
    JSR UpdateCurrentEntitySprites
    RTS

SetMonkeySpritesUp:
    LDA monkeyState
    CMP #IDLE
    JSR SetMonkeySpritesUpIdle
    JMP MonkeySpritesSet
SetMonkeySpritesUpIdle:
    LDA #LOW(sprMonkeyUpIdle)
    STA currentMetaSprite
    LDA #HIGH(sprMonkeyUpIdle)
    LDY #$01
    STA currentMetaSprite, y
    RTS

SetMonkeySpritesDown:
    LDA monkeyState
    CMP #IDLE
    JSR SetMonkeySpritesDownIdle
    JMP MonkeySpritesSet
SetMonkeySpritesDownIdle:
    LDA #LOW(sprMonkeyDownIdle)
    STA currentMetaSprite
    LDA #HIGH(sprMonkeyDownIdle)
    LDY #$01
    STA currentMetaSprite, y
    RTS

SetMonkeySpritesLeft:
    LDA monkeyState
    CMP #IDLE
    JSR SetMonkeySpritesLeftIdle
    JMP MonkeySpritesSet
SetMonkeySpritesLeftIdle:
    LDA #LOW(sprMonkeyLeftIdle)
    STA currentMetaSprite
    LDA #HIGH(sprMonkeyLeftIdle)
    LDY #$01
    STA currentMetaSprite, y
    RTS

SetMonkeySpritesRight:
    LDA monkeyState
    CMP #IDLE
    JSR SetMonkeySpritesRightIdle
    JMP MonkeySpritesSet
SetMonkeySpritesRightIdle:
    LDA #LOW(sprMonkeyRightIdle)
    STA currentMetaSprite
    LDA #HIGH(sprMonkeyRightIdle)
    LDY #$01
    STA currentMetaSprite, y
    RTS

UpdateCurrentEntitySprites:
    LDY #$00
UpdateCurrentEntitySpritesLoop:
    ; Y coordinate
    LDA [currentMetaSprite], y
    CMP #$FF ; No more sprites!
    BEQ UpdateCurrentEntitySpritesDone
    CLC
    ADC currentEntityY
    STA $0200, x
    INX
    INY

    ; Tile
    LDA [currentMetaSprite], y
    STA $0200, x
    INX
    INY

    ; Attribute
    LDA [currentMetaSprite], y
    STA $0200, x
    INX
    INY

    ; X coordinate
    LDA [currentMetaSprite], y
    CLC
    ADC currentEntityX
    STA $0200, x
    INX
    INY

    JMP UpdateCurrentEntitySpritesLoop

UpdateCurrentEntitySpritesDone:
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Game logic ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdateGame:
    JSR UpdateMonkey

    RTS

UpdateMonkey:
    LDA controller1
    AND #BUTTON_UP
    BEQ UpdateMonkeyUpDone
    JSR UpdateMonkeyGoUp
UpdateMonkeyUpDone:

    LDA controller1
    AND #BUTTON_DOWN
    BEQ UpdateMonkeyDownDone
    JSR UpdateMonkeyGoDown
UpdateMonkeyDownDone:

    LDA controller1
    AND #BUTTON_LEFT
    BEQ UpdateMonkeyLeftDone
    JSR UpdateMonkeyGoLeft
UpdateMonkeyLeftDone:

    LDA controller1
    AND #BUTTON_RIGHT
    BEQ UpdateMonkeyRightDone
    JSR UpdateMonkeyGoRight
UpdateMonkeyRightDone:

    RTS

MONKEY_SPEED = $01

UpdateMonkeyGoUp:
    LDA monkeyY
    SEC
    SBC #MONKEY_SPEED
    STA monkeyY

    LDA #DIR_UP
    STA monkeyDir

    RTS

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

sprMonkeyDownWalking:
    ; Number of sprites in meta-sprite
    .db $02
    ; Number of sprites in animation
    .db $02
    ; Format: $x-offs, $y-offs, [$tile-no, %attr]
    ; Upper sprite
    .db $00, $00,    $15, %00000000,  $15, %01000000
    ; Lower sprite
    .db $00, $08,    $25, %00000000,  $25, %01000000

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
