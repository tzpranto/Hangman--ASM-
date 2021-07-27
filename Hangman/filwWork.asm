.MODEL SMALL

.STACK 100H

.DATA

FILENAME DB 'RiQue.txt',0 
FILENAME2 DB 'RiAns.txt',0 
QUESTION DB 512 DUP(0) 
ANSWER DB 100 DUP(0)
BUFFER DB 512 DUP (0)
BUFFER2 DB 512 DUP(0)
HANDLE DW ?
HANDLE2 DW ? 
QLENGTH DW 0
ALENGTH DW 0
OPENERR DB 0DH,0AH, 'OPEN ERROR - CODE'
ERRCODE DB 30H,'$'

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX   ;INITIALIZE DS
    MOV ES,AX   ; AND ES 
    
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
    LEA DI,QUESTION  ;INITIALIZING QUESTION POINTER
    LEA SI,BUFFER    ;INITIALIZING BUFFER POINTER
    CLD              ;MOVING POINTERS FORWARD
        
        QLOOP:
        CMP BYTE PTR [SI],0AH   ;CHECKING IF QUESTION IS COMPLETED?
        JE END_QLOOP   ;OKY DUDE. THIS ONE IS DONE
        MOVSB          ;KEEP WRITING QUESTION
        INC QLENGTH    ;KEEP TRACKING QUESTION LENGTH
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
        INC QLENGTH
        MOV AL,'$' 
        STOSB     ;INDICATING END OF STRING  
        DEC CX    ;JUMPED BEFORE LOOP QLOOP WAS CALLED. SO MANUALLY 
                  ;DECREASING CX
        
        MOV AH,9
        LEA DX,QUESTION
        INT 21H           ;SHOWING QUESTION 
        
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
        
        LEA DI,ANSWER 
        MOV AX,0
        MOV ALENGTH,AX ;RESTORING ANSWER SIZE
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
        INC ALENGTH
        JMP ALOOP
        END_ALOOP:
        STOSB 
        DEC ALENGTH 
        END_ALOOP2:                           
        MOV AL,'$'
        STOSB
        MOV AH,9
        LEA DX,ANSWER
        INT 21H
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
        
        LEA DI,QUESTION    ;RESTORING QUESTION POINTER
        MOV AX,0 
        MOV QLENGTH,AX      ;RESTORING QUESTION LENGTH
        CMP CX,0           ;IF QUESTION ENDED AND SO DID BUFFER
        JLE RELOAD_BRIDGE         ;YES, RELOAD BUFFER 
        JMP QLOOP          ;BUFFER HAS NEXT QUESTION , START READING
        
       
    
    
    OPEN_ERROR:
    LEA DX,OPENERR ;GET ERROR MESSAGE
    ADD ERRCODE,AL ;CONVERT ERROR CODE TO ASCII
    MOV AH,9
    INT 21H ;DISPLAY ERROR MESSAGE
    
    EXIT:
    MOV BX,HANDLE   ;GET HANDLE
    CALL CLOSE      ;CLOSING QUESTION FILE 
    MOV BX,HANDLE2
    CALL CLOSE      ;CLOSING ANSWER FILE
    MOV AH,4CH
    INT 21H
    
    MAIN ENDP


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

END MAIN
    
     