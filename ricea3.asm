title   RiceAaron3                     (ricea3.asm)

comment ;
Assignment 3
13 March 2014
Accepts a hex input and return the LSB, MSB, and total number of 
set bits.
;

include Irvine32.inc
.data
blank    BYTE      " ",0ah,0
lsbMsg   BYTE      "LSB in postition ",0
msbMsg   BYTE      "MSB in postition ",0
prompt   BYTE      "Input a hex value: ",0
ttlMsg   BYTE      "Total set bits: ",0
zeroMsg  BYTE      "No bits set",0ah,0
bitmask  SDWORD    1h
LSB      SDWORD    20h
MSB      SDWORD    20h

.code
main PROC

         mov       edx,offset prompt   
         call      writeString         ;Prompt user for input
         call      readHex             ;Read input from user
         mov       ecx,32              ;Clear ecx for iteration ctr
         mov       edx,0               ;Clear edx for bit ctr

         cmp       eax,0
         jz        zroBit
lsbCt:   test      eax,bitmask         ;Test status of right-most bit
         .if       !zero?              ;If right-most bit is set...
          inc      edx                 ;Increase total bits ctr
          sub      LSB,ecx             ;Store least-sig bit in LSB
          mov      ebx,ecx             ;Track last instance of set bit
          dec      ecx                 ;Dec iterator (no dec from loop)
          jmp      msbCt               ;Jump when LSB is found
         .endIf
         shr       eax,1               ;Shift to test next bit
         loop      lsbCt               ;Loop until all bits are tested

msbCt:   shr       eax,1               ;Shift to test next bit
         test      eax,bitmask         ;Tests status of right-most bit
         .if       !zero?              ;If right-most bit is set...
          inc      edx                 ;Increase total bits ctr
          mov      ebx,ecx             ;Track last instance of set bit
         .endIf       
         loop      msbCt               ;Loop until all bits are tested

         sub       MSB,ebx             ;Store most-sig bit in MSB
         mov       ebx,edx             ;Move total bit couont to ebx

         comment ;
Prints results to console in the order of least significant bit
position, most significant bit position, and total set bits. Strings
can only be passed to edx for output, and numerical values can only be
passed to eax for output.
;
         mov       edx,offset lsbMsg
         call      WriteString
         mov       eax,LSB
         call      WriteInt
         mov       edx,offset blank
         call      WriteString

         mov       edx,offset msbMsg
         call      WriteString
         mov       eax,MSB
         call      WriteInt
         mov       edx,offset blank
         call      WriteString

         mov       edx,offset ttlMsg
         call      WriteString
         mov       eax,ebx
         call      WriteInt
         mov       edx,offset blank
         call      WriteString
         invoke    exitprocess,0       ;Terminate gracefully

zroBit:  mov       edx,offset zeroMsg  
         call      WriteString
         invoke    exitprocess,0       ;Terminate gracefully

main ENDP

END main