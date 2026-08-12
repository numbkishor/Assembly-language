.MODEL SMALL
.STACK 100H

.DATA
            ;declaring variables and values
    num1        DB  35
    num2        DB  25

    operation   DB  '?'


                            ;creating selection menu
    menu     DB  0DH, 0AH 
            DB  ' SIMPLE CALCULATOR', 0DH, 0AH 
             DB 0DH, 0AH                
             DB '  1. Addition',       0DH, 0AH
             DB '  2. Subtraction',    0DH, 0AH
             DB '  3. Multiplication', 0DH, 0AH
             DB '  4. Exit',           0DH, 0AH
             DB 0DH, 0AH
             DB 'Enter Operation : $'
                
    operationM  DB  0DH, 0AH, 'Selected Operation: $' 
               
    addM        DB  'Addition', 0DH, 0AH, '$'
    subM        DB  'Subtraction', 0DH, 0AH, '$'
    mulM        DB  'Multiplication', 0DH, 0AH, '$'
    resultM     DB  'Result: $'
    errorM      DB  0DH, 0AH, ' Invalid operation. Choose again ', 0DH, 0AH, '$'
    exitM       DB  0DH, 0AH, 'Exited', 0DH, 0AH, '$'
    newLine     DB  0DH, 0AH, '$'

.CODE

MAIN PROC

    MOV AX, @DATA
    MOV DS, AX


MENU_LOOP:
                      ;CALLING THE MENU
    LEA DX, menu
    CALL P_STRING

    MOV AH, 01H
    INT 21H                    
    
    
                    ;SWITCHING TO THE OPERATION AS USER'S INPUT
    MOV operation, AL

    CMP operation, '1'
    JE ADDS

    CMP operation, '2'
    JE SUBS

    CMP operation, '3'
    JE MULS

    CMP operation, '4'
    JE EXIT


    LEA DX, errorM
    CALL P_STRING

    JMP MENU_LOOP   
    
    

            ;IF OPERATION=1 (ADDITION), IT WILL JUMP TO THIS function
ADDS:

    LEA DX, operationM
    CALL P_STRING

    LEA DX, addM
    CALL P_STRING

    LEA DX, newLine
    CALL P_STRING


    XOR AX, AX
    XOR BX, BX

    MOV AL, num1
    MOV BL, num2

    ADD AX, BX

    LEA DX, resultM
    CALL P_STRING

    CALL PRINT_NUMBER

    LEA DX, newLine
    CALL P_STRING

    JMP MENU_LOOP

                 ;IF OPERATION=2 (SUBSTRACTION), IT WILL JUMP TO THIS function
SUBS:

    LEA DX, operationM
    CALL P_STRING

    LEA DX, subM
    CALL P_STRING

    LEA DX, newLine
    CALL P_STRING


    LEA DX, resultM
    CALL P_STRING

    MOV AL, num1
    MOV BL, num2

    CMP AL, BL
    JAE SUB_POSITIVE

    MOV DL, '-'
    MOV AH, 02H
    INT 21H

    MOV AL, num2
    MOV BL, num1

SUB_POSITIVE:

    SUB AL, BL
    XOR AH, AH

    CALL PRINT_NUMBER

    LEA DX, newLine
    CALL P_STRING

    JMP MENU_LOOP
                         ;IF OPERATION=3 (MULTIPLICATION), IT WILL JUMP TO THIS function

MULS:

    LEA DX, operationM
    CALL P_STRING

    LEA DX, mulM
    CALL P_STRING

    LEA DX, newLine
    CALL P_STRING

    MOV AL, num1
    MOV BL, num2

    MUL BL

    LEA DX, resultM
    CALL P_STRING

    CALL PRINT_NUMBER

    LEA DX, newLine
    CALL P_STRING

    JMP MENU_LOOP

                       ;IF OPERATION=4 (EXIT), IT WILL JUMP TO THIS function
EXIT:

    LEA DX, exitM
    CALL P_STRING

    MOV AH, 4CH
    INT 21H

MAIN ENDP

                 ;P_STRING PROC TO DISPLAY THE STRING 

P_STRING PROC
       PUSH AX

    MOV AH, 09H
    INT 21H   
    POP AX
    

    RET

P_STRING ENDP   


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