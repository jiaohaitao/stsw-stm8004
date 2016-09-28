   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  45                     ; 38 void main(void)
  45                     ; 39 {
  47                     	switch	.text
  48  0000               _main:
  52                     ; 41 	CLK->CKDIVR = 0;                // sys clock /1
  54  0000 725f50c6      	clr	20678
  55                     ; 49 	GPIOB->DDR&= 0xcf;
  57  0004 c65007        	ld	a,20487
  58  0007 a4cf          	and	a,#207
  59  0009 c75007        	ld	20487,a
  60                     ; 50 	GPIOB->CR1&= 0xcf;
  62  000c c65008        	ld	a,20488
  63  000f a4cf          	and	a,#207
  64  0011 c75008        	ld	20488,a
  65                     ; 51 	GPIOB->CR2&= 0xcf;
  67  0014 c65009        	ld	a,20489
  68  0017 a4cf          	and	a,#207
  69  0019 c75009        	ld	20489,a
  70                     ; 54 	Init_I2C();
  72  001c cd0000        	call	_Init_I2C
  74                     ; 57 	enableInterrupts();
  77  001f 9a            rim
  79  0020               L12:
  80                     ; 60   while(1);
  82  0020 20fe          	jra	L12
  95                     	xdef	_main
  96                     	xref	_Init_I2C
 115                     	end
