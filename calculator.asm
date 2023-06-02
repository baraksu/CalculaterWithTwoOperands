.MODEL small
.STACK 100h

.DATA


                            
msg0 db ,13,10,'                    _            _       _         '             
    db ,13,10,'                   | |          | |     | |            '
    db ,13,10,'           ___ __ _| | ___ _   _| | __ _| |_ ___  _ __   '
    db ,13,10,'          / __/ _` | |/ __| | | | |/ _` | __/ _ \|  __|  '
    db ,13,10,'         | (_| (_| | | (__| |_| | | (_| | || (_) | |     '
    db ,13,10,'          \___\__,_|_|\___|\__,_|_|\__,_|\__\___/|_|    ',0dh,0ah,0dh,0ah,0dh,0ah,'Addition (+)',0dh,0ah,'Subtraction (-)',0dh,0ah,'Multiplication (*)',0dh,0ah,'Division (-)',0dh,0ah, '$'
                            

msg1    db 13,10,'Enter a number: $'
msg2    db 13,10,'Enter an operation: $'
msg4    db 13,10,'The calculation is: $'
msg5    db 13,10,'Hit any key to exit or do (1) to clear: $'
warn    db 13,10,'You must provide valid input! $'
firstNum    db 0
secondNum    db 0
operator    db 0

.CODE


    
jmp start

    ;the Itro function, show the intro

    proc Intro
        
        lea DX,msg0     ;show intro           
        mov AH,09h
        int 21h
        
        ret ;return to the start
        
    endp Intro
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     
    ;GetNumber function, get number from the user, use twise
        
    proc GetNumber      
            
        lea DX,msg1     ;show msgl
        mov AH,09h
        int 21h
             
        mov AH,01h      ;read a character
        int 21h
        sub al,30h
        cmp al,0
        jl Illegal
        cmp al,9
        jg Illegal             
             
        ret ;return to the start
    endp GetNumber
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
     
    ;GetOperator function, get the operator from the player (+,)
        
    proc GetOperator
        
        lea dx,msg2     ;show msg2
        mov ah,09h
        int 21h
        
        mov AH,01h      ;read a operator
        int 21h
        mov operator,AL
        
        ret ;return to the start   
    endp GetOperator
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
     
    proc PreformCalc
        
        mov ax,0
        cmp operator,2bh
        je plus
        
        cmp operator,2dh
        je minus
        
        cmp operator,2ah
        je mult
        
        cmp operator,2fh
        je divi
         
Illegal:
         
        lea dx,warn     ;Illegal input
        mov ah,09h
        int 21h
        
        jmp start
                               
        plus:
                mov al, [firstNum]
                add al, [secondNum]
                cmp al,10
                ja ascii
                add al,30h
                mov bx,ax
                jmp enda
                
        minus:
                mov al, [firstNum]
                sub al, [secondNum]                                
                add al,30h
                mov bx,ax
                cmp al,0ffh
                jge Illegal
                jmp enda
                                
        mult:
                mov al,[firstNum]
                mul [secondNum]
                jmp ascii
                        
        divi:
                mov al,[firstNum]
                mov bl,[secondNum]
                cmp bl,0
                je Illegal
                div bl
                add al,30h
                add ah,30h
                mov bx,ax
                jmp enda
        
        
        
        ascii:        
                               
                mov ah,0
                mov bl,10
                div bl
                add al,30h
                add ah,30h
                mov bx,ax                        
                                       
       enda:                                            
        ret ;return to the start       
    endp PreformCalc
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
     
    proc Print
        
        push bx
        
        lea DX,msg4     ;show msg4
        mov AH,09h
        int 21h
        
        mov dl,[firstNum]
        add dl,30h
        mov AH,02h
        int 21h 
        
        mov dl,[operator]
        mov AH,02h
        int 21h
        
        mov dl,[ secondNum]
        add dl,30h
        mov AH,02h
        int 21h
        
        mov dl,3dh
        mov AH,02h
        int 21h 
        
        pop bx
        
        cmp operator,2fh
        je diviPrint
        
        lea Dl,bl
        mov AH,02h
        int 21h
                                                                
        lea Dl,bh
        mov AH,02h
        int 21h
        jmp continue
        
diviPrint:
              
        lea Dl,bl
        mov AH,02h
        int 21h
        
        mov Dl,20h
        mov AH,02h
        int 21h
                                                                
        lea Dl,bh
        mov AH,02h
        int 21h
        
        mov dl,2fh
        mov AH,02h
        int 21h 
        
        mov dl,[secondNum]
        add dl,30h
        mov AH,02h
        int 21h
        
continue:                
        ret ;return to the start
    endp Print
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
     
    proc End      
            
        lea DX,msg5     ;show msgl
        mov AH,09h
        int 21h
             
        mov AH,01h      ;read a character
        int 21h
        
        cmp al,31h
        je start
        cmp al,31h
        jne exit             
             
        ret ;return to the start
    endp End



        
start:
        mov ax,@data
        mov ds,ax
        
        call Intro
        
        call GetNumber
        mov firstNum,AL        
        
        call GetOperator        
        
        call GetNumber
        mov secondNum,AL
        
        call PreformCalc

        call Print
        
        call End
        
                       
exit:   mov AH,4Ch     ;End program
        int 21h

END                   
