.data
enti: .asciiz "Insira a string 1:"
ent2: .asciiz "Insira a string 2: "
strl: .space 100
str2: space 100
str3: .space 200

.text
main: la $a0, ent1 # Parâmetro: mensagem
la $al, strl # Parâmetro: endereço da string jal leitura # leitura (mensagem, string) la $a0, ent2 # Parâmetro: mensagem
la sal, str2 # Parâmetro: endereço da string jal leitura # leitura (mensagem, string) la $a0, strl # Parâmetro: endereço da string 1 la $al, str2 # Parâmetro: endereço da string 2 la $a2, str3 # Parâmetro: endereço da string 3 jal intercala # intercala (stri, str2, str3) move $a0, $v0 # move o retorno da string resultante li $v0,4 # Código de impressão de string
syscall # Imprime a string intercalada
li $v0, 10# Código para finalizar o programa syscall # Finaliza o programa
leitura:
li $v0, 4 # Código de impressão de string syscall # Imprime a string
move $a0, $al # Endereço da string para leitura
li şal, 100 # Número máximo de caracteres
li sv0, 8 # Código de leitura da string
syscall # Faz a leitura da string
jr fra #Retorna para a main
intercala: