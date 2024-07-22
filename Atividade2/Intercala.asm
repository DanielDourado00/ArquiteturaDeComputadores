
.data
ent1: .asciiz "Insira a string 1: "
ent2: .asciiz "Insira a string 2: "
ent3: .asciiz "Insira a string 3 para verificar se é palindroma: "
str1: .space 100
str2:  .space 100
str3:  .space 200
.text
main:
la $a0, ent1 # Parâmetro: mensagem
la $a1, str1 # Parâmetro: endereço da string jal leitura # leitura (mensagem, string) la $a0, ent2 # Parâmetro: mensagem
jal leitura  #leitura mensagem
la $a0, ent2 # Parâmetro: endereço da string jal leitura # leitura (mensagem, string) la $a0, strl # Parâmetro: endereço da string 1 la $al, str2 # Parâmetro: endereço da string 2 la $a2, str3 # Parâmetro: endereço da string 3 jal intercala # intercala (stri, str2, str3) move $a0, $v0 # move o retorno da string resultante li $v0,4 # Código de impressão de string
la $a1, str2 # Parâmetro: endereço da string jal leitura # leitura (mensagem, string) la $a0, strl # Parâmetro: endereço da string 1 la $al, str2 # Parâmetro: endereço da string 2 la $a2, str3 # Parâmetro: endereço da string 3 jal intercala # intercala (stri, str2, str3) move $a0, $v0 # move o retorno da string resultante li $v0,4 # Código de impressão de string
jal leitura
la $a0, str1
la $a1, str2
la $a2, str3
jal intercala
move $a0, $v0
li $v0, 4
syscall # Imprime a string intercalada
li $v0, 10 # Código para finalizar o programa syscall # Finaliza o programa
syscall


leitura:
li $v0, 4 # Código de impressão de string
syscall # Imprime a string
move $a0, $a1 # Endereço da string para leitura
li $a1, 100 # Número máximo de caracteres
li $v0, 8 # Código de leitura da string
syscall # Faz a leitura da string
jr $ra # Retorna para a main


intercala:
    move $t0, $a0   # Endereço da primeira string
    move $t1, $a1   # Endereço da segunda string
    move $t2, $a2   # Endereço da terceira string (resultado)

loop_intercala:
    lb $t3, ($t0)   # Caracter atual da primeira string
    lb $t4, ($t1)   # Caracter atual da segunda string

    # Copiar o caractere da primeira string para a terceira string
    sb $t3, ($t2)
    addi $t0, $t0, 1   # Avançar para o próximo caractere da primeira string
    addi $t2, $t2, 1   # Avançar para o próximo caractere da terceira string

    # Copiar o caractere da segunda string para a terceira string
    sb $t4, ($t2)
    addi $t1, $t1, 1   # Avançar para o próximo caractere da segunda string
    addi $t2, $t2, 1   # Avançar para o próximo caractere da terceira string

    # Verificar se chegou ao final de alguma das strings
    beqz $t3, fim_intercala
    beqz $t4, fim_intercala

    j loop_intercala

fim_intercala:
    move $v0, $a2   # Retorna o endereço da string intercalada
    jr $ra
    
    
