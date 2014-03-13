TITLE   RiceA2                     (ricea2.asm)

COMMENT !
Assignment 2
6 March 2014
Prompts a user for numbers to average. Uses 0 as the exit condition to
stop prompting user and calculate the average of all input values.
!

INCLUDE Irvine32.inc
.data
blank    BYTE      " ",0ah,0
prompt   BYTE      "Input a value to average: ",0
zeroErr  BYTE      "Cannot divide by 0!",0ah,0

.code
main PROC

         mov       ebx,0               ;Clear ebx for num
         mov       ecx,0               ;Clear ecx for denom

inLoop:  mov       edx,offset prompt   ;Prompt user for input
         call      writeString
         call      readInt             ;Read input from user
         jo        inLoop              ;Jump to prompt on OF without
                                       ;increasing num or denom
         cmp       eax,0               ;Check for exit condition
         jz        average             ;Jump on exit condition on ZF
        
         add       ebx,eax             ;Add input to num
         inc       ecx                 ;Increment denom
         call      dumpRegs
         jnz       inLoop              ;Jump to prompt for input

average: cmp       ecx,0               ;Check for div by 0
         jz        zErr                ;Jump to div by 0 error on ZF
         
         mov       eax,ebx             ;Move num to eax for idiv
         cdq                           ;Extend sign bit for idiv
         idiv      ecx                 ;Compute quotient
         call      dumpRegs
         call      writeInt            ;Print result to console
         mov       edx,offset blank
         call      WriteString         ;Insert carriage return

         invoke    exitprocess,0       ;Terminate gracefully

zErr:    mov       edx, offset zeroErr 
         call      WriteString         ;Print error message
         invoke    ExitProcess,0       ;Terminate gracefully
 
main ENDP

END main