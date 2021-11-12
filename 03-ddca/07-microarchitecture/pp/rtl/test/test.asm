.text
.global main
main:
	addi $v0, $0, 5
	addi $v1, $0, 12 
	addi $a3, $v1, -9
	or $a0, $a3, $v0
	and $a1, $v1, $a0
	add $a1, $a1, $a0
	beq $a1, $a3, 10
	slt $a0, $v1, $a0
	beq $a0, $0, 1
	addi $a1, $0, 0
	slt $a0, $a3, $v0
	add $a3, $a0, $a1
	sub $a3, $a3, $v0
	sll $a3, $a3, 2
	sub $a3, $a3, $a1
	srl $a3, $a3, 2
	slti $a0, $a3, 5
	add $a3, $a3, $a0
	sw $a3, 68($v1)
	lw $v0, 80($0)
	j 22
	addi $v0, $0, 1
	sw $v0, 84($0)
