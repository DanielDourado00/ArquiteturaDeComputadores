.data
Mat: .space 48	# 4x3 * 4 (inteiro)
Vet: .space 12 	# 3 elementos * 4
Ent1: .asciiz "Insira o valor da matriz A["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "

.text
main:	la $a0, Mat	# endere o base da matriz A
	li $a1, 4	# numero de linhas da matriz
	li $a2, 3	# numero de colunas da matriz
	la $s3, Vet	# endere o base do vetor V
	li $s4, 3	# numero de linhas do vetor
	jal leitura 	# leitura(mat, nlin, ncol)
	move $a0, $v0	# endere o da matriz lida
	jal escrita	# escrita(mat, nlin, ncol)
	li $v0, 10	# codigo para finalizar o programa
	syscall		# finaliza o programa
	
indice:
	mul $v0, $t0, $a2	# i * ncol
	add $v0, $v0, $t1	# (i * ncol) + j
	sll $v0, $v0, 2		# [ (i * ncol) + j ] * 4 (inteiro)
	add $v0, $v0, $a3	# soma o endere o base de mat
	jr $ra			# retorna para o caller
	
leitura:
	subi $sp, $sp, 4# espa o para 1 item na pilha
	sw $ra, ($sp)	# salva o retorno para a main
	move $a3, $a0	# aux = endere o base de mat
l:	#---------------------------------------------------------------------
	la $a0, Ent1	# carrega o endere o da string
	li $v0, 4	# codigo de impressao de string
	syscall		# imprime i
	move $a0, $t0	# valor de i para impressao
	li $v0, 1	# codigo de impressao de inteiro
	syscall 	# imprime i
	la $a0, Ent2	# carrega o endere o da string
	li $v0, 4	# codigo de impressao de string
	syscall		# imprime a string
	move $a0, $t1	# valor de j para impressao
	li $v0, 1	# codigo de impressao de inteiro
	syscall		# imprime j
	la $a0, Ent3	# carrega o endere o da string
	li $v0, 4	# codigo de impressao de string
	syscall		# imprime a string
	#---------------------------------------------------------------------
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do valor (retorna em $v0)
	move $t2, $v0	# aux = valor lido
	jal indice	# calcula o endere o de mat[i][j]
	sw $t2, ($v0)	# mat[i][j] = aux
	addi $t1, $t1, 1	# j++
	blt $t1, $a2, l	# if(j < ncol) goto l
	li $t1, 0	# j = 0
	addi $t0, $t0, 1	# i++
	blt $t0, $a1, l	# if(i < nlin) goto l
	li $t0, 0	# i = 0
	lw $ra, ($sp)	# recupera o retorno para a main
	addi $sp, $sp, 4	# libera o espa o na pilha
	move $v0, $a3	# endere o base da matriz para o retorno
	jr $ra		# retorna para a main	
	
escrita:
	subi $sp, $sp, 4# espa o para 1 item na pilha
	sw $ra, ($sp)	# salva o retorno para a main
	move $a3, $a0	# aux = endere o base de mat
e:	jal indice	# calcula o endere o de mat[i][j]
	lw $a0, ($v0)	# valor em mat[i][j]
	li $v0, 1	# codigo de impressao de inteiro
	syscall		# imprime mat[i][j]
	la $a0, 32	# codigo ASCII para espa o
	li $v0, 11	# codigo de impressao de caracteres
	syscall		# imprime o espa o
	addi $t1, $t1, 1	# j++
	blt $t1, $a2, e	# if(j < ncol) goto e
	la $a0, 10	# codigo ASCII para newline (\n)
	syscall		# pula a linha
	li $t1, 0	# j = 0
	addi $t0, $t0, 1	# i++
	blt $t0, $a1, e	# if(i < nlin) goto e
	li $t0, 0	# i = 0
	lw $ra, ($sp)	# recupera o retorno para a main
	addi $sp, $sp, 4	# libera o espa o na pilha
	move $v0, $a3	# endere o base da matriz para retorno
	jr $ra		# retorna para a main