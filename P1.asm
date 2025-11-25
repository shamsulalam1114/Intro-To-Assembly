.MODEL SMALL
.STACK 100H

.DATA
    A DB 0AH,0DH,"ENTER NUM1:$"
    B DB 0AH,0DH,"ENTER NUM2:$"
    C DB 0AH,0DH,"YOU ENTERED:$"
   
.CODE
MAIN PROC
   
    MOV AX,@DATA
    MOV DS,AX
   
    ; --- Prompt 1 ---
    LEA DX,A
    MOV AH,9
    INT 21H
   
    ; --- Input 1 ---
    MOV AH,1
    INT 21H
    MOV BL, AL    ; <--- FIX 1: Save input (AL) into Safe Spot (BL)
   
    ; --- Prompt 2 ---
    LEA DX,B
    MOV AH,9
    INT 21H
   
    ; --- Input 2 ---
    MOV AH,1
    INT 21H
    MOV CL, AL    ; <--- FIX 2: Save input (AL) into Safe Spot (CL)
   
    ; --- Result Text ---
    LEA DX,C
    MOV AH,9
    INT 21H
   
    ; --- Print First Number ---
    MOV DL,BL     ; Retrieve data from Safe Spot (BL)
    MOV AH,2      ; <--- FIX 3: Use Function 2 (Character Output)
    INT 21H
   
    ; --- Print Space ---
    MOV DL,20H
    MOV AH,2
    INT 21H
   
    ; --- Print Second Number ---
    MOV DL,CL     ; Retrieve data from Safe Spot (CL)
    MOV AH,2      ; <--- FIX 3: Use Function 2 (Character Output)
    INT 21H
   
    ; --- Exit ---
    MOV AH,4CH
    INT 21H

MAIN ENDP
END MAIN