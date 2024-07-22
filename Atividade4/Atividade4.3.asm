.include "DDmacros2.asm"


#falta so o item de fazer a somatoria da diag princ acima a baixo e subtrair

.data
	Mat: .space 62 # 4x4 * 4 (inteiro)
	
.text
	main:
	print_str("\nA matriz é quadrada de ordem 4: ")
	li $a1, 4 # Numero de linhas e colunas
	  
	la $a0, Mat # Endereco base de Mat
      	addi $a2, $a1, 0 # Numero de colunas
      	jal leitura # leitura(mat, nlin, ncol)
      	move $a0, $v0 # Endereco da matriz lida
      	jal escrita # escrita(mat, nlin, ncol)
      	
      	
      	li $s0, 9999 # Ao final, o menor valor abaixo da diagonal principal estar em $s0
      	li $s1, -9999 # Ao final, o maior valor acima da diagonal principal estar em $s1
      	li $s2, 0 # A = Soma dos valores acima da diag prin
      	li $s3, 0 # B = Soma dos valores abaixo da diag prin
      	li $s4, 0 # Subtracao A-B
      	
      	move $a0, $v0
      	jal menor_maior
      	
      	#print_str("\n valor do acumulador acima da diag principal: ")
      #	print_int($s5)
      	
      	#print_str("\n valor do acumulador abaixo da diag principal: ")
      	#print_int($s6)
      	
      	print_str("\n Soma dos elementos acima da diag principal: ")
      	print_int($s5)
      	print_str("\n Soma dos elementos abaixo da diag principal: ")
      	print_int($s6)
      	
      	sub $s7, $s5, $s6
      	print_str("\n Subtracao entre ambas: ")
      	print_int($s7)
      	print_str("\n Menor elemento abaixo da diagonal principal: ")
      	print_int($s0)
      	print_str("\n Maior elemento acima da diagonal principal: ")
      	print_int($s1)
      
      	
      	la $a0, Mat
      	move $a0, $v0
      	mul $s0, $a1, $a1
      	
      	print_str("\n\n Matriz ordenada em ordem crescente: \n")
      	sort_array(Mat, $s0)  #vetor e tamanho
      	
		li $t1, 0
		la $t2, Mat
		li $t7, 0
		loop_print:	
				beq $s0, $t1, exit  # Se tamanho máximo do vetor ja foi alcan�ado, encerrar
				sll $t3, $t1, 2  # Reg temp $t1 = 4*i (indice atual do vetor)
				add $t3, $t3, $t2  # Carregando em $t1 = endere�o de vetor[i] 
				lw $t4, 0($t3)  # $t2 = valor de vetor[i]
				print_int($t4)
				print_str(" ")
				addi $t1, $t1, 1  # Atualizando i = i+1
				addi $t7, $t7, 1
				bne $t7, $a1, loop_print
				print_str("\n")
				li $t7, 0
				j loop_print
		exit:
      	
		terminate
		
################leitura##################		
	
	indice:
		mul $v0, $t0, $a2 # i * ncol
   		add $v0, $v0, $t1 # (i * ncol) + j
   		sll $v0, $v0, 2 # [(i * ncol) + j] * 4 (inteiro)
   		add $v0, $v0, $a3 # Soma o endereco base de mat
   		jr $ra # Retorna para o caller
   
	leitura:
   		subi $sp, $sp, 4 # Espa�o para 1 item na pilha
   		sw $ra, ($sp) # Salva o retorno para a main
   		move $a3, $a0 # aux = endere�o base de mat
	l:
		print_str(" Insira o valor de Mat[") 
		print_int($t0)
   		print_str("][")
   		print_int($t1)
   		print_str("]: ")
   		li $v0, 5 # Codigo de leitura de inteiro
   		syscall # Leitura do valor (retorna em $v0)
   		move $t2, $v0 # aux = valor lido
   		jal indice # Calcula o endereco de mat[i][j]
   		sw $t2, ($v0) # mat[i][j] = aux
   		bgt $t1, $t0, acimaDiagonal
		bgt $t0, $t1, abaixoDiagonal
	return:
   		addi $t1, $t1, 1 # j++
   		blt $t1, $a2, l # if(j < ncol) goto l
   		li $t1, 0 # j = 0
   		addi $t0, $t0, 1 # i++
   		blt $t0, $a1, l # if(i < nlin) goto l
   		li $t0, 0 # i = 0
   		lw $ra, ($sp) # Recupera o retorno para a main
   		addi $sp, $sp, 4 # Libera o espaco na pilha
   		move $v0, $a3 # Endereco base da matriz para retorno
		jr $ra # Retorna para a main	
		
	escrita:
   		subi $sp, $sp, 4 # Espaco para 1 item na pilha
   		sw $ra, ($sp) # Salva o retorno para a main
   		move $a3, $a0 # aux = endereco base de mat
	e:
		jal indice # Calcula o endereco de mat[i][j]
   		lw $a0, ($v0) # Valor em mat[i][j]
   		li $v0, 1 # Codigo de impressao de inteiro
   		syscall # Imprime mat[i][j]
   		print_str(" ")
   		addi $t1, $t1, 1 # j++
   		blt $t1, $a2, e # if(j < ncol) goto e
   		print_str("\n")
   		li $t1, 0 # j = 0
   		addi $t0, $t0, 1 # i++
   		blt $t0, $a1, e # if(i < nlin) goto e
   		li $t0, 0 # i = 0
	   	lw $ra, ($sp) # Recupera o retorno para a main
   		addi $sp, $sp, 4 # Libera o espaco na pilha
  		move $v0, $a3 # Endereco base da matriz para retorno
   		jr $ra # Retorna para a main
   		
   		
   		
   		
   		
 ################funcoes para determinar maior ou menor elemento #################
   		
   	## Os elementos abaixo da diag princ tem i > j, ou seja, $t0 > $t1 	
   	## enquanto os elementos acima da diag princ t�m i < j, ou seja, $t0 < $t1
   	menor_maior:
   		subi $sp, $sp, 4 # Espaco para 1 item na pilha
   		sw $ra, ($sp) # Salva o retorno para a main
   		move $a3, $a0 # aux = endereco base de mat
	shared:
		jal indice # Calcula o endereco de mat[i][j]
   		lw $a0, ($v0) # Valor em mat[i][j]
   		beq $t0, $t1, next
   		bgt $t0, $t1, menor # $t0 > $t1 vai pra menor
   		maior:
   		add $s2, $s2, $a0
   		blt $a0, $s1, next
   		move $s1, $a0
   		j next
   		menor: 
   		add $s3, $s3, $a0 # soma dos abaixo
   		bgt $a0, $s0, next # se valor em $a0 for maior que o de $s0, nao troca
   		move $s0, $a0 # colocando em $s0 o menor valor
   		
   		next:
   			addi $t1, $t1, 1 # j++
   			blt $t1, $a2, shared # if(j < ncol) goto e
   			li $t1, 0 # j = 0
   			addi $t0, $t0, 1 # i++
   			blt $t0, $a1, shared # if(i < nlin) goto e
   			li $t0, 0 # i = 0
	   		lw $ra, ($sp) # Recupera o retorno para a main
   			addi $sp, $sp, 4 # Libera o espaco na pilha
  			move $v0, $a3 # Endereco base da matriz para retorno
   			jr $ra # Retorna para a main
   			
   			
################funcoes para somar elementos acima e abaixo da diag principal #################	
	acimaDiagonal:
		add $s5, $s5, $t2	# Adiciona o valor lido ao acumulador de elementos acima da diagonal principal
		j return	# Retorna ao ponto de chamada

	abaixoDiagonal:
		add $s6, $s6, $t2	# Adiciona o valor lido ao acumulador de elementos abaixo da diagonal principal
		j return	# Retorna ao ponto de chamada

   			
   			
   			
  
   			