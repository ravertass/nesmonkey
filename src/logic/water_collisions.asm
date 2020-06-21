;;;;;;;; Game logic -- Water collisions ;;;;;;;;
;; Logic making an entity stay on land goes here.

; SUBROUTINE ;
WaterCollision:
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
    ; tile_offset = x - x % 8 + (y - y % 8)*32
    ;
    ; More easy-to-use math:
    ; x - x % 8 = x AND %11111000
