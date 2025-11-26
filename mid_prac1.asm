.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH              ; CR = Carriage Return (Move cursor to start of line)
    LF EQU 0AH              ; LF = Line Feed (Move cursor down)
    
    MSG1 DB 'SAMPLE MESSAGE$'
    MSG2 DB 'STOP$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV CX, 5               ; Initialize Counter to 5

PRINT_:
    ; --- Print "SAMPLE MESSAGE" ---
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

    ; --- Print New Line (CR + LF) ---
    MOV AH, 2
    MOV DL, CR              ; Print Carriage Return
    INT 21H
    MOV DL, LF              ; Print Line Feed
    INT 21H

    ; --- Loop Logic ---
    DEC CX                  ; Decrease counter (5 -> 4 -> 3...)
    JNZ PRINT_              ; Jump back if CX is Not Zero

    ; --- Print Extra New Line ---
    MOV AH, 2
    MOV DL, 0DH             ; Manually print CR
    INT 21H
    MOV DL, 10              ; Manually print LF (10 is decimal for 0AH)
    INT 21H

    ; --- Print "STOP" ---
    LEA DX, MSG2
    MOV AH, 9
    INT 21H

    ; --- Exit Program ---
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN