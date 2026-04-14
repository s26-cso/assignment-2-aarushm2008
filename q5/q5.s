.section .rodata
filename: .string "input.txt"
mode: .string "r"
yes: .string "Yes\n"
no: .string "No\n"

.section .text
.global main
main:
addi sp,sp,-48                 
sd ra,40(sp)                   
sd s0,32(sp)                    #s0 = file ptr
sd s1,24(sp)                    #s1 = size
sd s2,16(sp)                   #s2 = left index
sd s3,8(sp)                    #s3 = right index
sd s4,0(sp)                    #s4 = left char
la a0,filename                 
la a1,mode                     
call fopen                     
addi s0,a0,0                   
li s1,0   

size_loop:
addi a0,s0,0                   # a0 = file ptr
call fgetc                     
li t0,-1                      
beq a0,t0,size_done            # if EOF stop
addi s1,s1,1                   # size++
beq a0,a0,size_loop

size_done:
addi a0,s0,0                   # a0 = file ptr
li a1,0                        # offset = 0
li a2,0                        
call fseek                     # to move file ptr to start
li s2,0                        # s2 = left index
addi s3,s1,-1                  # s3 = right index
beq a0,a0,loop

loop:
bge s2,s3,yes_label         # if left >= right,then yes
addi a0,s0,0                 # a0 = file ptr
addi a1,s2,0                   # a1 = left index
li a2,0                        #Move pointer so that we are at that char which we have to compare 
call fseek                    
addi a0,s0,0                   # a0 = file ptr
call fgetc                     
addi s4,a0,0                   # s4 = left char 
addi a0,s0,0                   # a0 = file ptr
addi a1,s3,0                   # a1 = right index
li a2,0                        #Move pointer so that we are at that char which we have to compare 
call fseek                    
addi a0,s0,0                  
call fgetc                    
addi t0,a0,0                   # t0 = right char
bne s4,t0,no_label             # if left != right not palindrome
addi s2,s2,1                   # left++
addi s3,s3,-1                # right--
beq a0,a0,loop

yes_label:
la a0,yes                      
call printf               # print Yes
beq a0,a0,done

no_label:
la a0,no                      
call printf                  # print No

done:
addi a0,s0,0                  
call fclose                    
ld ra,40(sp)                   
ld s0,32(sp)                  
ld s2,16(sp)               
ld s3,8(sp)                   
ld s4,0(sp)                   
addi sp,sp,48                 
ret