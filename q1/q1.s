.section .text
.global make_node
.global insert
.global get
.global getAtMost

make_node:
addi sp,sp,-16
sd ra,8(sp)                    # save ra
sw a0,0(sp)                    # save val
li a0,24                       # 24 bytes: 4(val)+4(pad)+8(left)+8(right)
call malloc                    
addi t0,a0,0                   # t0 = new node ptr
lw a0,0(sp)                    # restore val
sw a0,0(t0)                    # node->val = val
sd x0,8(t0)                    # node->left = NULL
sd x0,16(t0)                   # node->right = NULL
addi a0,t0,0                   # return node ptr
ld ra,8(sp)                   
addi sp,sp,16
ret

insert:
beq a0,x0,done                 # if root==NULL create node
lw t0,0(a0)                    # t0 = root->val
addi t1,a1,0                   # t1 = val to insert
bge t1,t0,else                 # if val >= root->val go right
addi sp,sp,-16                 # save ra and root
sd ra,8(sp)
sd a0,0(sp)
ld t3,8(a0)                    # t3 = root->left
addi a0,t3,0                   # a0 = left child
jal ra,insert                  # insert left
addi t2,a0,0                   # t2 = new left child
ld a0,0(sp)                    
sd t2,8(a0)                    # root->left = new child
ld ra,8(sp)                    # restore ra
addi sp,sp,16
ret

else:
addi sp,sp,-16                 # save ra and root
sd ra,8(sp)
sd a0,0(sp)
ld t3,16(a0)                   # t3 = root->right
addi a0,t3,0                   # a0 = right child
jal ra,insert                  # insert right
addi t2,a0,0                   # t2 = new right child
ld a0,0(sp)                    # restore root
sd t2,16(a0)                   # root->right = new child
ld ra,8(sp)                    # restore ra
addi sp,sp,16
ret

done:
addi sp,sp,-8
sd ra,0(sp)                  
addi a0,a1,0                   # a0 = val
jal ra,make_node               # create node
ld ra,0(sp)                    
addi sp,sp,8
ret

get:
beq a0,x0,nul                  # if root==NULL return NULL
lw t0,0(a0)                    # t0 = root->val
addi t1,a1,0                   # t1 = search val
beq t0,t1,recieved             # found
bge t1,t0,large                # if val > root->val go right
addi sp,sp,-8                  
sd ra,0(sp)
ld t4,8(a0)                    # t4 = root->left
addi a0,t4,0
jal ra,get                     # search left
ld ra,0(sp)
addi sp,sp,8
ret

large:
addi sp,sp,-8                  # save ra 
sd ra,0(sp)
ld t4,16(a0)                   # t4 = root->right
addi a0,t4,0
jal ra,get                     # search right
ld ra,0(sp)
addi sp,sp,8
ret

recieved:
ret                             # return node ptr in a0

nul:
ret                             # return NULL

getAtMost:
addi sp,sp,-16
sd ra,8(sp)                    # save ra
sd s0,0(sp)                    
li s0,-1                       # default -1
jal ra,solve                   # find greatest val <= a0
addi a0,s0,0                   # return result
ld s0,0(sp)                   
ld ra,8(sp)                    # restore ra
addi sp,sp,16
ret

solve:
addi sp,sp,-16
sd ra,8(sp)                    # save ra
sd a0,0(sp)                   
beq a1,x0,solvedone            # if NULL return
lw t0,0(a1)                    # t0 = node->val
beq t0,a0,max                  # exact match
bge t0,a0,bigg                 # node->val > target go left
addi s0,t0,0                   # best so far = node->val
ld t4,16(a1)                   # go right now
addi a1,t4,0
jal ra,solve                   # recurse right
ld a0,0(sp)                    # restore target
ld ra,8(sp)
addi sp,sp,16
ret

bigg:
ld t4,8(a1)                    # go left, too big
addi a1,t4,0
jal ra,solve                   # recurse left
ld a0,0(sp)                    # restore target
ld ra,8(sp)
addi sp,sp,16
ret

max:
addi s0,t0,0                   # exact match
ld a0,0(sp)                    # restore target
ld ra,8(sp)
addi sp,sp,16
ret

solvedone:
ld a0,0(sp)                    # restore target
ld ra,8(sp)
addi sp,sp,16
ret