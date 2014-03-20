title   RiceAaron4                     (ricea4.asm)

comment ;
Assignment 4
20 March 2014
Reads an array of integer, sorts them, and prints the values in
ascedended order.
;

include Irvine32.inc
.data
blank    BYTE      " ",0ah,0
oFlow    BYTE      "Array overflow ",0ah,0
prompt   BYTE      "Input an integer value: ",0
space    BYTE      " ",0
uFlow    BYTE      "Array underflow.",0ah,0
zErr     BYTE      "No array entries found",0ah,0
arr      SDWORD    100 dup(?)
len      SDWORD    ?
lenMO    SDWORD    ?

.code
main PROC

         mov       esi,offset arr      ;Set esi to mem location of arr
         mov       ebx,0               ;Clear ebx to count elements
         mov       ecx,100             ;Set ecx to ensure arr.len < 101

input:   mov       edx,offset prompt   ;Prompt user for input
         call      writeString         
         call      readInt             ;Read input from user
         cmp       eax,0               ;Test for terminal 0
         jz        clrReg              ;Jump to sorting on terminal 0
         mov       [esi],eax           ;Add input to array
         add       esi,4               ;Move to next array address
         inc       ebx                 ;Incriment element counter
         loop      input               ;Continue receiving input

clrReg:  cmp       ebx,0               ;Test if arr is empty
         jz        err                 ;Exit if arr is empty
         mov       len,ebx             ;Store arr length in memory
         dec       ebx                 
         mov       lenMO,ebx           ;Store arr length -1
         mov       ecx,-1              ;Use ecx as outer loop counter
         mov       edx,ecx             
         inc       edx                 ;Use edx as inner loop counter

outLoop: inc       ecx                 ;Inc outer loop counter
         mov       eax,ecx             ;Track min value of arr
         mov       edx,ecx             ;Set inner loop counter
         inc       edx                 ;Inc inner loop value

inLoop:  cmp       edx,len             ;Test loop exit condition
         jge       clrLoop             ;Jump on exit condition
         mov       esi,arr[4*edx]      ;Use esi to compare val in arr
         mov       edi,arr[4*eax]      ;Use edi to compare val in arr
         .if       esi < edi           
          mov      eax,edx             ;Move min val pointer if new min
         .endIf
         inc       edx                 ;Incease inner loop counter
         cmp       edx,len             ;Test loop exit condition
         jl        inLoop

         .if       eax != ecx          ;MASM swap routine. Checks if 
          mov      ebx,arr[4*ecx]      ; value is not in correct pos
          xchg     ebx,arr[4*eax]      ; and swaps the two elements
          xchg     ebx,arr[4*ecx]      ; if needed.
         .endIf
         cmp       ecx,lenMO           ;Test loop exit condition
         jl        outLoop

clrLoop: mov       ecx,0               ;Set ecx for memory scalar
prtLoop: mov       eax,arr[4*ecx]      ;Put element in write register
         call      WriteInt
         mov       edx, offset space   ;Add space between output ints
         call      WriteString
         inc       ecx                 ;Inc memory address scalar
         cmp       ecx,len             ;Test for remaining elements
         jl        prtLoop
         invoke    exitProcess,0       ;Terminate gracefully

err:     mov       edx,offset zErr     ;Print error msg
         call      WriteString
         invoke    exitProcess,0       ;Terminate gracfully
main ENDP

END main