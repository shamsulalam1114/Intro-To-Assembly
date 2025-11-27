.MODEL SMALL
.STACK 100H

.DATA
    ; --- Messages ---
    MSG1    DB 'First number: $'
    MSG2    DB 0AH, 0DH, 'Second number: $'
    MSG3    DB 0AH, 0DH, 'Third number: $'
    MSG_RES DB 0AH, 0DH, ' is the biggest number.$'

    ; --- Variables to store inputs ---
    NUM1 DB ?
    NUM2 DB ?
    NUM3 DB ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; ==========================================
    ;       PART 1: TAKING INPUTS
    ; ==========================================

    ; --- Input 1 ---
    LEA DX, MSG1        ; Print "First number: "
    MOV AH, 9
    INT 21H

    MOV AH, 1           ; Input Character
    INT 21H
    MOV NUM1, AL        ; Store in variable NUM1

    ; --- Input 2 ---
    LEA DX, MSG2        ; Print "Second number: "
    MOV AH, 9
    INT 21H

    MOV AH, 1           ; Input Character
    INT 21H
    MOV NUM2, AL        ; Store in variable NUM2

    ; --- Input 3 ---
    LEA DX, MSG3        ; Print "Third number: "
    MOV AH, 9
    INT 21H

    MOV AH, 1           ; Input Character
    INT 21H
    MOV NUM3, AL        ; Store in variable NUM3

    ; ==========================================
    ;       PART 2: FINDING THE BIGGEST
    ; ==========================================
    
    ; Strategy: Use BL register to hold the "Current Winner"
    
    MOV BL, NUM1        ; Step A: Assume NUM1 is the biggest

    CMP NUM2, BL        ; Step B: Compare NUM2 with Current Winner (BL)
    JLE CHECK_3         ; If NUM2 is Less or Equal, don't change anything. Jump to next check.
    MOV BL, NUM2        ; BUT, if NUM2 was bigger, make NUM2 the new Winner.

CHECK_3:
    CMP NUM3, BL        ; Step C: Compare NUM3 with Current Winner (BL)
    JLE SHOW_RESULT     ; If NUM3 is Less or Equal, we are done.
    MOV BL, NUM3        ; BUT, if NUM3 was bigger, make NUM3 the new Winner.

    ; ==========================================
    ;       PART 3: DISPLAY RESULT
    ; ==========================================

SHOW_RESULT:
    ; 1. Print New Line (for formatting)
    MOV AH, 2
    MOV DL, 0AH         ; Line Feed
    INT 21H
    MOV DL, 0DH         ; Carriage Return
    INT 21H

    ; 2. Print the Winning Number (Stored in BL)
    MOV AH, 2
    MOV DL, BL          ; Move the winner to DL for printing
    INT 21H

    ; 3. Print the text " is the biggest number."
    LEA DX, MSG_RES
    MOV AH, 9
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN