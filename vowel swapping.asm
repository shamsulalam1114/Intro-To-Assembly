.MODEL SMALL
.STACK 100H

.DATA
    PROMPT      DB 'ENTER THREE INITIALS: $'
    ERR_MSG     DB 0AH, 0DH, 'ERROR: INVALID INPUT.$'
    ERR_INFO    DB 0AH, 0DH, 'ONLY UPPERCASE LETTERS (A-Z) ARE ALLOWED.$'
    TRY_AGAIN   DB 0AH, 0DH, 'TRY AGAIN!!', 0AH, 0DH, '$'
    
    NEWLINE     DB 0AH, 0DH, '$'
    PREFIX_1    DB 0AH, 0DH, '1. $'
    PREFIX_2    DB 0AH, 0DH, '2. $'
    PREFIX_3    DB 0AH, 0DH, '3. $'

    CHAR1 DB ?
    CHAR2 DB ?
    CHAR3 DB ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

START_INPUT:
    ; --- 1. Prompt ---
    LEA DX, PROMPT
    MOV AH, 9
    INT 21H

    ; --- 2. Read & Validate Char 1 ---
    MOV AH, 1
    INT 21H
    call VALIDATE_CHAR ; Call a helper logic to check A-Z
    MOV CHAR1, AL      ; Save if valid

    ; --- 3. Read & Validate Char 2 ---
    MOV AH, 1
    INT 21H
    call VALIDATE_CHAR
    MOV CHAR2, AL

    ; --- 4. Read & Validate Char 3 ---
    MOV AH, 1
    INT 21H
    call VALIDATE_CHAR
    MOV CHAR3, AL

    ; --- 5. Sorting Logic (Descending: Z -> A) ---
    ; We will load them into AL, BL, CL and swap registers
    MOV AL, CHAR1
    MOV BL, CHAR2
    MOV CL, CHAR3

    ; Compare AL and BL
    CMP AL, BL
    JGE CHECK_AC    ; If AL >= BL, move to next check
    XCHG AL, BL     ; Else, Swap AL and BL (Now AL is bigger)

CHECK_AC:
    ; Compare AL and CL
    CMP AL, CL
    JGE CHECK_BC    ; If AL >= CL, move to next check
    XCHG AL, CL     ; Else, Swap AL and CL (Now AL is definitely the biggest)

CHECK_BC:
    ; Compare BL and CL
    CMP BL, CL
    JGE PRINT_RES   ; If BL >= CL, we are sorted!
    XCHG BL, CL     ; Else, Swap BL and CL

    ; --- 6. Display Results ---
PRINT_RES:
    ; At this point: AL = 1st, BL = 2nd, CL = 3rd
    MOV CHAR1, AL   ; Save sorted values back to variables
    MOV CHAR2, BL
    MOV CHAR3, CL

    ; Print "1. [Biggest]"
    LEA DX, PREFIX_1
    MOV AH, 9
    INT 21H
    MOV DL, CHAR1
    MOV AH, 2
    INT 21H

    ; Print "2. [Middle]"
    LEA DX, PREFIX_2
    MOV AH, 9
    INT 21H
    MOV DL, CHAR2
    MOV AH, 2
    INT 21H

    ; Print "3. [Smallest]"
    LEA DX, PREFIX_3
    MOV AH, 9
    INT 21H
    MOV DL, CHAR3
    MOV AH, 2
    INT 21H

    ; Exit Program
    MOV AH, 4CH
    INT 21H

; --- Helper Procedure: Validation ---
VALIDATE_CHAR PROC
    ; Checks if AL is between 'A' and 'Z'
    CMP AL, 'A'
    JL SHOW_ERROR   ; If Less than 'A', it's invalid
    CMP AL, 'Z'
    JG SHOW_ERROR   ; If Greater than 'Z', it's invalid
    RET             ; Return if valid

SHOW_ERROR:
    ; Print Error Messages
    LEA DX, ERR_MSG
    MOV AH, 9
    INT 21H
    LEA DX, ERR_INFO
    MOV AH, 9
    INT 21H
    LEA DX, TRY_AGAIN
    MOV AH, 9
    INT 21H
    
    ; Clear Stack/Reset (Simple jump to start)
    JMP START_INPUT
VALIDATE_CHAR ENDP

MAIN ENDP
END MAIN