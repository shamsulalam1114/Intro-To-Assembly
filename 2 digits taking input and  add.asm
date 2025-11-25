.MODEL SMALL
.STACK 100H

.DATA
    MSG_WELCOME DB 0AH,0DH, "HELLO WORLD!$"
    MSG_INPUT1  DB 0AH,0DH, "ENTER FIRST NUMBER (2 Digits): $"
    MSG_INPUT2  DB 0AH,0DH, "ENTER SECOND NUMBER (2 Digits): $"
    MSG_OUTPUT  DB 0AH,0DH, "RESULT: $"

    NUM1 DB 0, 0   ; Storage for first number (e.g., '1', '2')
    NUM2 DB 0, 0   ; Storage for second number (e.g., '1', '5')
    
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- 1. WELCOME ---
    MOV AH, 9
    LEA DX, MSG_WELCOME
    INT 21H

    ; --- 2. INPUT FIRST NUMBER ---
    LEA DX, MSG_INPUT1
    MOV AH, 9
    INT 21H

    ; Read Tens Digit
    MOV AH, 1
    INT 21H
    SUB AL, 30H        ; Convert ASCII to Real Number immediately
    MOV NUM1, AL

    ; Read Ones Digit
    MOV AH, 1
    INT 21H
    SUB AL, 30H        ; Convert ASCII to Real Number immediately
    MOV NUM1+1, AL

    ; Eat the Enter Key (Optional but good practice)
    MOV AH, 1
    INT 21H
    
    ; --- 3. INPUT SECOND NUMBER ---
    LEA DX, MSG_INPUT2
    MOV AH, 9
    INT 21H

    ; Read Tens Digit
    MOV AH, 1
    INT 21H
    SUB AL, 30H        ; Convert ASCII to Number
    MOV NUM2, AL

    ; Read Ones Digit
    MOV AH, 1
    INT 21H
    SUB AL, 30H        ; Convert ASCII to Number
    MOV NUM2+1, AL
    
    ; Eat the Enter Key
    MOV AH, 1
    INT 21H

    ; =================================================
    ;      THE MATH SECTION (Making Real Numbers)
    ; =================================================

    ; --- Step A: Make the First Number (Store in BL) ---
    MOV AL, NUM1       ; Load the Tens digit (e.g., 1)
    MOV CL, 10
    MUL CL             ; Multiply AL by 10. (AL becomes 10)
    ADD AL, NUM1+1     ; Add the Ones digit (e.g., 2). (AL becomes 12)
    MOV BL, AL         ; Save the full number (12) into BL

    ; --- Step B: Make the Second Number (Store in CL) ---
    MOV AL, NUM2       ; Load the Tens digit
    MOV DL, 10
    MUL DL             ; Multiply by 10
    ADD AL, NUM2+1     ; Add the Ones digit
    MOV CL, AL         ; Save the full number into CL

    ; --- Step C: ADD THEM ---
    ADD BL, CL         ; BL = BL + CL. Result is in BL.

    ; =================================================
    ;      OUTPUT SECTION (Splitting the Result)
    ; =================================================

    ; Print "RESULT: "
    LEA DX, MSG_OUTPUT
    MOV AH, 9
    INT 21H

    ; --- Step D: Separate Tens and Ones ---
    MOV AL, BL         ; Move the result (e.g., 27) into AL for division
    MOV AH, 0          ; Clear AH so it doesn't mess up the division
    MOV CL, 10
    DIV CL             ; Divide AL by 10. 
                       ; AL = Quotient (Tens place), AH = Remainder (Ones place)
    
    MOV BX, AX         ; Save results. BH now has Remainder, BL has Quotient

    ; --- Print Tens Digit ---
    MOV DL, BL         ; Get the Tens digit
    ADD DL, 30H        ; Convert back to ASCII
    MOV AH, 2
    INT 21H

    ; --- Print Ones Digit ---
    MOV DL, BH         ; Get the Remainder (Ones digit)
    ADD DL, 30H        ; Convert back to ASCII
    MOV AH, 2
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN