.MODEL SMALL
.STACK 100H

.DATA
    ; We don't strictly need variables for this simple task, 
    ; but we define the Data Segment to keep the standard structure.

.CODE
MAIN PROC
    ; 1. Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX

    ; 2. Display the Question Mark '?'
    MOV AH, 2       ; Function 2: Output Single Character
    MOV DL, '?'     ; Load '?' into DL to print it
    INT 21H

    ; 3. Read a Character from Keyboard
    MOV AH, 1       ; Function 1: Input Single Character
    INT 21H         ; Waits for input. Character is stored in AL
    MOV BL, AL      ; Save the input char into BL so we don't lose it

    ; 4. Move Cursor to the Beginning of the Next Line
    ; We need to print two things: Carriage Return (0Dh) and Line Feed (0Ah)
    
    MOV AH, 2       ; Set output function
    MOV DL, 0Dh     ; ASCII for Carriage Return (Move to start of line)
    INT 21H

    MOV DL, 0Ah     ; ASCII for Line Feed (Move down one line)
    INT 21H

    ; 5. Display the Saved Character
    MOV DL, BL      ; Move our saved character from BL to DL
    INT 21H         ; AH is still 2, so this prints the character

    ; 6. Exit to DOS
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN