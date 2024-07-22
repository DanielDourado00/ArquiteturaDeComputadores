.data
    prompt: .asciiz "Digite o CPF (xxxxxxxxx-xx): "
    invalid_msg: .asciiz "CPF invalido.\n"
    valid_msg: .asciiz "CPF valido.\n"
    input_buffer: .space 14 # Buffer para armazenar o CPF e o traço

.text
.globl main

main:
    # Imprimir prompt para entrada do CPF
    li $v0, 4
    la $a0, prompt
    syscall

    # Ler o CPF fornecido pelo usuário
    li $v0, 8
    la $a0, input_buffer
    li $a1, 14 # 11 dígitos + 1 traço + 2 dígitos verificadores
    syscall

    # Validar o CPF
    la $t0, input_buffer
    li $t1, 0   # Inicializar a soma para o primeiro dígito verificador
    li $t2, 0   # Inicializar a soma para o segundo dígito verificador

    # Calcular a soma para o primeiro dígito verificador
    li $t3, 10  # Peso inicial
    li $t4, 0   # Índice do dígito CPF
loop_first_digit:
    lb $t5, ($t0)  # Carregar o próximo dígito do CPF
    beq $t5, '-', continue_first_digit  # Ignorar o traço
    sub $t5, $t5, '0'  # Converter o caractere para número
    mul $t5, $t5, $t3  # Multiplicar pelo peso
    add $t1, $t1, $t5  # Adicionar ao total
    subi $t3, $t3, 1   # Decrementar o peso
    addi $t4, $t4, 1   # Incrementar o índice
    addi $t0, $t0, 1   # Avançar para o próximo dígito
    bne $t4, 9, loop_first_digit  # Verificar se ainda não chegou aos nove primeiros dígitos
    nop
continue_first_digit:

    # Calcular o primeiro dígito verificador
    rem $t1, $t1, 11
    bge $t1, 2, first_digit_not_zero
    li $t1, 0  # Se o resultado for menor que 2, o dígito verificador é zero
first_digit_not_zero:
    li $t6, 11       # Carregar 11 em um registrador
    sub $t1, $t6, $t1  # Subtrair de $t611

    # Calcular a soma para o segundo dígito verificador
    li $t3, 11  # Peso inicial
    li $t4, 0   # Resetar o índice do dígito CPF
    la $t0, input_buffer  # Reiniciar o ponteiro para o início do CPF
loop_second_digit:
    lb $t5, ($t0)  # Carregar o próximo dígito do CPF
    beq $t5, '-', continue_second_digit  # Ignorar o traço
    sub $t5, $t5, '0'  # Converter o caractere para número
    mul $t5, $t5, $t3  # Multiplicar pelo peso
    add $t2, $t2, $t5  # Adicionar ao total
    subi $t3, $t3, 1   # Decrementar o peso
    addi $t4, $t4, 1   # Incrementar o índice
    addi $t0, $t0, 1   # Avançar para o próximo dígito
    bne $t4, 10, loop_second_digit  # Verificar se ainda não chegou aos nove primeiros dígitos
    nop
continue_second_digit:

    # Calcular o segundo dígito verificador
    rem $t2, $t2, 11
    bge $t2, 2, second_digit_not_zero
    li $t2, 0  # Se o resultado for menor que 2, o dígito verificador é zero
second_digit_not_zero:
    li $t6, 11       # Carregar 11 em um registrador
    sub $t2, $t6, $t2  # Subtrair de $t6

    # Comparar os dígitos verificadores
    la $t0, input_buffer
    lb $t3, 11($t0)  # Primeiro dígito verificador
    sub $t3, $t3, '0'
    lb $t4, 12($t0)  # Segundo dígito verificador
    sub $t4, $t4, '0'

    # Verificar se o CPF é válido
    bne $t1, $t3, cpf_invalid
    bne $t2, $t4, cpf_invalid
    nop

    # Imprimir mensagem de CPF válido
    li $v0, 4
    la $a0, valid_msg
    syscall
    j exit_program

cpf_invalid:
    # Imprimir mensagem de CPF inválido
    li $v0, 4
    la $a0, invalid_msg
    syscall

exit_program:
    # Terminar o programa
    li $v0, 10
    syscall

