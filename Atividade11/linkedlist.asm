.include "DDmacros2.asm"

.data 
    list: .word 12, 0, 0 # tamanho da palavra, número de elementos, cabeça
    node: .word 12, 0, 0 # tamanho da palavra, info, próximo 
.text

    main:
        print_str("Lista encadeada em MIPS\n")

        la $s0, list # carrega o endereço da lista
        jal create_list # endereço da lista em $s1

        la $s2, node # carrega o endereço do nó      
        
        li $t0, 9 # flag
        loop:
            beqz $t0, end # se flag == 1, termina
            jal menu
            beq $t0, 1, create_node
            beq $t0, 2, consulta_numero
            j loop
        end:
            terminate
    
    create_list:
        lw $a0, 0($s0) # carrega o tamanho da palavra
        calloc($a0, $s0)
        jr $ra

    create_node:
        lw $a0, 0($s2) # carrega o tamanho da palavra
        calloc($a0, $s3)
        print_str("\nDigite a informação para adicionar: ")
        scan_int($t2)
        sw $t2, 4($s3) # nó->info = info
        sw $zero, 8($s3) # nó->próximo = null

        lw $t1, 8($s0) # carrega a cabeça
        beqz $t1, first_node # se a cabeça == null, first_node

        traverse:
            lw $t2, 8($t1) # carrega o próximo
            beqz $t2, save_node # se o próximo == null, plus
            next_node:
                move $t1, $t2 # anterior = próximo
                j traverse
            save_node:
                sw $s3, 8($t1) # anterior->próximo = nó
                j plus

        first_node:
            sw $s3, 8($s0) # cabeça = nó
        plus:
            lw $t2, 4($s0) # carrega o tamanho
            addi $t2, $t2, 1 # tamanho++
            sw $t2, 4($s0) # lista->tamanho = tamanho
        j loop

    print_list:
        lw $t2, 8($s0) # carrega a cabeça
        beqz $t2, loop # se a cabeça == null, loop
        print_str("\nLista: ")
        print_loop:
            lw $t3, 4($t2) # carrega a informação
            print_int($t3)
            print_str(" ")
            lw $t2, 8($t2) # carrega o próximo
            bnez $t2, print_loop
        print_str("\n")
        j loop



    menu:
        print_str("\n1. Adicionar nó\n")
        print_str("2. Consultar número\n")
        print_str("0. Sair\n")
        print_str(">> Digite a opção: ")
        scan_int($t0)
        jr $ra

    consulta_numero:
        print_str("\nDigite o número a ser consultado: ")
        scan_int($t2) # Escaneia o número a ser consultado

        lw $t1, 8($s0) # Carrega a cabeça da lista
        beqz $t1, numero_nao_encontrado # Se a lista estiver vazia, o número não está na lista

        loop_consulta:
            lw $t3, 4($t1) # Carrega a informação do nó atual
            beq $t2, $t3, numero_encontrado # Se o número for encontrado, pula para numero_encontrado
            lw $t1, 8($t1) # Carrega o próximo nó
            bnez $t1, loop_consulta # Se não for o último nó, continua a busca
            j numero_nao_encontrado # Se chegou ao último nó e não encontrou o número, pula para numero_nao_encontrado

        numero_encontrado:
            print_str("\nNúmero encontrado na lista\n")
            j loop

        numero_nao_encontrado:
            print_str("\nNúmero não encontrado na lista\n")
            j loop
