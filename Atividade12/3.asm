.data
    prompt_n: .asciiz "Enter the number of elements (n): "
    prompt_elem: .asciiz "Enter the elements: "
    result_msg: .asciiz "The GCD of the sequence is: "
    array: .space 400    # Espaço para armazenar até 100 inteiros (assumindo 4 bytes por inteiro)
    n: .word 0
    result: .word 0

.text
.globl main

# Função principal
main:
    # Ler o valor de n
    li $v0, 4
    la $a0, prompt_n
    syscall
    li $v0, 5
    syscall
    sw $v0, n
    
    # Carregar o valor de n
    lw $t0, n

    # Ler a sequência de n inteiros
    la $t1, array
    li $t2, 0
read_elements:
    beq $t2, $t0, read_done
    li $v0, 4
    la $a0, prompt_elem
    syscall
    li $v0, 5
    syscall
    sw $v0, 0($t1)
    addi $t1, $t1, 4
    addi $t2, $t2, 1
    j read_elements
read_done:

    # Inicializar o MDC com o primeiro elemento da sequência
    la $t1, array
    lw $a0, 0($t1)   # $a0 = array[0]
    addi $t1, $t1, 4
    addi $t2, $zero, 1

calculate_gcd:
    beq $t2, $t0, calc_done  # Se t2 == n, fim da iteração
    lw $a1, 0($t1)           # $a1 = array[t2]
    jal mdc                  # Chamar a função mdc(a0, a1)
    move $a0, $v0            # Atualizar o MDC com o valor retornado
    addi $t1, $t1, 4
    addi $t2, $t2, 1
    j calculate_gcd

calc_done:
    # Armazenar o resultado
    sw $a0, result

    # Exibir o resultado
    li $v0, 4
    la $a0, result_msg
    syscall
    lw $a0, result
    li $v0, 1
    syscall
    
    # Terminar o programa
    li $v0, 10
    syscall

# Função mdc(a, b)
# Parâmetros: $a0 = a, $a1 = b
# Retorno: $v0 = MDC(a, b)
mdc:
    # Verificar se b é 0
    beq $a1, $zero, mdc_done
    
    # Calcular a % b
    div $a0, $a1
    mfhi $t0    # $t0 = a % b
    
    # Chamar recursivamente mdc(b, a % b)
    move $a0, $a1
    move $a1, $t0
    jal mdc
    
    jr $ra

mdc_done:
    # Retornar a como o MDC
    move $v0, $a0
    jr $ra
