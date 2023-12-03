# Unit Width = 32, Unit Height = 32, Display Width = 512, Display Height = 512 (16x16 board)
# Base address for display 0x10008000 ($gp)

# Ships Coordinates:
	# Big ship: 0 0 0 3
	# Medium ships: 5 3 5 5	, 6 0 6 2
	# Small ships: 1 4 2 4  , 4 4 4 5  , 2 1 3 1
					
.data
	screen:			.word	0x10008000	# start of screen
	lightBlue:		.word	0x004876FF	# lighter blue hex
	darkBlue:		.word	0x004169E1	# darker blue hex
	black:			.word	0x00212F3D	# black
	green:			.word	0x00159895	# green
	red:			.word	0x00922B21	# red
	lightGreen:		.word	0x0003C988	# light green
	darkGreen:		.word	0x0000337C
    yellow:         .word   0x00FFC436  # yellow
    bigShip:     	.word   0x009E6F21
	mediumShip:		.word	0x008696FE
	smallShip:		.word	0x00F5E8C7
    brown:          .word   0x00E1AA74
    real_black:     .word   0x00000000  
	Coor:			.byte	0:20
	buffer:			.space 	4
	buffer2:			.space 	7
	filename:		.asciiz		"D:\\HCMUT\\HK231\\Computer Achitecture\\Assignment\\game_log.txt"
	welcome:		.asciiz		"Welcome to BattleShip!\nThis is a 1v1 game! \nTwo players choose their ships location and blindly fire the opponent's ship, the first who hit all the opponent's ship will be the winner!"
	Prompt_Rules: 	.asciiz		"Rules of the Game:\n1. Shots must be taken by the number (0-6) for row coordinate and (0-6) for column coordinate, i.e. Top left corner have coordinates(0,0)\n2. A ship sinks when it has been hit for all its times\n- Small ships (2x1): 3\n- Medium ships (3x1): 2\n- Big ship (4x1): 1\n3. You play against Each other. First to lose all their ships, lose."
	newLine:		.asciiz		"\n"
	missMessage:	.asciiz		"Miss!"
	hitMessage:		.asciiz		"Hit!"
	p1InitMessage:	.asciiz		"Player 1 - Please begin by placing your ships"
	p2InitMessage:	.asciiz		"Player 2 - Please begin by placing your ships"
	InputSmallShipMessage:	.asciiz "Now, Let's begin by placing your Small ships.\nNote that the size of small ships is 2x1 and you have 3 small ships."
	InputMediumShipMessage:	.asciiz "Good! Next, please place your Medium ships.\nNote that the size of medium ships is 3x1 and you have 2 medium ships."
	InputBigShipMessage:	.asciiz "Excelent! Let's end up placing your Large ship.\nNote that the size of medium ships is 4x1 and you have 1 Large ship."
	AskCoordinates_Prompt:	.asciiz		"Enter the ship coordinates. Must be by the form (x0 y0 x1 y1): "
	invalid_message:   .asciiz "Invalid input. Please enter four integers (0-6) separated by spaces.\n"
	AskFireCoordinates_Prompt:	.asciiz		"Enter the ship coordinates. Must be by the form (x y): "
	invalid_fire_message:   .asciiz "Invalid input. Please enter two integers (0-6) separated by a space.\n"
	p1FireMessage:	.asciiz "Player 1 - Please set up a fire location"
	p2FireMessage:	.asciiz "Player 2 - Please set up a fire location"
	Duplicate_Prompt:	.asciiz "You've already shot this location !!!"
	user1Win:	.asciiz		"Congratulations! Player 1 won!" #30
	user2Win:	.asciiz		"Congratulations! Player 2 won!"
	Draw_result:	.asciiz		"Both of you are excellent. Draw !!!" #35
	playAgain:	.asciiz		"Would you like to play again?"
	space:	.asciiz " "
	p1_identity:		.asciiz "P1: "
	p2_identity:		.asciiz "P2: "
	Dash:		.asciiz "----------------------------------------------------------------------------\n" 
	Setup_phase:		.asciiz "Setup Phase: \n" #14
	Battle_prompt:		.asciiz "Battle Phase: \n"  #15
	Hit_message:	.asciiz "HIT!\n"
	Miss_message:	.asciiz "MISS!\n"

	p1Board:		.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
	
	p2Board:		.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	
					.word	0,0,0,0,0,0,0	

#define 
	.eqv N 7	#const int N = 7
	.eqv Nscreen 16
	.eqv M 256	#const int M = 16 * 16
.text

#s0 store the current turn. 0 - User 1 : 1 - User 2
#s1 store x0, s2 store y0, s3 store x1, s4 store y1
# Draw welcome screen, pause for 2 seconds, draw battle screen.... Go time!
main:

	# Open file for writing
    li $v0, 13         # system call for open file
    la $a0, filename   # load address of filename into $a0
    li $a1, 1          # flags: 1 for write, 0 for read
    li $a2, 0          # mode: ignored for write
    syscall            # make system call
    move $s6, $v0      # save file descriptor to $s0

	jal	drawWelcomeScreen
	li	$s0, 0
 
	li	$v0, 55
	la	$a0, welcome		# Print welcome message
	la	$a1, 1
	syscall

	li	$v0, 55
	la	$a0, Prompt_Rules		# Print rules message
	la	$a1, 1
	syscall

	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, Setup_phase     # load address of string into $a1
	li $a2, 14         # length of the string
	syscall
	
	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, Dash     # load address of string into $a1
	li $a2, 77         # length of the string
	syscall

	jal	sleepScreen500ms
	jal	drawGameScreen

	jal p1ShipsInit
	xori	$s0, $s0, 1			# $ts = $s0 ^ 1
	jal p2ShipsInit
	xori	$s0, $s0, 1

	#--------------------------#
	jal DrawBlankScreen
	#jal DrawBorder
	jal Draw3
	jal sleepScreen1Sec
	
	jal DrawBlankScreen
	#jal DrawBorder
	jal Draw2
	jal sleepScreen1Sec
	
	jal DrawBlankScreen
	#jal DrawBorder
	jal Draw1
	jal sleepScreen1Sec
	#--------------------------#

	jal DrawBlankScreen
	jal GameStart

	beq $s3, $s4, DrawResult

	blt $s3, $s4, Win2
	j Win1
DrawResult:
	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, Draw_result     # load address of string into $a1
	li $a2, 35         # length of the string
	syscall

	li	$v0, 55
	la	$a0, Draw_result		# Print rules message
	la	$a1, 1
	syscall	
	j replay

Win1:
	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, user1Win     # load address of string into $a1
	li $a2, 30         # length of the string
	syscall

	li	$v0, 55
	la	$a0, user1Win		# Print rules message
	la	$a1, 1
	syscall
	j replay

Win2:
	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, user2Win     # load address of string into $a1
	li $a2, 30         # length of the string
	syscall

	li	$v0, 55
	la	$a0, user2Win		# Print rules message
	la	$a1, 1
	syscall
	
	j replay
#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
#---------------------------------P1 and P2 SHIP PLACEMENT---------------------------#
#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#

returnP1:
	lw 		$ra, 0($sp)
	addi 	$sp, $sp, 4
	jr 		$ra

p1ShipsInit:
	addi 	$sp, $sp, -4
	sw 		$ra, 0($sp)

	jal drawP1

	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, p1_identity     # load address of string into $a1
	li $a2, 4         # length of the string
	syscall
	
	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, newLine     # load address of string into $a1
	li $a2, 1         # length of the string
	syscall

	li	$v0, 55
	la	$a0, p1InitMessage		# Print p1 init message
	la	$a1, 1
	syscall
	
	li	$v0, 55
	la	$a0, InputSmallShipMessage		# Print p1 init message
	la	$a1, 1
	syscall

	li $t7, 6
	try:
		beq $t7, 0, returnP1

		jal AskCoordinates
		subi	$s1, $s1, 48			# $s1 = $s1 - 0
		subi	$s2, $s2, 48			# $s2 = $s2 - 0
		subi	$s3, $s3, 48			# $s3 = $s3 - 0
		subi	$s4, $s4, 48			# $s4 = $s4 - 0
		
		li $t9, 1

		jal Coordinate_Validate1	
		and $t9, $t9, $v0
		jal Coordinate_Validate2	
		and	$t9, $t9, $v0
		jal Coordinate_Validate3	
		and $t9, $t9, $v0
		jal Coordinate_Validate4	
		and $t9, $t9, $v0
		jal Coordinate_Validate
		and $t9, $t9, $v0

		bne $t8, 10, error
		beq $t9, 0, error
		j continue

error:
		li	$v0, 55
		la	$a0, invalid_message		# Print welcome message
		la	$a1, 1
		syscall
		j try

continue:
		lw		$t5, smallShip
		li		$s5, 2
		bgt		$t7, 3, ok
		jal		ColorUpdate
ok:		
		jal	Size_Validate
		and $t9, $t9, $v0
		beq $t9, 0, error

					#Print 2 Coordinates to file
		addiu $s1, $s1, 48
		addiu $s2, $s2, 48
		addiu $s3, $s3, 48
		addiu $s4, $s4, 48

		la	  $s7, buffer2
		sb    $s1, 0($s7)
		sb    $s2, 2($s7)
		sb	  $s3, 4($s7)
		sb    $s4, 6($s7)

		# Write string to file
		li $v0, 15
		move $a0, $s6
		la $a1, buffer2
		li $a2, 7
		syscall

		addiu $s1, $s1, -48
		addiu $s2, $s2, -48
		addiu $s3, $s3, -48
		addiu $s4, $s4, -48
		#return back value before filling 

		li $v0, 15         # system call for write to file
		move $a0, $s6      # file descriptor
		la $a1, newLine     # load address of string into $a1
		li $a2, 1         # length of the string
		syscall

		jal fill
		subi $t7, $t7, 1

		beq $t7, 3, kek
		j kekek
kek:
		li $v0, 15         # system call for write to file
		move $a0, $s6      # file descriptor
		la $a1, newLine     # load address of string into $a1
		li $a2, 1         # length of the string
		syscall
	
		li	$v0, 55
		la	$a0, InputMediumShipMessage		# Print p1 init message
		la	$a1, 1
		syscall
		
		j try
kekek:
		bne $t7, 1, try
		
		li $v0, 15         # system call for write to file
		move $a0, $s6      # file descriptor
		la $a1, newLine     # load address of string into $a1
		li $a2, 1         # length of the string
		syscall

		li	$v0, 55
		la	$a0, InputBigShipMessage		# Print p1 init message
		la	$a1, 1
		syscall
		j try


fillreturn:
	lw		$ra, 12($sp)
	lw		$s1, 8($sp)
	lw		$s2, 4($sp)
	lw		$t7, 0($sp)
	addi 	$sp, $sp, 16

	jr $ra
fill: 
	addi 	$sp, $sp, -16
	sw		$ra, 12($sp)
	sw		$s1, 8($sp)
	sw		$s2, 4($sp)
	sw		$t7, 0($sp) 

	la 	$t1, p1Board
	bne	$s0, 1, go		#if it's not the p2 turn
	la 	$t1, p2Board

go:
	li 		$t2, 0 #t2 used to decode
	mul 	$t2, $s1, N		#row index * size
	add 	$t2, $t2, $s2	#row index * size + col index
	mul		$t2, $t2, 4
	add		$t1, $t1, $t2

	blt $s2, $s4, fori
	j ford
	fori:
		bgt $s2, $s4, fillreturn

		move	$t3, $s1
		move	$t4, $s2
		
		li 		$t7, 1
		sw		$t7, ($t1)

		jal		Decode_and_UpdateScreen
		addi $s2, $s2, 1
		addi $t1, $t1, 4
		jal sleepScreen500ms
		j fori

	ford:
		bgt $s1, $s3, fillreturn
		move	$t3, $s1
		move	$t4, $s2
		
		li 		$t7, 1
		sw		$t7, ($t1)

		jal		Decode_and_UpdateScreen
		addi $s1, $s1, 1
		addi $t1, $t1, 28
		jal sleepScreen500ms
		j ford

#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
#------------------------------END P1 SHIP PLACEMENT---------------------------------#
#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#

returnP2:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

p2ShipsInit:
#init stack pointer
	addi 	$sp, $sp, -4
	sw		$ra, ($sp)

	jal sleepScreen1Sec
	jal drawGameScreen
	jal drawP2

	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, newLine     # load address of string into $a1
	li $a2, 1         # length of the string
	syscall

	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, p2_identity     # load address of string into $a1
	li $a2, 4         # length of the string
	syscall
	
	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, newLine     # load address of string into $a1
	li $a2, 1         # length of the string
	syscall

	li	$v0, 55
	la	$a0, p2InitMessage		# Print p1 init message
	la	$a1, 1
	syscall
	
	li	$v0, 55
	la	$a0, InputSmallShipMessage		# Print p1 init message
	la	$a1, 1
	syscall

	li $t7, 6
	try2:
		beq $t7, 0, returnP2

		jal AskCoordinates
		subi	$s1, $s1, 48			# $s1 = $s1 - 0
		subi	$s2, $s2, 48			# $s2 = $s2 - 0
		subi	$s3, $s3, 48			# $s3 = $s3 - 0
		subi	$s4, $s4, 48			# $s4 = $s4 - 0
		
		li $t9, 1

		jal Coordinate_Validate1	
		and $t9, $t9, $v0
		jal Coordinate_Validate2	
		and	$t9, $t9, $v0
		jal Coordinate_Validate3	
		and $t9, $t9, $v0
		jal Coordinate_Validate4	
		and $t9, $t9, $v0
		jal Coordinate_Validate
		and $t9, $t9, $v0

		bne $t8, 10, error2
		beq $t9, 0, error2
		j continue2

error2:
		li	$v0, 55
		la	$a0, invalid_message		# Print welcome message
		la	$a1, 1
		syscall
		j try2

continue2:
		lw		$t5, smallShip
		li		$s5, 2
		bgt		$t7, 3, ok2
		jal		ColorUpdate
ok2:		
		
		jal	Size_Validate
		and $t9, $t9, $v0
		beq $t9, 0, error2

			#Print 2 Coordinates to file
		addiu $s1, $s1, 48
		addiu $s2, $s2, 48
		addiu $s3, $s3, 48
		addiu $s4, $s4, 48

		la	  $s7, buffer2
		sb    $s1, 0($s7)
		sb    $s2, 2($s7)
		sb	  $s3, 4($s7)
		sb    $s4, 6($s7)

		# Write string to file
		li $v0, 15
		move $a0, $s6
		la $a1, buffer2
		li $a2, 7
		syscall

		addiu $s1, $s1, -48
		addiu $s2, $s2, -48
		addiu $s3, $s3, -48
		addiu $s4, $s4, -48
		#return back value before filling 

		li $v0, 15         # system call for write to file
		move $a0, $s6      # file descriptor
		la $a1, newLine     # load address of string into $a1
		li $a2, 1         # length of the string
		syscall

		jal fill
		subi $t7, $t7, 1

		beq $t7, 3, kek2
		j kekek2
kek2:
		li $v0, 15         # system call for write to file
		move $a0, $s6      # file descriptor
		la $a1, newLine     # load address of string into $a1
		li $a2, 1         # length of the string
		syscall

		li	$v0, 55
		la	$a0, InputMediumShipMessage		# Print p1 init message
		la	$a1, 1
		syscall
		
		j try2
kekek2:
		bne $t7, 1, try2

		li $v0, 15         # system call for write to file
		move $a0, $s6      # file descriptor
		la $a1, newLine     # load address of string into $a1
		li $a2, 1         # length of the string
		syscall

		li	$v0, 55
		la	$a0, InputBigShipMessage		# Print p1 init message
		la	$a1, 1
		syscall
		j try2

#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
#------------------------------END P2 SHIP PLACEMENT---------------------------------#
#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#



#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
#-----------------------------------START GAME---------------------------------------#
#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#

# From now, always use $t0 to encode screen, $t1 to encode back_end board, $s0 to indicate the current turn
# $s1, $s2 to ask for fire coordinates. (Use Coordinate_validate1 and Coordinate_validate2 to check when asking)
# Draw a new board (P1 : left, P2 : right)
# Use a new Screen_decoding Function
# P1 will shoot to right board, while P2, will shoot to left board
# Remember to Stack variable in case of using old variable

GameReturn:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j return

GameStart:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal Draw2Boards
	jal Decoration

	li $s3, 16
	li $s4, 16

	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, Dash     # load address of string into $a1
	li $a2, 77         # length of the string
	syscall
	
	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, Battle_prompt     # load address of string into $a1
	li $a2, 15         # length of the string
	syscall

	li $v0, 15         # system call for write to file
	move $a0, $s6      # file descriptor
	la $a1, Dash     # load address of string into $a1
	li $a2, 77         # length of the string
	syscall
	

	Game:
	P1:	
		jal TurnIndicator
		li	$v0, 55
		la	$a0, p1FireMessage		# Print p1 init message
		la	$a1, 1
		syscall

		jal AskFireCoordinates
		subi	$s1, $s1, 48			# $s1 = $s1 - 0
		subi	$s2, $s2, 48			# $s2 = $s2 - 0
		
		li $t9, 1

		jal Coordinate_Validate1	
		and $t9, $t9, $v0
		jal Coordinate_Validate2	
		and	$t9, $t9, $v0
		bne $t8, 10, P1_Error
		beq $t9, 0,  P1_Error		

		jal CheckDuplicate
		and $t9, $t9, $v0
		beq $t9, 0,  Duplicate_Error1		

		li $v0, 15         # system call for write to file
		move $a0, $s6      # file descriptor
		la $a1, p1_identity     # load address of string into $a1
		li $a2, 4         # length of the string
		syscall

		jal Fire
		xori $s0, $s0, 1

		j P2
P1_Error:
		li	$v0, 55
		la	$a0, invalid_fire_message		# Print welcome message
		la	$a1, 1
		syscall
		
		j P1

Duplicate_Error1:
		li	$v0, 55
		la	$a0, Duplicate_Prompt		# Print welcome message
		la	$a1, 1
		syscall

		j P1
#----------------------ok ok P1 check ok ok------------------#

	P2:
		jal TurnIndicator
		
		li	$v0, 55
		la	$a0, p2FireMessage		# Print p1 init message
		la	$a1, 1
		syscall

		jal AskFireCoordinates
		subi	$s1, $s1, 48			# $s1 = $s1 - 0
		subi	$s2, $s2, 48			# $s2 = $s2 - 0
		
		li $t9, 1

		jal Coordinate_Validate1	
		and $t9, $t9, $v0
		jal Coordinate_Validate2	
		and	$t9, $t9, $v0
		bne $t8, 10, P2_Error
		beq $t9, 0,  P2_Error		

		jal CheckDuplicate
		and $t9, $t9, $v0
		beq $t9, 0,  Duplicate_Error2
	
		li $v0, 15         # system call for write to file
		move $a0, $s6      # file descriptor
		la $a1, p2_identity     # load address of string into $a1
		li $a2, 4         # length of the string
		syscall

		jal Fire
		xori $s0, $s0, 1

		beq $s3, 0, GameReturn
		beq $s4, 0, GameReturn

		li $v0, 15         # system call for write to file
    	move $a0, $s6      # file descriptor
    	la $a1, Dash     # load address of string into $a1
    	li $a2, 77         # length of the string
    	syscall 

		j Game

P2_Error:
		li	$v0, 55
		la	$a0, invalid_fire_message		# Print welcome message
		la	$a1, 1
		syscall
		
		j P2

Duplicate_Error2:
		li	$v0, 55
		la	$a0, Duplicate_Prompt		# Print welcome message
		la	$a1, 1
		syscall

		j P2
#----------------------------------------------------------------------------#

Fire:
	addi 	$sp, $sp, -12
	sw 		$s1, 0($sp)
	sw		$s2, 4($sp)
	sw		$ra, 8($sp)
	#Decoding
	li		$t7, 1
	la 		$t1, p1Board
	bne 	$s0, 0, startfire
	la 		$t1, p2Board

startfire:
	mul $s1, $s1, N
	add $s1, $s1, $s2
	mul $s1, $s1, 4

	add $t1, $t1, $s1
	lw  $t7, ($t1)
	beq $t7, 1, Hit
	j Miss
Hit:
	beq $s0, 0, P1Successfull
	j P2Successfull
	P1Successfull:	
		subi $s4, $s4, 1
		j hithit
	P2Successfull:	
		subi $s3, $s3, 1
	
	hithit:
	li $t7, 2
	sw $t7, ($t1)
	j FillScreen
Miss:

	li $t7, 3
	sw $t7, ($t1)

FillScreen:
	lw $s1, 0($sp)
	lw $s2, 4($sp) 

	#Print 2 Coordinates to file
    addiu $s1, $s1, 48
	addiu $s2, $s2, 48
	la	  $s7, buffer
	sb    $s1, 0($s7)
	sb    $s2, 2($s7)

	# Write string to file
    li $v0, 15
    move $a0, $s6
    la $a1, buffer
    li $a2, 4
    syscall
	
	lw $s1, 0($sp)
	lw $s2, 4($sp) 
	lw $t0, screen
	lw $t6, green
	bne $t7, 3, Color
	lw $t6, red

Color:
	addi 	$s1, $s1, 4
	mul		$s1, $s1, 64
	mul		$s2, $s2, 4
	add		$s1, $s1, $s2
	add		$t0, $t0, $s1
	
	bne		$s0, 0, letcolor
	addi	$t0, $t0, 36

letcolor:
	sw		$t6, ($t0)
	beq 	$t7, 3, missmiss
	beq		$t7, 2, hitt
	missmiss:

	# Write string to file
    li $v0, 15         # system call for write to file
    move $a0, $s6      # file descriptor
    la $a1, Miss_message     # load address of string into $a1
    li $a2, 6         # length of the string
    syscall            # make system call

	li	$v0, 55
	la	$a0, Miss_message		# Print welcome message
	la	$a1, 1
	syscall
	j back

	hitt:
	li $v0, 15         # system call for write to file
    move $a0, $s6      # file descriptor
    la $a1, Hit_message     # load address of string into $a1
    li $a2, 5         # length of the string
    syscall  

	li	$v0, 55
	la	$a0, Hit_message		# Print welcome message
	la	$a1, 1
	syscall

	back:
	lw 		$s1, 0($sp)
	lw		$s2, 4($sp)
	lw		$ra, 8($sp)
	addi	$sp, $sp, 12
	j return

#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
#------------------------------------INPUT-------------------------------------------#
#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#

AskCoordinates:
	addi 	$sp, $sp, -4
	sw		$s0, ($sp)

	li	$v0, 54		# prepare to print string input dialog
	la	$a0, AskCoordinates_Prompt# load question to print
	la	$a1, Coor	# store user's answer into userRow
	la	$a2, 21		
	syscall			# display the input dialog
	beq	$a1, -2, exit	# 'cancel' is chosen
	#beq	$a1, -3, exit	# 'ok' was chose but input field is blank
	beq	$a1, -4, exit	# input exceeds length
	la	$s0, Coor
	lb	$s1, 0($s0)	# get attack column letter
	lb	$s2, 2($s0)	# get attack row number
	lb	$s3, 4($s0)	# get attack row number
	lb	$s4, 6($s0)	# get attack row number
	lb 	$t8, 7($s0) #special input case (I'm stupid)
	
	lw		$s0, ($sp)
	addi	$sp, $sp, 4
	j return

trash_value:
	li $s1, 99
	li $s2, 99
	lw		$s0, ($sp)
	addi	$sp, $sp, 4
	j return

AskFireCoordinates:
	addi 	$sp, $sp, -4
	sw		$s0, ($sp)

	li	$v0, 54		# prepare to print string input dialog
	la	$a0, AskFireCoordinates_Prompt# load question to print
	la	$a1, Coor	# store user's answer into userRow
	la	$a2, 21		
	syscall			# display the input dialog
	beq	$a1, -2, exit	# 'cancel' is chosen
	beq	$a1, -3, trash_value	# 'ok' was chose but input field is blank
	beq	$a1, -4, exit	# input exceeds length
	la	$s0, Coor
	lb	$s1, 0($s0)	# get attack column letter
	lb	$s2, 2($s0)	# get attack row number
	lb 	$t8, 3($s0) #special input case (I'm stupid)
	
	lw		$s0, ($sp)
	addi	$sp, $sp, 4
	j return

#----------------------SIZE VALIDATING-----------------------#
Size_Validate:
	addi $sp, $sp, -8
	sw $s1, 0($sp)
	sw $s2, 4($sp)

	sub $s1, $s1, $s3
	blt $s1, 0, abs1
	j sub2
abs1:
	mul $s1, $s1, -1

sub2:
	sub $s2, $s2, $s4
	bgt $s2, 0, res
	mul $s2, $s2, -1

res:
	add $s1, $s1, $s2
	sub $s5, $s5, $s1


ValueBack:
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8

	li $v0, 1
	beq $s5, 1, return
	li $v0, 0
	j return
#---------------------------SIZE VALIDATING---------------------#

#------------Coordinate Validating------------------------------#
#input s1,s2,s3,s4, output $v0
Coordinate_Validate:
	blt $s3, $s1, Invalid	#if $s1 > $s3
	blt $s4, $s2,	Invalid #if $s2 > $s4
	li $v0, 1

	bgt $s3, $s1, check2 	#if (s3 > s1)
	j start					#else start 
check2:
	bgt $s4, $s2, Invalid	#if (s4 > s2)
	j start

start:
	addi		$sp, $sp, -24			# $sp -= 20
	sw			$s1, 20($sp)
	sw			$s2, 16($sp)
	sw			$s3, 12($sp)
	sw			$s4, 8($sp)
	sw			$t3, 4($sp)
	sw			$t4, 0($sp)

	blt $s1, $s3, loop_case1 	#loop down
	j loop_case2	#loop right

loop_case1: #assume that the size is correct (unchecked the size)
	#decode s1,s2 to table
	li 		$t2, 0 #t2 used to decode
	mul 	$t2, $s1, N		#row index * size
	add 	$t2, $t2, $s2	#row index * size + col index
	mul		$t2, $t2, 4

	la 	$t0, p1Board
	add	$t0, $t0, $t2
	bne	$s0, 1, for		#if it's not the p2 turn
	la 	$t0, p2Board
	add $t0, $t0, $t2

	for:
		bgt $s1, $s3, finish
		li $t3, 1
		lw $t4, ($t0)
		bne $t3, $t4, move_next 
		li $v0, 0

	move_next:
		add $t0, $t0, 28
		addi $s1, $s1, 1
		j for

loop_case2:		#loop right
	#decode s1,s2 to table
	li 		$t2, 0 #t2 used to decode
	mul 	$t2, $s1, N		#row index * size
	add 	$t2, $t2, $s2	#row index * size + col index
	mul		$t2, $t2, 4

	la 	$t0, p1Board
	add	$t0, $t0, $t2
	bne	$s0, 1, for2		#if it's not the p2 turn
	la 	$t0, p2Board
	add $t0, $t0, $t2

	for2:
		bgt $s2, $s4, finish
		li $t3, 1
		lw $t4, ($t0)
		bne $t3, $t4, move_next2 
		li $v0, 0
	move_next2:
		add $t0, $t0, 4
		addi $s2, $s2, 1
		j for2

finish:
	lw			$s1, 20($sp)
	lw			$s2, 16($sp)
	lw			$s3, 12($sp)
	lw			$s4, 8($sp)
	lw			$t3, 4($sp)
	lw			$t4, 0($sp)			# $sp += 20
	addi		$sp, $sp, 24			# $sp -= 20

	j return

#--------------------------------------------------------------#

#Input $s1. Output $v0
Coordinate_Validate1:
	blt $s1, 0, Invalid
	bgt $s1, 6, Invalid
	li $v0, 1
	j return

Coordinate_Validate2:
	blt $s2, 0, Invalid
	bgt $s2, 6, Invalid
	li $v0, 1
	j return

Coordinate_Validate3:
	blt $s3, 0, Invalid
	bgt $s3, 6, Invalid
	li $v0, 1
	j return

Coordinate_Validate4:
	blt $s4, 0, Invalid
	bgt $s4, 6, Invalid
	li $v0, 1
	j return

Invalid:
	move $v0, $zero			# $v0 = $zero
	j return					# jump to $ra

#----------------------Duplicate checking-------------------------------#
CheckDuplicate:
	addi 	$sp, $sp, -12
	sw		$s1, 0($sp)
	sw		$s2, 4($sp)
	sw		$ra, 8($sp)

	la $t1, p1Board
	bne $s0, 0, _CheckDuplicate
	la $t1, p2Board
_CheckDuplicate:
	mul $s1, $s1, N
	add $s1, $s1, $s2
	mul $s1, $s1, 4

	add $t1, $t1, $s1
	lw  $t5, ($t1)
	

	li	$v0, 1
	blt $t5, 2, CheckDuplicateReturn
	li 	$v0, 0

CheckDuplicateReturn:
	lw		$s1, 0($sp)
	lw		$s2, 4($sp)
	lw		$ra, 8($sp)
	addi	$sp, $sp, 12
	j return
#----------------------Duplicate return-----------------------#

#arg: t3,t4,t5(color) #use $t0
Decode_and_UpdateScreen:
	addi 	$t3, $t3, 4
	addi 	$t4, $t4, 4
	mul	 	$t3, $t3, 64
	mul		$t4, $t4, 4
	add		$t3, $t3, $t4

	lw 		$t0, screen
	add 	$t0, $t0, $t3
	sw 		$t5, ($t0)

	li $t3, 0
	li $t4, 0
	li $t0, 0

	j return

ColorUpdate:
	bgt $t7, 1, update_medium_ship
	j update_big_ship

update_medium_ship:
	li $s5, 3
	lw $t5, mediumShip
	j return

update_big_ship:
	li $s5, 4
	lw $t5, bigShip
	j return

# Sleep for 3 seconds
sleepScreen5Sec:
	ori 	$v0, $zero, 32			# Syscall sleep
	ori 	$a0, $zero, 5000		# For this many milliseconds
	syscall
	jr	$ra

# Sleep for 2 seconds
sleepScreen2Sec:
	ori 	$v0, $zero, 32			# Syscall sleep
	ori 	$a0, $zero, 2000		# For this many milliseconds
	syscall
	jr	$ra

# Sleep for 2 seconds
sleepScreen1Sec:
	ori 	$v0, $zero, 32			# Syscall sleep
	ori 	$a0, $zero, 1000		# For this many milliseconds
	syscall
	jr	$ra

# Sleep for 500ms
sleepScreen500ms:
	ori 	$v0, $zero, 32			# Syscall sleep
	ori 	$a0, $zero, 500		# For this many milliseconds
	syscall
	jr	$ra


# Resets all of the values then calls main to replay the game
replay:
 	# Close file
    li $v0, 16
    move $a0, $s6
    syscall
	li	$v0, 50
	la	$a0, playAgain
	la	$a1, 3
	syscall
	bne	$a0, 0, exit

	li	$t0, 0
	li	$t1, 0
	li	$t2, 0
	li	$t3, 0
	li	$t4, 0
	li	$t5, 0
	li	$t6, 0
	li	$t7, 0
	li	$t8, 0
	li	$t9, 0
	
	li	$s0, 0
	li	$s1, 0
	li	$s2, 0
	li	$s3, 0
	li	$s4, 0
	li	$s5, 0
	li	$s6, 0
	li	$s7, 0
	
	li	$a0, 0
	li	$a1, 0
	li	$a2, 0
	li	$a3, 0
	
	j	main

# Terminate
exit:
	# Close file
    li $v0, 16
    move $a0, $s6
    syscall

	li	$v0, 10
	syscall	


#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
#---------------------------------WELCOME SCREEN-------------------------------------#
#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#	

# Load colors into registers
drawWelcomeScreen:
	lw	$t0, screen		# store start of screen in $t0
	
	lw	$t1, black		# load black into #t1
	lw	$t2, yellow		# load lightblue into $t2
	lw	$t3, brown		# load darkBlue into $t3

# Draws first two lines black	
drawBlankCounter1:
	addi	$t4, $t4, 1
	addi	$t5, $t5, 32	

# Draws first two lines black
drawBlank1:	
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	beq	$t4, $t5, battleWord
	addi	$t4, $t4, 1
	j	drawBlank1

# Draw word BATTLE
battleWord:
	# Row 3
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue 8
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	# Row 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	# Row 5
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	# Row 6
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	# Row 7
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	
drawBlankCounter2:
	addi	$t4, $t4, 1
	addi	$t5, $t5, 32	

# Draw rows 8 and 9 black
drawBlank2:	
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	beq	$t4, $t5, shipWord
	addi	$t4, $t4, 1
	j	drawBlank2
	
# Draw word SHIP
shipWord:
	# Row 10
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	# Row 11
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	# Row 12
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	# Row 13
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	# Row 14
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4

# Draw last two rows black	
drawBlankCounter3:
	addi	$t4, $t4, 1
	addi	$t5, $t5, 32	

# Draw last two rows black
drawBlank3:	
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4		
	beq	$t4, $t5, return	# Goes to helper func that returns back to where this function was called
	addi	$t4, $t4, 1		# Increment counter
	j	drawBlank3
	
#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#
#---------------------------------BATTLE SCREEN-------------------------------------#
#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#
drawGameScreen:
	lw	$t0, screen		# store start of screen in $t0
	
	lw	$t1, black		# load black into #t1
	lw	$t2, lightBlue		# load lightblue into $t2
	lw	$t3, darkBlue		# load darkBlue into $t3
    lw  $t4, yellow
    lw  $t5, real_black
    lw  $t6, brown

	#start of row 1
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 2
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 3
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 5
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 6
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 7
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 8
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 9
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 10
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 11
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw dark blue
	addi	$t0, $t0, 4
	sw	$t2, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 12
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 13
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4
	
    # start of row 14
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw yellow
	addi	$t0, $t0, 4

	# start of row 15
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t4, ($t0)		# Draw yellow
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t1, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t6, ($t0)		# Draw brown
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw black
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw black
	addi	$t0, $t0, 4

	# start of row 16
    sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
    sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
    sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
    sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
    sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
    sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
    sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t3, ($t0)		# Draw light blue
	addi	$t0, $t0, 4
	sw	$t5, ($t0)		# Draw light blue

	jr	$ra

drawP1:
    lw  $t0, screen         #row 1
    lw  $t1, yellow

    sw  $t1, 16($t0)
    sw  $t1, 20($t0)
    sw  $t1, 36($t0)

    addi    $t0, $t0, 64   #row 2
    sw  $t1, 16($t0)
    sw  $t1, 24($t0)
    sw  $t1, 32($t0)
    sw  $t1, 36($t0)

    addi    $t0, $t0, 64   #row 3
    sw  $t1, 16($t0)
    sw  $t1, 20($t0)
    sw  $t1, 36($t0)

    addi    $t0, $t0, 64   #row 4
    sw $t1, 16($t0)
    sw $t1, 32($t0)
    sw $t1, 36($t0)
    sw $t1, 40($t0)

    j return					# jump to $ra

drawP2:
    lw  $t0, screen         #row 1
    lw  $t1, yellow
	lw	$t2, black

    sw  $t1, 16($t0)
    sw  $t1, 20($t0)
    sw  $t1, 36($t0)
    sw  $t1, 40($t0)

    addi    $t0, $t0, 64   #row 2
    sw  $t1, 16($t0)
    sw  $t1, 24($t0)
    sw  $t1, 40($t0)

    addi    $t0, $t0, 64   #row 3
    sw  $t1, 16($t0)
    sw  $t1, 20($t0)
    sw  $t1, 36($t0)

    addi    $t0, $t0, 64   #row 4
    sw $t1, 16($t0)
    sw $t1, 32($t0)
    sw $t1, 36($t0)
    sw $t1, 40($t0)

    j return					# jump to $ra

# END FUN foo

return:
	jr	$ra

#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#
#--------------------------------LOADING SCREEN-------------------------------------#
#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#

DrawBlankScreen:
	lw $t0, screen
	lw $t7, black
	li $t8, 0
	Draw:
		beq $t8, 256, return
		sw	$t7, ($t0)
		addi $t0, $t0, 4
		addi $t8, $t8, 1
		j Draw


#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#
#--------------------------------BATTLE SCREEN--------------------------------------#
#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#

Draw2BoardsReturn:
	lw $s6, 0($sp)
	addi $sp, $sp, 4
	j return

Draw2Boards:
	addi $sp, $sp, -4
	sw $s6, 0($sp)

	lw $t0, screen
	lw $t7, black
	lw $t8, lightBlue
	lw $t9, darkBlue
	addi $t0, $t0, 256
	li $s6, 0
	li $s7, 0
	for_row:
		beq $s6, 7, Draw2BoardsReturn
		li $s7, 0
		for_col:
			beq $s7, 4, skip1
			sw $t8, ($t0)
		skip1:
			beq $s7, 3, skip2
			sw $t9, 4($t0)
		skip2:			
			addi $t0, $t0, 8
			addi $s7, $s7, 1
			bne $s7, 8, for_col
	move $s5, $t8
	move $t8, $t9
	move $t9, $s5
	addi  $s6, $s6, 1
	j for_row

TurnIndicator:
	lw $t0, screen
	lw $t7, yellow
	bne $s0, 1, light1
	lw $t7, darkGreen

light1: 
	sw $t7, 12($t0)
	addi $t0, $t0, 64
	
	sw $t7, 8($t0)
	sw $t7, 12($t0)
	addi $t0, $t0, 64

	sw $t7, 12($t0)
	addi $t0, $t0, 64

	sw $t7, 8($t0)
	sw $t7, 12($t0)
	sw $t7, 16($t0)

	lw $t7, darkGreen
	bne $s0, 1, light2
	lw $t7, yellow
	
light2:
	lw $t0, screen
	
	sw $t7, 48($t0)
	sw $t7, 52($t0)
	addi $t0, $t0, 64

	sw $t7, 52($t0)
	addi $t0, $t0, 64

	sw $t7, 48($t0)
	addi $t0, $t0, 64

	sw $t7, 44($t0)
	sw $t7, 48($t0)
	sw $t7, 52($t0)

	j return

DrawBorder:
	lw $t0, screen
	lw $t1, darkBlue
	li $t3, 0
	top_bottom:
		beq $t3, 16, MidPart
		sw $t1, ($t0)
		sw $t1, 960($t0)
		addi $t0, $t0, 4
		addi $t3, $t3, 1
	j top_bottom
	
	MidPart:
	li $t3, 0
	lw $t0, screen
	addi $t0, $t0, 64
	Loop_MidPart:
		sw $t1, 0($t0)
		sw $t1, 60($t0)
		addi $t3,$t3, 1
		addi $t0, $t0, 64
		beq $t3, 14, return
	j Loop_MidPart

Draw3:
	lw $t0, screen
	lw $t1, yellow
	addi $t0, $t0, 128

	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	addi $t0, $t0, 64

	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64
	
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64

	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64
	
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64
	
	sw $t1, 28($t0)	
	sw $t1, 32($t0)	
	sw $t1, 36($t0)	
	sw $t1, 40($t0)	
	addi $t0, $t0, 64
	
	sw $t1, 28($t0)	
	sw $t1, 32($t0)	
	sw $t1, 36($t0)	
	sw $t1, 40($t0)	
	addi $t0, $t0, 64

	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64
	
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64

	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64
	
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64

	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	
	j return

Draw1:
	lw $t0, screen
	lw $t1, yellow
	addi $t0, $t0, 128

	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64

	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64
	
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64

	j return

Draw2:
	lw $t0, screen
	lw $t1, yellow
	addi $t0, $t0, 128

	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	addi $t0, $t0, 64
	
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64
	
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	addi $t0, $t0, 64

	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 44($t0)
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	addi $t0, $t0, 64

	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	addi $t0, $t0, 64
	
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	addi $t0, $t0, 64
	
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, 64
	
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	addi $t0, $t0, 64
	
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	addi $t0, $t0, 64

	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	addi $t0, $t0, 64	
	
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	addi $t0, $t0, 64	

	j return

Decoration:
	lw $t0, screen
	lw $t2, green
	lw $t3, darkBlue
	addi $t0, $t0, 704

	sw $t2, 12($t0)
	sw $t2, 48($t0)
	addi $t0, $t0, 64

	sw $t2, 8($t0)
	sw $t2, 16($t0)
	sw $t2, 44($t0)
	sw $t2, 52($t0)
	addi $t0, $t0, 64

	sw $t2, 4($t0)
	sw $t2, 20($t0)
	sw $t2, 40($t0)
	sw $t2, 56($t0)
	addi $t0, $t0, 64

	sw $t2, 0($t0)
	sw $t2, 24($t0)
	sw $t2, 36($t0)
	sw $t2, 60($t0)

	li $t4, 0
	last_row:
		beq $t4, 16, return
		#sw $t2, 0($t0)
		addi $t0,$t0, 64
		sw $t3, 0($t0)
		addi $t0, $t0, -64
		addi $t0, $t0, 4
		addi $t4, $t4, 1
		j last_row
