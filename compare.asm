.MODEL SMALL
.STACK 100H

.DATA
    ; Define our messages
    PROMPT      DB '%'
                DB '$' ; Terminator
    MSG_SUM     DB 0AH, 0DH, 'THE SUM OF $'
    MSG_AND     DB ' AND $'
    MSG_IS      DB ' IS $'
    MSG_LOWER   DB 0AH, 0DH, 'THE SUM IS LOWER THAN 9$'
    MSG_GREATER DB 0AH, 0DH, 'THE SUM IS GREATER THAN 9$'
    
    NUM1 DB ?   ; Variable to store first number
    NUM2 DB ?   ; Variable to store second number
    TOTAL DB ?  ; Variable to store the sum

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- 1. Display Prompt "%" ---
    MOV AH, 2       ; Function 2: Print Char
    MOV DL, '%'
    INT 21H

    ; --- 2. Read First Number ---
    MOV AH, 1       ; Function 1: Read Char
    INT 21H         ; User types (e.g., '2')
    SUB AL, 30H     ; Convert ASCII to Decimal ('2' -> 2)
    MOV NUM1, AL    ; Save it

    ; --- 3. Read Second Number ---
    MOV AH, 1
    INT 21H         ; User types (e.g., '6')
    SUB AL, 30H     ; Convert ASCII to Decimal
    MOV NUM2, AL    ; Save it

    ; --- 4. Calculate Sum ---
    MOV AL, NUM1    ; Move first number to AL
    ADD AL, NUM2    ; Add second number (AL = AL + NUM2)
    MOV TOTAL, AL   ; Save the sum (e.g., 8)

    ; --- 5. Print "THE SUM OF " ---
    LEA DX, MSG_SUM
    MOV AH, 9
    INT 21H

    ; Print First Number
    MOV DL, NUM1
    ADD DL, 30H     ; Convert Decimal back to ASCII for printing
    MOV AH, 2
    INT 21H

    ; Print " AND "
    LEA DX, MSG_AND
    MOV AH, 9
    INT 21H

    ; Print Second Number
    MOV DL, NUM2
    ADD DL, 30H
    MOV AH, 2
    INT 21H

    ; Print " IS "
    LEA DX, MSG_IS
    MOV AH, 9
    INT 21H

    ; --- 6. Print The Result (The Sum) ---
    MOV AL, TOTAL   ; Get the sum back
    CMP AL, 9       ; Compare sum with 9
    JG PRINT_TWO_DIGITS ; If sum > 9 (like 12), go to special print logic

    ; Logic for Single Digit (0-9)
    ADD AL, 30H     ; Convert to ASCII
    MOV DL, AL
    MOV AH, 2
    INT 21H
    JMP CHECK_SIZE  ; Skip the 2-digit logic

PRINT_TWO_DIGITS:
    ; Logic for Sums 10-18
    SUB AL, 10      ; Subtract 10 to get the second digit (e.g., 12-10=2)
    MOV BL, AL      ; Save the second digit
    
    ; Print '1'
    MOV DL, '1'
    MOV AH, 2
    INT 21H
    
    ; Print Second Digit
    MOV DL, BL
    ADD DL, 30H
    MOV AH, 2
    INT 21H

    ; --- 7. Check Size for Final Message ---
CHECK_SIZE:
    MOV AL, TOTAL   ; Reload the original sum
    CMP AL, 9
    JG IS_GREATER   ; If Sum > 9, Jump to IS_GREATER

    ; Case: Lower or Equal
    LEA DX, MSG_LOWER
    MOV AH, 9
    INT 21H
    JMP EXIT_PROG

IS_GREATER:
    ; Case: Greater
    LEA DX, MSG_GREATER
    MOV AH, 9
    INT 21H

EXIT_PROG:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN