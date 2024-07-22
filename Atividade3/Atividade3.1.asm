.data
MatA: .space 48          # Reserva espaço para armazenar a matriz A de 4x3 elementos
V: .space 12             # Reserva espaço para armazenar o vetor V de 3 elementos
PromptMat: .asciiz "Insira o elemento A["    # Mensagem de solicitação para a matriz
PromptVec: .asciiz "Insira o elemento V["    # Mensagem de solicitação para o vetor
CloseBracket: .asciiz "]: "                   # Mensagem indicando o fechamento de um colchete

.text
main:
    # Leitura da matriz A
    la $a0, MatA          # Carrega o endereço base da matriz A
    li $a1, 4             # Define o número de linhas da matriz A
    li $a2, 3             # Define o número de colunas da matriz A
    jal leituraMatriz     # Chama a função para ler a matriz A

    # Leitura do vetor V
    la $a0, V             # Carrega o endereço base do vetor V
    li $a1, 3             # Define o tamanho do vetor V
    jal leituraVetor      # Chama a função para ler o vetor V

    # Cálculo do produto de A por V
    jal produtoMatrizVetor

    # Encerramento do programa
    li $v0, 10            # Define o código de syscall para encerrar o programa
    syscall

# Função para ler a matriz A
leituraMatriz:
    move $t0, $a0          # Copia o endereço base da matriz A para $t0
    li $t2, 0              # Inicializa o índice da linha com 0

    # Loop para percorrer as linhas da matriz
    m_row_loop:
        bge $t2, $a1, end_m_loop  # Se o índice da linha for maior ou igual ao número de linhas, encerra o loop
        li $t3, 0                 # Inicializa o índice da coluna com 0

        # Loop para percorrer as colunas da matriz
        m_col_loop:
            bge $t3, $a2, end_m_row_loop  # Se o índice da coluna for maior ou igual ao número de colunas, encerra o loop
            la $a0, PromptMat      # Carrega o endereço da mensagem de solicitação
            li $v0, 4              # Define o código de syscall para imprimir uma string
            syscall

            move $a0, $t2          # Passa o índice da linha como argumento para impressão
            li $v0, 1              # Define o código de syscall para imprimir um inteiro
            syscall

            la $a0, CloseBracket   # Carrega o endereço da mensagem de fechamento do colchete
            li $v0, 4              # Define o código de syscall para imprimir uma string
            syscall

            move $a0, $t3          # Passa o índice da coluna como argumento para impressão
            li $v0, 1              # Define o código de syscall para imprimir um inteiro
            syscall

            la $a0, CloseBracket   # Carrega o endereço da mensagem de fechamento do colchete
            li $v0, 4              # Define o código de syscall para imprimir uma string
            syscall

            li $v0, 5              # Define o código de syscall para ler um inteiro
            syscall
            sw $v0, 0($t0)         # Armazena o valor lido na matriz

            addi $t3, $t3, 1       # Incrementa o índice da coluna
            addi $t0, $t0, 4       # Avança para o próximo elemento na linha da matriz
            j m_col_loop           # Volta para o início do loop da coluna

        end_m_row_loop:
        addi $t2, $t2, 1           # Incrementa o índice da linha
        j m_row_loop                # Volta para o início do loop da linha

    end_m_loop:
    jr $ra                         # Retorna à chamada

# Função para ler o vetor V
leituraVetor:
    move $t0, $a0                  # Copia o endereço base do vetor V para $t0
    li $t1, 0                      # Inicializa o índice do vetor com 0

    # Loop para percorrer o vetor
    v_loop:
        bge $t1, $a1, end_v_loop   # Se o índice for maior ou igual ao tamanho do vetor, encerra o loop
        la $a0, PromptVec          # Carrega o endereço da mensagem de solicitação
        li $v0, 4                  # Define o código de syscall para imprimir uma string
        syscall

        move $a0, $t1              # Passa o índice atual como argumento para impressão
        li $v0, 1                  # Define o código de syscall para imprimir um inteiro
        syscall

        la $a0, CloseBracket       # Carrega o endereço da mensagem de fechamento do colchete
        li $v0, 4                  # Define o código de syscall para imprimir uma string
        syscall

        li $v0, 5                  # Define o código de syscall para ler um inteiro
        syscall
        sw $v0, 0($t0)             # Armazena o valor lido no vetor

        addi $t1, $t1, 1           # Incrementa o índice
        addi $t0, $t0, 4           # Avança para a próxima posição no vetor
        j v_loop                   # Volta para o início do loop

    end_v_loop:
    jr $ra                         # Retorna à chamada

# Função para calcular o produto de A por V
produtoMatrizVetor:
    li $t0, 0                      # Inicializa o índice da linha da matriz A com 0
    la $t1, MatA                   # Carrega o endereço base da matriz A para $t1
    la $t2, V                      # Carrega o endereço base do vetor V para $t2
    li $t3, 0                      # Inicializa um acumulador para o produto

    # Loop para percorrer as linhas da matriz A
    prod_loop:
        bge $t0, 4, end_prod_loop  # Se o índice da linha for maior ou igual ao número de linhas da matriz A, encerra o loop
        li $t4, 0                  # Inicializa o índice da coluna com 0

        # Loop para percorrer as colunas da matriz A
        col_loop:
            bge $t4, 3, next_row_loop  # Se o índice da coluna for maior ou igual ao número de colunas da matriz A, passa para a próxima linha
            lw $t5, 0($t1)            # Carrega o elemento da matriz A em $t5
            lw $t6, 0($t2)            # Carrega o elemento do vetor V em $t6
            mul $t5, $t5, $t6         # Multiplica o elemento da matriz pelo elemento do vetor
            add $t3, $t3, $t5         # Acumula o resultado no registrador $t3

            addi $t1, $t1, 4          # Avança para o próximo elemento na linha da matriz A
            addi $t2, $t2, 4          # Avança para o próximo elemento no vetor V
            addi $t4, $t4, 1          # Incrementa o índice da coluna
            j col_loop                # Volta para o início do loop da coluna

        next_row_loop:
        addi $t0, $t0, 1               # Incrementa o índice da linha
        j prod_loop                     # Volta para o início do loop da linha

    end_prod_loop:
    # Imprime o produto de A por V
    li $v0, 1                         # Define o código de syscall para imprimir um inteiro
    move $a0, $t3                     # Move o produto para $a0
    syscall

    jr $ra                           # Retorna à chamada
