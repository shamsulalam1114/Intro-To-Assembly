.MODEL SMALL
.STACK 100H

.DATA
    MSG_INPUT  DB 0AH, 0DH, 'ENTER TWO ALPHABETS: $'
    MSG_OUTPUT DB 0AH, 0DH, 'THE CORRECT ORDER IS: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- PART A: Print '@' 5 times ---
    MOV CX, 5           ; Set loop counter to 5
    
PRINT_LOOP:
    MOV AH, 2           ; Function to print character
    MOV DL, '@'         ; Character to print
    INT 21H
    
    DEC CX              ; Decrease counter (5 -> 4 -> 3...)
    JNZ PRINT_LOOP      ; Jump if Not Zero back to loop start

    ; --- PART B: Input Two Alphabets ---
    ; 1. Show Prompt
    LEA DX, MSG_INPUT
    MOV AH, 9
    INT 21H

    ; 2. Take First Input
    MOV AH, 1
    INT 21H
    MOV BL, AL          ; Save 1st letter in BL

    ; 3. Take Second Input
    MOV AH, 1
    INT 21H
    MOV CL, AL          ; Save 2nd letter in CL

    ; --- PART C: Display in Swapped Order ---
    ; 1. Show Output Message
    LEA DX, MSG_OUTPUT
    MOV AH, 9
    INT 21H

    ; 2. Print Second Letter (CL) first
    MOV AH, 2
    MOV DL, CL
    INT 21H

    ; 3. Print First Letter (BL) second
    MOV AH, 2
    MOV DL, BL
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN