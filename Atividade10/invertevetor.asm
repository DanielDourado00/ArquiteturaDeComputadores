.data
	msgN: .asciiz "Insira o numero de elementos do vetor: "
	msgVet: .asciiz "Insira vet["
	msgVet2: .asciiz "]: "
	espaco: .asciiz " "
	saida1: .asciiz "V1 = "
	saida2: .asciiz "\nV2 = "
	
.text
main:
	jal leituraN
	move $s0, $v0	# $s0 = N
	
	# alocando espa�o para o V1
	move $a0, $s0	# passa o tamanho do vetor para o argumento $a0
	jal alloc
	move $s1, $v0 	# $s1 = endere�o base do V1
	
	# alocando espa�o para o V2
	jal alloc
	move $s2, $v0 	# $s2= endere�o base do V2
	
	# leitura do V1
	move $t1, $s1	# passa o endere�o base do V1 para o argumento $t1
	jal leituraVetor
	
	# invers�o do V1 para o V2
	move $t1, $s1	# passa o endere�o base do V1 para o argumento $t1
	move $t2, $s2 	# passa o endere�o base do V2 para o argumento $t2
	jal inverte_vetor
	
	move $a2, $s1	# passa o endere�o base do V1 para o argumento $a2
	la $a3, saida1
	jal imprime_vetor
	
	move $a2, $s2
	la $a3, saida2
	jal imprime_vetor
	
	# encerra o programa
	li $v0, 10
	syscall
	
leituraN:
	# imprimindo mensagem para o usuario
	la $a0, msgN
	li $v0, 4	# c�digo de impress�o de string
	syscall
	# leitura do N
	li $v0, 5	# c�digo de leitura de inteiro
	syscall
	jr $ra
	
alloc:	# retorna o endere�o do vetor em $v0
	mul $a0, $a0, 4		# multiplica o tamanho do vetor por 4 bits
	li $v0, 9		# c�digo de aloca��o din�mica
	syscall
	jr $ra
	
leituraVetor:
	li $t0, 0		# $t0 = i = 0
	
l:	la $a0, msgVet	
	li $v0, 4		# c�digo de impress�o de string
	syscall
	move $a0, $t0
	li $v0, 1		# c�digo de impress�o de inteiro
	syscall
	la $a0, msgVet2
	li $v0 4		# c�digo de impress�o de string
	syscall
	li $v0, 5		# c�digo de leitura de inteiro
	syscall
	
	sw $v0, ($t1)		# $v0 = conteudo apontado por $t1
	addi $t1, $t1, 4	# incrementa o endere�o do vetor
	addi $t0, $t0, 1	# # i = i+1
	
	blt $t0, $s0, l		# if i < N continua a leitura do vetor
	jr $ra
	
inverte_vetor:
	li $t0, 0	# i = 0
	mul $t4, $s0, 4	
	sub $t4, $t4, 4
	add $t2, $t2, $t4	# ponteiro p/ a ultima posi��o do V2
	
	loop:
	beq $t0, $s0, endLoop	
	lw $t9, ($t1)	# conteudo de V1[i]
	
	sw $t9, ($t2)	# armazena de tras pra frente no V2
	add $t1, $t1, 4	# proxima posi��o do V1
	sub $t2, $t2, 4	# prosi��o anterior do V2
	add $t0, $t0, 1	# i++
	j loop
	
endLoop:
	jr $ra
	
imprime_vetor:
	li $t0, 0
	li $v0, 4
	move $a0, $a3
	syscall
	l2:
	beq $t0, $s0, endLoop
	lw  $t9, ($a2)
	
	li $v0, 1	# impressao de inteiro
	move $a0, $t9	
	syscall
	
	li $v0, 4	# impressao de string
	la $a0, espaco
	syscall
	
	add $a2, $a2, 4
	add $t0, $t0, 1
	j l2