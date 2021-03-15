# Connect Four - MIPS Version

.data

welcome:		.asciiz "Welcome to Connect Four: MIPS Version\nThis is a two player game, each player will take turns dropping tokens.\nThe objective is to create a line of four of your tokens\nGood luck!\n"
input_prompt:		.asciiz " Enter a column [0-6] -> "
win_prompt:		.asciiz "The winner is player "
full:			.asciiz "Board is full. Game over\n"

board:			.word
			0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0,
			
.eqv	B_SIZE		42
.eqv	B_ROWS		6
.eqv	B_COLS		7
.eqv	BORDER_CHAR	'|'

.text
.globl main
main:
	li	v0, 4
	la	a0, welcome	# printf(welcome_string);
	syscall
	
	la	a0, board
	jal	render
	
	li	s4, 1		# player register
_main_while:

	
_input_valid_loop:

	jal	is_full
	bnez	v0, _main_end_while

	li	v0, 11
	li	a0, '['
	syscall
	
	move	a0, s4
	jal	token_char	# Display the token to be dropped next
	move	a0, v0
	li	v0, 11
	syscall
	
	li	v0, 11
	li	a0, ']'
	syscall

	li	v0, 4
	la	a0, input_prompt 
	syscall
	
	li	v0, 5
	syscall			# scanf(int);
	move	s1, v0

	bltz	s1, _input_valid_loop
	bgt	s1, B_COLS, _input_valid_loop
	
	la	a0, board
	move	a1, s1
	jal	drop_token
	beq	v0, 0xFFFFFF, _input_valid_loop	# Col is full, repeat
	
	move	s5, v0
	move	s6, s1
	
	
	
	la	a0, board
	move	a1, v0
	move	a2, s1				
	jal	matrix_element_address	
	move	t0, s4
	sw	t0, (v0)
	
	la	a0, board
	jal	render
	
	move	a0, s5
	move	a1, s6
	jal	winning_pattern
	beqz	v0, _main_end_while
	
	beq	s4, 1, _main_if_player_eq_1
	li	s4, 1
	j	_main_end_if
_main_if_player_eq_1:
	li	s4, 2
_main_end_if:
	j _main_while
	
_main_full:
	li,	v0, 4
	la,	a0, full
	syscall
_main_end_while:
	li	v0, 10
	syscall
	
# See libc4.c
# a0 - value
token_char:
	push	ra
	beq	a0, 1, _token_char_if_1	
	beq	a0, 2, _token_char_if_2
	
	li	v0, '_'
	j	_token_char_end_if
_token_char_if_1:
	li	v0, '*'
	j	_token_char_end_if
_token_char_if_2:
	li	v0, '+'
	j	_token_char_end_if
	
_token_char_end_if:
	pop	ra
	jr	ra

# See libc4.c
# a0 - board
render:
	push	ra
	push	s0
	push	s1
	push	s2
	move	s2, a0					# s1 = board

	li	v0, 11
	li	a0, '\n'
	syscall
	
	# Print header column.
	li	v0, 11
	li	a0, ' '	 				# printf(" ");
	syscall
	
	
	move	s0, zero				# for(int h = 0
_render_for_header:
	bge	s0, B_COLS, _render_end_for_header	# h < cols;

	li	v0, 1
	move	a0, s0					# printf(i);
	syscall

	li	v0, 11
	li	a0, ' '	 				# printf(" ");
	syscall
	
	addi	s0, s0, 1				# h++;)
	j	_render_for_header
	
_render_end_for_header:

	li	v0, 11
	li	a0, '\n'
	syscall

	move	s0, zero				# for (int i = 0
_render_for_row:					
	bge	s0, B_ROWS, _render_end_for_row		# i < rows
	
	li	v0, 11
	li	a0, BORDER_CHAR				# printf(BORDER_CHAR);
	syscall
	
	move	s1, zero				# for (int k = 0
_render_for_column:					
	bge	s1, B_COLS, _render_end_for_column	# k < cols
	
	move	a0, s2
	move	a1, s0
	move	a2, s1
	jal	matrix_element_address
	lw	t2, (v0)
	move	a0, t2
	jal	token_char
	move	t2, v0
	
	li	v0, 11
	move	a0, t2					# printf(_);
	syscall	
	
	li	v0, 11
	li	a0, BORDER_CHAR				# printf(BORDER_CHAR);
	syscall
	
	addi	s1, s1, 1
	j 	_render_for_column
_render_end_for_column:

	li	v0, 11
	li	a0, '\n'
	syscall
	
	addi	s0, s0, 1				# i++;
	j	_render_for_row
	
_render_end_for_row:

	li	v0, 11
	li	a0, '\n'
	syscall
	
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra


# See libc4.c
# a0 - board
# a1 - col
# v0 - col to drop
drop_token:
	push	ra
	push	s0 # loop index
	push	s1
	push	s2
	
	li	s0, B_ROWS
	move	s1, a0
	move	s2, a1
	
	move	a0, s1
	li	a1, 0
	move	a2, s2			# board[0][col]
	jal	matrix_element_address
	lw	t2, (v0)
	bnez	t2, _drop_token_full_col # if the top row is full then so are all the others.
	
	subi	s0, s0, 1
_drop_token_for:
	bltz	s0, _drop_token_end_for
	
	move	a0, s1
	move	a1, s0
	move	a2, s2
	jal	matrix_element_address
	lw	t2, (v0)
	
	bnez	t2, _drop_token_else
	
_drop_token_if_equal:
	
	move	v0, s0
	j	_drop_token_end_for
	
_drop_token_else:

	subi	s0, s0, 1
	j	_drop_token_for
	
_drop_token_full_col:
	li	v0, 0xFFFFFF
_drop_token_end_for:
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra

# See libc4.c
# a0 - row
# a1 - col
winning_pattern:
	push	ra
	push	s0 # row
	push	s1 # col
	push	s2 # value
	push	s3 # c_row
	push	s4 # c_col
	push	s5 # s
	
	li	v0, 1
	
	move	s0, a0
	move	s1, a1
	
	move	s3, s0
	move	s4, s1
	
	la	a0, board
	move	a1, s0
	move	a2, s1
	jal	matrix_element_address
	lw	s2, (v0)
	
	li	s5, 1
	move	s3, s0
	
_down_while:
	bge	s3, B_ROWS, _down_end_while # c_row < row
	
	la	a0, board
	move	a1, s3
	move	a2, s1
	addi	a1, a1, 1
	jal	matrix_element_address			# Track down until we find a token that is not ours
	lw	t0, (v0)
	bne	s2, t0, _down_end_while
	addi	s3, s3, 1
	addi	s5, s5, 1
	j	_down_while
_down_end_while:
	bge	s5, 4, _winning_pattern_return

# RIGHT

	move	s3, s0
	move	s4, s1
	li	s5, 1
	
_right_while:
	bge	s4, B_COLS, _right_end_while # c_row < row
	
	la	a0, board
	move	a1, s0
	move	a2, s4
	addi	a2, a2, 1
	jal	matrix_element_address			# Track right until we find a token that is not ours
	lw	t0, (v0)
	bne	s2, t0, _right_end_while
	addi	s4, s4, 1
	addi	s5, s5, 1
	j	_right_while
_right_end_while:
	bge	s5, 4, _winning_pattern_return

# LEFT

	move	s3, s0
	move	s4, s1
	li	s5, 1
	
_left_while:
	ble	s4, 0, _left_end_while # c_row < row
	
	la	a0, board
	move	a1, s0
	move	a2, s4
	subi	a2, a2, 1
	jal	matrix_element_address			# Track left until we find a token that is not ours
	lw	t0, (v0)
	bne	s2, t0, _left_end_while
	subi	s4, s4, 1
	addi	s5, s5, 1
	j	_left_while
_left_end_while:
	bge	s5, 4, _winning_pattern_return

# DIAGONAL

	move	s3, s0
	move	s4, s1
	li	s5, 1
	
_ne_while:
	bge	s4, B_COLS, _ne_end_while 		
	ble	s3, 0, _ne_end_while 			
	
	la	a0, board
	move	a1, s3
	move	a2, s4
	subi	a1, a1, 1
	addi	a2, a2, 1
	jal	matrix_element_address			# Track along both diagonals
	lw	t0, (v0)
	bne	s2, t0, _ne_end_while
	subi	s3, s3, 1
	addi	s4, s4, 1
	addi	s5, s5, 1
	j	_ne_while
_ne_end_while:

	move	s3, s0
	move	s4, s1

_sw_while:
	ble	s4, 0, _sw_end_while 
	bge	s3, B_ROWS, _sw_end_while 
	
	la	a0, board
	move	a1, s3
	move	a2, s4
	subi	a2, a2, 1
	addi	a1, a1, 1
	jal	matrix_element_address
	lw	t0, (v0)
	bne	s2, t0, _sw_end_while
	subi	s4, s4, 1
	addi	s5, s5, 1
	j	_sw_while
_sw_end_while:
	bge	s5, 4, _winning_pattern_return

# DIAGONAL

	move	s3, s0
	move	s4, s1
	li	s5, 1
	
_nw_while:
	ble	s4, 0, _nw_end_while 			
	ble	s3, 0, _nw_end_while 
	
	la	a0, board
	move	a1, s3
	move	a2, s4
	subi	a1, a1, 1
	subi	a2, a2, 1
	jal	matrix_element_address
	lw	t0, (v0)
	bne	s2, t0, _nw_end_while
	subi	s3, s3, 1
	subi	s4, s4, 1
	addi	s5, s5, 1
	j	_nw_while
_nw_end_while:

	move	s3, s0
	move	s4, s1

_se_while:
	bge	s4, B_COLS, _se_end_while # c_row < row
	bge	s3, B_ROWS, _se_end_while # c_row < row
	
	la	a0, board
	move	a1, s3
	move	a2, s4
	addi	a1, a1, 1
	addi	a2, a2, 1
	jal	matrix_element_address
	lw	t0, (v0)
	bne	s2, t0, _se_end_while
	addi	s4, s4, 1
	addi	s3, s3, 1
	addi	s5, s5, 1
	j	_se_while
_se_end_while:
	bge	s5, 4, _winning_pattern_return

	j	_winning_pattern_return_f
_winning_pattern_return:
	li	v0, 0
_winning_pattern_return_f:
	pop	s5
	pop	s4
	pop	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra

# Since the board is an array of numbers, we can use
# a nice little multiplication trick. If any space is 0
# the product of every sqaure will be 0. Hence, if prod != 0
# the board is full.
is_full:
	push	ra
	push	s0
	li	t0, 1	# acc
	li	s0, 0
_is_full_for:
	bge	s0, B_SIZE, _is_full_end_for
	la	a0, board
	move	a1, s0
	jal	array_element_address
	lw	t1, (v0)
	mul	t0, t0, t1
	addi	s0, s0, 1
	j 	_is_full_for
_is_full_end_for:
	li	v0, 0
	beqz	t0, _if_full_prod_zero
	li	v0, 1
_if_full_prod_zero:
	pop	s0
	pop	ra
	jr	ra


# array[i];
# a0 - array
# a1 - i
array_element_address:
	push 	ra
	move	t1, a0
	move	t2, a1
	
	add	t2, t2, t2
	add	t2, t2, t2	# i * 4
	add	v0, t1, t2	# A + i
	pop	ra
	jr	ra

# matrix[row][col];
# a0 - matrix
# a1 - row
# a2 - col	
matrix_element_address:
	push	ra
	li	t2, 4
	mul	t0, t2, B_COLS
	mul	t1, t0, a1
	add	a0, a0, t1
	move	a1, a2
	jal	array_element_address
	pop	ra
	jr	ra