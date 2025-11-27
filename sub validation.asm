.MODEL SMALL
.STACK 100H

.DATA
    MSG1    DB 0AH, 0DH, 'ENTER FIRST NUMBER: $'
    MSG2    DB 0AH, 0DH, 'ENTER SECOND NUMBER: $'
    MSG_ERR DB 0AH, 0DH, 'INVALID! TRY AGAIN$'
    MSG_RES DB 0AH, 0DH, 'THE DIFFERENCE IS: $'
    
    NUM1    DB ?
    NUM2    DB ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- INPUT FIRST NUMBER ---
INPUT1:
    LEA DX, MSG1        ; Print "Enter First Number"
    MOV AH, 9
    INT 21H

    MOV AH, 1           ; Take Input
    INT 21H
    
    ; Check if Valid (Between '0' and '9')
    CMP AL, '0'
    JL ERROR1           ; If less than '0', it's invalid
    CMP AL, '9'
    JG ERROR1           ; If greater than '9', it's invalid
    
    MOV NUM1, AL        ; If valid, save to NUM1
    JMP INPUT2_START    ; Go to next step

ERROR1:                 ; Error handler for first number
    LEA DX, MSG_ERR
    MOV AH, 9
    INT 21H
    JMP INPUT1          ; Jump back to try again

    ; --- INPUT SECOND NUMBER ---
INPUT2_START:
INPUT2:
    LEA DX, MSG2        ; Print "Enter Second Number"
    MOV AH, 9
    INT 21H

    MOV AH, 1           ; Take Input
    INT 21H

    ; Check if Valid
    CMP AL, '0'
    JL ERROR2
    CMP AL, '9'
    JG ERROR2

    MOV NUM2, AL        ; If valid, save to NUM2
    JMP CALCULATE       ; Go to math

ERROR2:                 ; Error handler for second number
    LEA DX, MSG_ERR
    MOV AH, 9
    INT 21H
    JMP INPUT2          ; Jump back to try again

    ; --- CALCULATION & OUTPUT ---
CALCULATE:
    LEA DX, MSG_RES     ; Print "The difference is:"
    MOV AH, 9
    INT 21H

    ; Perform Subtraction
    MOV AL, NUM1        ; Move first char (e.g., '7') to AL
    SUB AL, NUM2        ; Subtract second char (e.g., '5')
    ADD AL, 30H         ; Fix ASCII (Result 2 became binary 2, make it char '2')

    ; Print Result
    MOV DL, AL
    MOV AH, 2
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN