# Definindo o tamanho do vetor (n)
.data
n:     .word 5          # Tamanho do vetor (5 elementos)

# Vetor original (Vet)
.text
main:
    # Inicialização do vetor Vet
    la $t0, Vet           # Endereço base do vetor Vet
    li $t1, 0             # Índice do vetor (inicializado em 0)

    # Leitura dos elementos do vetor Vet
read_loop:
    li $v0, 5             # Código para leitura de inteiro
    syscall               # Realiza a leitura do inteiro
    sw $v0, 0($t0)        # Armazena o elemento no vetor Vet
    addi $t0, $t0, 4      # Avança para o próximo elemento
    addi $t1, $t1, 1      # Incrementa o índice
    bne $t1, 5, read_loop # Continua a leitura até 5 elementos

    # Compactação do vetor Vet
    la $t3, Vetcomp       # Endereço base do vetor Vetcomp
    li $t4, 0             # Índice do vetor compactado (inicializado em 0)

    # Copia os elementos não nulos para Vetcomp
copy_loop:
    lw $t2, 0($t0)        # Carrega o elemento do vetor Vet
    beqz $t2, end_copy    # Se o elemento for zero, encerra a cópia
    sw $t2, 0($t3)        # Armazena o elemento em Vetcomp
    addi $t0, $t0, 4      # Avança para o próximo elemento de Vet
    addi $t3, $t3, 4      # Avança para o próximo elemento de Vetcomp
    addi $t4, $t4, 1      # Incrementa o índice
    j copy_loop

end_copy:
    # Exibição da mensagem "Vetor compactado:"
    la $a0, VetorCompactado
    li $v0, 4
    syscall

    # Exibição do vetor compactado (Vetcomp)
    la $t3, Vetcomp       # Endereço base do vetor Vetcomp
    li $t4, 0             # Índice do vetor compactado (inicializado em 0)

print_loop:
    lw $t2, 0($t3)        # Carrega o elemento do vetor Vetcomp
    beqz $t2, end_print   # Se o elemento for zero, encerra a exibição
    li $v0, 1             # Código para impressão de inteiro
    move $a0, $t2         # Carrega o valor a ser impresso
    syscall               # Realiza a impressão
    addi $t3, $t3, 4      # Avança para o próximo elemento de Vetcomp
    j print_loop

end_print:
    # Fim do programa
    li $v0, 10            # Código de saída
    syscall

# Vetor original (Vet)
.data
Vet:   .space 20         # Espaço para 5 elementos inteiros (4 bytes cada)

# Vetor compactado (Vetcomp)
.data
Vetcomp: .space 20       # Espaço para 5 elementos inteiros (4 bytes cada)
VetorCompactado: .asciiz "Vetor compactado:"
