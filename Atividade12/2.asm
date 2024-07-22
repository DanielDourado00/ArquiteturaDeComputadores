.data
    result: .word 0    # Armazena o resultado do MDC
    prompt_a: .asciiz "Enter the first number (a): "
    prompt_b: .asciiz "Enter the second number (b): "
    result_msg: .asciiz "The GCD is: "

.text
.globl main

# Função principal
main:
    # Ler o valor de a
    li $v0, 4
    la $a0, prompt_a
    syscall
    li $v0, 5
    syscall
    move $a0, $v0
    
    # Ler o valor de b
    li $v0, 4
    la $a0, prompt_b
    syscall
    li $v0, 5
    syscall
    move $a1, $v0
    
    # Chamar a função mdc
    jal mdc
    
    # Armazenar o resultado
    sw $v0, result

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
