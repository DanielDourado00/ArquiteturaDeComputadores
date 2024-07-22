#catalan
.data
prompt: .asciiz "Digite o valor de N: "
result: .asciiz "O N-ésimo número de Catalan é: "

.text
main:
    # Imprime o prompt para digitar N
    li $v0, 4
    la $a0, prompt
    syscall

    # Lê o valor de N
    li $v0, 5
    syscall
    move $a0, $v0   # Move o valor de N para o primeiro argumento

    # Chama a função para calcular o N-ésimo número de Catalan
    jal catalan

    # Imprime o resultado
    li $v0, 4
    la $a0, result
    syscall

    move $a0, $v0   # Move o resultado para imprimir
    li $v0, 1
    syscall

    # Termina o programa
    li $v0, 10
    syscall

# Procedimento recursivo para calcular o N-ésimo número de Catalan
catalan:
    # Verifica se N é igual a 0 ou 1
    beq $a0, $zero, return_one   # Se N for 0, retorna 1
    beq $a0, $1, return_one      # Se N for 1, retorna 1

    # Cálculo do N-ésimo número de Catalan
    addi $a0, $a0, -1   # N - 1
    jal catalan         # Chama a função recursivamente para N - 1
    move $t0, $v0       # Salva o resultado em $t0

    move $a0, $t0       # Move o resultado para o primeiro argumento
    addi $a0, $a0, -1   # N - 2
    jal catalan         # Chama a função recursivamente para N - 2
    move $t1, $v0       # Salva o resultado em $t1

    add $v0, $t0, $t1  # Soma os resultados para obter o N-ésimo número de Catalan

    jr $ra              # Retorna

return_one:
    li $v0, 1           # Retorna 1
    li $v0, 1
    jr $ra              # Retorna
