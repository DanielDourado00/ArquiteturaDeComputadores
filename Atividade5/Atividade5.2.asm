.include "DDmacros2.asm"
.data

mVet: .asciiz "Vetor: \n"
mN: .asciiz "N: "
mMenorEle: .asciiz "\nMenor elemento: "
mPosicaoMenor: .asciiz "\nPosicao do menor elemento: "
mMaiorEle: .asciiz "\nMaior elemento: "
mPosicaoMaior: .asciiz "\nPosicao do maior elemento: "

.text

print_str("\nPrograma que le um vetor de n elementos inteiros e apresenta como saida o menor e manior elemento e sua posicao!\n")
# Pede ao usuário para inserir o tamanho do vetor
li $v0, 4       # código de impressão de string
la $a0, mN      # carrega o endereço da string
syscall         # impressão da string

# Lê o tamanho do vetor
li $v0, 5       # código de leitura de inteiro
syscall         # leitura do inteiro
move $t1, $v0   # $t1 = N

# Calcula a quantidade de memória a ser alocada para o vetor
mul $s1, $t1, 4 # $s1 = quantidade de memória a ser alocada (4*N)
move $a0, $s1   # $a0 <- $s1 (argumento da função de alocar)
li $v0, 9       # código de alocação dinâmica de heap
syscall         # aloca 4*N bytes (endereço em $v0)
move $t9, $v0   # move para $t9 o endereço do primeiro elemento do vetor 

# Imprime "Vetor: "
li $v0, 4       # código de impressão de string
la $a0, mVet    # carrega o endereço da string
syscall         # impressão da string

# Inicia a leitura dos elementos do vetor
li $t0, 0       # $t0 = i 
loopLeituraVet:
    beq $t0, $t1, endLoopLeituraVet   # quando $t0 = $t1 termina a leitura
    
    li $v0, 5       # código de leitura de inteiro
    syscall         # leitura do inteiro
    move $t2, $v0   # $t2 = aux (elemento inserido)
    sw $t2, ($t9)   # armazenando $t2 na posição de memória que $t9 aponta 
    add $t9, $t9, 4    # próxima posição do vetor
    add $t0, $t0, 1    # i = i+1
    j loopLeituraVet
endLoopLeituraVet:

# Inicializa variáveis para armazenar o menor e o maior elemento
li $t3, 99999   # $t3 = menor elemento inicializado com valor grande
li $t4, 0       # $t4 = posição do menor elemento
li $t5, -99999  # $t5 = maior elemento inicializado com valor pequeno
li $t6, 0       # $t6 = posição do maior elemento

# Loop para encontrar o menor elemento
sub $t9, $t9, $s1   # agora $t9 aponta para a primeira posição do vetor
li $t0, 0
loopAnaliseMenor:
    beq $t0, $t1, endLoopAnaliseMenor    # quando $t0 = $t1 sai do loop
    
    lw $t8, ($t9)       # carrega $t8 com o valor da posição apontada por $t9
    blt $t8, $t3, menorElemento   # if $t8 < $t3 , substitui o valor de $t3 por $t8
    add $t9, $t9, 4     # próxima posição do vetor 
    add $t0, $t0, 1     # i = i+1
    j loopAnaliseMenor
endLoopAnaliseMenor:

# Loop para encontrar o maior elemento
sub $t9, $t9, $s1   # agora $t9 aponta para a primeira posição do vetor
li $t0, 0
loopAnaliseMaior:
    beq $t0, $t1, endLoopAnaliseMaior    # quando $t0 = $t1 sai do loop
    
    lw $t8, ($t9)       # carrega $t8 com o valor da posição apontada por $t9
    bgt $t8, $t5, maiorElemento   # if $t8 > $t5 , substitui o valor de $t5 por $t8
    add $t9, $t9, 4     # próxima posição do vetor 
    add $t0, $t0, 1     # i = i+1
    j loopAnaliseMaior
endLoopAnaliseMaior:

# Imprime o menor elemento e sua posição
li $v0, 4           # código de impressão de string
la $a0, mMenorEle   # carrega o endereço da string
syscall             # impressão da string

li $v0, 1       # comando para imprimir inteiro
move $a0, $t3   # movendo o valor de $t3 para o registrador $a0
syscall         # executando

li $v0, 4           # código de impressão de string
la $a0, mPosicaoMenor   # carrega o endereço da string
syscall             # impressão da string

li $v0, 1       # comando para imprimir inteiro
move $a0, $t4   # movendo o valor de $t4 para o registrador $a0
syscall         # executando

# Imprime o maior elemento e sua posição
li $v0, 4           # código de impressão de string
la $a0, mMaiorEle   # carrega o endereço da string
syscall             # impressão da string

li $v0, 1       # comando para imprimir inteiro
move $a0, $t5   # movendo o valor de $t5 para o registrador $a0
syscall         # executando

li $v0, 4               # código de impressão de string
la $a0, mPosicaoMaior   # carrega o endereço da string
syscall                 # impressão da string

li $v0, 1       # comando para imprimir inteiro
move $a0, $t6   # movendo o valor de $t6 para o registrador $a0
syscall			# executando


li $v0, 10	# encerra o programa
syscall
#-------------------------------------------------------------------------------------------------------------
menorElemento:
	move $t3, $t8		# $t3 (menor elemento) passa a ter o valor de $t8
	add $t4, $t0, 1		# $t4 tem o indice 
	add $t9, $t9, 4			# proxima posi??o do vetor 
	add $t0, $t0, 1			# i = i+1
	j loopAnaliseMenor
	
maiorElemento:
	move $t5, $t8		# $t5 (menor elemento) passa a ter o valor de $t8
	add $t6, $t0, 1		# $t6 tem o indice 
	add $t9, $t9, 4		# proxima posi??o do vetor 
	add $t0, $t0, 1		# i = i+1
	j loopAnaliseMaior