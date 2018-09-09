;;;;;;;; Sprites ;;;;;;;;
;; All sprite data can be found here.

; Sprite attribute bits:
; 76543210
; ||||||||
; ||||||++- Palette (4 to 7) of sprite
; |||+++--- Unimplemented
; ||+------ Priority (0: in front of background; 1: behind background)
; |+------- Flip sprite horizontally
; +-------- Flip sprite vertically

; To be used in cases that are not relevant (e.g. seagull has no idle animations)
dummySprites:
    .db $FF

monkeyAnimationsTable:
    .dw sprMonkeyUpIdle,   sprMonkeyDownIdle,   sprMonkeyLeftIdle,   sprMonkeyRightIdle
    .dw sprMonkeyUpMoving, sprMonkeyDownMoving, sprMonkeyLeftMoving, sprMonkeyRightMoving

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


seagullAnimationsTable:
    .dw dummySprites, dummySprites, dummySprites, dummySprites
    .dw sprSeagullUpMoving, sprSeagullDownMoving, sprSeagullLeftMoving, sprSeagullRightMoving

sprSeagullUpMoving:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Sprite
    .db $00, $7A, %00000000, $00
    ; End of animation frame
    .db $FE
    ; Sprite
    .db $00, $8A, %01000000, $00
    ; End of sprites
    .db $FF

sprSeagullDownMoving:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Sprite
    .db $00, $79, %00000000, $00
    ; End of animation frame
    .db $FE
    ; Sprite
    .db $00, $89, %01000000, $00
    ; End of sprites
    .db $FF

sprSeagullLeftMoving:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Sprite
    .db $00, $78, %01000000, $00
    ; End of animation frame
    .db $FE
    ; Sprite
    .db $00, $88, %01000000, $00
    ; End of sprites
    .db $FF

sprSeagullRightMoving:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Sprite
    .db $00, $78, %00000000, $00
    ; End of animation frame
    .db $FE
    ; Sprite
    .db $00, $88, %00000000, $00
    ; End of sprites
    .db $FF
