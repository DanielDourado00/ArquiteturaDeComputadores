.data
prompt: .asciiz "Digite o valor de N: "
result: .asciiz "O hiperfatorial de N é: "

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

    # Chama a função para calcular o hiperfatorial
    jal hiperfatorial

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

# Procedimento recursivo para calcular o hiperfatorial de N
hiperfatorial:
    # Verifica se N é igual a 0 ou 1
    beq $a0, $zero, return_one   # Se N for 0, retorna 1
    beq $a0, $1, return_one      # Se N for 1, retorna 1

    # Calcula o hiperfatorial de N-1
    addi $a0, $a0, -1   # N - 1
    jal hiperfatorial   # Chama a função recursivamente para N - 1
    move $t0, $v0       # Salva o resultado em $t0

    # Calcula o fatorial de N
    jal fatorial         # Chama a função para calcular o fatorial de N
    move $t1, $v0       # Salva o resultado em $t1

    # Calcula o hiperfatorial de N multiplicando o hiperfatorial de N-1 pelo fatorial de N
    mul $v0, $t0, $t1  # Calcula o hiperfatorial

    jr $ra              # Retorna

# Função para calcular o fatorial de N
fatorial:
    # Verifica se N é igual a 0 ou 1
    beq $a0, $zero, return_one   # Se N for 0, retorna 1
    beq $a0, $1, return_one      # Se N for 1, retorna 1

    li $v0, 1           # Inicializa o resultado como 1
    li $t0, 1           # Inicializa o contador como 1

    # Loop para calcular o fatorial de N
    loop:
        addi $t0, $t0, 1       # Incrementa o contador
        mul $v0, $v0, $t0      # Multiplica o resultado pelo contador
        blt $t0, $a0, loop     # Loop enquanto contador < N

    jr $ra              # Retorna

return_one:
    li $v0, 1           # Retorna 1
    jr $ra              # Retorna
