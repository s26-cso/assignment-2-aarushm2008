.section .rodata
fmt: .string "%d "
fmt_last: .string "%d\n"
line: .string "\n"
.section .text
.global main

main:
addi sp,sp,-24                 # save ra, s5, s6
sd ra,16(sp)                 
sd s5,8(sp)                   
sd s6,0(sp)                    
addi s0,a0,-1                  # s0 = number of elements (argc-1)
addi s1,a1,0                   # s1 = argv
li t0,8                        # malloc s2 = input array
mul a0,s0,t0
call malloc
addi s2,a0,0                   # s2 = input array ptr
li t0,8                        # malloc s3 = result array
mul a0,s0,t0
call malloc
addi s3,a0,0                   # s3 = result array ptr
li t0,8                        # malloc s5 = NGE stack 
mul a0,s0,t0
call malloc
addi s5,a0,0                   # s5 = NGE stack ptr
li t0,1                        # t0 = loop counter 
beq a0,a0,loop
loop:
bgt t0,s0,done                 # if t0 > s0 done
li t1,8
mul t2,t0,t1
add t3,t2,s1                   # t3 = &argv[t0]
addi s4,t0,0                   # save t0 in s4
ld a0,0(t3)                    # a0 = argv[t0]
call atoi
addi t0,s4,0                   # restore t0 from s4
addi t4,t0,-1
li t1,8
mul t5,t4,t1
add t6,s2,t5                   # t6 = &s2[t0-1]
sd a0,0(t6)                    # s2[t0-1] = get int from string
addi t0,t0,1                   # t0++
beq a0,a0,loop

done:
addi t0,s0,-1                  # start from rightmost element
li s4,0                        # s4 = stack top index
beq a0,a0,solve
solve:
blt t0,x0,ans                  # if t0 < 0 we are done
beq s4,x0,minus                # if stack empty no NGE exists,so put -1
addi t3,s4,-1                  # top of stack = s5[s4-1]
li t2,8
mul t3,t3,t2
add t3,t3,s5
ld t1,0(t3)                    # t1 = top index
mul t3,t1,t2
add t3,t3,s2
ld t4,0(t3)                    # t4 = s2[top]
mul t5,t0,t2
add t5,t5,s2
ld t6,0(t5)                    # t6 = s2[t0]
bge t4,t6,else                 # if s2[top] > s2[t0] found NGE
addi s4,s4,-1                  # pop stack
beq a0,a0,solve

else:
beq s4,x0,minus                # if stack empty no NGE
addi t3,s4,-1                  #  top again = s5[s4-1]
li t2,8
mul t3,t3,t2
add t3,t3,s5
ld t6,0(t3)                    # t6 = NGE index
mul t4,t0,t2
add t5,s3,t4
sd t6,0(t5)                    # s3[t0] = NGE index
mul t3,s4,t2
add t3,t3,s5
sd t0,0(t3)                    # push t0 onto stack
addi s4,s4,1                   # increment stack top
addi t0,t0,-1                  # t0--
beq a0,a0,solve

minus:
li t6,-1                       # no NGE found
li t2,8
mul t4,t0,t2
add t5,s3,t4
sd t6,0(t5)                    # s3[t0] = -1
mul t3,s4,t2
add t3,t3,s5
sd t0,0(t3)                    # push t0 onto stack
addi s4,s4,1                   # increment stack top
addi t0,t0,-1                  # t0--
beq a0,a0,solve

ans:
li s6,0 # s6 = counter
printloop:
bge s6,s0,exit          # if s6 >= s0 done
li t1,8
mul t2,s6,t1
add t3,s3,t2
ld a1,0(t3)       # a1 = s3[s6]
addi t2,s0,-1
beq s6,t2,print_last
la a0,fmt
call printf
addi s6,s6,1                   # s6++
beq a0,a0,printloop
print_last:
la a0,fmt_last
call printf
beq a0,a0,exit

exit:
addi s5,s5,0        # s2 = free atoi input arr
addi a0,s2,0
call free
addi a0,s3,0        # s3 = free result
call free
addi a0,s5,0        # s5 = free stack
call free
ld ra,16(sp)        # restore ra
ld s5,8(sp)         # restore s5
ld s6,0(sp)         # restore s6
addi sp,sp,24
ret
