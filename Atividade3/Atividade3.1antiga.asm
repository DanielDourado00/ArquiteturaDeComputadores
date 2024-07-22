.include "DDmacros2.asm"
.data
A:      .word   1, 2, 3
        .word   4, 5, 6
        .word   7, 8, 9
        .word   10, 11, 12
V:      .word   2, 3, 4
result: .space  12 # Espaço para armazenar o resultado (4 linhas x 3 colunas)

.text
.globl main

main:
    # Carrega endereços das matrizes A e V
    la $a0, A
    la $a1, V
    la $a2, result

    # Chama a função de multiplicação de matriz por vetor
    jal multiply

    # Imprime a matriz resultante
    li $t0, 4 # Número de linhas
    li $t1, 3 # Número de colunas
    move $a0, $a2 # Endereço da matriz resultante
    move $a1, $t0 # Número de linhas
    move $a2, $t1 # Número de colunas
    jal print_matrix

    # Termina o programa
    terminate

multiply:
    # Inicializa i = 0
    li $t0, 0
    
    loop_rows:
        # Inicializa j = 0
        li $t1, 0
        
        loop_cols:
            # Carrega A[i][j]
            lw $t2, 0($a0)

            # Carrega V[j]
            lw $t3, 0($a1)

            # Calcula A[i][j] * V[j]
            mul $t4, $t2, $t3

            # Carrega o endereço da matriz resultante
            move $t5, $a2

            # Calcula o offset para a posição correta na matriz resultante
            mul $t6, $t0, 12 # 4 * 3 (número de colunas)
            add $t6, $t6, $t1 # Adiciona o índice da coluna
            sll $t6, $t6, 2 # Multiplica por 4 para obter o deslocamento em bytes

            # Soma o offset ao endereço base da matriz resultante
            add $t5, $t5, $t6

            # Armazena o resultado na matriz resultante
            sw $t4, 0($t5)

            # Atualiza j = j + 1
            addi $t1, $t1, 1

            # Move para o próximo elemento de V
            addi $a1, $a1, 4

            # Verifica se j < 3
            blt $t1, 3, loop_cols
        
        # Atualiza i = i + 1
        addi $t0, $t0, 1

        # Move para a próxima linha de A
        addi $a0, $a0, 12 # 3 * 4 (número de colunas * tamanho do inteiro)

        # Verifica se i < 4
        blt $t0, 4, loop_rows
    
    # Retorna
    jr $ra

# Printa uma matriz
# Argumentos:
# $a0: endereço base da matriz
# $a1: número de linhas
# $a2: número de colunas
print_matrix:
    li $t0, 0 # i = 0
    loop_print_rows:
        li $t1, 0 # j = 0
        loop_print_cols:
            mul $t2, $t0, $a2 # i * num_colunas
            add $t2, $t2, $t1 # i * num_colunas + j
            sll $t2, $t2, 2 # (i * num_colunas + j) * 4 (para obter o deslocamento em bytes)
            add $t3, $a0, $t2 # Endereço do elemento da matriz

            # Printa o elemento
            lw $a0, 0($t3)
            li $v0, 1
            syscall

            # Printa espaço
            li $a0, 32 # Código ASCII para espaço
            li $v0, 11
            syscall

            # Atualiza j = j + 1
            addi $t1, $t1, 1
            # Verifica se j < num_colunas
            blt $t1, $a2, loop_print_cols

        # Printa nova linha
        li $a0, 10 # Código ASCII para nova linha
        li $v0, 11
        syscall

        # Atualiza i = i + 1
        addi $t0, $t0, 1
        # Verifica se i < num_linhas
        blt $t0, $a1, loop_print_rows
    
    # Retorna
    jr $ra

# Termina o programa
terminate:
    li $v0, 10 # Código para syscall de término
    syscall
