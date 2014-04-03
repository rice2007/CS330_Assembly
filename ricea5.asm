title   RiceAaron5                     (ricea5.asm)

comment ;
Assignment 5
3 April 2014
Applies the quadratic equation to three input values provided by user.
;

include Irvine32.inc
.data
blank    BYTE      " ",0ah,0
aPrompt  BYTE      "Input a floating point value for a: ",0
bPrompt  BYTE      "Input a floating point value for b: ",0
cPrompt  BYTE      "Input a floating point value for c: ",0
pPrompt  BYTE      "x1 = ",0
nPrompt  BYTE      "x2 = ",0
fErr     BYTE      "Input exception. Program will terminate.",0ah,0
two      REAL4     2.0
four     REAL4     4.0
aVal     REAL4     ?
bVal     REAL4     ?
cVal     REAL4     ?
sVal     REAL4     ?

.code
main PROC

aInput:  lea       edx,aPrompt         ;Prompt user for a val
         call      writeString 
         call      readFloat           ;Read input from user
         fldz                          ;Load 0.0 to check div/0 error
         fcomp                         ;Compare top elements for div/0
         fnstsw    ax                  ;Store flag bits in ax
         sahf                          ;Copy FPU flags to CPU flags
         je        err                 ;Jump on div/0 error
         fstp      aVal                ;Store and pop A
bInput:  lea       edx,bPrompt         ;Prompt user for b val
         call      writeString         
         call      readFloat           ;Read input from user
         fst       bVal                ;Store B
cInput:  lea       edx,cPrompt         ;Prompt user for a val
         call      writeString         
         call      readFloat           ;Read input from user
         fstp      cVal                ;Store and pop C

root:    fmul      bVal                ;Calculate b^2
         fld       four
         fmul      aVal
         fmul      cVal                ;Calculate  4*a*c
         fsub                          ;Calc b^2 - 4*a*c
         fsqrt                         ;Calc sqrt of expression
         fst       sVal                ;Store the sqrt
         mov       ecx,2               ;Use ecx as loop counter

pmb:     fld       bVal                ;Load b on stack for final comp
         fchs                          ;Negate b
         .if       ecx > 1             ;Test if b + or - sqrt
          fsub                         ;Calc b - sqrt(b^2-4ac)
          fld      aVal                ;Prep stack for division
          fmul     two                 ;Calc 2a
          fdiv                         ;Calc final answer
          fld      sVal                ;Store final answer
         .else
          fadd                         ;Calc b + sqrt(b^2-4ac)
          fld      aVal                ;Prep stack for division
          fmul     two                 ;Calc 2a
          fdiv                         ;Calc final answer
         .endIf
         loop      pmb                 ;Loop to solve for x2

         comment ;
The final block of code displays the two calculated x values. The first
x value must be popped and saved before the second x value can be 
displayed.
                 ;
         lea       edx,pPrompt
         call      writeString
         call      writeFloat
         fstp      sVal
         lea       edx,blank
         call      writeString
         lea       edx,nPrompt
         call      writeString
         call      writeFloat
         lea       edx,blank
         call      writeString

         invoke    exitProcess,0       ;Terminate gracefully

err:     mov       edx,offset fErr     ;Print error msg
         call      WriteString
         invoke    exitProcess,0       ;Terminate gracfully
main ENDP

END main