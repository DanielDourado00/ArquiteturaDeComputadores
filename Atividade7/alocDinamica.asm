.data
numbers: .float 5.0, 2.0, -2.0, -7.0, 3.0, 12.0, -3.0, 9.0, -6.0
n:      .word 11             # Número de elementos na sequência
max_sum: .float 0.0          # Variável para armazenar a soma máxima
start_index: .word 0         # Índice inicial do segmento de nota máxima
end_index: .word 0           # Índice final do segmento de nota máxima
zero_float: .float 0.0       # Constante zero em ponto flutuante

.text
.globl main

main:
    # Inicialização
    la $t0, numbers           # Carrega o endereço do vetor de números
    lw $t1, n                 # Carrega o número de elementos na sequência
    l.s $f4, zero_float       # Inicializa a soma atual com zero
    l.s $f5, zero_float       # Inicializa a soma máxima com zero
    li $t2, 0                 # Inicializa o índice de início do segmento
    li $t3, 1                 # Inicializa o índice final do segmento como 1

    # Loop para encontrar o segmento de soma máxima
    loop:
        bge $t2, $t1, end_loop     # Se o índice de início for maior ou igual ao número de elementos, termina o loop
        l.s $f6, ($t0)             # Carrega o número atual do vetor
        add.s $f4, $f4, $f6        # Adiciona o número atual à soma atual

        # Atualiza a soma máxima e os índices do segmento se a soma atual for maior
        c.lt.s $f5, $f4            # Verifica se a soma atual é maior que a soma máxima
        bc1f not_greater           # Se a soma atual não for maior, vá para not_greater
        mov.s $f5, $f4            # Atualiza a soma máxima com a soma atual
        move $t3, $t2             # Atualiza o índice final do segmento

    not_greater:
        # Atualiza o índice de fim do segmento
        addi $t2, $t2, 1

        # Avança para o próximo número
        addi $t0, $t0, 4
        j loop

    end_loop:
        # Imprime a soma máxima e os índices do segmento
        li $v0, 2                  # syscall para imprimir um número em ponto flutuante
        mov.s $f12, $f5            # carrega a soma máxima
        syscall

        li $v0, 10                 # syscall para encerrar o programa
        syscall
