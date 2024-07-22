.data
	msgK: .asciiz "k = "
	msgN: .asciiz "n = "
	msgErro: .asciiz "Os valores k e n devem ser inteiros e positivos!\n"
	msgSaida: .asciiz "k^n = "
.text
main:
	jal leitura
	# $s0 = k
	# $s2 = n
	
	# parametros
	li $t0, 0
	move $s2, $s0
	jal operacao
	
	jal resultado
	
	# encerra o programa
	li $v0, 10
	syscall
	
leitura:
	# K:
	li $v0, 4	# impressao de string
	la $a0, msgK
	syscall
	# leitura do k
	li $v0, 5
	syscall
	move $s0, $v0
	
	# N:
	li $v0, 4	# impressao de string
	la $a0, msgN
	syscall
	# leitura do n
	li $v0, 5
	syscall
	move $s1, $v0
	
	# verifica��o se k e n s�o n�meros inteiros e positivos
	blt $s0, 0, erro
	blt $s1, 0, erro
	jr $ra
	
erro:
	li $v0, 4
	la $a0, msgErro
	syscall
	j leitura
	
operacao:
	mul $s2, $s2, $s0
	add $t0, $t0, 1		# i++
	blt $t0, $s1, operacao	# recurs�o
	jr $ra
	
resultado:
	# impressao de string
	li $v0, 4
	la $a0, msgSaida
	syscall
	#impressao de inteiro
	li $v0, 1
	move $a0, $s2
	syscall
	jr $ra
	