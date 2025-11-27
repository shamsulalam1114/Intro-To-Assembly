.MODEL SMALL
.STACK 100H

.DATA
    PH DB 1
    XH DB 33H               ; ASCII for '3'
    ZH DB 35H               ; ASCII for '5'
    HMSG DB " Strees $"
    BMSG DB "No Strees$"
    NEWLINE DB 10,13,'$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV CH, PH              ; Initialize Loop Counter (CH)
    MOV CL, 8D              ; Set Loop Limit to 8

P0:
    MOV BH, PH              ; Load current number into BH
    CMP CH, CL              ; Compare Counter vs Limit
    JL P1                   ; If Less, go to P1 (Print Number)
    JE P2                   ; If Equal, go to P2
    JG exit                 ; If Greater, Exit

P1:
    ADD BH, 30H             ; Convert number to ASCII (1 -> '1')
    MOV AH, 2
    MOV DL, BH              ; Print the number
    INT 21H
    
    INC CH                  ; Increase loop counter
    ADD PH, 2               ; Increase number by 2 (1->3->5...)
    JMP P2                  ; Go to check logic

P2:
    CMP BH, XH              ; Check if printed number matches XH ('3')
    JE PRINT                ; If match, print " Strees "
    
    MOV AH, 9
    LEA DX, NEWLINE         ; Else, print new line
    INT 21H
    
    INC CH                  ; Increase loop counter
    JMP P0                  ; Jump back to start

PRINT:
    MOV AH, 9
    LEA DX, HMSG            ; Print " Strees "
    INT 21H
    
    MOV BH, 30H             ; Reset BH (Not strictly necessary but in image)
    MOV AL, ZH              ; Load '5' into AL
    MOV XH, AL              ; Update XH to '5' (So next match is at 5)
    JMP P2                  ; Jump back to P2

exit:
    MOV AH, 9
    LEA DX, BMSG            ; Print "No Strees"
    INT 21H
    
    MOV AH, 2
    MOV DL, CH              ; Print CH (Raw value 9 = Tab)
    INT 21H
    
    MOV AH, 4CH             ; Exit
    INT 21H

MAIN ENDP
END MAIN