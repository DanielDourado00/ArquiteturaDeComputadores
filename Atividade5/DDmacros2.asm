.macro terminate
	addi $v0, $zero, 10  # Encerrando o programa
	syscall
.end_macro

.macro calloc(%size, %return)
	li $v0, 9
	la $a0, (%size)
	syscall
	la %return, ($v0) 
.end_macro

## PRINTS
.macro print_int(%x)
	add $a0, %x, $zero  # Carregando $a0 com int %x a printar
	addi $v0, $zero, 1  # Informando que o syscall deve printar int
	syscall
.end_macro

.macro print_float(%x)
	mov.s $f12, %x  # Carregando $a0 com float %x a printar
	li $v0, 2  # Informando que o syscall deve printar int
	syscall
.end_macro

.macro print_str(%str)
	.data
		toPrint: .asciiz %str
	.text	
	la $a0, toPrint  # Carregando em $a0 a string a printar (Separador)
	addi $v0, $zero, 4  # Informando que o syscall deve printar string
	syscall
.end_macro

.macro print_char(%c)
	move $a0, %c  # Carregando $a0 com o char %c a printar
	li $v0, 11  # Informando que o syscall deve printar char
	syscall
.end_macro 

## SCANS
.macro scan_int(%a)
	li $v0, 5  # Informando que o syscall deverá ler um int
	syscall
	add %a, $v0, $zero  # Armazenando A em $s0
.end_macro

.macro scan_float(%a)
	li $v0, 6  # Informando que o syscall deverá ler um float
	syscall
	mov.s %a, $f0
.end_macro

.macro scan_char(%a)
	addi $v0, $zero, 12  # Informando que o syscall deverá ler um float
	syscall
	add %a, $v0, $zero  # Armazenando A em $s0
.end_macro

.macro scan_str(%input, %size)
	li $v0, 8  # Informando que o syscall deverá ler uma string
	move $a0, %input  # Carregando em $a0 o endereço de memória da string a ser lida
	move $a1, %size  # Carregando em $a1 o tamanho máximo da string a ser lida
	syscall
.end_macro

.macro strcmp(%str1, %str2, %return)
	move $s0, %str1  # Carregando em $s0 o endereço da primeira string
	move $s7, %str2  # Carregando em $s7 o endereço da segunda string

	print_str("Comparando ")
	move $a0, $s0
	li $v0, 4
	syscall
	print_str(" com ")
	move $a0, $s7
	li $v0, 4
	syscall

	li $t5, 0      # inicializa contador de posição na string
	loop_strcmp:
		lbu $t2, ($s0) # carrega byte da primeira string
		lbu $t6, ($s7) # carrega byte da segunda string
		beqz $t2, end  # se chegar ao final da string, sai do loop
		bne $t2, $t6, dif # se os bytes são diferentes, sai do loop
		addi $s0, $s0, 1 # avança posição na primeira string
		addi $s7, $s7, 1 # avança posição na segunda string
		j loop_strcmp         # volta ao início do loop
	dif:
		li $v1, 1       # as strings são diferentes
		j return
	end:
		li $v1, 0       # as strings são iguais
	return:
		move %return, $v1
.end_macro

## ARRAYS
.macro scan_array(%array, %size)
	add $s0, %size, 0
	li $t1, 0
	li $t2, 0
	la $t3, %array
	loop_load:	
			beq $s0, $t2, exit
			sll $t4, $t1, 2  # Reg temp $t1 = 4*i (indice atual do vetor)
			add $t4, $t4, $t3  # Carregando em $t1 = endereço de vetor[i] 
			print_str("v[")
			print_int($t2)
			print_str("] = ")
			scan_int($t5)
			sw $t5, 0($t4)  # Armazenando valor de $t2 na posição [i] $t1 do vetor
			addi $t1, $t1, 1  # Iterador do vetor +1
			addi $t2, $t2, 1  # Iterador estético +1
			j loop_load
	exit:
.end_macro

.macro scan_array_din(%array, %size)
	add $s7, %size, 0
	li $t1, 0
	li $t2, 0
	loop_load:	
			beq $s7, $t2, exit
			sll $t4, $t1, 2  # Reg temp $t1 = 4*i (indice atual do vetor)
			add $t4, $t4, %array  # Carregando em $t1 = endereço de vetor[i] 
			print_str("v[")
			print_int($t2)
			print_str("] = ")
			scan_float($f1)
			s.s $f1, 0($t4)  # Armazenando valor real em $f1 na posição [i] $t4 do vetor
			addi $t1, $t1, 1  # Iterador do vetor +1
			addi $t2, $t2, 1  # Iterador estético +1
			j loop_load
	exit:
.end_macro

.macro print_array(%array, %size)
	add $s0, %size, 0
	li $t1, 0
	la $t2, %array
	loop_print:	
			beq $s0, $t1, exit  # Se tamanho máximo do vetor ja foi alcançado, encerrar
			sll $t3, $t1, 2  # Reg temp $t1 = 4*i (indice atual do vetor)
			add $t3, $t3, $t2  # Carregando em $t1 = endereço de vetor[i] 
			lw $t4, 0($t3)  # $t2 = valor de vetor[i]
			print_int($t4)
			print_str(" | ")
			addi $t1, $t1, 1  # Atualizando i = i+1
			j loop_print
	exit:
.end_macro

.macro print_array_din(%array, %size)
	add $s0, %size, 0
	li $t1, 0
	loop_print:	
			beq $s0, $t1, exit  # Se tamanho máximo do vetor ja foi alcançado, encerrar
			sll $t3, $t1, 2  # Reg temp $t1 = 4*i (indice atual do vetor)
			add $t3, $t3, %array  # Carregando em $t3 = endereço de vetor[i] 
			l.s $f2, 0($t3)  # $t2 = valor de vetor[i]
			print_float($f2)
			print_str(" | ")
			addi $t1, $t1, 1  # Atualizando i = i+1
			j loop_print
	exit:
.end_macro

.macro print_array_char(%array, %size)
	add $s0, %size, 0
	li $t1, 0
	la $t2, %array
	loop_print:	
			beq $s0, $t1, exit  # Se tamanho máximo do vetor ja foi alcançado, encerrar
			sll $t3, $t1, 2  # Reg temp $t1 = 4*i (indice atual do vetor)
			add $t3, $t3, $t2  # Carregando em $t1 = endereço de vetor[i] 
			lb $a0, 0($t3)  # $t2 = valor de vetor[i]
			li $v0, 11  # Informando que o syscall deve printar char
			syscall
			print_str(" | ")
			addi $t1, $t1, 1  # Atualizando i = i+1
			j loop_print
	exit:
.end_macro

.macro clean_string(%string)
	move $a0, %string
	li $t8, 0         # inicializa o contador de posição da string        
	cleaning:
		sll $t2, $t8, 0
		add $t2, $t2, $a0
		lb $t1, 0($t2)     # carrega o caractere
		beqz $t1, end_cleaning # termina o loop se o caractere é zero
		sb $zero, 0($t2)   # substitui o caractere por zero
		addi $t8, $t8, 1  # avança para o próximo caractere
		bnez $t1, cleaning    # repete o loop se o próximo caractere não é zero
	end_cleaning:
.end_macro

.macro sum_array(%array, %size, %sum)
	add $s0, %size, 0
	li $t1, 0  # Iterador
	la $t2, %array
	li $t3, 0  # Variável soma
	loop_sum:	
			beq $s0, $t1, exit  # Se tamanho máximo do vetor ja foi alcançado, encerrar
			sll $t4, $t1, 2  # Reg temp $t1 = 4*i (indice atual do vetor)
			add $t4, $t4, $t2  # Carregando em $t1 = endereço de vetor[i] 
			lw $t5, 0($t4)  # $t2 = valor de vetor[i]
			add $t3, $t3, $t5  # Amazenando no endereço fornecido a soma dos elementos do vetor
			addi $t1, $t1, 1  # Atualizando i = i+1
			j loop_sum
	exit:
		la %sum, ($t3)
.end_macro

.macro sum_pares(%array, %size, %sum)
	add $s0, %size, 0
	li $t5, 0  # Iterador
	la $t6, %array
	li $t7, 0  # Variável soma
	loop_sum:	
			beq $s0, $t5, exit  # Se tamanho máximo do vetor ja foi alcançado, encerrar
			sll $t1, $t5, 2  # Reg temp $t1 = 4*i (indice atual do vetor)
			add $t1, $t1, $t6  # Carregando em $t1 = endereço de vetor[i] 
			lw $t2, 0($t1)  # $t2 = valor de vetor[i]
			li $t8, 2
			div $t2, $t8   # Dividindo vet[i] por 2 para saber se é par
			mfhi $t3
			bne $t3, 0, repet  # Se o resto da divisão for diferente de 0, número ímpar não somar
			add $t7, $t7, $t2  # Amazenando no endereço fornecido a soma dos elementos do vetor
			repet:	
				addi $t5, $t5, 1  # Atualizando i = i+1
				j loop_sum
	exit:
		la %sum, ($t7)
.end_macro


.macro print_matrix(%matrix, %n, %m) # imprime matriz com n linhas e m colunas
	mul $t6, %n, %m
	li $t1, 0
	la $t2, %matrix
	li $t7, 0
	loop_print:	
			beq $t6, $t1, exit  # Se tamanho máximo do vetor ja foi alcan�ado, encerrar
			sll $t3, $t1, 2  # Reg temp $t1 = 4*i (indice atual do vetor)
			add $t3, $t3, $t2  # Carregando em $t1 = endere�o de vetor[i] 
			lb $a0, 0($t3)  # $a0 = valor de vetor[i]
			li $v0, 11  # Informando que o syscall deve printar char
			syscall
			print_str(" ")
			addi $t1, $t1, 1  # Atualizando i = i+1
			addi $t7, $t7, 1
			bne $t7, %m, loop_print
			print_str("\n")
			li $t7, 0
			j loop_print
		exit:
.end_macro

.macro init_array(%array, %size)

    li $t5, 0 # inicializa iterador com 0
    .data
		bigFloat: .float 9999.0
	.text
	lwc1 $f5, bigFloat
    loop:
        beq $t5, %size, exit # verifica se iterador >= tamanho do vetor, caso verdadeiro, pula para a sa�da
        sll $t7, $t5, 2 # multiplica iterador por 4 (tamanho de uma palavra) para obter o deslocamento de byte correspondente � posi��o do vetor
        add $t7, $t7, %array # adiciona deslocamento � base do vetor para obter o endere�o da posi��o atual
        s.s $f5, 0($t7) # armazena o valor na posi��o atual
        addi $t5, $t5, 1 # incrementa o iterador
        j loop # pula para o in�cio do loop
    exit:
.end_macro



#Ordenar vetor#

.macro sort_array(%array, %size)
	add $s0, %size, 0
	add $s5, $s0, -1  # $s5 = Tamanho do vetor -1 (pois são dois loops com essa condição de parada)
	la $s6, %array
	
	li $t6, 0  # i
	loop1:
		beq $t6, $s5, end1  # Se i = tamanho do vetor -1
		li $s3, 1  # auxiliar para acessar o vet[j+1]
		li $s4, 0  # j
		loop2:
			beq $s4, $s5, end2	# Se j = tamanho do vetor -1
			sll $t1, $s4, 2  # Reg temp $t1 = 4*j (indice atual do vetor)
			add $t1, $t1, $s6  # Carregando em $t1 = endereço de vetor[j]
			lw $t2, 0($t1)  # $t2 = valor de vetor[j]
			sll $t3, $s3, 2  # Reg temp $t3 = 4*j+1 (indice atual+1 do vetor)
			add $t3, $t3, $s6  # Carregando em $t3 = endereço de vetor[j+1] 
			lw $t4, 0($t3)  # $t4 = valor de vetor[j+1]
			
			sgt $t0, $t2, $t4  # Se vetor[j] > vetor[j+1], $t0=1
			bne $t0, 1, rept
			swap:
				add $t5, $t2, 0  # $t5 = vet[j] 
				sw $t4, 0($t1)  # vet[j] = vet[j+1], posição 0($t1) recebendo conteúdo de $t4  
				sw $t5, 0($t3)  # vet[j+1] = vet[j], posição 0($t3) recebendo conteúdo de $t5			
			rept:
				addi $s3, $s3, 1  # (j+1) = j+1
				addi $s4, $s4, 1  # j = j + 1
				j loop2
			
		end2:
			addi $t6, $t6, 1  # i = i + 1
			j loop1
	end1:
.end_macro
