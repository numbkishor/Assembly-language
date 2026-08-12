.MODEL SMALL
.STACK 100H

.DATA
    ; declaring variables & their values
    math         DB 78
    phy          DB 82
    programming  DB 91
    totalSub     DB 3

    totalMarks   DW 0
    averageMarks DB 0
    grade        DB '?'

    Msg   DB ' STUDENT RESULT ', 0DH, 0AH, '$'
    totalM     DB 'Total Marks : $'
    averageM   DB 'Average     : $'
    gradeM     DB 'Grade       : $'
    newLine      DB 0DH, 0AH, '$'
   

.CODE

MAIN PROC

    MOV AX, @DATA
    MOV DS, AX

    ; Calculate total marks  
    XOR AX,AX
  
  
    MOV AL, math
      XOR BX,BX
   
    MOV BL, phy  
    
    ADD AX, BX
                  
                  
                   
    MOV BL, programming
    ADD AX, BX

    MOV totalMarks, AX


    ; Calculate average
    MOV AX, totalMarks

   XOR BX, BX
    MOV BL, totalSub

    DIV  BL

    MOV averageMarks, AL


            ; Determine grade according to the grading system
            
    MOV AL, averageMarks

    CMP AL, 80
    JAE A

    CMP AL, 70
    JAE B

    CMP AL, 60
    JAE C

    MOV grade, 'F'
    JMP OUTPUT


A:
    MOV grade, 'A'
    JMP OUTPUT

B:
    MOV grade, 'B'
    JMP OUTPUT

C:
    MOV grade, 'C'


OUTPUT:

    LEA DX, Msg      ;display * Student Result*
    CALL PRINT_STRING
       
  LEA DX, newLine
    CALL PRINT_STRING
   

    LEA DX, totalM       ;display totalmarks
    CALL PRINT_STRING

    MOV AX, totalMarks
    CALL PRINT_NUMBER
    LEA DX, newLine
    CALL PRINT_STRING


    LEA DX, averageM          ;display averageMarks
    CALL PRINT_STRING

    XOR AX, AX
    MOV AL, averageMarks
    CALL PRINT_NUMBER

    LEA DX, newLine
    CALL PRINT_STRING


                         ;DISPLAY Grade
    LEA DX, gradeM
    CALL PRINT_STRING

    MOV DL, grade
    MOV AH, 02H
    INT 21H

    LEA DX, newLine
    CALL PRINT_STRING



    MOV AH, 4CH
    INT 21H

MAIN ENDP



PRINT_STRING PROC

    MOV AH, 09H
    INT 21H

    RET

PRINT_STRING ENDP

                  
PRINT_NUMBER PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX, CX
    MOV BX, 10

                  ;EXTRACTING THE DIGITS ONE BY ONE 
EXTRACT_DIGIT:

    XOR DX, DX
    DIV BX
                  ;AX = quotient 
                  ;DX = remainder
    PUSH DX
    INC CX

    CMP AX, 0         ;CONTINUE THE LOOP UNTIL AX=0
    JNE EXTRACT_DIGIT

                   ;PRINTING THE DIGITS REVERSELY FROM THE STACK
PRINT_DIGIT:

    POP DX
    ADD DL, '0'     ;CONVERTING INTO ASCII 

    MOV AH, 02H
    INT 21H

    LOOP PRINT_DIGIT


    POP DX
    POP CX
    POP BX
    POP AX

    RET

PRINT_NUMBER ENDP

END MAIN