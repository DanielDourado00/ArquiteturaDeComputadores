.data

mVetC: .asciiz "Vetor C: \n"
mVetD: .asciiz "Vetor D: \n"
mVetE: .asciiz "Vetor E: \n"
mN: .asciiz "N: "
espaco: .byte ' '

.text

li $v0, 4	# codigo de impressao de string
la $a0, mN	# carrega o endere?o da string
syscall		# impress?o da string

li $v0, 5	# codigo de leitura de inteiro
syscall		# leitura do inteiro
move $t1, $v0	# $t1 = N

# ------------------------------------- LEITURA DO VETOR C --------------------------------------

li $v0, 4	# codigo de impressao de string
la $a0, mVetC	# carrega o endere?o da string
syscall		# impress?o da string

mul $s1, $t1, 4	# $s1 = quantidade de mem?ria a ser alocada (4*N)
move $a0, $s1	# $a0 <- $s1 (argumento da funcao de alocar)
li $v0, 9	# codigo de aloca?ao dinamica heap
syscall		# aloca 4*N bytes (endere?o em $v0)
move $t9, $v0	# move para $t9 o endere?o do primeiro elemento do vetor C

li $t0, 0	# $t0 = i 
loopLeituraVetC:
	beq $t0, $t1, endLoopLeituraVetC	# quando $t0 = $t1 termina a leitura
	
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do inteiro
	move $t2, $v0	# $t2 = aux (elemento inserido)
	sw $t2, ($t9)	# armazenando $t2 na posi??o de memoria que $t9 aponta 
	add $t9, $t9, 4	# proxima posi??o do vetor
	add $t0, $t0, 1	# i = i+1
	j loopLeituraVetC	
endLoopLeituraVetC:


# ------------------------------------- LEITURA DO VETOR D --------------------------------------

li $v0, 4	# codigo de impressao de string
la $a0, mVetD	# carrega o endere?o da string
syscall		# impress?o da string

move $a0, $s1	# $a0 <- $s1 (argumento da funcao de alocar)
li $v0, 9	# codigo de aloca?ao dinamica heap
syscall		# aloca 4*N bytes (endere?o em $v0)
move $t8, $v0	# move para $t8 o endere?o do primeiro elemento do vetor D

li $t0, 0	# $t0 = i 
loopLeituraVetD:
	beq $t0, $t1, endLoopLeituraVetD	# quando $t0 = $t1 termina a leitura
	
	li $v0, 5	# codigo de leitura de inteiro
	syscall		# leitura do inteiro
	move $t2, $v0	# $t2 = aux (elemento inserido)
	sw $t2, ($t8)	# armazenando $t2 na posi??o de memoria que $t9 aponta 
	add $t8, $t8, 4	# proxima posi??o do vetor
	add $t0, $t0, 1	# i = i+1
	j loopLeituraVetD	
endLoopLeituraVetD:

# preciso fazer $t8 e $t9 apontarem pro inicio dos vetores de novo, ent?o pega a ultima posi??o e subtrai 4*N
sub $t8, $t8, $s1	# agora $t8 aponta pra primeira posi??o do vetor D
sub $t9, $t9, $s1	# agora $t8 aponta pra primeira posi??o do vetor C

# ------------------------------------- CRIA��O DO VETOR E --------------------------------------

mul $s2, $s1, 2	# $s2 = quantidade de mem?ria a ser alocada (8*N), *o vetor E tem o dobro do tamanho do C e D , por isso multiplica por 8
move $a0, $s2	# $a0 <- $s1 (argumento da funcao de alocar)
li $v0, 9	# codigo de aloca?ao dinamica heap
syscall		# aloca 4*N bytes (endere?o em $v0)
move $t7, $v0	# move para $t7 o endere?o do primeiro elemento do vetor 

li $t0, 0	# $t0 = i 
mul $t3, $t1, 2	# $t3 = 2*N (tamanho do vetor E)

#nas posi??es pares os valores do primeiro (C) e nas posi??es impares os valores do segundo (D).
loopCriacaoE:
	beq $t0, $t3, endLoopCriacaoE	# quando $t0 = $t3 termina a leitura
	
	# posi??es ?mpares:
	lw $t2, ($t8) 		# carrega $t2 com o valor da posi??o apontada por $t8 (D)
	sw $t2, ($t7)		# armazenando $t2 na posi??o de memoria que $t7 aponta
	add $t7, $t7, 4		# proxima posi??o do vetor E
	add $t8, $t8, 4		# proxima posi??o do Vetor D
	#posi??es pares:
	lw $t2, ($t9)		# carrega $t2 com o valor da posi??o apontada por $t9 (C)
	sw $t2, ($t7)		# armazenando $t2 na posi??o de memoria que $t7 aponta
	add $t7, $t7, 4		# proxima posi??o do vetor E
	add $t9, $t9, 4		# proxima posi??o do Vetor C
	
	add $t0, $t0, 2		# i = i+2
	j loopCriacaoE
endLoopCriacaoE:

# -------------------------------------------------------------------------------------------------------------

# agora preciso fazer $t7 apontar pro inicio do vetor E de novo, ent?o pega a ultima posi??o e subtrai 4*N
sub $t7, $t7, $s2	# agora $t7 aponta pra primeira posi??o do vetor

li $v0, 4	# codigo de impressao de string
la $a0, mVetE	# carrega o endere?o da string
syscall		# impress?o da string

li $t0, 0	# $t0 = i 
loopImpressaoVetE:
	beq $t0, $t3, endLoopImpressaoVetE	# quando $t0 = $t3 sai do loop
	
	# impress?o:
	lw $a0, ($t7)	# carrega $a0 (argumento) com o valor da posi??o apontada por $t7 
	li $v0, 1	# codigo de impressao de inteiro
	syscall		# imprime 
	
	# imprime um espa?o
	li $v0, 4
	la $a0, espaco
	syscall
	
	add $t7, $t7, 4	# proxima posi??o do vetor E
	
	add $t0, $t0, 1
	j loopImpressaoVetE
endLoopImpressaoVetE:


