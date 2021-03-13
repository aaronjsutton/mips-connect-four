# Connect Four - MIPS Version

.data

welcome:		.asciiz "Welcome to Connect Four: MIPS Version\nThis is a two player game, each player will take turns dropping tokens.\nThe objective is to create a line of four of your tokens\nGood luck!\n"
input_prompt_fst:	.asciiz "Enter a column [0-"
input_prompt_snd:	.asciiz "] "

.text
.globl main
main:
	# printf(welcome_string);
	li	v0, 4
	la	a0, welcome
	syscall
	
	