.data
	Mat: .space 48 	# 4x3 * 4 bytes (inteiros)
	vet: .space 12 	# 3 * 4 bytes (inteiros)
	result: .space 16 	# 4 * 4 bytes (inteiros)
	msg1: .asciiz "Insira o valor de Mat["
	msg2: .asciiz "]["
	msg3: .asciiz "]: "
	msg4: .asciiz "Insira o valor de Vet["
	msg5: .asciiz "\nResultado: "
	
.text
	.globl main
main:
	la $a0, Mat	# carrega o endereço base de Mat em $a0
	li $a1, 4	# $a1 = número de linhas
	li $a2, 3	# $a2 = número de colunas
	jal leMatriz	# chama a função leMatriz(Mat[][], nlin, ncol)
	move $a0, $v0	# armazena o endereço da matriz lida em $a0
	jal escreveMat	# chama a função escreveMat(Mat[][], nlin, ncol)
	move $s0, $v0	# armazena o endereço da matriz em $s0
	
	la $a0, vet	# carrega o endereço base de vet em $a0
	jal leVetor	# chama a função leVetor(vet[])
	move $s1, $v0	# armazena o endereço do vetor em $s1
	
	la $a0, Mat	# carrega o endereço base de Mat em $a0
	li $a1, 4	# $a1 = número de linhas
	li $a2, 3	# $a2 = número de colunas
	# s1 = endereço de vet[]
	jal produto
	
	la $a0, msg5	# carrega o endereço de "\nResultado: " em $a0
	li $v0, 4	# código para imprimir string
	syscall
	
	move $a0, $s3	# armazena o endereço de result em $a0
	jal escreveVet	# chama a função escreveVet(vet[])
	
	li $v0, 10	# código para terminar o programa
	syscall		
	
	
indice:
	mul $v0, $t0, $a2	# $v0 = i(t0) * ncol($a2)
	add $v0, $v0, $t1	# $v0 = [i(t0) * ncol($a2)] + j($t1)
	sll $v0, $v0, 2		# $v0 = {[i(t0) * ncol($a2)] + j($t1)} * 4
	add $v0, $v0, $a3	# $v0 += endereço base de mat (&Mat[i][j])
	jr $ra		# retorna para a função chamadora
	
leMatriz: # (a0 = Mat[][], a1 = nlin, a2 = ncol)
	subi $sp, $sp, 4	# reserva espaço na pilha para 1 item
	sw $ra, ($sp)		# salva o valor de retorno
	
	move $a3, $a0	# armazena o endereço base de mat em $a3
	li $t0, 0	# inicializa o contador de linhas ($t0) = 0
	li $t1, 0	# inicializa o contador de colunas ($t1) = 0
lM:	la $a0, msg1	# carrega o endereço da mensagem "Insira o valor de Mat[" em $a0
	li $v0, 4	# código para imprimir string
	syscall
	
	move $a0, $t0	# carrega o índice da linha em $a0
	li $v0, 1	# código para imprimir inteiro
	syscall
	
	la $a0, msg2	# carrega o endereço da mensagem "][" em $a0
	li $v0, 4	# código para imprimir string
	syscall
	
	move $a0, $t1	# carrega o índice da coluna em $a0
	li $v0, 1	# código para imprimir inteiro
	syscall
	
	la $a0, msg3	# carrega o endereço da mensagem "]: " em $a0
	li $v0, 4	# código para imprimir string
	syscall
	
	li $v0, 5 	# código para ler inteiro
	syscall
	move $t2, $v0	# armazena o inteiro lido em $t2
	
	jal indice	# chama a função indice para calcular o índice de Mat[i][j]
	sw $t2, ($v0)	# armazena o inteiro lido em Mat[i][j]
	
	addi $t1, $t1, 1	# incrementa o contador de colunas ($t1)++
	blt $t1, $a2, lM	# se $t1 < ncol, continua o loop lM
	li $t1, 0		# reseta o contador de colunas ($t1) = 0
	
	addi $t0, $t0, 1	# incrementa o contador de linhas ($t0)++
	blt $t0, $a1, lM	# se $t0 < nlin, continua o loop lM
	li $t0, 0		# reseta o contador de linhas ($t0) = 0
	
	lw $ra, ($sp)	# recupera o valor de retorno
	addi $sp, $sp, 4	# libera o espaço na pilha
	move $v0, $a3	# armazena o endereço da matriz em $v0
	jr $ra		# retorna para a função chamadora
	
	
escreveMat: # (a0 = Mat[][], a1 = nlin, a2 = ncol)
	subi $sp, $sp, 4	# reserva espaço na pilha para 1 item
	sw $ra, ($sp)		# salva o valor de retorno
	
	move $a3, $a0	# armazena o endereço base de mat em $a3
eM: 	jal indice	# chama a função indice para calcular o índice de Mat[i][j]
	lw $a0, ($v0)	# carrega o valor de mat[i][j] em $a0
	
	li $v0, 1	# código para imprimir inteiro
	syscall
	
	la $a0, 32	# carrega o código ASCII para espaço em $a0
	li $v0, 11	# código para imprimir caractere
	syscall
	
	addi $t1, $t1, 1	# incrementa o contador de colunas ($t1)++
	blt $t1, $a2, eM	# se $t1 < ncol, continua o loop eM
	li $t1, 0		# reseta o contador de colunas ($t1) = 0
	
	la $a0, 10	# carrega o código ASCII para quebra de linha "\n" em $a0
	syscall
	
	addi $t0, $t0, 1	# incrementa o contador de linhas ($t0)++
	blt $t0, $a1, eM	# se $t0 < nlin, continua o loop eM
	li $t0, 0		# reseta o contador de linhas ($t0) = 0
	
	lw $ra, ($sp)	# recupera o valor de retorno
	addi $sp, $sp, 4	# libera o espaço na pilha
	move $v0, $a3	# armazena o endereço da matriz em $v0
	jr $ra		# retorna para a função chamadora
	
	
leVetor: # (a0 = vet[])
	move $t0, $a0 	# armazena o endereço base do vetor em $t0
	move $t1, $t0	# $t1 = endereço do vetor[i]
	li $t2, 0 	# inicializa o contador de índice ($t2) = 0
		
lV: 	li $v0, 4	# código para imprimir string
    	la $a0, msg4	# carrega o endereço da mensagem "Insira o valor de Vet[" em $a0
    	syscall
			
	move $a0, $t2	# carrega o índice do vetor em $a0
	li $v0, 1 	# código para imprimir inteiro 
	syscall
			
	li $v0, 4	# código para imprimir string
    	la $a0, msg3	# carrega o endereço da mensagem "]: " em $a0
    	syscall
    			
    	li $v0, 5	# código para ler inteiro
    	syscall		# inteiro lido armazenado em $v0
    			
    	sw $v0, ($t1)	# armazena o inteiro lido no vetor[i]
	add $t1, $t1, 4 	# move para o próximo endereço do vetor
	addi $t2, $t2, 1	# incrementa o contador de índice ($t2)++
	blt $t2, 3, lV	# se $t2 < 3, continua o loop lV
		
	move $v0, $t0	# armazena o endereço do vetor em $v0
	jr $ra 		# retorna para a função chamadora
	

escreveVet:
	move $t0, $a0	# armazena o endereço base do vetor em $t0
	move $t1, $t0	# $t1 = endereço do vetor[i]
	li $t2, 0 	# inicializa o contador de índice ($t2) = 0
		
eV:	lw $a0, ($t1)	# carrega o valor do vetor[i] em $a0
	li $v0, 1 	# código para imprimir inteiro 
	syscall
		
	li $a0, 32	# carrega o código ASCII para espaço em $a0
	#la $a0, 10	# código ASCII para quebra de linha "\n"
	li $v0, 11	# código para imprimir caractere
	syscall
		
	add $t1, $t1, 4 	# move para o próximo endereço do vetor
	addi $t2, $t2, 1	# incrementa o contador de índice ($t2)++
	blt $t2, 4, eV		# se $t2 < 4, continua o loop eV
		
	move $v0, $t0	# armazena o endereço do vetor em $v0
	jr $ra 		# retorna para a função chamadora
	

produto: # (a0 = Mat[][], a1 = nlin, a2 = ncol, s1 = Vet[])
	subi $sp, $sp, 4	# reserva espaço na pilha para 1 item
	sw $ra, ($sp)		# salva o valor de retorno
	
	move $a3, $a0	# armazena o endereço base de mat em $a3
	la $s3, result	# carrega o endereço base de result em $s3
	li $t0, 0	# inicializa o contador de linhas ($t0) = 0
	li $t1, 0	# inicializa o contador de colunas ($t1) = 0
	li $t4, 0	# inicializa o acumulador de produtos ($t4) = 0
p: 	jal indice	# chama a função indice para calcular o índice de Mat[i][j]
	lw $a0, ($v0)	# carrega o valor de mat[i][j] em $a0
	
	add $v0, $t1, $zero	# armazena o valor de $t1 em $v0
	sll $v0, $v0, 2		# multiplica $v0 por 4
	add $v0, $v0, $s1	# adiciona o endereço base de vet ao $v0
	lw $s2, ($v0)		# carrega o valor de vet[j] em $s2
	
	mul $t3, $a0, $s2	# multiplica Mat[i][j] por vet[j] e armazena em $t3
	add $t4, $t4, $t3	# acumula o produto em $t4
	
	add $v0, $t0, $zero	# armazena o valor de $t0 em $v0
	sll $v0, $v0, 2		# multiplica $v0 por 4
	add $v0, $v0, $s3	# adiciona o endereço base de result ao $v0
	sw $t4, ($v0)		# armazena o resultado da soma em result[i]
	
	addi $t1, $t1, 1	# incrementa o contador de colunas ($t1)++
	blt $t1, $a2, p		# se $t1 < ncol, continua o loop p
	li $t1, 0		# reseta o contador de colunas ($t1) = 0
	li $t4, 0		# reseta o acumulador de produtos ($t4) = 0
	
	addi $t0, $t0, 1	# incrementa o contador de linhas ($t0)++
	blt $t0, $a1, p		# se $t0 < nlin, continua o loop p
	
	lw $ra, ($sp)	# recupera o valor de retorno
	addi $sp, $sp, 4	# libera o espaço na pilha
	move $v0, $s3	# armazena o endereço de result em $v0
	jr $ra		# retorna para a função chamadora
