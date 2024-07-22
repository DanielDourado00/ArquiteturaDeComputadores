.data
    prompt_frase: .asciiz "Enter the phrase: "
    prompt_palavra: .asciiz "Enter the word: "
    result_msg: .asciiz "The word occurs: "
    times_msg: .asciiz " times.\n"
    frase: .space 256       # Espaço para armazenar a frase (256 bytes)
    palavra: .space 32      # Espaço para armazenar a palavra (32 bytes)
    count: .word 0          # Armazena a contagem de ocorrências

.text
.globl main

main:
    # Ler a frase
    li $v0, 4
    la $a0, prompt_frase
    syscall
    li $v0, 8
    la $a0, frase
    li $a1, 256
    syscall

    # Ler a palavra
    li $v0, 4
    la $a0, prompt_palavra
    syscall
    li $v0, 8
    la $a0, palavra
    li $a1, 32
    syscall

    # Inicializar variáveis
    la $t0, frase          # Ponteiro para a frase
    la $t1, palavra        # Ponteiro para a palavra
    li $t2, 0              # Índice na frase
    li $t3, 0              # Contador de ocorrências

count_occurrences:
    # Verificar se chegamos ao fim da frase
    lb $t4, 0($t0)
    beq $t4, $zero, print_result
    
    # Verificar se a subsequência a partir de $t0 é igual à palavra
    la $t5, palavra        # Reinicializar o ponteiro para a palavra
    li $t6, 0              # Índice na palavra
check_word:
    lb $t7, 0($t5)         # Carregar o caractere atual da palavra
    beq $t7, $zero, match  # Se chegamos ao fim da palavra, encontramos uma correspondência
    lb $t8, 0($t0)         # Carregar o caractere atual da frase
    bne $t7, $t8, no_match # Se os caracteres não correspondem, não há correspondência
    addi $t0, $t0, 1       # Avançar para o próximo caractere na frase
    addi $t5, $t5, 1       # Avançar para o próximo caractere na palavra
    j check_word           # Continuar verificando
match:
    # Incrementar o contador de ocorrências
    addi $t3, $t3, 1

no_match:
    # Avançar para a próxima posição na frase e reinicializar o ponteiro
    addi $t0, $t0, 1
    la $t0, frase
    add $t0, $t0, $t2
    addi $t2, $t2, 1       # Incrementar o índice na frase
    j count_occurrences    # Continuar verificando

print_result:
    # Armazenar o resultado
    sw $t3, count
    
    # Exibir o resultado
    li $v0, 4
    la $a0, result_msg
    syscall
    lw $a0, count
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, times_msg
    syscall
    
    # Terminar o programa
    li $v0, 10
    syscall
