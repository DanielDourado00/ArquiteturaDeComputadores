.data
msg1: .asciiz "Digite um numero(base binaria):\n"  
msg2: .asciiz "Numero binario:\n"                      
msg3: .asciiz "Nao eh um numero binario!"                
new_line: .asciiz "\n"                                       

num: .word 0          # Variável para armazenar o número binário digitado
num1: .word 0         # Variável para armazenar uma cópia do número binário
count: .word 0        # Contador para o loop de verificação
val: .word 0          # Variável temporária para armazenar o valor de um dígito binário
decim: .word 0        # Variável para armazenar o valor decimal do número binário
base: .word 0         # Base utilizada para a conversão para decimal
ultimo: .word 0       # Último dígito do número binário

.text
main:
    li $v0, 4           # Chamada de sistema para imprimir string
    la $a0, msg1        # Carrega o endereço da mensagem em $a0
    syscall

    la $s0, num         # Carrega o endereço da variável num em $s0
    la $s1, num1        # Carrega o endereço da variável num1 em $s1
    la $s2, count       # Carrega o endereço da variável count em $s2
    la $s3, val         # Carrega o endereço da variável val em $s3
    la $s4, decim       # Carrega o endereço da variável decim em $s4
    la $s5, base        # Carrega o endereço da variável base em $s5
    la $s6, ultimo      # Carrega o endereço da variável ultimo em $s6

    li $v0, 5           # Chamada de sistema para ler inteiro
    syscall
    sw $v0, 0($s0)      # Armazena o número lido na variável num
    lw $t0, 0($s0)      # Carrega o número binário em $t0
    sw $t0, 0($s1)      # Armazena uma cópia do número binário em num1
    lw $t0, 0($s1)      # Carrega o número binário em $t0 novamente
    lw $t2, 0($s3)      # Carrega 0 em $t2 (valor temporário)
    lw $t4, 0($s2)      # Carrega 0 em $t4 (contador)

loop:  
    beq $t0, $zero, fim_loop  # Se $t0 for zero, encerra o loop
    addi $t1, $zero, 10   # $t1 = 10 (base para divisão)
    div $t0, $t1          # Divide $t0 por 10
    mfhi $t2              # Move o resto da divisão para $t2
    addi $t3, $zero, 1    # $t3 = 1 (valor temporário)
    beq $t2, $t3, s       # Se o resto for 1, vai para 's'
    beq $t2, $zero, s     # Se o resto for 0, vai para 's'
    addi $t4, $t4, 1      # Incrementa o contador
    addi $t5, $zero, 10   # $t5 = 10 (base para divisão)
    div $t0, $t0, $t5     # Divide $t0 por 10
    j loop                # Volta ao início do loop

s:
    addi $t5, $zero, 10   # $t5 = 10 (base para divisão)
    div $t0, $t0, $t5     # Divide $t0 por 10
    j loop                # Volta ao início do loop

fim_loop: 
    li $v0, 4             # Chamada de sistema para imprimir string
    la $a0, new_line      # Carrega o endereço de new_line para imprimir quebra de linha
    syscall

    bne $t4, $zero, saida # Se o contador não for zero, vai para 'saida'
    li $v0, 4             # Chamada de sistema para imprimir string
    la $a0, msg2          # Carrega o endereço de msg2 para imprimir
    syscall
    lw $t0, 0($s0)        # Carrega o número binário em $t0
    lw $t1, 0($s4)        # Carrega o valor decimal em $t1
    lw $t2, 0($s5)        # Carrega a base em $t2
    lw $t3, 0($s6)        # Carrega o último dígito em $t3
    addi $t2, $zero, 1    # $t2 = 1 (base para cálculo do dígito decimal)

loop1:  
    beq $t0, $zero, fim_loop1   # Se $t0 for zero, sai do loop
    addi $t5, $zero, 10   # $t5 = 10 (base para divisão)
    div $t0, $t5          # Divide $t0 por 10
    mfhi $t3              # Move o resto para $t3
    div $t0, $t0, $t5     # Divide $t0 por 10
    mul $t6, $t3, $t2     # Multiplica o último dígito pelo valor da base
    add $t4, $t4, $t6     # Adiciona o resultado ao número decimal
    addi $t7, $zero, 2    # $t7 = 2 (base binária)
    mul $t2, $t2, $t7     # Multiplica a base por 2
    j loop1               # Volta ao início do loop

fim_loop1:  
    li $v0, 1             # Chamada de sistema para imprimir inteiro
    move $a0, $t4         # Move o número decimal para $a0
    syscall 
    j saida_program       # Vai para saida_program

saida: 
    li $v0, 4             # Chamada de sistema para imprimir string
    la $a0, msg3          # Carrega o endereço de msg3 para imprimir a mensagem de erro
    syscall

saida_program:
    li $v0, 10            # Chamada de sistema para sair do programa
    syscall
