.data
    matrix: .space 100    # Espaço para armazenar a matriz 5x5 (25 ints)
    prompt: .asciiz "Enter a number: "
    newLine: .asciiz "\n"
    space: .asciiz " "
    x: .word 0
    y: .word 0

.text
main:
    # Ler a matriz 5x5
    la $t0, matrix
    li $t1, 25
read_matrix:
    beqz $t1, read_done
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    sw $v0, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    j read_matrix
read_done:

    # Exibir a matriz 5x5
    la $t0, matrix
    li $t1, 5
print_matrix:
    li $t2, 5
print_row:
    lw $t3, 0($t0)
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, space
    syscall
    addi $t0, $t0, 4
    addi $t2, $t2, -1
    bnez $t2, print_row
    li $v0, 4
    la $a0, newLine
    syscall
    addi $t1, $t1, -1
    bnez $t1, print_matrix

    # Ler x e y
    li $v0, 4
    la $a0, newLine
    syscall
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    sw $v0, x
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    sw $v0, y

    # Carregar x e y
    lw $t4, x
    lw $t5, y

    # Trocar a x-ésima linha pela y-ésima linha
    la $t0, matrix
    li $t1, 5
    mul $t6, $t4, 20
    add $t6, $t0, $t6
    mul $t7, $t5, 20
    add $t7, $t0, $t7
swap_rows:
    lw $t8, 0($t6)
    lw $t9, 0($t7)
    sw $t9, 0($t6)
    sw $t8, 0($t7)
    addi $t6, $t6, 4
    addi $t7, $t7, 4
    addi $t1, $t1, -1
    bnez $t1, swap_rows

    # Trocar a x-ésima coluna pela y-ésima coluna
    la $t0, matrix
    li $t1, 5
swap_columns:
    mul $t6, $t1, 20
    add $t6, $t0, $t6
    add $t6, $t6, $t4
    mul $t7, $t1, 20
    add $t7, $t0, $t7
    add $t7, $t7, $t5
    lw $t8, 0($t6)
    lw $t9, 0($t7)
    sw $t9, 0($t6)
    sw $t8, 0($t7)
    addi $t1, $t1, -1
    bnez $t1, swap_columns

    # Trocar a diagonal principal pela diagonal secundária
    la $t0, matrix
    li $t1, 0
swap_diagonals:
    mul $t6, $t1, 24
    add $t6, $t0, $t6
    lw $t8, 0($t6)
    mul $t7, $t1, 16
    add $t7, $t0, $t7
    add $t7, $t7, 16
    lw $t9, 0($t7)
    sw $t9, 0($t6)
    sw $t8, 0($t7)
    addi $t1, $t1, 4
    li $t3, 4
    bgez $t1, swap_diagonals_end
swap_diagonals_end:

    # Exibir a matriz modificada
    la $t0, matrix
    li $t1, 5
print_matrix_modified:
    li $t2, 5
print_row_modified:
    lw $t3, 0($t0)
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, space
    syscall
    addi $t0, $t0, 4
    addi $t2, $t2, -1
    bnez $t2, print_row_modified
    li $v0, 4
    la $a0, newLine
    syscall
    addi $t1, $t1, -1
    bnez $t1, print_matrix_modified

    # Terminar o programa
    li $v0, 10
    syscall
