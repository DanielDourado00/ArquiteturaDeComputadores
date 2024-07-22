.include "DDmacros2.asm"
.data
A:      .word   0, 0, 1, 0
        .word   1, 0, 0, 1
        .word   0, 0, 0, 1
        .word   0, 1, 0, 0
n:      .word   4  # Tamanho

.text
.globl main

main:
    # Carrega endereço da matriz A
    la $a0, A

    # Carrega o tamanho da matriz (n)
    lw $t0, n

    # Chama a função para verificar se a matriz é de permutação
    jal is_permutation

    # Verifica o resultado
    beq $v0, 1, permutation_true
    j permutation_false

permutation_true:
    # A matriz é de permutação
    print_str("A matriz A eh uma matriz de permutacao.\n")
    j end

permutation_false:
    # A matriz não é de permutação
    print_str("A matriz A nao eh uma matriz de permutacao.\n")
    j end

end:
    # Termina o programa
    terminate

is_permutation:
    # $a0: Endereço da matriz
    # $t0: Tamanho da matriz

    # Inicializa i = 0
    li $t1, 0

loop_rows:
    # Inicializa contador de 1's na linha
    li $t3, 0

    # Inicializa j = 0
    li $t2, 0

    loop_cols:
        # Calcula o deslocamento para o elemento atual
        mul $t4, $t1, $t0
        add $t4, $t4, $t2
        sll $t4, $t4, 2 # Multiplica por 4 para obter o deslocamento em bytes

        # Carrega o elemento atual
        lw $t5, 0($a0)

        # Verifica se o elemento atual é igual a 1
        beq $t5, 1, check_row

        addi $t2, $t2, 1
        blt $t2, $t0, loop_cols
        j next_row

check_row:
        # Conta 1's na linha
        addi $t3, $t3, 1

        # Verifica se há mais de um elemento igual a 1 na linha
        bgt $t3, 1, permutation_false

        addi $t2, $t2, 1
        blt $t2, $t0, loop_cols

    # Verifica se a linha possui exatamente um 1
    beq $t3, 1, next_row
    j permutation_false

next_row:
    # Atualiza i = i + 1
    addi $t1, $t1, 1

    # Verifica se i < n
    blt $t1, $t0, loop_rows

    # Se a matriz passou por todas as verificações, então é uma matriz de permutação
    li $v0, 1
    jr $ra

# Função para imprimir uma string
print_str:
    # $a0: Endereço da string

    loop:
        lb $a0, 0($a0) # Carrega o caractere atual
        beqz $a0, end_print # Se chegar ao final da string, termina
        li $v0, 11 # Código da syscall para imprimir um caractere
        syscall
        addi $a0, $a0, 1 # Move para o próximo caractere
        j loop

    end_print:
        jr $ra # Retorna

# Função para terminar o programa
terminate:
    li $v0, 10 # Código da syscall para terminar o programa
    syscall


