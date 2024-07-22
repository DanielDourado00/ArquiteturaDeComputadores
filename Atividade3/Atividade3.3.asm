.data
    matriz: .space 400 # reserva espaço para a matriz de 10x10
.text
    main:
        # inicializa os valores de m e n
        li $s0, 10 # m = 10
        li $s1, 10 # n = 10
        
        # inicializa os contadores de linhas e colunas nulas
        li $v0, 0 # linhas nulas = 0
        li $v1, 0 # colunas nulas = 0
        
        # inicializa os índices de linha e coluna
        li $t0, 0 # i = 0
        li $t1, 0 # j = 0
        
        # inicializa o endereço base da matriz
        la $t2, matriz # $t2 = 0x10010000
        
        # loop para verificar as linhas
        loop_linhas:
            # verifica se o índice de linha é menor que m
            bge $t0, $s0, fim_linhas # se i >= m, sai do loop
            
            # inicializa a soma dos elementos da linha
            li $t3, 0 # soma = 0
            
            # loop para somar os elementos da linha
            loop_soma:
                # verifica se o índice de coluna é menor que n
                bge $t1, $s1, fim_soma # se j >= n, sai do loop
                
                # calcula o deslocamento do elemento atual
                mul $t4, $t0, $s1 # $t4 = i * n
                add $t4, $t4, $t1 # $t4 = i * n + j
                sll $t4, $t4, 2 # $t4 = (i * n + j) * 4
                
                # carrega o elemento atual da matriz
                add $t5, $t2, $t4 # $t5 = endereço do elemento atual
                lw $t6, 0($t5) # $t6 = valor do elemento atual
                
                # soma o elemento atual à soma da linha
                add $t3, $t3, $t6 # soma = soma + elemento
                
                # incrementa o índice de coluna
                addi $t1, $t1, 1 # j = j + 1
                
                # volta para o loop de soma
                j loop_soma
            
            # fim do loop de soma
            fim_soma:
            
            # verifica se a soma da linha é zero
            beqz $t3, linha_nula # se soma == 0, incrementa o contador de linhas nulas
            
            # caso contrário, continua o loop de linhas
            j continua_linhas
            
            # incrementa o contador de linhas nulas
            linha_nula:
                addi $v0, $v0, 1 # linhas nulas = linhas nulas + 1
            
            # continua o loop de linhas
            continua_linhas:
            
            # zera o índice de coluna
            li $t1, 0 # j = 0
            
            # incrementa o índice de linha
            addi $t0, $t0, 1 # i = i + 1
            
            # volta para o loop de linhas
            j loop_linhas
        
        # fim do loop de linhas
        fim_linhas:
        
        # zera os índices de linha e coluna
        li $t0, 0 # i = 0
        li $t1, 0 # j = 0
        
        # loop para verificar as colunas
        loop_colunas:
            # verifica se o índice de coluna é menor que n
            bge $t1, $s1, fim_colunas # se j >= n, sai do loop
            
            # inicializa a soma dos elementos da coluna
            li $t3, 0 # soma = 0
            
            # loop para somar os elementos da coluna
            loop_soma2:
                # verifica se o índice de linha é menor que m
                bge $t0, $s0, fim_soma2 # se i >= m, sai do loop
                
                # calcula o deslocamento do elemento atual
                mul $t4, $t0, $s1 # $t4 = i * n
                add $t4, $t4, $t1 # $t4 = i * n + j
                sll $t4, $t4, 2 # $t4 = (i * n + j) * 4
                
                # carrega o elemento atual da matriz
                add $t5, $t2, $t4 # $t5 = endereço do elemento atual
                lw $t6, 0($t5) # $t6 = valor do elemento atual
                
                # soma o elemento atual à soma da coluna
                add $t3, $t3, $t6 # soma = soma + elemento
                
                # incrementa o índice de linha
                addi $t0, $t0, 1 # i = i + 1
                
                # volta para o loop de soma
                j loop_soma2
            
            # fim do loop de soma
            fim_soma2:
            
            # verifica se a soma da coluna é zero
            beqz $t3, coluna_nula # se soma == 0, incrementa o contador de colunas nulas
            
            # caso contrário, continua o loop de colunas
            j continua_colunas
            
            # incrementa o contador de colunas nulas
            coluna_nula:
                addi $v1, $v1, 1 # colunas nulas = colunas nulas + 1
            
            # continua o loop de colunas
            continua_colunas:
            
            # zera o índice de linha
            li $t0, 0 # i = 0
            
            # incrementa o índice de coluna
            addi $t1, $t1, 1 # j = j + 1
            
            # volta para o loop de colunas
            j loop_colunas
        
        # fim do loop de colunas
        fim_colunas:
        
        # termina o programa
        li $v0, 10 # syscall para encerrar
        syscall