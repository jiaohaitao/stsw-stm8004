   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  46                     ; 13 	void I2C_transaction_begin(void)
  46                     ; 14 	{
  48                     	switch	.text
  49  0000               _I2C_transaction_begin:
  53                     ; 15 		MessageBegin = TRUE;
  55  0000 35010003      	mov	_MessageBegin,#1
  56                     ; 16 	}
  59  0004 81            	ret
  83                     ; 17 	void I2C_transaction_end(void)
  83                     ; 18 	{
  84                     	switch	.text
  85  0005               _I2C_transaction_end:
  89                     ; 20 	}
  92  0005 81            	ret
 129                     ; 21 	void I2C_byte_received(u8 u8_RxData)
 129                     ; 22 	{
 130                     	switch	.text
 131  0006               _I2C_byte_received:
 133  0006 88            	push	a
 134       00000000      OFST:	set	0
 137                     ; 23 		if (MessageBegin == TRUE  &&  u8_RxData < MAX_BUFFER) {
 139  0007 b603          	ld	a,_MessageBegin
 140  0009 a101          	cp	a,#1
 141  000b 2612          	jrne	L74
 143  000d 7b01          	ld	a,(OFST+1,sp)
 144  000f a120          	cp	a,#32
 145  0011 240c          	jruge	L74
 146                     ; 24 			u8_MyBuffp= &u8_My_Buffer[u8_RxData];
 148  0013 7b01          	ld	a,(OFST+1,sp)
 149  0015 ab06          	add	a,#_u8_My_Buffer
 150  0017 5f            	clrw	x
 151  0018 97            	ld	xl,a
 152  0019 bf04          	ldw	_u8_MyBuffp,x
 153                     ; 25 			MessageBegin = FALSE;
 155  001b 3f03          	clr	_MessageBegin
 157  001d 2014          	jra	L15
 158  001f               L74:
 159                     ; 27     else if(u8_MyBuffp < &u8_My_Buffer[MAX_BUFFER])
 161  001f be04          	ldw	x,_u8_MyBuffp
 162  0021 a30026        	cpw	x,#_u8_My_Buffer+32
 163  0024 240d          	jruge	L15
 164                     ; 28       *(u8_MyBuffp++) = u8_RxData;
 166  0026 7b01          	ld	a,(OFST+1,sp)
 167  0028 be04          	ldw	x,_u8_MyBuffp
 168  002a 1c0001        	addw	x,#1
 169  002d bf04          	ldw	_u8_MyBuffp,x
 170  002f 1d0001        	subw	x,#1
 171  0032 f7            	ld	(x),a
 172  0033               L15:
 173                     ; 29 	}
 176  0033 84            	pop	a
 177  0034 81            	ret
 202                     ; 30 	u8 I2C_byte_write(void)
 202                     ; 31 	{
 203                     	switch	.text
 204  0035               _I2C_byte_write:
 208                     ; 32 		if (u8_MyBuffp < &u8_My_Buffer[MAX_BUFFER])
 210  0035 be04          	ldw	x,_u8_MyBuffp
 211  0037 a30026        	cpw	x,#_u8_My_Buffer+32
 212  003a 240c          	jruge	L56
 213                     ; 33 			return *(u8_MyBuffp++);
 215  003c be04          	ldw	x,_u8_MyBuffp
 216  003e 1c0001        	addw	x,#1
 217  0041 bf04          	ldw	_u8_MyBuffp,x
 218  0043 1d0001        	subw	x,#1
 219  0046 f6            	ld	a,(x)
 222  0047 81            	ret
 223  0048               L56:
 224                     ; 35 			return 0x00;
 226  0048 4f            	clr	a
 229  0049 81            	ret
 232                     	switch	.ubsct
 233  0000               L17_sr1:
 234  0000 00            	ds.b	1
 235  0001               L37_sr2:
 236  0001 00            	ds.b	1
 237  0002               L57_sr3:
 238  0002 00            	ds.b	1
 293                     ; 45 @far @interrupt void I2C_Slave_check_event(void) {
 295                     	switch	.text
 296  004a               f_I2C_Slave_check_event:
 298  004a 3b0002        	push	c_x+2
 299  004d be00          	ldw	x,c_x
 300  004f 89            	pushw	x
 301  0050 3b0002        	push	c_y+2
 302  0053 be00          	ldw	x,c_y
 303  0055 89            	pushw	x
 306                     ; 52 sr1 = I2C->SR1;
 308  0056 5552170000    	mov	L17_sr1,21015
 309                     ; 53 sr2 = I2C->SR2;
 311  005b 5552180001    	mov	L37_sr2,21016
 312                     ; 54 sr3 = I2C->SR3;
 314  0060 5552190002    	mov	L57_sr3,21017
 315                     ; 57   if (sr2 & (I2C_SR2_WUFH | I2C_SR2_OVR |I2C_SR2_ARLO |I2C_SR2_BERR))
 317  0065 b601          	ld	a,L37_sr2
 318  0067 a52b          	bcp	a,#43
 319  0069 2708          	jreq	L521
 320                     ; 59     I2C->CR2|= I2C_CR2_STOP;  // stop communication - release the lines
 322  006b 72125211      	bset	21009,#1
 323                     ; 60     I2C->SR2= 0;					    // clear all error flags
 325  006f 725f5218      	clr	21016
 326  0073               L521:
 327                     ; 63   if ((sr1 & (I2C_SR1_RXNE | I2C_SR1_BTF)) == (I2C_SR1_RXNE | I2C_SR1_BTF))
 329  0073 b600          	ld	a,L17_sr1
 330  0075 a444          	and	a,#68
 331  0077 a144          	cp	a,#68
 332  0079 2605          	jrne	L721
 333                     ; 65     I2C_byte_received(I2C->DR);
 335  007b c65216        	ld	a,21014
 336  007e ad86          	call	_I2C_byte_received
 338  0080               L721:
 339                     ; 68   if (sr1 & I2C_SR1_RXNE)
 341  0080 b600          	ld	a,L17_sr1
 342  0082 a540          	bcp	a,#64
 343  0084 2706          	jreq	L131
 344                     ; 70     I2C_byte_received(I2C->DR);
 346  0086 c65216        	ld	a,21014
 347  0089 cd0006        	call	_I2C_byte_received
 349  008c               L131:
 350                     ; 73   if (sr2 & I2C_SR2_AF)
 352  008c b601          	ld	a,L37_sr2
 353  008e a504          	bcp	a,#4
 354  0090 2707          	jreq	L331
 355                     ; 75     I2C->SR2 &= ~I2C_SR2_AF;	  // clear AF
 357  0092 72155218      	bres	21016,#2
 358                     ; 76 		I2C_transaction_end();
 360  0096 cd0005        	call	_I2C_transaction_end
 362  0099               L331:
 363                     ; 79   if (sr1 & I2C_SR1_STOPF) 
 365  0099 b600          	ld	a,L17_sr1
 366  009b a510          	bcp	a,#16
 367  009d 2707          	jreq	L531
 368                     ; 81     I2C->CR2 |= I2C_CR2_ACK;	  // CR2 write to clear STOPF
 370  009f 72145211      	bset	21009,#2
 371                     ; 82 		I2C_transaction_end();
 373  00a3 cd0005        	call	_I2C_transaction_end
 375  00a6               L531:
 376                     ; 85   if (sr1 & I2C_SR1_ADDR)
 378  00a6 b600          	ld	a,L17_sr1
 379  00a8 a502          	bcp	a,#2
 380  00aa 2703          	jreq	L731
 381                     ; 87 		I2C_transaction_begin();
 383  00ac cd0000        	call	_I2C_transaction_begin
 385  00af               L731:
 386                     ; 90   if ((sr1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == (I2C_SR1_TXE | I2C_SR1_BTF))
 388  00af b600          	ld	a,L17_sr1
 389  00b1 a484          	and	a,#132
 390  00b3 a184          	cp	a,#132
 391  00b5 2606          	jrne	L141
 392                     ; 92 		I2C->DR = I2C_byte_write();
 394  00b7 cd0035        	call	_I2C_byte_write
 396  00ba c75216        	ld	21014,a
 397  00bd               L141:
 398                     ; 95   if (sr1 & I2C_SR1_TXE)
 400  00bd b600          	ld	a,L17_sr1
 401  00bf a580          	bcp	a,#128
 402  00c1 2706          	jreq	L341
 403                     ; 97 		I2C->DR = I2C_byte_write();
 405  00c3 cd0035        	call	_I2C_byte_write
 407  00c6 c75216        	ld	21014,a
 408  00c9               L341:
 409                     ; 99 	GPIOD->ODR^=1;
 411  00c9 c6500f        	ld	a,20495
 412  00cc a801          	xor	a,	#1
 413  00ce c7500f        	ld	20495,a
 414                     ; 100 }
 417  00d1 85            	popw	x
 418  00d2 bf00          	ldw	c_y,x
 419  00d4 320002        	pop	c_y+2
 420  00d7 85            	popw	x
 421  00d8 bf00          	ldw	c_x,x
 422  00da 320002        	pop	c_x+2
 423  00dd 80            	iret
 445                     ; 105 void Init_I2C (void)
 445                     ; 106 {
 447                     	switch	.text
 448  00de               _Init_I2C:
 452                     ; 109 		I2C->CR1 |= 0x01;				        	// Enable I2C peripheral
 454  00de 72105210      	bset	21008,#0
 455                     ; 110 		I2C->CR2 = 0x04;					      		// Enable I2C acknowledgement
 457  00e2 35045211      	mov	21009,#4
 458                     ; 111 		I2C->FREQR = 16; 					      	// Set I2C Freq value (16MHz)
 460  00e6 35105212      	mov	21010,#16
 461                     ; 112 		I2C->OARL = (SLAVE_ADDRESS << 1) ;	// set slave address to 0x51 (put 0xA2 for the register dues to7bit address) 
 463  00ea 35a25213      	mov	21011,#162
 464                     ; 113 		I2C->OARH = 0x40;					      	// Set 7bit address mode
 466  00ee 35405214      	mov	21012,#64
 467                     ; 125 	I2C->ITR	= 0x07;					      // all I2C interrupt enable  
 469  00f2 3507521a      	mov	21018,#7
 470                     ; 126 }
 473  00f6 81            	ret
 517                     	xdef	_I2C_byte_write
 518                     	xdef	_I2C_byte_received
 519                     	xdef	_I2C_transaction_end
 520                     	xdef	_I2C_transaction_begin
 521                     	switch	.ubsct
 522  0003               _MessageBegin:
 523  0003 00            	ds.b	1
 524                     	xdef	_MessageBegin
 525  0004               _u8_MyBuffp:
 526  0004 0000          	ds.b	2
 527                     	xdef	_u8_MyBuffp
 528  0006               _u8_My_Buffer:
 529  0006 000000000000  	ds.b	32
 530                     	xdef	_u8_My_Buffer
 531                     	xdef	f_I2C_Slave_check_event
 532                     	xdef	_Init_I2C
 533                     	xref.b	c_x
 534                     	xref.b	c_y
 554                     	end
