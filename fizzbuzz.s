.data
	fizz: .asciiz "Fizz\n"
	buzz: .asciiz "Buzz\n"
	fizzb: .asciiz "FizzBuzz\n"
	newline: .asciiz "\n"

.text
.globl main

main:
	li $t0, 3
	li $t1, 5
	li $t2, 1
	li $t3, 21
	li $t7, 0

head:
	beq $t2, $t3, exit
	#body

	div $t2, $t0
	mfhi $t4

	div $t2, $t1
	mfhi $t5

	beq $t4, $t7, f
	beq $t5, $t7, bu
	li  $v0, 1
	move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
	j latch
f:
	beq $t4,$t5, fb

	li $v0, 4
    la $a0, fizz
    syscall

	j latch
bu:
	li $v0, 4
    la $a0, buzz
    syscall
	j latch
fb:
	li $v0, 4
    la $a0, fizzb
    syscall
	
latch:
	add $t2,$t2,1
	j head

exit:
	jr $ra