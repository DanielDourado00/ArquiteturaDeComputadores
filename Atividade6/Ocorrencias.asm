.include "DDmacros2.asm"

.data
    aluno: .float 0.0
    aprovados: .asciiz "Alunos aprovados: "
    reprovados: .asciiz "Alunos reprovados: "

.text
    main:
        print_str("Digite o número de alunos na turma: ")
        scan_int($s0)  # $s0 contém o número de alunos

        # Alocando dinamicamente a matriz para armazenar as notas dos alunos
        li $a0, 4  # Tamanho de cada elemento da matriz (um float)
        mul $a1, $s0, $a0  # Tamanho total necessário para alocar (número de alunos * tamanho de cada elemento)
        calloc($a1, $s1)  # Alocando memória para a matriz, $s1 conterá o endereço base

        # Preenchendo a matriz com as notas dos alunos
        la $s2, aluno  # Registrador $s2 contém o endereço da variável aluno
        la $s3, ($s1)  # Registrador $s3 contém o endereço base da matriz
        li $s4, 0  # Contador do loop externo (alunos)

    fill_matrix_loop:
        beq $s4, $s0, calculate_averages  # Se todos os alunos foram avaliados, vá para o cálculo das médias
        li $s5, 0  # Contador do loop interno (notas)

    fill_row_loop:
        beq $s5, 3, increment_counters  # Se todas as notas do aluno atual foram lidas, vá para o próximo aluno
        add $t0, $s4, $zero  # $t0 contém o número do aluno atual
        mul $t0, $t0, 3  # $t0 contém o índice da nota atual do aluno atual
        add $t0, $t0, $s5  # $t0 contém o índice da nota atual do aluno atual
        sll $t0, $t0, 2  # Multiplica por 4 para obter o deslocamento correto na matriz
        add $t1, $s3, $t0  # $t1 contém o endereço da célula da matriz correspondente à nota atual
        print_str("Digite a nota do aluno ")
        print_int($s4)
        print_str(", prova ")
        print_int($s5)
        print_str(": ")
        scan_float($f0)  # Lê a nota do aluno atual na prova atual
        s.s $f0, ($t1)  # Armazena a nota lida na matriz
        addi $s5, $s5, 1  # Incrementa o contador de notas
        j fill_row_loop  # Volta para o início do loop interno

    increment_counters:
        addi $s4, $s4, 1  # Incrementa o contador de alunos
        j fill_matrix_loop  # Volta para o início do loop externo

    calculate_averages:
        li $s6, 0  # $s6 conterá a média da turma
        li $s7, 0  # $s7 conterá o número de alunos aprovados
        li $s8, 0  # $s8 conterá o número de alunos reprovados
        li $s9, 0  # Contador do loop externo (alunos)

    calculate_averages_loop:
        beq $s9, $s0, print_results  # Se todos os alunos foram avaliados, vá para a impressão dos resultados
        li $s10, 0  # $s10 conterá a soma das notas do aluno atual
        li $s11, 0  # Contador do loop interno (notas)

    calculate_student_average_loop:
        beq $s11, 3, check_approval  # Se todas as notas do aluno atual foram somadas, vá para a verificação de aprovação
        add $t0, $s9, $zero  # $t0 contém o número do aluno atual
        mul $t0, $t0, 3  # $t0 contém o índice da nota atual do aluno atual
        add $t0, $t0, $s11  # $t0 contém o índice da nota atual do aluno atual
        sll $t0, $t0, 2  # Multiplica por 4 para obter o deslocamento correto na matriz
        add $t1, $s3, $t0  # $t1 contém o endereço da célula da matriz correspondente à nota atual
        l.s $f0, ($t1)  # Carrega a nota do aluno atual na prova atual
        add.s $f1, $f1, $f0  # Soma a nota atual à soma das notas do aluno atual
        addi $s11, $s11, 1  # Incrementa o contador de notas
        j calculate_student_average_loop  # Volta para o início do loop interno

    check_approval:
        div.s $f1, $f1, 3.0  # Calcula a média do aluno atual
        li.s $f0, 6.0  # Carrega 6.0 em ponto flutuante
        c.le.s $f0, $f1  # Verifica se a média do aluno atual é maior ou igual a 6.0
        bc1t is_approved  # Se sim, vá para a contagem de alunos aprovados
        addi $s8, $s8, 1  # Se não, incrementa o contador de alunos reprovados
        j next_student  # Pula para o próximo aluno

    is_approved:
        addi $s7, $s7, 1  # Incrementa o contador de alunos aprovados
        j next_student  # Pula para o próximo aluno

    next_student:
        addi $s6, $s6, 1  # Incrementa o contador de alunos
        addi $s9, $s9, 1  # Incrementa o contador do loop externo
        j calculate_averages_loop  # Volta para o início do loop externo

    print_results:
        div.s $f1, $s6, 1.0  # Calcula a média da turma
        print_str("A média da turma é: ")
        print_float($f1)
        print_str("\n")
        print_str(aprovados)
        print_int($s7)
        print_str("\n")
        print_str(reprovados)
        print_int($s8)
        print_str("\n")

        terminate
