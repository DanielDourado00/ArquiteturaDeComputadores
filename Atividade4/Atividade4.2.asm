.include "DDmacros2.asm"

.data
    Matriz1: .space 64   # 4x4 * 4 (inteiro)
    Matriz2: .space 64   # 4x4 * 4 (inteiro)
    iguais: .word 0       # Variável para armazenar a quantidade de valores iguais na mesma posição
    soma_posicoes: .word 0  # Variável para armazenar a soma das posições (linha+coluna) dos valores iguais
    
.text
main:
    # Inicialização das variáveis
    li $t0, 0    # contador i
    li $t1, 0    # contador j
    li $t2, 0    # soma_posicoes
    li $t3, 0    # iguais
    
    # Leitura da primeira matriz
    la $a0, Matriz1
    jal leitura_matriz
    
    # Leitura da segunda matriz
    la $a0, Matriz2
    jal leitura_matriz
    
    # Comparação das matrizes
    li $t0, 0    # Reinicializa o contador i
comparacao_loop:
    beq $t0, 4, fim   # Se i = 4, termina o loop
    li $t1, 0    # Reinicializa o contador j
    
comparacao_inner_loop:
    beq $t1, 4, proxima_linha  # Se j = 4, avança para a próxima linha
    sll $t4, $t0, 2   # $t4 = i * 4
    add $t4, $t4, $t1   # $t4 = i * 4 + j
    sll $t4, $t4, 2   # $t4 = (i * 4 + j) * 4 (para obter o offset em bytes)
    la $t5, Matriz1
    add $t5, $t5, $t4   # Endereço de Matriz1[i][j]
    lw $t6, 0($t5)   # Valor de Matriz1[i][j]
    la $t5, Matriz2
    add $t5, $t5, $t4   # Endereço de Matriz2[i][j]
    lw $t7, 0($t5)   # Valor de Matriz2[i][j]
    bne $t6, $t7, proximo_elemento   # Se os valores forem diferentes, vá para o próximo elemento
    add $t3, $t3, 1   # Incrementa a quantidade de valores iguais
    add $t2, $t2, $t0   # Adiciona a linha à soma_posicoes
    add $t2, $t2, $t1   # Adiciona a coluna à soma_posicoes
proximo_elemento:
    addi $t1, $t1, 1   # Avança para o próximo elemento da linha
    j comparacao_inner_loop
proxima_linha:
    addi $t0, $t0, 1   # Avança para a próxima linha
    j comparacao_loop

fim:
    # Impressão dos resultados
    print_str("Quantidade de valores iguais na mesma posição: ")
    print_int($t3)   # Quantidade de valores iguais
    
    print_str("\nSoma das posições (linha+coluna) dos valores iguais: ")
    print_int($t2)   # Soma das posições
    
    terminate

# Função para ler uma matriz
leitura_matriz:
    li $t0, 0    # contador i
leitura_loop:
    beq $t0, 4, fim_leitura  # Se i = 4, termina a leitura
    li $t1, 0    # contador j
leitura_inner_loop:

    beq $t1, 4, proxima_linha_leitura  # Se j = 4, avança para a próxima linha
    sll $t4, $t0, 2   # $t4 = i * 4
    add $t4, $t4, $t1   # $t4 = i * 4 + j
    sll $t4, $t4, 2   # $t4 = (i * 4 + j) * 4 (para obter o offset em bytes)
    la $t5, 0($a0)
    add $t5, $t5, $t4   # Endereço de Matriz[i][j]
    scan_int($t6)   # Leitura do valor inteiro
    sw $t6, 0($t5)   # Salva o valor lido na matriz
    addi $t1, $t1, 1   # Avança para o próximo elemento da linha
    j leitura_inner_loop
proxima_linha_leitura:
    addi $t0, $t0, 1   # Avança para a próxima linha
    j leitura_loop
fim_leitura:
    jr $ra   # Retorna ao chamador

