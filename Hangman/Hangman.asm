.MODEL SMALL
.STACK 100h

.DATA
HEADING DB 'HANGMAN'
TYPED_LETTERS DB 'PRESSED LETTERS: '
HIGHSCORE_MSG DB 'HIGHSCORE'
SCORE DB 'SCORE: '
QUESTION DB 'QUESTION: '
ANSWER DB 'ANSWER: '
LOSE DB 'YOU LOSE!!!'
WIN DB 'YOU WIN!!!'
EXIT_MSG DB 'PRESS ANY KEY TO EXIT'

QUESTION_F DB 120 DUP (0)
ANSWER_F DB 120 DUP (0)

FILENAME DB 'RiQue.txt',0 
FILENAME2 DB 'RiAns.txt',0
SCORE_FILE DB 'Score.txt',0

QSIZE DW 0
ASIZE DW 0
A DB 6 DUP(0)
N DB 6
BUFFERSIZE DW 0
BUFFER DB 512 DUP (0)
BUFFER2 DB 512 DUP(0)
BUFFER_SCORE DB 512 DUP (0)
HANDLE DW ?
HANDLE2 DW ?
HANDLE_SCORE DW ?

OPENERR DB 0DH,0AH, 'OPEN ERROR - CODE'
ERRCODE DB 30H,'$'

CORRECT DW ?
CHANCE DW 6

CURSOR DW ?
WIN_OR_LOSE DW ?
TOTAL_SCORE DB 0

.CODE
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    MOV ES,AX
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

;write Title of the game
;
;HANGMAN
;HANGMAN
; 
;;;;
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,1    ;row = 1
    MOV DL,37   ;column = 37      
    INT 10H
    
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    LEA SI,HEADING
    CLD
    MOV CX,7
    WRITE_TITLE:
    LODSB
    INT 10h
    LOOP WRITE_TITLE
    
;write PRESSED LETTERS
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,16    ;row = 16
    MOV DL,30   ;column = 30      
    INT 10H
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    LEA SI,TYPED_LETTERS
    CLD
    MOV CX,17
    WRITE_PRESSED:
    LODSB
    INT 10h
    LOOP WRITE_PRESSED

;write SCORE
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,18    ;row = 18
    MOV DL,30   ;column = 30      
    INT 10H
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    LEA SI,SCORE
    CLD
    MOV CX,7
    WRITE_SCORE:
    LODSB
    INT 10h
    LOOP WRITE_SCORE 
 
;write Question
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,25    ;row = 25
    MOV DL,1  ;column = 1      
    INT 10H  
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    LEA SI,QUESTION
    CLD
    MOV CX,10
    WRITE_QUES:
    LODSB
    INT 10h
    LOOP WRITE_QUES

;write Answer
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,27    ;row = 27
    MOV DL,1   ;column = 1      
    INT 10H  
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    LEA SI,ANSWER
    CLD
    MOV CX,8
    WRITE_ANS:
    LODSB
    INT 10h
    LOOP WRITE_ANS
    
    
    ;--------------------------------------
    ;FILE WORK
    
    ;OPENING QUESTION FILE
    LEA DX,FILENAME ;DX HAS FILENAME OFFSE
    MOV AL,0        ; ACCESS CODE 0 FOR READING
    CALL OPEN       ;OPEN FILE
    JC OPEN_ERROR_BRIDGE   ;EXIT IF ERROR 
    MOV HANDLE,AX   ;SAVE HANDLE   
    
    ;OPENING ANSWER FILE
    LEA DX,FILENAME2 ;DX HAS FILENAME OFFSE
    MOV AL,0        ; ACCESS CODE 0 FOR READING
    CALL OPEN       ;OPEN FILE
    JC OPEN_ERROR_BRIDGE   ;EXIT IF ERROR 
    MOV HANDLE2,AX   ;SAVE HANDLE
    
    
    ;INITIALIZING BUFFER

    LEA DX, BUFFER ; DX PTS TO BUFFER
    MOV BX,HANDLE ;GET HANDLE
    CALL READ    ;READ FILE. AX = BYTES READ
    OR AX,AX ;EOF?  
    JE EXIT_BRIDGE 
    
    MOV CX,AX
    LEA DI,QUESTION_F  ;INITIALIZING QUESTION POINTER
    LEA SI,BUFFER    ;INITIALIZING BUFFER POINTER
    CLD              ;MOVING POINTERS FORWARD
        
        QLOOP:
        CMP BYTE PTR [SI],0AH   ;CHECKING IF QUESTION IS COMPLETED?
        JE END_QLOOP   ;OKY DUDE. THIS ONE IS DONE
        MOVSB          ;KEEP WRITING QUESTION
        INC QSIZE    ;KEEP TRACKING QUESTION LENGTH
        LOOP QLOOP 
        
        RELOAD: ;CX = 0, BUFFER ENDED BUT QUESTION NOT COMPLETED; RELOAD BUFFER 
        
        LEA DX,BUFFER ; DX PTS TO BUFFER
        MOV BX,HANDLE ;GET HANDLE
        CALL READ    ;READ FILE. AX = BYTES READ
        OR AX,AX   
        JE EXIT_BRIDGE 
        MOV CX,AX ;RELOADING CX
        LEA SI,BUFFER ;RESTORING BUFFER POINTER
        JMP QLOOP 
        EXIT_BRIDGE:
        JMP EXIT
        END_QLOOP:
        MOVSB     ;SAVING 0AH
        INC QSIZE
        MOV AL,'$' 
        STOSB     ;INDICATING END OF STRING  
        DEC CX    ;JUMPED BEFORE LOOP QLOOP WAS CALLED. SO MANUALLY 
                  ;DECREASING CX
        
                  ;MOV AH,9
                  ;LEA DX,QUESTION
                  ;INT 21H           ;SHOWING QUESTION 
        
        ;NOW QUESTION ARRAY HAS QUESTION AND QLENGTH HAS STRING LENGTH
        ;LETS LOAD ANSWER IN ANSWER ARRAY
        
        ;START BY SAVING CURRENT INFO
        PUSH SI
        PUSH DI
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        
        ;READ 1 BYTE EACH TIME UNTIL YOU FIND 0DH
        ;AND STORE THEN IN ANSWER
        
        LEA DI,ANSWER_F 
        MOV AX,0
        MOV ASIZE,AX ;RESTORING ANSWER SIZE
        JMP ALOOP
        OPEN_ERROR_BRIDGE:
        JMP OPEN_ERROR
        ALOOP:
        LEA DX,BUFFER2 ; DX PTS TO BUFFER
        MOV BX,HANDLE2 ;GET HANDLE
        PUSH CX
        MOV AH,3FH
        MOV CX,1
        INT 21H
        POP CX 
        CMP AX,0
        JE END_ALOOP2
        MOV AL,[BUFFER2+0]
        CMP AL,0AH
        JE END_ALOOP
        STOSB 
        INC ASIZE
        JMP ALOOP
        END_ALOOP:
        STOSB 
        DEC ASIZE 
        END_ALOOP2:                           
        MOV AL,'$'
        STOSB
        ;MOV AH,9
        ;LEA DX,ANSWER
        ;INT 21H
        JMP SKIP_NEXT_LINE 
        RELOAD_BRIDGE:
        JMP RELOAD
        ;TIME TO RESTORE REGISTERS. WHAT DO U SAY VOTKA?
        SKIP_NEXT_LINE:
        POP DX
        POP CX
        POP BX
        POP AX
        POP DI
        POP SI
        
        ;HEY RALPH NOW YOU HAVE
        ;QUESTION IN QUESTION
        ;QUESTION SIZE IN QLENGTH
        ;ANSWER IN ANSWER
        ;ANSWER SIZE IN ALENGTH
        ;PUT YOUR CODE HERE
        ;SHOW IN SCREEN
        ;PLAY THE GAME
        ;WHEN YOU ARE DONE
        ;REFRESH THE SCREEN (GET RID OF THE CORPSE, CLEAR QUESTION AND ANSWER AREA)
        ;THEN ASK A NEW QUESTION 
        ;PLAY THE GAME
        ;I'M DONE HERE
        ;HAPPY ?
        CALL CLEAR_TYPED_LET
        PUSH CX
        PUSH SI
        PUSH DI
        
        LEA SI,QUESTION_F
        LEA DI,ANSWER_F
        MOV CX,QSIZE
        SUB CX,2
        MOV AX,ASIZE
        ;MOV AH,9
        CALL PROCESS_QUES
        CMP WIN_OR_LOSE,0
        JE EXIT
        ;MOV AH,2
        ;MOV DL,'1'
        ;INT 21h
        MOV AL,0
        CALL BODY
        CALL HEAD
        CALL LEFT_HAND
        CALL RIGHT_HAND
        CALL RIGHT_LEG
        POP DI
        POP SI
        POP CX
        LEA DI,QUESTION_F    ;RESTORING QUESTION POINTER
        MOV AX,0 
        MOV QSIZE,AX      ;RESTORING QUESTION LENGTH
        CMP CX,0           ;IF QUESTION ENDED AND SO DID BUFFER
        
        JLE RELOAD_BRIDGE         ;YES, RELOAD BUFFER 
        JMP QLOOP          ;BUFFER HAS NEXT QUESTION , START READING
        
       
    
    
    OPEN_ERROR:
    LEA DX,OPENERR ;GET ERROR MESSAGE
    ADD ERRCODE,AL ;CONVERT ERROR CODE TO ASCII
    MOV AH,9
    INT 21H ;DISPLAY ERROR MESSAGE
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;FILE WORK END
    ;--------------------------------------
    
    
    
    
    
;OTHERS 
    EXIT:   
    LEA DX,SCORE_FILE ;DX HAS FILENAME OFFSE
    MOV AL,0        ; ACCESS CODE 0 FOR READING
    CALL OPEN       ;OPEN FILE
    MOV HANDLE_SCORE,AX   ;SAVE HANDLE
    LEA DX, BUFFER_SCORE ; DX PTS TO BUFFER
    MOV BX,HANDLE_SCORE ;GET HANDLE
    CALL READ    ;READ FILE. AX = BYTES READ
    OR AX,AX ;EOF?  
    JE SHOW_HIGH_SCORE
    CLD
    LEA SI,BUFFER_SCORE
    LEA DI,A
    
    MOV CX,5
    
    INPUT:
    CALL INDEC
    STOSB
    LOOP INPUT
    
    MOV AL,TOTAL_SCORE
    STOSB
    
    SORT:
    MOV CL,N
    XOR CH,CH
    DEC CX
    JCXZ COMP
    OUTER:
        PUSH CX
        LEA SI,A
        INNER:
            MOV AL,BYTE PTR[SI+1]
            CMP BYTE PTR[SI],AL
            JNL FINAL
            XCHG BYTE PTR[SI],AL
            MOV BYTE PTR[SI+1],AL
            FINAL:
                INC SI
                LOOP INNER
        POP CX
        LOOP OUTER      
    COMP:    
        
    MOV CX,5
    LEA SI,A
    LEA DI,BUFFER_SCORE
    OUTPUT:
    MOV AH,0 
    LODSB
    CALL OUTDEC
    MOV AL,0DH
    STOSB
    MOV AL,0AH
    STOSB
    ADD BX,2
    ADD BX,BUFFERSIZE
    MOV BUFFERSIZE,BX
    
    LOOP OUTPUT
    
    MOV BX,HANDLE_SCORE   ;GET HANDLE
    CALL CLOSE  
    
    LEA DX,SCORE_FILE ;DX HAS FILENAME OFFSE
    MOV AH,3DH
    MOV AL,1
    INT 21H
    MOV HANDLE_SCORE,AX   ;SAVE HANDL  
    MOV BX,HANDLE_SCORE
    MOV CX,BUFFERSIZE
    LEA DX,BUFFER_SCORE
    
    MOV AH,40H     ;WRITE FUNCTION
    INT 21H
    SHOW_HIGH_SCORE:
    CALL SCROLL_SCREEN
    CMP WIN_OR_LOSE,1
    JNE PRINT_LOSE
    CALL SHOW_WIN_MSG
    JMP PROPER_EXIT
    PRINT_LOSE:
    CALL SHOW_LOSE_MSG
    PROPER_EXIT:
    CALL SHOW_SCORES
    CALL SHOW_EXIT_MSG
    
    MOV BX,HANDLE_SCORE   ;GET HANDLE
    CALL CLOSE
    
    MOV AH, 0
    INT 16h
       
    MOV AX, 3
    INT 10h    
    
    MOV AH, 4CH
    INT 21h
    
MAIN ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------

HIGHSCORE PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,1    ;row = 1
    MOV DL,34   ;column = 37      
    INT 10H  
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    LEA SI,HIGHSCORE_MSG
    CLD
    MOV CX,9
    WRITE_HIGH:
    LODSB
    INT 10h
    LOOP WRITE_HIGH
    POP DX
    POP CX
    POP BX
    POP AX
    RET
HIGHSCORE ENDP

_SHOW_DEC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX    
    MOV BL,N
    XOR BH,BH
    NEG BX
    ADD BX,5
    MOV AL,A[BX]
    XOR AH,AH
    XOR CX,CX
    DIV_AND_DEC:
    CMP AX,0
    JE PRINT_DEC
    MOV BL,10
    IDIV BL
    INC CX
    XOR DH,DH
    MOV DL,AH
    PUSH DX
    XOR AH,AH
    JMP DIV_AND_DEC
    PRINT_DEC:
    POP DX
    MOV AL,DL
    ADD AL,48
    MOV AH,0Eh
    MOV BH,0
    MOV BL,2    ;color = red
    INT 10h
    LOOP PRINT_DEC 
    POP DX
    POP CX
    POP BX
    POP AX
    RET
_SHOW_DEC ENDP

SHOW_SCORES PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    DEC N
    CALL HIGHSCORE
    MOV DH,4
    N_LOOP:
    CMP N,0
    JE EXIT_SHOW_SCORE
    ;set cursor
    MOV AH,2
    MOV BH,0
    ;MOV DH,4    ;row = 1
    MOV DL,37   ;column = 37      
    INT 10H
    ;write
    CALL _SHOW_DEC
    DEC N
    ADD DH,3
    JMP N_LOOP
    EXIT_SHOW_SCORE:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
SHOW_SCORES ENDP
    


SCROLL_SCREEN PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,7
    MOV AL,0
    MOV BH,0
    XOR CX,CX
    MOV DH,28
    MOV DL,79
    INT 10h
    POP DX
    POP CX
    POP BX
    POP AX
    RET
SCROLL_SCREEN ENDP
    




;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
SHOW_LOSE_MSG PROC
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,23    ;row = 10
    MOV DL,34   ;column = 50      
    INT 10H  
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    LEA SI,LOSE
    CLD
    MOV CX,11
    WRITE_LOSE:
    LODSB
    INT 10h
    LOOP WRITE_LOSE
    RET
SHOW_LOSE_MSG ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------



;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
SHOW_EXIT_MSG PROC
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,27    ;row = 10
    MOV DL,27   ;column = 50      
    INT 10H  
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    LEA SI,EXIT_MSG
    CLD
    MOV CX,21
    WRITE_EXIT:
    LODSB
    INT 10h
    LOOP WRITE_EXIT
    RET
SHOW_EXIT_MSG ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------



;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
SHOW_WIN_MSG PROC
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,23    ;row = 10
    MOV DL,34   ;column = 50      
    INT 10H  
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    LEA SI,WIN
    CLD
    MOV CX,10
    WRITE_WIN:
    LODSB
    INT 10h
    LOOP WRITE_WIN
    RET
SHOW_WIN_MSG ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------



;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
SHOWQUES PROC NEAR
;input: SI = input string
;       CX = size of string 
;output: writes the ques from row = 25, column = 11
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH CX
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,25   ;row = 25   
    MOV DL,11   ;column = 11
    INT 10h
    ;print space
    MOV CX,69
    MOV AH,0Eh
    MOV BH,0
    MOV BL,2    ;color = red
    MOV AL,' '
    PRINT_SPACE_QUES1:
    INT 10h
    LOOP PRINT_SPACE_QUES1
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,26   ;row = 26   
    MOV DL,0   ;column = 11
    INT 10h
    ;print space
    MOV CX,79
    MOV AH,0Eh
    MOV BH,0
    MOV BL,2    ;color = red
    MOV AL,' '
    PRINT_SPACE_QUES2:
    INT 10h
    LOOP PRINT_SPACE_QUES2
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,25   ;row = 25   
    MOV DL,11   ;column = 11
    INT 10h
    POP CX
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,2    ;color = red
    SHOW_QUES:
    LODSB
    INT 10h
    LOOP SHOW_QUES
    POP DX
    POP BX
    POP AX
    RET
SHOWQUES ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
SHOW_QUES_MARK PROC NEAR
;CX = Number of ?
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH CX
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,27   ;row = 27   
    MOV DL,10   ;column = 10
    INT 10h
    ;write space
    MOV AH,0Eh
    XOR BH,BH
    MOV BL,2
    MOV AL,' '
    MOV CX,70
    P_SPACE:
    INT 10h
    LOOP P_SPACE
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,27   ;row = 27   
    MOV DL,10   ;column = 10
    INT 10h
    ;start writing
    POP CX
    MOV AH,0Eh
    MOV BH,0
    MOV BL,2    ;color = red
    MOV AL,'?'
    QMARK:
    INT 10h
    LOOP QMARK
    POP DX
    POP BX
    POP AX
    RET
SHOW_QUES_MARK ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------




;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
MATCH_CHAR PROC NEAR
;input
;DI = input string
;AL = char to match
;CX = string size
;output
;DX = 1 if found, DX = 0 if not found
;BX = position at which it was found, undefined when not found
    PUSH CX
    PUSH DI
    PUSH AX
    INC CX
    CLD
    REPNZ SCASB
    CMP CX,0
    JNE FOUNDC
    MOV DX,0
    JMP EXIT_MATCH
    FOUNDC:
    MOV DX,1
    MOV BX,DI
    DEC BX
    DEC DI
    MOV AL,'.'
    STOSB
    EXIT_MATCH:
    POP AX
    POP DI
    SUB BX,DI
    POP CX
    RET
MATCH_CHAR ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------   
    








;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------   
    
SHOW_SCORE PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,18   ;row = 18   
    MOV DL,38   ;column = 38
    INT 10h
    XOR CX,CX
    MOV AL,TOTAL_SCORE
    XOR AH,AH
    CMP TOTAL_SCORE,0
    JNE DIV_AND_SHOW
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,2    ;color = red
    MOV AL,'0'
    INT 10h
    JMP EXIT_SCORE
    DIV_AND_SHOW:
    CMP AX,0
    JE PRINT_SCORE
    MOV BL,10
    IDIV BL
    INC CX
    XOR DH,DH
    MOV DL,AH
    PUSH DX
    XOR AH,AH
    JMP DIV_AND_SHOW
    PRINT_SCORE:
    POP DX
    MOV AL,DL
    ADD AL,48
    MOV AH,0Eh
    MOV BH,0
    MOV BL,2    ;color = red
    INT 10h
    LOOP PRINT_SCORE
    EXIT_SCORE:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
SHOW_SCORE ENDP









;-----------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------- 



CLEAR_TYPED_LET PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,16    ;row = 16
    MOV DL,48
    INT 10H
    MOV AL,' '
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    MOV CX,32
    LOP:
    INT 10h
    LOOP LOP
    POP DX
    POP CX
    POP BX
    POP AX
    RET
CLEAR_TYPED_LET ENDP





;-----------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------- 
SHOW_TYPED_LET PROC
;input AL = char
;      DL = COLUMN
;output = none
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ;set cursor
    MOV AH,2
    MOV BH,0
    MOV DH,16    ;row = 16
    INT 10H  
    ;start writing
    MOV AH,0Eh
    MOV BH,0
    MOV BL,1    ;color = green
    INT 10h
    POP DX
    POP CX
    POP BX
    POP AX
    RET    
SHOW_TYPED_LET ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------





;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
PROCESS_QUES PROC NEAR
;This runs until the man is fully drawn or player guesses correctly
;SI = question
;DI = answer
;CX = question size
;AX = answer size


    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    CLD
    CALL SHOWQUES       ;show the question
    MOV CX,AX
    CALL SHOW_QUES_MARK ;show unknown letters
    MOV CORRECT,AX
    MOV CHANCE,6
    MOV CURSOR,48
    MOV CX,AX   ;answer size
    WHILE_PQ:
    CALL SHOW_SCORE
    CMP CHANCE,0
    JE EXIT_CHANCE_BRIDGE
    CMP CORRECT,0
    JE EXIT_CORRECT_BRIDGE
    ;take input
    MOV AH,0
    INT 16h
    JMP BRIDGE
    EXIT_CHANCE_BRIDGE:
    JMP EXIT_CHANCE
    EXIT_CORRECT_BRIDGE:
    JMP EXIT_CORRECT
    ;MATCH WITH ANSWER
    BRIDGE:
    CALL MATCH_CHAR
    CMP DX,1
    JNE DEC_CHANCE
    MATCH_AGAIN:
    DEC CORRECT
    ADD TOTAL_SCORE,1
    ;show the correct char
    ;set cursor
    MOV AH,2
    MOV DH,27   ;row 27
    MOV DL,10   ;column 10
    ADD DL,BL   ;column 10 + BL
    MOV BH,0
    INT 10h
    ;show char at cursor
    MOV AH,0Eh
    MOV BL,2 ;red
    INT 10h
    CALL MATCH_CHAR
    CMP DX,0
    JE WHILE_PQ
    JMP MATCH_AGAIN
    DEC_CHANCE:
    DEC CHANCE
    CMP TOTAL_SCORE,0
    JE SKIP_TO_NEXT
    SUB TOTAL_SCORE,1
    ;then show the char at typed words, draw hangman, etc
    SKIP_TO_NEXT:
    PUSH DX
    MOV DX,CURSOR
    CALL SHOW_TYPED_LET
    INC CURSOR
    POP DX
    PUSH AX
    MOV AL,2
    CMP CHANCE,5
    JE DR_HEAD
    CMP CHANCE,4
    JE DR_BODY
    CMP CHANCE,3
    JE DR_RIGHT_HAND            ;depending on the chance draw the body part
    CMP CHANCE,2
    JE DR_LEFT_HAND
    CMP CHANCE,1
    JE DR_RIGHT_LEG
    CMP CHANCE,0
    JE DR_LEFT_LEG
    DR_HEAD:
    CALL HEAD
    POP AX
    JMP WHILE_PQ
    DR_BODY:
    CALL BODY
    POP AX
    JMP WHILE_PQ
    DR_RIGHT_HAND:
    CALL RIGHT_HAND
    POP AX
    JMP WHILE_PQ
    DR_LEFT_HAND:
    CALL LEFT_HAND
    POP AX
    JMP WHILE_PQ
    DR_RIGHT_LEG:
    CALL RIGHT_LEG
    POP AX
    JMP WHILE_PQ
    DR_LEFT_LEG:
    CALL LEFT_LEG
    POP AX
    JMP WHILE_PQ
    EXIT_CHANCE:
    ;you lose
    MOV WIN_OR_LOSE,0
    JMP EXIT_PQ
    EXIT_CORRECT:
    ;you win
    MOV WIN_OR_LOSE,1
    EXIT_PQ:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PROCESS_QUES ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------




;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
BODY PROC NEAR
;DRAW BODY
;   |
;   |
;   |
;   |
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    ;MOV AL,2   ;COLOR BROWN
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
    POP DX
    POP CX
    POP BX
    POP AX
    RET
BODY ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------




;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
RIGHT_HAND PROC NEAR
    ;DRAWING RIGHT HAND
;       /
;      /
;     /
;    /
;   /
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    ;MOV AL,2   ;COLOR BROWN
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
    POP DX
    POP CX
    POP BX
    POP AX
    RET
RIGHT_HAND ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------




;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
HEAD PROC NEAR
;DRAW HEAD
;   |--------|
;   | o -  O |
;   |  ---   |
;   |--------| 
;AL = color       
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    ;MOV AL,2   ;COLOR RED
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
    POP DX
    POP CX
    POP BX
    POP AX
    RET
HEAD ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------



;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
LEFT_HAND PROC NEAR
;DRAWING LEFT HAND
;    \ 
;     \   
;      \
;       \
;        \


    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    ;MOV AL,2   ;COLOR BROWN
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
    POP DX
    POP CX
    POP BX
    POP AX
    RET
LEFT_HAND ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------



;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
LEFT_LEG PROC NEAR
;DRAWING LEFT LEG
;    \ 
;     \   
;      \
;       \
;        \

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    ;MOV AL,2   ;COLOR BROWN
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
    POP DX
    POP CX
    POP BX
    POP AX
    RET
LEFT_LEG ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------





;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------
RIGHT_LEG PROC NEAR
;DRAWING RIGHT LEG
;       /
;      /
;     /
;    /
;   /

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    ;MOV AL,2   ;COLOR BROWN
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
    POP DX
    POP CX
    POP BX
    POP AX
    RET
RIGHT_LEG ENDP
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;file procedures
OPEN PROC NEAR
    ;OPENS FILE
    ;INPUT DS:DX FILENAME, AL ACCESS CODE
    ;OUTPUT IF SUCCESSFUL AX HANDLE
    ;IF UNSUCCESSFUL CF =1 , AX = ERROR CODE
    
    MOV AH,3DH
    MOV AL,0
    INT 21H
    RET 
    OPEN ENDP

READ PROC NEAR
    ;READS A FILE SECTOR
    ;INPUT: BX FILE HANDLE
    ;CX BYTES TO READ
    ;DS:DX BUFFER
    ;OUTPUT: IF SUCCESSFUL, SECTOR IN BUFFER
    ;AX NUMBER OF BYTED READ
    ; IF UNSUCCESSFUL CF =1
    
    PUSH CX
    MOV AH,3FH
    MOV CX,512
    INT 21H
    POP CX
    RET
    READ ENDP 

CLOSE PROC NEAR
    ;CLOSES A FILE
    ;INPUT BX = HANDLE
    ;OUTPUT CF =1; ERROR CODE IN AX
    MOV AH,3EH
    INT 21H
    RET
    CLOSE ENDP



INDEC PROC
;OUTPUT AX HOLDS THE SCORE
;INPUT SI CONTAINS BUFFER

PUSH BX
PUSH CX
PUSH DX

@BEGIN:

XOR BX,BX

XOR CX,CX

LODSB

@REPEAT2:
CMP AL,'0'
JNGE @NOT_DIGIT
CMP AL,'9'
JNLE @NOT_DIGIT

AND AX,000FH
PUSH AX

MOV AX,10
MUL BX
POP BX
ADD BX,AX

LODSB

CMP AL,0DH
JNE @REPEAT2

MOV AX,BX

@EXIT:
POP DX
POP CX
POP BX
RET

@NOT_DIGIT:
JMP @BEGIN   
INDEC ENDP


OUTDEC PROC
;INPUT AX 
;OUTPUT : DI CONTAINS BUFFER FOR FILE 
;BX CONTAINS NO. OF BYTES

PUSH AX
PUSH CX
PUSH DX

@END_IF1:
XOR CX,CX
MOV BX,10D

@REPEAT1:
XOR DX,DX
DIV BX
PUSH DX
INC CX
OR AX,AX
JNE @REPEAT1

MOV BX,CX

@PRINT_LOOP:

POP AX
OR AL,30H
STOSB

LOOP @PRINT_LOOP

POP DX
POP CX
POP AX
RET
OUTDEC ENDP






END MAIN
;-----------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------    
    
