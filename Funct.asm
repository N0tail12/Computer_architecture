.data
input: .space 100 # Buffer 100 byte chua chuoi ki tu can 
output: .space 100
.text
ReadInput: # read infix
# TO DO
 li 	$v0, 8
 la 	$a0, input
 li 	$a1, 100
 syscall 
 la 	$t0, input
 jr 	$ra
 #--------------------------------
 
Push: # push in stack
# TO DO
sub	$sp, $sp, 4	# add $sp
sw	$a0, 0($sp)	# push
jr	$ra
Pop: # output : $a0
# TO DO
lw	$a1, ($sp)	# pop from stack
addi	$sp, $sp, 4	# pop
jr	$ra
IsDigit: # input : $a0
	 # output : $a1 
subi	$sp, $sp, 16
sw	$t0, 0($sp)
sw	$t1, 4($sp)	 
sw	$t2, 8($sp)
sw	$t3, 12($sp)
addi	$t1, $zero, 48	# $t1 = '0'
loop:
addi	$t2, $zero, 57	# $t2 = '9'
addi	$t0, $a0, 0	# $t0 = $a0
sub	$t0, $t0, $t1	# 
beqz	$t0, yes
addi	$t1, $t1, 1	# $t1 += 1
sub	$t2, $t2, $t1	# $t2 -= $t1
beqz	$t2, no
j	loop
no:
addi	$a1, $zero, 0	# no
lw	$t0, 0($sp)
lw	$t1, 4($sp)	 
lw	$t2, 8($sp)
lw	$t3, 12($sp)
addi	$sp, $sp, 16
jr	$ra
yes:

#addi	$a0, $a0, -48	# (int) token

addi	$a1, $zero, 1	# yes 
lw	$t0, 0($sp)
lw	$t1, 4($sp)	 
lw	$t2, 8($sp)
lw	$t3, 12($sp)
addi	$sp, $sp, 16
jr	$ra
#----------------------------------------

GetPrio: # get priority and save in $a1
# TO DO
beq	$a2, 43, plus # if '+'
nop
beq	$a2, 45, subtract # if '-'
nop
beq	$a2, 42, time	# tf '*'
nop
beq	$a2, 47, divine	#if '/'
nop
beq	$a2, 37, modulos	#if '%'
nop
beq	$a2, 40, open_parent	#if '('
nop
li	$a1, -1	#if isdigit
jr	$ra
plus:
li	$a1, 1
jr 	$ra
subtract:
li	$a1, 1
jr 	$ra
time:
li	$a1, 2
jr 	$ra
divine:
li	$a1, 2
jr 	$ra
modulos:
li	$a1, 2
jr 	$ra
open_parent:
li 	$a1, 0
jr 	$ra
#addi	$t0, $zero, 43 
#-----------------------------------------

In2Post: # convert from inFix[] to postFix[]
# TO DO
li	$s0, 0		# i = 0
li	$s1, 0		# j = 0
la	$t0, input	# $t0 = (inFix[0])
la	$t2, output	# $t2 = (postFix[0])
addi	$t5, $ra, 0
loop1:
lb	$a0, ($t0)	# $a0 = inFix[0]
beq	$a0, 10,  back2main
If:
jal	IsDigit
beqz	$a1, else 	# else


sb	$a0, ($t2)
addi	$s1, $s1, 1	# j++
addi	$t2, $t2, 1	# postFix[j++]
# addi	$a2, $a0, 0	# $a2 = inFix[i]
addi	$s0, $s0, 1	# i++
addi	$t0, $t0, 1	# inFix[i++]
lb	$a0, ($t0)	# $a0 = inFix[i+1]
jal	IsDigit
beqz	$a1, endif1	# end if
#li	$t9, 10
#mult	$a2, $t9
#mflo	$a2
#add	$a0, $a0, $a2	# Digit
sb	$a0, ($t2)
addi	$s1, $s1, 1	# j++
addi	$t2, $t2, 1	# postFix[j++]
li	$a0, 32
sb	$a0, ($t2)
addi	$s1, $s1, 1	# j++
addi	$t2, $t2, 1	# postFix[j++]
j	exit
endif1:
subi	$s0, $s0, 1
subi	$t0, $t0, 1
# sb	$a2, ($t2)
# addi	$s1, $s1, 1	# j++
# addi	$t2, $t2, 1	# postFix[j++]
j	exit


else:			# if == '('
li	$t3, 40		# $t3 = '('
bne	$a0, $t3, else1	# else1
jal	Push		# push
j	exit
else1:			# if == ')'
li	$t4, 41		# $t3 = ')'
bne	$a0, $t4, else2	# else
whileLoop:
jal	Pop
sb	$a1, ($t2)	# 

addi	$s1, $s1, 1	# j++
addi	$t2, $t2, 1	# postFix[j++]	
bne	$a1, $t3, whileLoop
j	exit
else2:
whileLoop1:
addi	$a2, $a0, 0	# $a2 = token
jal	GetPrio
addi	$t3, $a1, 0	# $t3 = Priority(token)
sub	$t8, $t3, 3
beqz	$t8, exit
addi	$a2, $sp, 0
lw	$a2, ($a2)	# $a2 = stackpointer
jal	GetPrio
sub	$t3, $t3, $a1	# 
bgtz	$t3, exitWhileLoop1
beq	$sp, 0x7fffeffc, exitWhileLoop1
jal	Pop
sb	$a1, ($t2)	# 

addi	$s1, $s1, 1	# j++
addi	$t2, $t2, 1	# postFix[j++]	
j	whileLoop1
exitWhileLoop1:
jal	Push
exit:
addi	$s0, $s0, 1	# i++
add	$t0, $t0, 1	# inFix[i++]	
j	loop1
back2main:
beq	$sp, 0x7fffeffc, back
jal	Pop
sb	$a1, ($t2)	# 

addi	$s1, $s1, 1	# j++
addi	$t2, $t2, 1	# postFix[j++]
j	back2main
back:
addi	$ra, $t5, 0
jr	$ra

#----------------------------------------------------------

Calculate: # calculate 
# TO DO
add	$k0, $ra,$zero	#save ra
la	$t0, output	# output
calWhile:		#while
lb	$a0, 0($t0)
bne	$a0, '\0', ifCal1
nop
jal	Pop
nop
li 	$v0, 36		#print
add	$a0, $a1, $zero
syscall
jr	$k0
ifCal1:
jal	IsDigit
nop
beqz	$a1, elseCal1
addi	$a0, $a0, -48 
jal	Push		#if digit -> push
nop
addi	$t0, $t0, 1
j 	calWhile
elseCal1:
jal	Pop		#get op1
nop
add	$t1, $a1, $zero
jal	Pop		#get op2
nop
add	$t2, $a1, $zero
switchCase:
beq	$a0, 43, plusCase 	#case +
nop
beq	$a0, 45, subtractCase 	#case -
nop
beq	$a0, 42, timeCase 	#case *
nop
beq	$a0, 47, divineCase 	#case /
nop
beq 	$a0, 32, spaceCase	#get 2 number
nop
spaceCase:
li	$k1, 10
mult	$t2, $k1
mflo	$t2
add	$a0, $t2, $t1
jal	Push
nop
add	$t0, $t0, 1
j	calWhile
divineCase:
div	$t2, $t1
mflo	$t3
j	endswitch
plusCase:
add	$t3, $t1, $t2
j 	endswitch
subtractCase:
sub	$t3, $t2, $t1
j	endswitch
timeCase:
mult	$t1, $t2
mflo	$t3
j	endswitch
endswitch:
add 	$a0, $t3, $zero
jal	Push
add	$t0, $t0, 1
j	calWhile