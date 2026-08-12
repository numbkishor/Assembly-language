.MODEL SMALL
.STACK 100H

.DATA

    price       DW  40, 30, 60      ; pricing of the product
    quantity    DW  0, 0, 0         ; quantity of the product
    total       DW  0               ; total bill

    menu        DB 0DH,0AH,0DH,0AH,'SHOP MENU',0DH,0AH    ; display the menu
                DB '1. Apple',0DH,0AH
                DB '2. Orange',0DH,0AH
                DB '3. Mango',0DH,0AH
                DB '4. Checkout',0DH,0AH
                DB '5. Exit',0DH,0AH
                DB 'Choice: $'

    error       DB 0DH,0AH,'Invalid choice$'

    appleqty    DB 0DH,0AH,'Apple Quantity: $'
    orangeQty   DB 0DH,0AH,'Orange Quantity: $'
    mangoQty    DB 0DH,0AH,'Mango Quantity: $'
    totalBill   DB 0DH,0AH,'Total Bill: $'

    newLine     DB 0DH,0AH,'$'


.CODE

MAIN PROC

    MOV AX,@DATA
    MOV DS,AX


MENU_call:

                    ; DISPLAY *SHOP MENU* TXT
    LEA DX,menu
    CALL P_STRING

    MOV AH,1
    INT 21H                           ; AL = user's input


                ;SWITCHING TO THE FUNCTION ACCORDING TO THE USER'S INPUT

    CMP AL,'1'
    JE APPLE

    CMP AL,'2'
    JE ORANGE

    CMP AL,'3'
    JE MANGO

    CMP AL,'4'
    JE CHECKOUT

    CMP AL,'5'
    JE EXITP

    JMP INVALID

                       ; SWITCHING TO THE PRODUCT 1:APPLE
APPLE:

    INC quantity                      ; increase Apple quantity by 1

    LEA DX,appleqty                   ; display Apple quantity message
    CALL P_STRING

    MOV AX,quantity                   ; AX = Apple quantity
    CALL P_NUMBER                         ; display Apple quantity

    JMP MENU_call

                               ; SWITCHING TO THE PRODUCT 2:ORANGE
ORANGE:

    INC quantity+2                    ; increase Orange quantity by 1

    LEA DX,orangeQty                  ; display Orange quantity message
    CALL P_STRING

    MOV AX,quantity+2                 ; AX = Orange quantity
    CALL P_NUMBER                         ; display Orange quantity

    JMP MENU_call


MANGO:

    INC quantity+4                    ; increase Mango quantity by 1

    LEA DX,mangoQty                   ; display Mango quantity message
    CALL P_STRING

    MOV AX,quantity+4                 ; AX = Mango quantity
    CALL P_NUMBER                         ; display Mango quantity

    JMP MENU_call

                      ;IF USER'S INPUT IS INVALID
INVALID:

    LEA DX,error
    CALL P_STRING

    JMP MENU_call

                     ;WHEN CHECKOUT(AL=4), IT WILL JUMP TO HERE
CHECKOUT:

    MOV total,0          ;INITIALIZING THE TOTAL=0

                      
                      ;display APPLE quantity
    LEA DX,appleqty
    CALL P_STRING

    MOV AX,quantity
    CALL P_NUMBER

    LEA DX,newLine
    CALL P_STRING


    MOV AX,price    ;calculating total price of apple(quantity*price)
    MOV BX,quantity
    MUL BX

    ADD total,AX


    LEA DX,orangeQty                ;display orange quantity
    CALL P_STRING

    MOV AX,quantity+2
    CALL P_NUMBER

    LEA DX,newLine
    CALL P_STRING


    MOV AX,price+2       ;calculating total price of orange(quantity*price)
    MOV BX,quantity+2
    MUL BX

    ADD total,AX


    LEA DX,mangoQty              ;display Mango quantity
    CALL P_STRING

    MOV AX,quantity+4
    CALL P_NUMBER

    LEA DX,newLine
    CALL P_STRING


    MOV AX,price+4      ;calculating total price of mango(quantity*price)
    MOV BX,quantity+4
    MUL BX

    ADD total,AX


    LEA DX,totalBill
    CALL P_STRING              ;display TOTAL BILL

    MOV AX,total
    CALL P_NUMBER

    LEA DX,newLine
    CALL P_STRING

    JMP MENU_call


EXITP:

    MOV AH,4CH
    INT 21H

MAIN ENDP


            ;PRINTING STRING

P_STRING PROC

    MOV AH,9
    INT 21H

    RET

P_STRING ENDP


                ;PRINTING THE NUMBER 

P_NUMBER PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX,CX
    MOV BX,10

    CMP AX,0
    JNE CONVERT

    MOV DL,'0'
    MOV AH,2
    INT 21H

    JMP PDONE


CONVERT:

    XOR DX,DX
    DIV BX

    PUSH DX
    INC CX

    CMP AX,0
    JNE CONVERT


PRT:

    POP DX

    ADD DL,'0'

    MOV AH,2
    INT 21H

    LOOP PRT


PDONE:

    POP DX
    POP CX
    POP BX
    POP AX

    RET

P_NUMBER ENDP

END MAIN