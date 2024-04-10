;Temperature Measurement and Display Project

;Author
;Ahmet Ali Dal 





#start=thermometer.exe#     ;this is for starting the thermometer device

mov ax, 100h  ; Initialize data segment 
mov es, ax          
          
mov di, 1000h  ;Load 1000h into DI. This is the start address of the target data area.                    




ileri:



;turnon:
;mov al, 1       ; this code is turn on function for heater of the thermometer device
;out 127, al

;turnoff:
;mov al, 0       ; this code is turn off function for heater of the thermometer device
;out 127, al
                  
                  
                  
                  


in al, 125    ; Read temperature value from port 125

cmp al,0      ; Check if temperature is less than 0
mov bl,al
jge celci     ; If temperature is greater than or equal to 0, jump to celci
jmp celcimin  ; If temperature is less than 0, jump to celcimin

celcimin:     ; Handle negative temperatures

mov ah,255    ; Convert to positive by subtracting from 255 and adding 1
sub ah,al  
inc ah
mov al,ah

call minus    ; Print '-' sign for negative temperature
call print1c  ; Print the temperature in Celsius format
call C        ; Print 'C' for Celsius unit
call print_nl ; Print newline 
jmp next      ; Jump to next

celci:        ; Handle non-negative temperatures
call print2f  ; Print the temperature in Celsius format
call C        ; Print 'C' for Celsius unit
call print_nl ; Print newline 
jmp next      ; Jump to next

next:         ; Handle Fahrenheit conversion
mov al,bl
mov ah,al

cmp ah,0
              
JGE above     ; If temperature is greater than or equal to 0, jump to above
jmp under     ; If temperature is less than 0, jump to under

above:        ; Convert Celsius to Fahrenheit for positive temperatures
mov cl, ah
mov al, 9
mul cl
mov cl, 5
div cl
add al, 32
mov ah, al

jmp label1    ; Jump to label1


under:        ; Convert Celsius to Fahrenheit for negative temperatures
cmp ah,-18
jb under2


mov cl, ah
mov al, 9
imul cl
mov cl, 5
idiv cl
add al, 32
mov ah, al

jmp label1     ; Jump to label1

under2:
             ; Convert Celsius to Fahrenheit for negative temperatures if its below -18

mov cl, ah
mov al, 9
imul cl
mov cl, -5
idiv cl
add al, -32
mov ah, al



jmp label2       ; Jump to label2




label1:        ; Print Fahrenheit temperature and store in memory
mov [di],ah

 
call print2f   ; Print Fahrenheit temperature
call F         ; Print 'F' for Fahrenheit unit
jmp gel        ; Jump to gel

 
label2:        ; Print Fahrenheit temperature and store in memory
mov [di],ah
mov bl,ah


call minus     ; Print '-' sign for negative Fahrenheit temperature
call print1c   ; Print Fahrenheit temperature
call F         ; Print 'F' for Fahrenheit unit







gel:

call print_nl    ; Print newline character
call print_nl    ; Print newline character



 
 
 


inc di
 
 cmp ah,[100Bh]    ;Compare current data and 12. data.
 je basadon        ;If equal jump to basadon
                   
                   
 jmp delay      ; Jump to delay

start1:         ; Return to loop after delay

loop ileri



delay:          ; Delay function to receive data at certain intervals
mov cx, 20      ; We can adjust how much delay there will be by giving value to cx.
mov ah, 86h 
int 15h

jmp start1      ; Jump to start1


basadon:        ; We designed it to store 12 data here(1000h-100Bh).If the 12th data         
mov cx, 20      ; is equal to the current data,The data is returned to the first data point
mov ah, 86h     ; 1000h and written there.
int 15h         ;Delay function in here too.
mov di, 1000h  
        


jmp ileri          ; Jump to ileri



 
 
 

 
 
 
minus proc
     push ax  ;A function we created to add a "-" sign to the beginning of negative data.
  mov cx,1
    mov ah,0Eh
    mov al,'-' ;Here we used teletype output interrupt
    int 10h
   pop ax
ret 
 
 
 
 
 
 
 
 
 C proc
     push ax   ;A function we created to add a "C" sign to the end of data in celcius
  mov cx,1
    mov ah,0Ah
    mov al,'C' ;Here we used write character only at cursor position interrupt
    int 10h
   pop ax
ret 
 
 
 
 
  F proc       ;A function we created to add a "F" sign to the end of data in fahrenheit
     push ax
  mov cx,1
    mov ah,0Ah
    mov al,'F' ;Here we used write character only at cursor position interrupt
    int 10h
   pop ax
ret 
 
 

  
 

print1c proc   ; Print function for numbers whose value is minus celcius and fahrenheit 


print11:
  
 
  
  pusha 
  mov ah, 0
  cmp ax, 0       ; Divide the numbers as decimals and wrote them in digits from left to right 
  je done0        ; Push the numbers into the Stack
  mov dl, 10
  div dl
   
  call print11
   
   
  mov al, ah
  add al, 30h    ; This segment is responsible for converting a digit in the AL register to its 
  mov ah, 0Eh    ; ASCII representation and then displaying it on the screen.
  int 10h      
  jmp done0 
 
done0:
 
  popa  
  ret  
endp             ; endp shows end of the code block    
                   
 
 
 
 
 
 
 
print2f proc    
cmp al, 0
jne print44     ; Print function whose value is greater than or equal to 0 fahrenheit or celsius 
    push ax
    mov al, '0'
    mov ah, 0Eh  ; We use teletype output interrupt to print 0.  
    int 10h
    pop ax
    ret
    

 
print44:    
    pusha
    mov ah, 0
    cmp ax, 0
    je done3     ;Divide the numbers as decimals and wrote them from left to right
    mov dl, 10   ; representation and then displaying it on the screen.
    div dl    
    call print44

    mov al, ah
    add al, 30h  ; This segment is responsible for converting a digit in the AL register to its ASCII
    mov ah, 0Eh
    int 10h      ; representation and then displaying it on the screen.
    jmp done3
   
done3:

    popa  
    ret  
endp                      
 
  
  
  
  
  
  
print_nl proc 
    push ax      ; We used interrupts to move to the next line  
    push dx      ; We push the numbers into the Stack
    mov ah, 2
    mov dl, 0Dh          
    int 21h  
    mov dl, 0Ah  ; to move the cursor to the beginning of the next line on the screen
    int 21h   
    pop dx 
    pop ax      
    ret
endp                     





ret
