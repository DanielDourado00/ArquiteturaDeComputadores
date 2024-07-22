# Definição de variáveis
.data
alphabet:   .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
n:          .word 3

# Inicialização
.text
main:
    li $t0, 0       # Inicializa o contador de combinações
    lw $t1, n       # Carrega o valor de n

    # Loop para gerar as combinações
    generate_combinations:
        move $a0, $t1       # Passa n como argumento para a função de permutação
        jal permutation      # Chama a função de permutação

        # Imprime a combinação
        move $a0, $v0       # Move o endereço da combinação para $a0
        jal print_string    # Chama a função para imprimir a string

        addi $t0, $t0, 1    # Incrementa o contador de combinações
        bne $t0, $t1, generate_combinations  # Loop enquanto não gerou todas as combinações

    # Finalização
    li $v0, 10      # Chamada de sistema para terminar o programa
    syscall

# Função para gerar permutações
permutation:
    addi $sp, $sp, -8       # Ajusta o ponteiro de pilha
    sw $ra, 4($sp)          # Salva o endereço de retorno
    sw $a0, 0($sp)          # Salva o valor de n

    move $t0, $a0           # Move n para $t0
    li $t1, 0               # Inicializa o contador de recursão
    jal generate_permutation   # Chama a função de permutação

    lw $ra, 4($sp)          # Restaura o endereço de retorno
    lw $a0, 0($sp)          # Restaura o valor de n
    addi $sp, $sp, 8        # Restaura o ponteiro de pilha
    jr $ra                  # Retorna

# Função recursiva para gerar permutações
generate_permutation:
    addi $sp, $sp, -16      # Ajusta o ponteiro de pilha
    sw $ra, 12($sp)         # Salva o endereço de retorno
    sw $s0, 8($sp)          # Salva o valor de $s0
    sw $s1, 4($sp)          # Salva o valor de $s1
    sw $s2, 0($sp)          # Salva o valor de $s2

    # Condição de parada da recursão
    bge $t1, $t0, end_permutation

    # Loop para gerar todas as permutações
    li $s0, 0               # Inicializa o contador de permutação
    generate_next_permutation:
        li $s1, 0               # Inicializa o contador de posição do alfabeto
        li $s2, 1               # Inicializa o indicador de flag para verificar se a letra foi usada

        check_used:
            bge $s1, $t0, end_check_used   # Verifica se já foram usadas todas as letras
            lb $t2, alphabet($s1)          # Carrega a letra do alfabeto
            beq $t2, 0, end_check_used     # Se encontrar o caractere nulo, termina o loop

            # Verifica se a letra já foi usada
            move $t3, $t1
            move $t4, $s1
            jal is_letter_used

            # Se a letra não foi usada, gera a próxima permutação
            beqz $v0, generate_next_permutation_done

            addi $s1, $s1, 1       # Incrementa o contador de posição do alfabeto
            j check_used

        end_check_used:

    generate_next_permutation_done:
        addi $s0, $s0, 1       # Incrementa o contador de permutação

        # Se encontrou todas as letras, imprime a permutação
        beq $s0, $t0, print_permutation

        j generate_next_permutation   # Gera a próxima permutação

    print_permutation:
        # Aloca espaço para a permutação
        addi $sp, $sp, -4
        sw $t1, 0($sp)

        # Copia a permutação para a pilha
        move $s1, $t1       # $s1 = n
        move $s2, $t0       # $s2 = contador de permutação
        move $s3, $t1       # $s3 = contador de posição do alfabeto
        move $s4, $sp       # $s4 = ponteiro para a pilha
        jal copy_permutation_to_stack

        # Imprime a permutação
        move $a0, $sp       # Move o endereço da permutação para $a0
        jal print_string    # Chama a função para imprimir a string

        # Desaloca espaço da permutação
        lw $t1, 0($sp)
        addi $sp, $sp, $t1
        j generate_next_permutation_done

    end_permutation:
        lw $ra, 12($sp)         # Restaura o endereço de retorno
        lw $s0, 8($sp)          # Restaura o valor de $s0
        lw $s1, 4($sp)          # Restaura o valor de $s1
        lw $s2, 0($sp)          # Restaura o valor de $s2
        addi $sp, $sp, 16       # Restaura o ponteiro de pilha
        jr $ra                  # Retorna

# Função para verificar se uma letra já foi usada na permutação
is_letter_used:
    move $v0, $zero         # Inicializa o resultado como falso

    # Loop para verificar se a letra já foi usada
    is_letter_used_loop:
        bge $t3, $zero, end_is_letter_used_loop   # Verifica se a posição na permutação é zero (caractere nulo)
        lw $t5, 0($s4)         # Carrega o valor atual na permutação
        beq $t5, $t4, set_letter_used     # Se encontrar a letra na permutação, define como usada

        addi $s4, $s4, 1       # Incrementa o ponteiro da pilha
        addi $t3, $t3, -1      # Decrementa o contador de posição da permutação
        j is_letter_used_loop

    set_letter_used:
        move $v0, $s2          # Define o resultado como verdadeiro
        jr $ra                  # Retorna

    end_is_letter_used_loop:
        jr $ra                  # Retorna

# Função para copiar a permutação para a pilha
copy_permutation_to_stack:
    # Cálculo da posição inicial na pilha
    mul $s5, $s1, $s2       # $s5 = n * contador de permutação
    add $s5, $s5, $s3       # $s5 = (n * contador de permutação) + contador de posição do alfabeto
    add $s5, $s5, $s5       # Multiplica por 2 para obter o deslocamento em bytes

    # Copia a letra para a pilha
    sb $t2, 0($s4)          # Armazena a letra na pilha
    addi $s4, $s4, 1        # Incrementa o ponteiro da pilha

    jr $ra                  # Retorna

# Função para imprimir uma string
print_string:
    # Loop para imprimir a string
    print_loop:
        lb $t0, 0($a0)          # Carrega o próximo caractere da string
        beqz $t0, end_print     # Se encontrar o caractere nulo, termina o loop
        li $v0, 11              # Chamada de sistema para imprimir um caractere
        syscall
        addi $a0, $a0, 1        # Incrementa o ponteiro da string
        j print_loop

    end_print:
    jr $ra                      # Retorna
