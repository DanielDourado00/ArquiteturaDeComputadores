.data
	entrada: .asciiz "Insira a string: "
	string: .space 999
	msg_naoPalindromo: .asciiz "Nao é palindromo"
	msg_ePalindromo: .asciiz "É palindromo"
	
.text
main:
	jal leitura	# leitura dos numeros
	move $s0, $a0	# $s0 = endereco inicial da string 
	move $a1, $a0
	
	jal tamanhoString	# percorre a string para descobrir o tamanho dela (quantidade de caracteres em $s1)
	sub $s1, $s1, 1		# tamanho da string
	sub $s0, $s0, 1		
	move $a0, $a1		# primeiro elemento em $a0
	jal verificadorPalindromo	
	
	encerraPrograma:
	li $v0, 10
	syscall
	
leitura:
	li $v0, 4	# codigo de impressao para string
	la $a0, entrada	# parametro
	syscall		# imprime a string

	la $a0, string
	li $a1, 999	# numero maximo de caracteres
	li $v0, 8 	# codigo de leitura para string
	syscall		# faz a leitura da string
	jr $ra 		# retorna para a main
	
tamanhoString:
	li $t9, 31	# caractere que encerra a string
	loop:
	lb $t0, ($s0)	# $t0 recebe o conteudo apontado por $s0
	add $s1, $s1, 1	# $s1 = tamanho da string
	ble $t0, $t9, return	# se chegou no ultimo caractere, fim da string
	add $s0, $s0, 1	# proximo caractere da string
	j loop
	
return:
	jr $ra
	
verificadorPalindromo:

	
	li $t0, 2	# aux para divisao
	div $s1, $t0	# tamString / 2
	mfhi $t1	# $t1 = resto da divisao
	bne $t1, 0, naoEPalindromo
	
	# se for par, analisa se é palindromo
	li $t0, 0	# indice i
	ePar:
	mflo $t1	# $t1 = resultado da divisao por 2 (quantidade de vezes que vai percorrer a string)
	beq $t0, $t1, ePalindromo	# if i = tamString/2, return	e se chegar ate aqui, significa que é palindromo
	lb $t2, ($a1)	# primeiro caractere
	lb $t3, ($s0) 	# ultimo caractere
	bne $t2, $t3, naoEPalindromo	# se os dois caracteres opostos forem diferentes, nao � palindromo
	# caso contr�rio, continua analisando os outros caracteres:
	add $t0, $t0, 1	# i = i+1
	add $a1, $a1, 1	# proximo caractere
	sub $s0, $s0, 1	# caractere anterior
	j ePar
	
naoEPalindromo:
	li $v0, 4	# codigo de impressao de string
	la $a0, msg_naoPalindromo	# parametro
	syscall
	j encerraPrograma
	
ePalindromo:
	li $v0, 4	# codigo de impressao de string
	la $a0, msg_ePalindromo	# parametro
	syscall
	j encerraPrograma