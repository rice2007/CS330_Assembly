TITLE RiceAAssignment1			    (RiceAAssignment1.asm)

INCLUDE Irvine32.inc
.data
blank    BYTE " ",0ah,0
promptA  BYTE "Input a number for A: ",0dh,0ah,0
promptB  BYTE "Input a number for B: ",0dh,0ah,0 
zeroErr  BYTE "Cannot divide by 0!",0ah,0
intA     SDWORD ?
intB     SDWORD ?

.code
main PROC

oErrA:   mov       edx,OFFSET promptA  ;Prompt user for input
	    call      WriteString         ;Prompt user for input
	    call      ReadInt             ;Accept input from user
	    jo        oErrA               ;Jump back to prompt on OF
	    mov       intA,eax            ;Store input as intA
         mov       ebx,intA            ;Prep ebx to become divisor

oErrB:   mov       edx,OFFSET promptB  ;Prompt user for input
         call      WriteString         ;Prompt user for input
         call      ReadInt             ;Accept input from user
	    jo        oErrB               ;Jump back to prompt on OF
         mov       intB,eax            ;Store input as intB
         add       eax,intA            ;Compute numerator (A+B)
         sub       ebx,intB            ;Compute denominator (A-B)
         jz        err                 ;Jump on zero denominator

	    cdq                           ;Extend sign bit for div 
         idiv      ebx                 ;Compute quotient (A+B)/(A-B)
         mov       ebx,eax             ;Move quotient to ebx
         mov       ecx,edx             ;Move remainder to ecx
         mov       eax,intA            ;Prepare eax for mul
         imul      intB                ;Compute product (A*B)

         sub       eax,ebx             ;Compute final result
	    call      WriteInt            ;Print result to console
	    mov       edx,OFFSET blank    ;Insert carriage return
	    call      WriteString         ;Insert carriage return
	    invoke    ExitProcess,0       ;Terminate gracefully
	     
err:     mov       edx,OFFSET zeroErr  ;Print error
	    call      WriteString         ;Print error
         invoke    ExitProcess,0       ;Terminate gracefully

	exit
main ENDP

END main