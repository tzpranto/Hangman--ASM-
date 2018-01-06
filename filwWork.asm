.MODEL SMALL

.STACK 100H

.DATA

FILENAME Db 'D:\RiddleQuestion.txt',0 
Filename2 db 'D:\RiddleAnswer.txt',0 
Question db 512 dup(0) 
Answer db 100 dup(0)
BUFFER DB 512 DUP (0)
Buffer2 db 512 dup(0)
HANDLE DW ?
handle2 dw ? 
qLength dw 0
aLength dw 0
OPENERR DB 0DH,0AH, 'OPEN ERROR - CODE'
ERRCODE DB 30H,'$'

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX   ;INITIALIZE DS
    MOV ES,AX   ; AND ES 
    
    ;opening question file
    LEA DX,FILENAME ;DX HAS FILENAME OFFSE
    MOV AL,0        ; ACCESS CODE 0 FOR READING
    CALL OPEN       ;OPEN FILE
    JC OPEN_ERROR   ;EXIT IF ERROR 
    MOV HANDLE,AX   ;SAVE HANDLE   
    
    ;opening answer file
    LEA DX,Filename2 ;DX HAS FILENAME OFFSE
    MOV AL,0        ; ACCESS CODE 0 FOR READING
    CALL OPEN       ;OPEN FILE
    JC OPEN_ERROR   ;EXIT IF ERROR 
    MOV handle2,AX   ;SAVE HANDLE
    
    
    ;initializing buffer

    LEA DX, BUFFER ; DX PTS TO BUFFER
    MOV BX,HANDLE ;GET HANDLE
    CALL READ    ;READ FILE. AX = BYTES READ
    OR AX,AX ;EOF?  
    JE EXIT 
    
    mov cx,ax
    lea di,Question  ;initializing question pointer
    lea si,buffer    ;initializing buffer pointer
    cld              ;moving pointers forward
        
        qLoop:
        cmp [si],0ah   ;checking if question is completed?
        je end_qLoop   ;oky dude. this one is done
        movsb          ;keep writing question
        inc qLength    ;keep tracking question length
        loop qLoop 
        
        reload: ;cx = 0, buffer ended but question not completed; reload buffer 
        
        LEA DX,BUFFER ; DX PTS TO BUFFER
        MOV BX,HANDLE ;GET HANDLE
        CALL READ    ;READ FILE. AX = BYTES READ
        OR AX,AX   
        JE EXIT  
        mov cx,ax ;reloading cx
        lea si,buffer ;restoring buffer pointer
        jmp qLoop 
         
        end_qLoop:
        movsb     ;saving 0ah
        inc qLength
        mov al,'$' 
        stosb     ;indicating end of string  
        dec cx    ;jumped before loop qLoop was called. so manually 
                  ;decreasing cx
        
        mov ah,9
        lea dx,Question
        int 21h           ;showing question 
        
        ;now question array has question and qLength has string length
        ;lets load answer in answer array
        
        ;start by saving current info
        push si
        push di
        push ax
        push bx
        push cx
        push dx
        
        ;read 1 byte each time until you find 0dh
        ;and store then in answer
        
        lea di,Answer 
        mov ax,0
        mov aLength,ax ;restoring answer size
        
        aLoop:
        LEA DX,Buffer2 ; DX PTS TO BUFFER
        MOV BX,handle2 ;GET HANDLE
        PUSH CX
        MOV AH,3FH
        MOV CX,1
        INT 21H
        POP CX 
        cmp ax,0
        je end_aLoop2
        mov al,[Buffer2+0]
        cmp al,0ah
        je end_aLoop
        stosb 
        inc aLength
        jmp aLoop
        
        end_aLoop:
        stosb 
        dec aLength 
        end_aLoop2:                           
        mov al,'$'
        stosb
        mov ah,9
        lea dx,Answer
        int 21h 
        
        ;time to restore registers. what do u say votka?
        pop dx
        pop cx
        pop bx
        pop ax
        pop di
        pop si
        
        ;hey ralph now you have
        ;question in Question
        ;question size in qLength
        ;answer in Answer
        ;answer size in aLength
        ;put your code here
        ;show in screen
        ;play the game
        ;when you are done
        ;refresh the screen (get rid of the corpse, clear question and answer area)
        ;then ask a new question 
        ;play the game
        ;i'm done here
        ;happy ?
        
        lea di,Question    ;restoring question pointer
        mov ax,0 
        mov qLength,ax      ;restoring question length
        cmp cx,0           ;if question ended and so did buffer
        jle reload         ;yes, reload buffer 
        jmp qLoop          ;buffer has next question , start reading
        
       
    
    
    OPEN_ERROR:
    LEA DX,OPENERR ;GET ERROR MESSAGE
    ADD ERRCODE,AL ;CONVERT ERROR CODE TO ASCII
    MOV AH,9
    INT 21H ;DISPLAY ERROR MESSAGE
    
    EXIT:
    MOV BX,HANDLE   ;GET HANDLE
    CALL CLOSE      ;closing question file 
    mov bx,handle2
    call CLOSE      ;closing answer file
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
    
     