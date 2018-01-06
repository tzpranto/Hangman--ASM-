.MODEL SMALL

.STACK 100H

.DATA

FILENAME DB 'd:\score.txt',0
BUFFER DB 512 DUP (0) 
A db 6 dup(0)
n db 6
HANDLE DW ? 
bufferSize dw 0
OPENERR DB 0DH,0AH, 'OPEN ERROR - CODE'
ERRCODE DB 30H,'$'   
sco db 34

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX   ;INITIALIZE DS
    MOV ES,AX   ; AND ES
    LEA DX,FILENAME ;DX HAS FILENAME OFFSE
    MOV AL,0        ; ACCESS CODE 0 FOR READING
    CALL OPEN       ;OPEN FILE
    JC OPEN_ERROR   ;EXIT IF ERROR 
    MOV HANDLE,AX   ;SAVE HANDLE
    
    
    LEA DX, BUFFER ; DX PTS TO BUFFER
    MOV BX,HANDLE ;GET HANDLE
    CALL READ    ;READ FILE. AX = BYTES READ
    OR AX,AX ;EOF?  
    JE EXIT
    cld
    lea si,buffer
    lea di,A
    
    mov cx,5
    
    input:
    call indec
    stosb
    loop input
    
    mov al,sco
    stosb
    
    sort:
    mov cl,n
    xor ch,ch
    dec cx
    jcxz comp
    outer:
        push cx
        lea si,A
        inner:
            mov al,byte ptr[si+1]
            cmp byte ptr[si],al
            jnl final
            xchg byte ptr[si],al
            mov byte ptr[si+1],al
            final:
                inc si
                loop inner
        pop cx
        loop outer      
    comp:    
        
    mov cx,5
    lea si,a
    lea di,buffer
    output:
    mov ah,0 
    lodsb
    call outdec
    mov al,0dh
    stosb
    mov al,0ah
    stosb
    add bx,2
    add bx,bufferSize
    mov bufferSize,bx
    
    loop output
    
    MOV BX,HANDLE   ;GET HANDLE
    CALL CLOSE  
    
    LEA DX,FILENAME ;DX HAS FILENAME OFFSE
    MOV AH,3DH
    MOV AL,1
    INT 21H
    MOV HANDLE,AX   ;SAVE HANDL  
    mov bx,handle
    mov cx,bufferSize
    lea dx,buffer
    
    MOV AH,40H     ;write function
    INT 21H 
    jmp exit
        
    OPEN_ERROR:
    LEA DX,OPENERR ;GET ERROR MESSAGE
    ADD ERRCODE,AL ;CONVERT ERROR CODE TO ASCII
    MOV AH,9
    INT 21H ;DISPLAY ERROR MESSAGE
    
    EXIT:
    MOV BX,HANDLE   ;GET HANDLE
    CALL CLOSE
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




    
INDEC PROC
;output AX HOLDS THE score
;input si contains buffer

PUSH BX
PUSH CX
PUSH DX

@BEGIN:

XOR BX,BX

XOR CX,CX

lodsb

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

lodsb

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
;output : di contains buffer for file 
;bx contains no. of bytes

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

mov bx,cx

@PRINT_LOOP:

POP aX
OR aL,30H
stosb

LOOP @PRINT_LOOP

POP DX
POP CX
POP AX
RET
OUTDEC ENDP

END MAIN