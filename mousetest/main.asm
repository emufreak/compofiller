BPLCON0=                    $100
BPLCON1=                    $102
BPLCON2=                    $104
BLTAMOD:                equ $64
BLTBMOD:                equ $62
BLTCMOD:                equ $60
BLTDMOD:                equ $66
BLTAFWM:                equ $44
BLTCON0:                equ $40
BLTCON1:                equ $42
VHPOSR:                 equ 6
BLTAPTH:                equ $50
BLTAPTL:                equ $52
BLTBPTH:                equ $4c
BLTCPTH:                equ $48
BLTDPTH:                equ $54
BLTSIZE:                equ $58
BLTADAT:                equ $74
BLTBDAT:                equ $72
CIAAPRA         EQU             $bfe001
VPOSR           EQU             $dff004
COP1LCH         EQU             $dff080
DMACONR		EQU		$dff002
ADKCONR		EQU		$dff010
INTENAR		EQU		$dff01c
INTREQR		EQU		$dff01e
CIAAPRA2         EQU             $001
VPOSR2           EQU             $004
COP1LCH2         EQU             $080
DMACONR2		EQU		$002
ADKCONR2		EQU		$010
INTENAR2		EQU		$01c
INTREQR2		EQU		$01e
DMACON		EQU		$dff096
ADKCON		EQU		$dff09e
INTENA		EQU		$dff09a
INTREQ		EQU		$dff09c
DMACON2		EQU		$096
ADKCON2		EQU		$09e
INTENA2		EQU		$09a
INTREQ2		EQU		$09c
init:
	; store data in hardwareregisters ORed with $8000
        ;(bit 15 is a write-set bit when values are written back into the system)
;Stack the registers
	movem.l d0-d7/a0-a6,-(sp)
	move.w	DMACONR,d0
	or.w #$8000,d0
	move.w d0,olddmareq
	move.w	INTENAR,d0
	or.w #$8000,d0
	move.w d0,oldintena
	move.w	INTREQR,d0
	or.w #$8000,d0
	move.w d0,oldintreq
;        move.w  #$7fff,INTENA
        move.w	ADKCONR,d0;
	or.w #$8000,d0
	move.w d0,oldadkcon
	; base library address in $4
	move.l	$4,a6
	move.l	#gfxname,a1
	moveq	#0,d0 ; whatever
	jsr	-552(a6) 
	move.l	d0,gfxbase
	move.l 	d0,a6
	move.l 	34(a6),oldview
	move.l 	38(a6),oldcopper
	move.l #0,a1
	jsr -222(a6)	; LoadView
	jsr -270(a6)	; WaitTOF
	jsr -270(a6)	; WaitTOF
	move.l	$4,a6
	jsr -132(a6)	; Forbid
        move.l #cop,a0
        move.l a0,COP1LCH
	jmp block1
Graphics_pa dc.l 0
Graphics_bpl	dc.w	0
Graphics_j	dc.w	0
Graphics_bytefill1	dc.b $ff, $7f, $3f, $1f, $f, $7, $3, $1
Graphics_bytefill2	dc.b $0, $80, $c0, $e0, $f0, $f8, $fc, $fe
	dc.b $ff, $ff
Graphics_bytefill3	dc.b $fe, $fc, $f8, $f0, $e0, $c0, $80, $0
mousereg	dc.w	$00
	 	CNOP 0,4
image_palette
	incbin "C:/Users/uersu/Documents/GitData/compofiller/mousetest///images/trse.pal"
	 	CNOP 0,4
	;*
; //	Sets up the copper list to point to a 320x256 buffer. Note that the screen will be set up 
; //	interlaced, with 40 bytes per line per bitplane. <p>
; //	
; //	Usage: 
; //		SetupDefaultScreen( [ data buffer ], [ number of bitplanes ] )
; //		
; //	Note that the data buffer must reside in chipmem
; //	
; //	Example:
; //	
; //	<code>
; //var
; //	const noBitPlanes = 2; 
; // 2 bitplanes = 4 colors
; //	buf : array[40*256*noBitPlanes] chipmem; 
; // data buffer stored in chipmem  
; //...
; //begin
; //	Graphics::SetupDefaultScreen(#buf, noBitPlanes);
; //	</code>
; //	
; 

	; ***********  Defining procedure : Graphics_SetupDefaultScreen
	;    Procedure type : User-defined procedure
	jmp block2
 ; Temp vars section
 ; Temp vars section ends
	 	CNOP 0,4
block2
Graphics_SetupDefaultScreen
	moveq #0,d0
	moveq #0,d1
	move.w #$1000,d1     ; BOP move
	mulu.w Graphics_bpl,d1 ; simple bop
	move.w d1,d0     ; BOP move
	or.w #$200,d0 ; simple bop
	; Store variable : Graphics_j
	move.w d0,Graphics_j
	; Poke command
	move.l #copper_resolution,a0
	move.w Graphics_j,(a0)
	cmp.w #$5,Graphics_bpl
	bne edblock6
ctb4: ;Main true block ;keep 
	
; // $4000  = bitplanes, $200 = colours
; // Set palette at copper palette location, 16 colors
; // Setup image copper list (4 bitplanes, 40*40 modulo 120
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane0,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane1,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane2,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane3,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane4,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	; Poke command
	move.l #copper_mod_even,a0
	move.w #$a0,(a0)
	; Poke command
	move.l #copper_mod_odd,a0
	move.w #$a0,(a0)
edblock6
	cmp.w #$4,Graphics_bpl
	bne edblock12
ctb10: ;Main true block ;keep 
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane0,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane1,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane2,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane3,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	; Poke command
	move.l #copper_mod_even,a0
	move.w #$78,(a0)
	; Poke command
	move.l #copper_mod_odd,a0
	move.w #$78,(a0)
edblock12
	cmp.w #$3,Graphics_bpl
	bne edblock18
ctb16: ;Main true block ;keep 
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane0,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane1,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane2,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; Poke command
	move.l #copper_mod_even,a0
	move.w #$50,(a0)
	; Poke command
	move.l #copper_mod_odd,a0
	move.w #$50,(a0)
edblock18
	cmp.w #$2,Graphics_bpl
	bne edblock24
ctb22: ;Main true block ;keep 
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane0,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane1,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$28,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; Poke command
	move.l #copper_mod_even,a0
	move.w #$28,(a0)
	; Poke command
	move.l #copper_mod_odd,a0
	move.w #$28,(a0)
edblock24
	cmp.w #$1,Graphics_bpl
	bne edblock30
ctb28: ;Main true block ;keep 
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane0,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	; Poke command
	move.l #copper_mod_even,a0
	move.w #$0,(a0)
	; Poke command
	move.l #copper_mod_odd,a0
	move.w #$0,(a0)
edblock30
	rts
	 	CNOP 0,4
block1
	
; // Some random image   	
; // Set to default interleaved 4-bpl screen
	move.l #image,Graphics_pa ; Simple a:=b optimization 
	move.w #$4,Graphics_bpl ; Simple a:=b optimization 
	jsr Graphics_SetupDefaultScreen
	move.l #$10,d0
	move.l #image_palette,a0
	move.l #copper_palette,a1
setpalette33
	addq.l #2,a1
	move.w (a0)+,(a1)+
	dbf d0,setpalette33
while34
loopstart38
	cmp.w #$0,mousereg
	bne edblock37
ctb35: ;Main true block ;keep 
	; Poke command
	move.l #$200,a1
	move.w #$1,(a1)
	; Peek command
	move.l #$BFE001,a1
	move.b (a1),d0
	; Store variable : mousereg
	move.w d0,mousereg
	move.w mousereg,d0
	and.w #$40,d0 ; Optimization: simple A := A op Const MUL DIV SHR etc
	move.w d0,mousereg
	
; // Wait for vertical blank
waitVB43
	move.l VPOSR,d0
	and.l #$1ff00,d0
	cmp.l #300<<8,d0
	bne waitVB43
	
; // Apply copper list
	move.l #cop,a1
	move.l a1,COP1LCH
	jmp while34
edblock37
loopend39
	 	CNOP 0,4
	 	CNOP 0,4
; exit gracefully - reverse everything done in init
	move.w #$7fff,DMACON
	move.w	olddmareq,DMACON
	move.w #$7fff,INTENA
	move.w	oldintena,INTENA
	move.w #$7fff,INTREQ
	move.w	oldintreq,INTREQ
	move.w #$7fff,ADKCON
	move.w	oldadkcon,ADKCON

	move.l	oldcopper,COP1LCH
	move.l 	gfxbase,a6
	move.l 	oldview,a1
	jsr -222(a6)	; LoadView
	jsr -270(a6)	; WaitTOF
	jsr -270(a6)	; WaitTOF
	move.l	$4,a6
	jsr -138(a6)	; Permit

	; end program
	movem.l (sp)+,d0-d7/a0-a6
	rts


;** PROCEDURES
; d6 = src shift
; d1 = dst x
; d2 = dst y
; d3 = modulo
; a0 = source
; a1 = dest
; d4 = blitter size
; d5 = bltmod
blitter:
    add.l   d6,a0
    mulu.w  d3,d2
    add.l   d1,d2
    add.l   d2,a1
                        ; Leftshift 1, use channels A and D, copy A -> D

    move.l  #$ffffffff,BLTAFWM(a6) ; Set last word and first word mask BLTAFWM and BLTALWM
.lp:

.litwait: ; Wait for blitter to be done
    btst    #14,DMACONR
    bne.s   .litwait

    move.w  d0,BLTCON0(a6)  ; Set registers; BLTCON0
    move.l  a0,BLTAPTH(a6) ; src 
    move.l  a1,BLTBPTH(a6) ; BLT Dest PTR
    move.l  a1,BLTCPTH(a6) ; BLT Dest PTR
    move.l  a1,BLTDPTH(a6) ; BLT Dest PTR
    move.w  d4,BLTSIZE(a6) ; BLTSIZE & Start blitter
    rts

; 1001




; storage for 32-bit addresses and data
	CNOP 0,4
oldview:	dc.l 0
oldcopper:	dc.l 0
gfxbase:	dc.l 0
frame:          dc.l 0

; storage for 16-bit data
	CNOP 0,4
olddmareq:	dc.w 0
oldintreq:	dc.w 0
oldintena:	dc.w 0
oldadkcon:	dc.w 0

copper_index    dc.w 0
	CNOP 0,4
gfxname: dc.b 'graphics.library',0



  section datachip,data_c

Chip:

    even
cop:
    dc.w    $008e
copper_diwstrt:
    dc.w    $2c81,$0090
copper_diwstop:
    dc.w    $2cc1

    
    dc.w    $0092
ddfstrt:
; 
    dc.w    $0038,$0094
ddfstop:
    dc.w    $00d0
    dc.w    $0108
copper_mod_even:

;set bplmodulo here
    dc.w    0,$010a
copper_mod_odd:
;set bplmodulo here
    dc.w    0




    
copper_spritestruct0:
    dc.w $120,0, $122,0
copper_spritestruct1:
    dc.w $124,0, $126,0
copper_spritestruct2:
    dc.w $128,0, $12A,0
copper_spritestruct3:
    dc.w $12C,0, $12E,0
copper_spritestruct4:
    dc.w $130,0, $132,0
copper_spritestruct5:
    dc.w $134,0, $136,0
copper_spritestruct6:
    dc.w $138,0, $13A,0
copper_spritestruct7:
    dc.w $13C,0, $13E,0

copper_spritedata0:
    dc.w $144,0, $146,0
copper_spritedata1:
    dc.w $14C,0, $14E,0


copper_palette:
    dc.w    $0180, $000
    dc.w    $0182, $fff
    dc.w    $0184, $236
    dc.w    $0186, $ba7
    dc.w    $0188, $836
    dc.w    $018a, $485
    dc.w    $018c, $723
    dc.w    $018e, $6cb
    dc.w    $0190, $246
    dc.w    $0192, $034
    dc.w    $0194, $569
    dc.w    $0196, $444
    dc.w    $0198, $666
    dc.w    $019a, $8d9
    dc.w    $019c, $b56
    dc.w    $019e, $999

    dc.w    $01A0, $000
    dc.w    $01A2, $fff
    dc.w    $01A4, $236
    dc.w    $01A6, $ba7
    dc.w    $01A8, $836
    dc.w    $01Aa, $485
    dc.w    $01Ac, $723
    dc.w    $01Ae, $6cb
    dc.w    $01B0, $246
    dc.w    $01B2, $034
    dc.w    $01B4, $569
    dc.w    $01B6, $444
    dc.w    $01B8, $666
    dc.w    $01Ba, $8d9
    dc.w    $01Bc, $b56
    dc.w    $01Be, $999





copper_bitplane0:
    dc.w    $e0,0
    dc.w    $e2,0
copper_bitplane1:
    dc.w    $e4,0
    dc.w    $e6,0
copper_bitplane2:
    dc.w    $e8,0
    dc.w    $ea,0
copper_bitplane3:
    dc.w    $ec,0
    dc.w    $ee,0
copper_bitplane4:
    dc.w    $f0,0
    dc.w    $f2,0


copbplcon1:
    dc.l    $01020000
    dc.l    $2c01fffe
copbplcon0
; Set bitplane  B
   dc.w    $0100
copper_resolution
   dc.w     $4200 

copper_custom:
    dc.w	$ffdf, $fffe
    dc.w	$2401, $fffe
    dc.w	$0100, $0200
    dc.l    $fffffffe

;    dc.l    $2d01fffe, $01800000
 ;   dc.l    $8001fffe, $01002200
  ;  dc.l    $9001fffe, $01001200
;    dc.l    $ffdffffe
 ;   dc.l    $0d01fffe, $01000200
 blk.l   1024
    dc.l    $fffffffe


spritepointer:
    blk.b    256






	Section ChipRAM,Data_c
 	CNOP 0,4
	 	CNOP 0,4
image
	incbin "C:/Users/uersu/Documents/GitData/compofiller/mousetest///images/trse.bin"
	 	CNOP 0,4
