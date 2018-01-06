.Model Small
.Stack 100h
.Code
main Proc
; set VGA 640x480 16 color mode
    MOV AH, 0      ;set mode func
    MOV AL, 12h
    INT 10h
    
;set backgroundM
    MOV AH,0BH  
    MOV BH,0    
    MOV BL,0  ;background color code(black)
    INT 10H
    
;choose palatte
    MOV BH,1
    MOV BL,0  ;SELECT PALATTE
    INT 10H
    
;DWAW STAND

;   |
;   |
;   |
;   |

    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,3   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV CX,30   ;COLUMN
    
    STAND_OUTER:
        MOV DX,90   ;STARTING ROW
        STAND_INNER:
            INT 10H
            INC DX
            CMP DX,350
        JL STAND_INNER
        INC CX
        CMP CX,35
    JL STAND_OUTER
    

;DRAW UPPER LINE _______
    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,3   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,90   ;ROW
    
    uLINE_OUTER:
        MOV CX,30   ;STARTING COLUMN
        uLINE_INNER:
            INT 10H
            INC CX
            CMP CX,150
            JL uLINE_INNER
        INC DX
        CMP DX,95
     JL uLINE_OUTER
    
;DRAW BASE LINE _______
    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,3   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,345   ;ROW
    
    bLINE_OUTER:
    MOV CX,10   ;STARTING COLUMN
        bLINE_INNER:
            INT 10H
            INC CX
            CMP CX,50
            JL bLINE_INNER
        INC DX
        CMP DX,350
    JL bLINE_OUTER
    
;DRAWING THE SUPPORT
;       /
;      /
;     /
;    /
;   /

    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,3   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,90   ;STARTING ROW
    MOV CX,90   ;STARTING COLUMN
    
    sLINE_OUTER:
        PUSH CX
        MOV BL,0
        sLINE_INNER:
            INT 10H
            INC CX
            INC BL
            CMP BL,7
        JL sLINE_INNER
        INC DX
        POP CX
        DEC CX
        CMP DX,151
    JL sLINE_OUTER
    
    MOV CX,35
    INT 10H
    
    
;DRAW ROPE
;   |
;   |
;   |
;   |
    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,3   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,90   ;ROW
    
    ROPE_OUTER:
    MOV CX,120   ;STARTING COLUMN
        ROPE_INNER:
            INT 10H
            INC CX
            CMP CX,125
            JL ROPE_INNER
        INC DX
        CMP DX,160
    JL ROPE_OUTER
    
;DRAW HEAD
;   |--------|
;   | o -  O |
;   |  ---   |
;   |--------|        

    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    
;DRAW -------    
    MOV DX,160   ;ROW
    
    H1_OUTER:
    MOV CX,102   ;STARTING COLUMN
        H1_INNER:
            INT 10H
            INC CX
            CMP CX,143
            JL H1_INNER
        INC DX
        CMP DX,165
        JL H1_OUTER
        
;DRAW ------- 
;
;
;
;     -------   
    MOV DX,195   ;ROW        
    H2_OUTER:
    MOV CX,102   ;STARTING COLUMN
        H2_INNER:
            INT 10H
            INC CX
            CMP CX,143
            JL H2_INNER
        INC DX
        CMP DX,200
        JL H2_OUTER
;DRAW ------- 
;     |
;     |
;     |
;     -------   
    MOV DX,165   ;ROW        
    H3_OUTER:
    MOV CX,102   ;STARTING COLUMN
        H3_INNER:
            INT 10H
            INC CX
            CMP CX,107
            JL H3_INNER
        INC DX
        CMP DX,195
        JL H3_OUTER
;DRAW ------- 
;     |      |
;     |      |
;     |      |
;     -------   
    MOV DX,165   ;ROW        
    H4_OUTER:
    MOV CX,138   ;STARTING COLUMN
        H4_INNER:
            INT 10H
            INC CX
            CMP CX,143
            JL H4_INNER
        INC DX
        CMP DX,195
        JL H4_OUTER
        
        
;DRAW BODY
;   |
;   |
;   |
;   |
    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,200   ;ROW
    
    BODY_OUTER:
    MOV CX,119   ;STARTING COLUMN
        BODY_INNER:
            INT 10H
            INC CX
            CMP CX,126
            JL BODY_INNER
        INC DX
        CMP DX,265
        JL BODY_OUTER

;DRAWING RIGHT HAND
;       /
;      /
;     /
;    /
;   /

    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,215   ;STARTING ROW
    MOV CX,119   ;STARTING COLUMN
    
    rHAND_OUTER:
        PUSH CX
        MOV BL,0
        rHAND_INNER:
            INT 10H
            INC CX
            INC BL
            CMP BL,7
            JL rHAND_INNER
        INC DX
        POP CX
        DEC CX
        CMP DX,245
        JL rHAND_OUTER
        
;DRAWING RIGHT LEG
;       /
;      /
;     /
;    /
;   /

    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,265   ;STARTING ROW
    MOV CX,119   ;STARTING COLUMN
    
    rLEG_OUTER:
        PUSH CX
        MOV BL,0
        rLEG_INNER:
            INT 10H
            INC CX
            INC BL
            CMP BL,7
            JL rLEG_INNER
        INC DX
        POP CX
        DEC CX
        CMP DX,295
        JL rLEG_OUTER
        
;DRAWING LEFT LEG
;    \ 
;     \   
;      \
;       \
;        \

    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,265   ;STARTING ROW
    MOV CX,119   ;STARTING COLUMN
    
    lLEG_OUTER:
        PUSH CX
        MOV BL,0
        lLEG_INNER:
            INT 10H
            INC CX
            INC BL
            CMP BL,7
            JL lLEG_INNER
        INC DX
        POP CX
        INC CX
        CMP DX,295
        JL lLEG_OUTER
        
        
;DRAWING LEFT HAND
;    \ 
;     \   
;      \
;       \
;        \

    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,215   ;STARTING ROW
    MOV CX,119   ;STARTING COLUMN
    
    lHAND_OUTER:
        PUSH CX
        MOV BL,0
        lHAND_INNER:
            INT 10H
            INC CX
            INC BL
            CMP BL,7
            JL lHAND_INNER
        INC DX
        POP CX
        INC CX
        CMP DX,245
    JL lHAND_OUTER
    
    
    ;DRAW BASE LINE _______
    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,0   ;COLOR BROWN
    MOV BH,0    ;PAGE 0
    MOV DX,160   ;ROW
    
    bbLINE_OUTER:
    MOV CX,50   ;STARTING COLUMN
        bbLINE_INNER:
            INT 10H
            INC CX
            CMP CX,150
            JL bbLINE_INNER
        INC DX
        CMP DX,190
    JL bbLINE_OUTER

 
    
;OTHERS   
    MOV AH, 0
    INT 16h
        
    MOV AX, 3
    INT 10h  
    
    MOV AH, 4CH
    INT 21h
    
main EndP
End main
    
    