.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB "ENTER A LOWER-CASE LETTER: $"
    MSG2 DB 0AH, 0DH, "IN UPPERCASE IT IS: $" 
    ; 0AH, 0DH adds a new line before the second message

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- 1. Prompt User ---
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

    ; --- 2. Take Input ---
    MOV AH, 1
    INT 21H          ; Input goes into AL (e.g., 'a')
    MOV BL, AL       ; Save it to BL so we don't lose it

    ; --- 3. The Conversion Logic ---
    SUB BL, 20H      ; Subtract 20H (32 decimal) to convert case
                     ; 'a' (61h) - 20h = 'A' (41h)

    ; --- 4. Print Result Message ---
    LEA DX, MSG2
    MOV AH, 9
    INT 21H

    ; --- 5. Print the Converted Character ---
    MOV DL, BL       ; Move the calculated uppercase letter to DL
    MOV AH, 2        ; Function 2: Print Single Character
    INT 21H

    ; --- Exit ---
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN