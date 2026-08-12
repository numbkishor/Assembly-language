.MODEL SMALL
.STACK 100H

.DATA
    Pass        DB '8'              ; the one digit password
    entered     DB '?'              ; the digit typed by the user
    attempts    DB 3                ; three chances are allowed

    ask         DB 0DH,0AH,'Enter Password: $'
    grantMsg    DB 0DH,0AH,0DH,0AH,' ACCESS GRANTED ',0DH,0AH,'$'
    wrongP   DB 0DH,0AH,'Wrong Password',0DH,0AH,'$'
    leftM     DB 'Attempts Left: $'
    deniedM   DB 0DH,0AH,0DH,0AH,' ACCESS DENIED ',0DH,0AH,'$'
    newLine     DB 0DH,0AH,'$'

.CODE

MAIN PROC

    MOV AX,@DATA
    MOV DS,AX

START:

                         ; DISPLAY *ENTER PASSWORD* MSG
    LEA DX,ask
    MOV AH,09H
    INT 21H

                        ; reading the ENTERED PASSWORD
    MOV AH,01H
    INT 21H


                    ; COMPARING ENTERED PASSWORD WITH ACTUAL PASSWORD
    CMP AL,Pass
    JE grantM  ;JUMP IF EQUAL (ENTERED PASS=PASS)

                         ; DISPLAY IF ENTERED PASS IS WRONG 
    LEA DX,wrongP
    MOV AH,09H
    INT 21H

                        ; ATTEMPTS decreasing when entered password is wrong 
    DEC attempts

                      ; access is denied when attempt
    CMP attempts,0
    JE DENIED
                                 
                ; DISPLAY ATTEMPTS LEFT
    LEA DX,leftM
    MOV AH,09H
    INT 21H

    MOV DL,attempts
    ADD DL,'0'
    MOV AH,02H
    INT 21H

    JMP START
                       ;if password matches then showing * Access Granted* message
grantM:

    LEA DX,grantMsg
    MOV AH,09H
    INT 21H

    JMP EXIT
                        ;if password matches then showing * Access Granted* message
DENIED:

    LEA DX,deniedM
    MOV AH,09H
    INT 21H
                  
                  ;it will exit the whole program

EXIT:

    MOV AH,4CH
    INT 21H

MAIN ENDP

END MAIN