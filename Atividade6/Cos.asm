.include "DDmacros2.asm"

.data
    zeroFloat: .float 0.0
    pi: .float 3.14159265
    divi: .float 180.0

.text
    main:
        print_str("\nPor favor, insira a quantidade N de termos da série para utilizar na aproximação: ")
        scan_int($s1)
        print_str("Agora, insira um ângulo X em graus, para calcular uma aproximação do cosseno: ")
        scan_float($f1)
        mov.s $f8, $f1

        ## Convertendo graus em radianos
        lwc1 $f0, pi
        mul.s $f1, $f1, $f0
        lwc1 $f0, divi
        div.s $f1, $f1, $f0

        # Inicialização de contadores e variáveis
        li $s2, 0 # Contador de termos
        li $s3, 0 # Variável auxiliar para potências e fatoriais
        li $t9, 2
        lwc1 $f9, zeroFloat

    # Loop para a aproximação
    aprox:
        beq $s2, $s1, end
        potencia($f1, $s3, $f4) # Calcula a potência de f1 elevado a s3, resultado armazenado em f4
        fatorial($s3, $s4) # Calcula o fatorial de s3, resultado armazenado em s4
        mtc1 $s4, $f5
        cvt.s.w $f5, $f5
        div.s $f6, $f4, $f5 # Divide o resultado da potência pelo fatorial
        div $s2, $t9
        mfhi $s4 
        beq $s4, $zero, positivo
    negativo:
        sub.s $f9, $f9, $f6
        j padrao
    positivo:
        add.s $f9, $f9, $f6
    padrao:
        addi $s3, $s3, 2
        addi $s2, $s2, 1
        j aprox

    end:
        # Impressão do resultado
        print_str("\n Valor aproximado para cos(")
        print_float($f8)
        print_str(") = ")
        print_float($f9)

        terminate
