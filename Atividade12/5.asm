.data
    prompt_n: .asciiz "Enter a non-negative integer (n): "
    result_true: .asciiz "The number is triangular.\n"
    result_false: .asciiz "The number is not triangular.\n"
    n: .word 0          # Armazena o valor de n
    k: .word 0          # Variável para k
    product: .word 0    # Variável para armazenar k*(k+1)*(k+2)

.text
.globl main

main:
    # Ler o valor de n
    li $v0, 4
    la $a0, prompt_n
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    sw $t0, n

    # Inicializar k com 1
    li $t1, 1

check_triangular:
    # Calcular k*(k+1)*(k+2)
    lw $t1, k
    add $t2, $t1, 1      # t2 = k + 1
    add $t3, $t1, 2      # t3 = k + 2
    mul $t4, $t1, $t2    # t4 = k * (k + 1)
    mul $t4, $t4, $t3    # t4 = k * (k + 1) * (k + 2)
    sw $t4, product
    
    # Comparar com n
    lw $t0, n
    lw $t4, product
    beq $t0, $t4, is_triangular   # Se k*(k+1)*(k+2) == n, n é triangular
    
    # Se o produto ultrapassar n, n não é triangular
    bgt $t4, $t0, not_triangular

    # Incrementar k
    lw $t1, k
    addi $t1, $t1, 1
    sw $t1, k
    j check_triangular

is_triangular:
    # Exibir mensagem de número triangular
    li $v0, 4
    la $a0, result_true
    syscall
    j end_program

not_triangular:
    # Exibir mensagem de número não triangular
    li $v0, 4
    la $a0, result_false
    syscall

end_program:
    # Terminar o programa
    li $v0, 10
    syscall
