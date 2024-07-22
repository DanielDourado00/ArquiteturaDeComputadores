.data
    promptA: .asciiz "Digite as dimensões da matriz A (m n): "
    promptB: .asciiz "Digite as dimensões da matriz B (n k): "
    promptElementsA: .asciiz "Digite os elementos da matriz A: "
    promptElementsB: .asciiz "Digite os elementos da matriz B: "
    promptResult: .asciiz "A matriz resultante C é:\n"
    newline: .asciiz "\n"
    space: .asciiz " "

.text
.globl main

main:
    # Leitura das dimensões das matrizes
    la $a0, promptA
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $t0, $v0  # m

    li $v0, 5
    syscall
    move $t1, $v0  # n

    la $a0, promptB
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $t2, $v0  # n (confirmar que é o mesmo valor de n)

    li $v0, 5
    syscall
    move $t3, $v0  # k

    # Verificar se as dimensões são compatíveis para multiplicação
    bne $t1, $t2, error

    # Alocar memória para a matriz A (m x n)
    move $a0, $t0        # número de linhas
    move $a1, $t1        # número de colunas
    jal allocate_matrix
    move $s0, $v0        # endereço da matriz A

    # Alocar memória para a matriz B (n x k)
    move $a0, $t1        # número de linhas
    move $a1, $t3        # número de colunas
    jal allocate_matrix
    move $s1, $v0        # endereço da matriz B

    # Alocar memória para a matriz C (m x k)
    move $a0, $t0        # número de linhas
    move $a1, $t3        # número de colunas
    jal allocate_matrix
    move $s2, $v0        # endereço da matriz C

    # Leitura dos elementos da matriz A
    la $a0, promptElementsA
    li $v0, 4
    syscall

    move $a0, $s0
    move $a1, $t0
    move $a2, $t1
    jal read_matrix

    # Leitura dos elementos da matriz B
    la $a0, promptElementsB
    li $v0, 4
    syscall

    move $a0, $s1
    move $a1, $t1
    move $a2, $t3
    jal read_matrix

    # Multiplicar matrizes A e B, armazenar resultado em C
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    move $a3, $t0
    move $t4, $t1
    move $t5, $t3
    jal multiply_matrices

    # Imprimir matriz C
    la $a0, promptResult
    li $v0, 4
    syscall

    move $a0, $s2
    move $a1, $t0
    move $a2, $t3
    jal print_matrix

    # Encerrar programa
    li $v0, 10
    syscall

allocate_matrix:
    # Allocate a matrix with dimensions a0 x a1
    # Entrada: $a0 = rows, $a1 = cols
    # Saída: $v0 = address of the allocated matrix
    li $t6, 4          # size of int
    mul $t7, $a0, $a1  # rows * cols
    mul $t7, $t7, $t6  # total size in bytes

    li $v0, 9          # sbrk syscall
    move $a0, $t7
    syscall

    jr $ra

read_matrix:
    # Read a matrix from input
    # Entrada: $a0 = address, $a1 = rows, $a2 = cols
    li $t6, 0

read_matrix_loop:
    beq $t6, $a1, read_matrix_end

    li $t7, 0
read_matrix_row_loop:
    beq $t7, $a2, read_matrix_next_row

    li $v0, 5
    syscall

    sll $t8, $t6, 2
    mul $t8, $t8, $a2
    sll $t9, $t7, 2
    add $t8, $t8, $t9
    sw $v0, 0($a0)

    addi $a0, $a0, 4
    addi $t7, $t7, 1
    j read_matrix_row_loop

read_matrix_next_row:
    addi $t6, $t6, 1
    j read_matrix_loop

read_matrix_end:
    jr $ra

multiply_matrices:
    # Multiply matrices A and B and store result in C
    # Entrada: $a0 = address of A, $a1 = address of B, $a2 = address of C, $a3 = m, $t4 = n, $t5 = k
    move $t0, $zero

multiply_matrices_outer:
    beq $t0, $a3, multiply_matrices_end

    move $t1, $zero
multiply_matrices_inner:
    beq $t1, $t5, multiply_matrices_next_row

    move $t2, $zero
    move $t3, $zero
multiply_matrices_dot:
    beq $t2, $t4, multiply_matrices_sum

    sll $t6, $t0, 2
    mul $t6, $t6, $t4
    sll $t7, $t2, 2
    add $t6, $t6, $t7
    lw $t8, 0($a0)

    sll $t9, $t2, 2
    mul $t9, $t9, $t5
    sll $t7, $t1, 2
    add $t9, $t9, $t7
    lw $t10, 0($a1)

    mul $t11, $t8, $t10
    add $t3, $t3, $t11

    addi $a0, $a0, 4
    addi $a1, $a1, 4
    addi $t2, $t2, 1
    j multiply_matrices_dot

multiply_matrices_sum:
    sll $t6, $t0, 2
    mul $t6, $t6, $t5
    sll $t7, $t1, 2
    add $t6, $t6, $t7
    sw $t3, 0($a2)

    addi $a2, $a2, 4
    addi $t1, $t1, 1
    j multiply_matrices_inner

multiply_matrices_next_row:
    addi $t0, $t0, 1
    j multiply_matrices_outer

multiply_matrices_end:
    jr $ra

print_matrix:
    # Print a matrix
    # Entrada: $a0 = address, $a1 = rows, $a2 = cols
    li $t6, 0

print_matrix_loop:
    beq $t6, $a1, print_matrix_end

    li $t7, 0
print_matrix_row_loop:
    beq $t7, $a2, print_matrix_next_row

    lw $t8, 0($a0)
    move $a0, $t8
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall

    addi $a0, $a0, 4
    addi $t7, $t7, 1
    j print_matrix_row_loop

print_matrix_next_row:
    la $a0, newline
    li $v0, 4
    syscall

    addi $t6, $t6, 1
    j print_matrix_loop

print_matrix_end:
    jr $ra

error:
    la $a0, newline
    li $v0, 4
    syscall
    li $v0, 10
    syscall
