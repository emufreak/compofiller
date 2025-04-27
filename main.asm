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
c2p1x1_5_c5_030_tempbuf	blk.b	 40960
curBuf	dc.w	$00
isDone	dc.w	$00
colorcycled	dc.w	$00
curcopperpos	dc.l	$00
lightypos	dc.w	$3001
screenOffset	dc.l	$2800
foamCounter	dc.w	$00
eff0Counter	dc.w	$00
yOffset	dc.w	$8b
	 	CNOP 0,4
imagechunky
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/images/cupempty.CHK"
	 	CNOP 0,4
	 	CNOP 0,4
image_palette
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/images/cupempty.COP"
	 	CNOP 0,4
	 	CNOP 0,4
image_palette_cycled
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/images/cupemptycycle.COP"
	 	CNOP 0,4
screen	dc.l	0
offscreen	dc.l	0
i	dc.w	$00
bltsize	dc.w	$00
musicPos	dc.w	$00
current	dc.w	$00
beerinput	dc.w	$00
curbplmod	dc.w	$ffd8
istart	dc.w	$82
musicPosOld	dc.w	$63
effectNumber	dc.w	$01
imagemask	dc.l	0
srcimage	dc.l	0
sine4Copper	dc.w $182, $188, $18e, $195, $19b, $1a1, $1a7, $1ad
	dc.w $1b3, $1b9, $1bf, $1c5, $1ca, $1cf, $1d4, $1d9
	dc.w $1de, $1e2, $1e6, $1ea, $1ee, $1f1, $1f5, $1f7
	dc.w $1fa, $1fc, $1fe, $200, $202, $203, $203, $204
	dc.w $204, $204, $203, $203, $202, $200, $1fe, $1fc
	dc.w $1fa, $1f8, $1f5, $1f2, $1ee, $1ea, $1e7, $1e2
	dc.w $1de, $1d9, $1d4, $1cf, $1ca, $1c5, $1bf, $1b9
	dc.w $1b4, $1ae, $1a8, $1a1, $19b, $195, $18e, $188
	dc.w $182, $17b, $175, $16f, $168, $162, $15c, $156
	dc.w $150, $14a, $144, $13f, $139, $134, $12f, $12a
	dc.w $125, $121, $11d, $119, $115, $112, $10e, $10c
	dc.w $109, $107, $105, $103, $102, $100, $100, $ff
	dc.w $ff, $ff, $100, $100, $101, $103, $104, $106
	dc.w $109, $10b, $10e, $111, $115, $118, $11c, $121
	dc.w $125, $12a, $12e, $133, $139, $13e, $144, $149
	dc.w $14f, $155, $15b, $161, $168, $16e, $174, $17b
	dc.w $181, $187, $18e, $194, $19b, $1a1, $1a7, $1ad
	dc.w $1b3, $1b9, $1bf, $1c4, $1ca, $1cf, $1d4, $1d9
	dc.w $1dd, $1e2, $1e6, $1ea, $1ee, $1f1, $1f4, $1f7
	dc.w $1fa, $1fc, $1fe, $200, $201, $203, $203, $204
	dc.w $204, $204, $203, $203, $202, $200, $1ff, $1fd
	dc.w $1fa, $1f8, $1f5, $1f2, $1ee, $1eb, $1e7, $1e3
	dc.w $1de, $1da, $1d5, $1d0, $1cb, $1c5, $1c0, $1ba
	dc.w $1b4, $1ae, $1a8, $1a2, $19c, $195, $18f, $189
	dc.w $182, $17c, $175, $16f, $169, $162, $15c, $156
	dc.w $150, $14a, $145, $13f, $13a, $134, $12f, $12a
	dc.w $126, $121, $11d, $119, $115, $112, $10f, $10c
	dc.w $109, $107, $105, $103, $102, $100, $100, $ff
	dc.w $ff, $ff, $ff, $100, $101, $103, $104, $106
	dc.w $109, $10b, $10e, $111, $115, $118, $11c, $120
	dc.w $125, $129, $12e, $133, $138, $13e, $143, $149
	dc.w $14f, $155, $15b, $161, $167, $16e, $174, $17a
sine4CopperAdd	dc.w $0, $0, $1, $1, $2, $3, $3, $4
	dc.w $4, $5, $6, $6, $7, $7, $8, $8
	dc.w $9, $9, $a, $a, $a, $b, $b, $b
	dc.w $c, $c, $c, $c, $c, $c, $c, $d
	dc.w $d, $d, $c, $c, $c, $c, $c, $c
	dc.w $c, $b, $b, $b, $a, $a, $a, $9
	dc.w $9, $8, $8, $7, $7, $6, $6, $5
	dc.w $5, $4, $3, $3, $2, $1, $1, $0
	dc.w $0, $0, $ffff, $ffff, $fffe, $fffd, $fffd, $fffc
	dc.w $fffc, $fffb, $fffa, $fffa, $fff9, $fff9, $fff8, $fff8
	dc.w $fff7, $fff7, $fff6, $fff6, $fff6, $fff5, $fff5, $fff5
	dc.w $fff4, $fff4, $fff4, $fff4, $fff4, $fff4, $fff4, $fff3
	dc.w $fff3, $fff3, $fff4, $fff4, $fff4, $fff4, $fff4, $fff4
	dc.w $fff4, $fff5, $fff5, $fff5, $fff6, $fff6, $fff6, $fff7
	dc.w $fff7, $fff8, $fff8, $fff9, $fff9, $fffa, $fffa, $fffb
	dc.w $fffb, $fffc, $fffd, $fffd, $fffe, $ffff, $ffff, $0
	dc.w $0, $0, $1, $1, $2, $3, $3, $4
	dc.w $4, $5, $6, $6, $7, $7, $8, $8
	dc.w $9, $9, $a, $a, $a, $b, $b, $b
	dc.w $c, $c, $c, $c, $c, $c, $c, $d
	dc.w $d, $d, $c, $c, $c, $c, $c, $c
	dc.w $c, $b, $b, $b, $a, $a, $a, $9
	dc.w $9, $8, $8, $7, $7, $6, $6, $5
	dc.w $5, $4, $3, $3, $2, $1, $1, $0
	dc.w $0, $0, $ffff, $ffff, $fffe, $fffd, $fffd, $fffc
	dc.w $fffc, $fffb, $fffa, $fffa, $fff9, $fff9, $fff8, $fff8
	dc.w $fff7, $fff7, $fff6, $fff6, $fff6, $fff5, $fff5, $fff5
	dc.w $fff4, $fff4, $fff4, $fff4, $fff4, $fff4, $fff4, $fff3
	dc.w $fff3, $fff3, $fff3, $fff4, $fff4, $fff4, $fff4, $fff4
	dc.w $fff4, $fff5, $fff5, $fff5, $fff6, $fff6, $fff6, $fff7
	dc.w $fff7, $fff8, $fff8, $fff9, $fff9, $fffa, $fffa, $fffb
	dc.w $fffb, $fffc, $fffd, $fffd, $fffe, $ffff, $ffff, $0
row	dc.w	$01
tmp	dc.w	$01
tmp2	dc.l	$00
planeoffset	dc.l	$00
frameCounter	dc.w	$00
	;*
; //	Sets up the copper list to point to a 320x256 buffer. Note that the screen will be set up 
; //	non-interlaced, with 40*256 bytes per bitplane. <p>
; //	
; //	Usage: 
; //		SetupNonInterlacedScreen( [ data buffer ], [ number of bitplanes ] )
; //		
; //	Note that the data buffer must reside in chipmem
; //	
; //	Example:
; //	
; //	<code>
; //var
; //	const noBitPlanes = 4; 
; // 4 bitplanes = 16 colors
; //	buf : array[40*256*noBitPlanes] chipmem; 
; // data buffer stored in chipmem  
; //...
; //begin
; //	Graphics::SetupNonInterlacedScreen(#buf, noBitPlanes);
; //	</code>
; //	
; 

	; ***********  Defining procedure : Graphics_SetupNonInterlacedScreen
	;    Procedure type : User-defined procedure
	jmp block2
 ; Temp vars section
 ; Temp vars section ends
	 	CNOP 0,4
block2
Graphics_SetupNonInterlacedScreen
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
	
; // $4000  = bitplanes, $200 = colours
	; Poke command
	move.l #copper_mod_even,a0
	move.w #$0,(a0)
	; Poke command
	move.l #copper_mod_odd,a0
	move.w #$0,(a0)
	cmp.w #$5,Graphics_bpl
	bne edblock6
ctb4: ;Main true block ;keep 
	
; // Set palette at copper palette location, 16 colors
; // Setup image copper list (4 bitplanes, 40*40 modulo 120
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane0,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane1,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane2,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane3,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane4,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
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
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane1,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane2,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane3,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
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
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane1,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane2,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
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
	add.l #$2800,Graphics_pa ; Optimization: simple A := A op Const ADD SUB OR AND
	; setcopperlist32
	move.l Graphics_pa,a1
	move.l a1,d0
	move.l #copper_bitplane1,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
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
edblock30
	rts
	; ***********  Defining procedure : LSP_CIAStart
	;    Procedure type : User-defined procedure
	jmp block33
cs_music	dc.l	0
cs_bank	dc.l	0
cs_vbr	dc.w	0
cs_palntsc	dc.w	0
	 	CNOP 0,4
block33
LSP_CIAStart
		; Init LSP and start replay using easy CIA toolbox
			move.l	cs_music,a0
			move.l	cs_bank,a1
			suba.l	a2,a2			
			move.w	cs_vbr,a2			; VBR
			moveq	#0,d0			
			move.w  cs_palntsc,d0		; PALNTSC
			bsr		LSP_MusicDriver_CIA_Start
			move.w	#$e000,$dff09a
			bra.w   lspend
			
LSP_MusicDriver_CIA_Start:
			move.w	d0,-(a7)
			lea		.irqVector(pc),a3
			lea		$78(a2),a2
			move.l	a2,(a3)
			lea		.LSPDmaCon+1(pc),a2		; DMACON byte patch address
			bsr		LSP_MusicInit			; init the LSP player ( whatever fast or insane version )
			lea		.pMusicBPM(pc),a2
			move.l	a0,(a2)					; store music BPM pointer
			move.w	(a0),d0					; start BPM
			lea		.curBpm(pc),a2
			move.w	d0,(a2)
			moveq	#1,d1
			and.w	(a7)+,d1
			bsr.s	.LSP_IrqInstall
			rts
.LSPDmaCon:	dc.w	$8000
.irqVector:	dc.l	0
.ciaClock:	dc.l	0
.curBpm:	dc.w	0
.pMusicBPM:	dc.l	0
; d0: music BPM
; d1: PAL(0) or NTSC(1)
.LSP_IrqInstall:
			move.w 	#(1<<13),$dff09a		; disable CIA interrupt
			lea		.LSP_MainIrq(pc),a0
			move.l	.irqVector(pc),a5
			move.l	a0,(a5)
			lea		$bfd000,a0
			move.b 	#$7f,$d00(a0)
			move.b 	#$10,$e00(a0)
			move.b 	#$10,$f00(a0)
			lsl.w	#2,d1
			move.l	.palClocks(pc,d1.w),d1				; PAL or NTSC clock
			lea		.ciaClock(pc),a5
			move.l	d1,(a5)
			divu.w	d0,d1
			move.b	d1,$400(a0)
			lsr.w 	#8,d1
			move.b	d1,$500(a0)
			move.b	#$83,$d00(a0)
			move.b	#$11,$e00(a0)
			
			move.b	#496&255,$600(a0)		; set timer b to 496 ( to set DMACON )
			move.b	#496>>8,$700(a0)
			move.w 	#(1<<13),$dff09c		; clear any req CIA
			move.w 	#$a000,$dff09a			; CIA interrupt enabled
			rts
		
.palClocks:	dc.l	1773447,1789773
.LSP_MainIrq:
			btst.b	#0,$bfdd00
			beq.s	.skipa
			
			movem.l	d0-a6,-(a7)
		; call player tick
			lea		$dff0a0,a6
			bsr		LSP_MusicPlayTick		; LSP main music driver tick
		; check if BMP changed in the middle of the music
			move.l	.pMusicBPM(pc),a0
			move.w	(a0),d0					; current music BPM
			cmp.w	.curBpm(pc),d0
			beq.s	.noChg
			lea		.curBpm(pc),a2			
			move.w	d0,(a2)					; current BPM
			move.l	.ciaClock(pc),d1
			divu.w	d0,d1
			move.b	d1,$bfd400
			lsr.w 	#8,d1
			move.b	d1,$bfd500			
.noChg:		lea		.LSP_DmaconIrq(pc),a0
			move.l	.irqVector(pc),a1
			move.l	a0,(a1)
			move.b	#$19,$bfdf00			; start timerB, one shot
			movem.l	(a7)+,d0-a6
.skipa:		move.w	#$2000,$dff09c
			nop
			rte
.LSP_DmaconIrq:
			btst.b	#1,$bfdd00
			beq.s	.skipb
			move.w	.LSPDmaCon(pc),$dff096
			pea		(a0)
			move.l	.irqVector(pc),a0
			pea		.LSP_MainIrq(pc)
			move.l	(a7)+,(a0)
			move.l	(a7)+,a0
.skipb:		move.w	#$2000,$dff09c
			nop
			rte
LSP_MusicDriver_CIA_Stop:
			move.b	#$7f,$bfdd00
			move.w	#$2000,$dff09a
			move.w	#$2000,$dff09c
			move.w	#$000f,$dff096
			rts
			
LSP_MusicInit:
			cmpi.l	#'LSP1',(a0)+
			bne		.dataError
			move.l	(a0)+,d0		; unique id
			cmp.l	(a1),d0			; check sample bank matches the lsmusic file
			bne		.dataError
			lea		LSP_State(pc),a3
			move.l	a2,m_dmaconPatch(a3)
			move.w	#$8000,-1(a2)			; Be sure DMACon word is $8000 (note: a2 should be ODD address)
			cmpi.w	#$010b,(a0)+			; this play routine supports v1.11 as minimal version of LPConvert.exe
			blt		.dataError
			movea.l	a0,a4					; relocation flag ad
			addq.w	#2,a0					; skip relocation flag
			move.w	(a0)+,m_currentBpm(a3)	; default BPM
			move.w	(a0)+,m_escCodeRewind(a3)
			move.w	(a0)+,m_escCodeSetBpm(a3)
			move.w	(a0)+,m_escCodeGetPos(a3)
			move.l	(a0)+,-(a7)				; music len in frame ticks
			move.w	(a0)+,d0				; instrument count
			lea		-12(a0),a2				; LSP data has -12 offset on instrument tab ( to win 2 cycles in insane player :) )
			move.l	a2,m_lspInstruments(a3)	; instrument tab addr ( minus 4 )
			subq.w	#1,d0
			move.l	a1,d1
			movea.l	a0,a1					; keep relocated flag
.relocLoop:	tst.b	(a4)					; relocation guard
			bne.s	.relocated
			add.l	d1,(a0)
			add.l	d1,6(a0)
.relocated:	lea		12(a0),a0
			dbf		d0,.relocLoop
			move.w	(a0)+,d0				; codes table size
			move.l	a0,m_codeTableAddr(a3)	; code table
			add.w	d0,d0
			add.w	d0,a0
		; read sequence timing infos (if any)
			move.w	(a0)+,m_seqCount(a3)
			beq.s	.noSeq
			move.l	a0,m_seqTable(a3)
			clr.w	m_currentSeq(a3)
			move.w	m_seqCount(a3),d0
			moveq	#0,d1
			move.w	d0,d1
			lsl.w	#3,d1			; 8 bytes per entry
			add.w	#12,d1			; add 3 last 32bits (word stream size, byte stream loop, word stream loop)
			add.l	a0,d1			; word stream data address
			subq.w	#1,d0
.seqRel:	tst.b	(a4)
			bne.s	.skipRel
			add.l	d1,(a0)
			add.l	d1,4(a0)
.skipRel:	addq.w	#8,a0
			dbf		d0,.seqRel
.noSeq:		movem.l	(a0)+,d0-d2				; word stream size, byte stream loop point, word stream loop point
			st		(a4)					
			move.l	a0,m_wordStream(a3)
			lea		0(a0,d0.l),a1			; byte stream
			move.l	a1,m_byteStream(a3)
			add.l	d2,a0
			add.l	d1,a1
			move.l	a0,m_wordStreamLoop(a3)
			move.l	a1,m_byteStreamLoop(a3)
			bset.b	#1,$bfe001				; disabling this fucking Low pass filter!!
			lea		m_currentBpm(a3),a0
			move.l	(a7)+,d0				; music len in frame ticks
			rts
.dataError:	illegal
;------------------------------------------------------------------
;
;	LSP_MusicPlayTick
;
;		In:	a6: should be $dff0a0
;			Scratched regs: d0/d1/d2/a0/a1/a2/a3/a4/a5
;		Out:None
;
;------------------------------------------------------------------
LSP_MusicPlayTick:
			lea		LSP_State(pc),a1
			move.l	(a1),a0					; byte stream
			move.l	m_codeTableAddr(a1),a2	; code table
.process:	moveq	#0,d0
.cloop:		move.b	(a0)+,d0
			beq		.cextended
			add.w	d0,d0
			move.w	0(a2,d0.w),d0			; code
			beq		.noInst
.cmdExec:	add.b	d0,d0
			bcc.s	.noVd
			move.b	(a0)+,$d9-$a0(a6)
.noVd:		add.b	d0,d0
			bcc.s	.noVc
			move.b	(a0)+,$c9-$a0(a6)
.noVc:		add.b	d0,d0
			bcc.s	.noVb
			move.b	(a0)+,$b9-$a0(a6)
.noVb:		add.b	d0,d0
			bcc.s	.noVa
			move.b	(a0)+,$a9-$a0(a6)
.noVa:		
			move.l	a0,(a1)+	; store byte stream ptr
			move.l	(a1),a0		; word stream
			tst.b	d0
			beq.s	.noPa
			add.b	d0,d0
			bcc.s	.noPd
			move.w	(a0)+,$d6-$a0(a6)
.noPd:		add.b	d0,d0
			bcc.s	.noPc
			move.w	(a0)+,$c6-$a0(a6)
.noPc:		add.b	d0,d0
			bcc.s	.noPb
			move.w	(a0)+,$b6-$a0(a6)
.noPb:		add.b	d0,d0
			bcc.s	.noPa
			move.w	(a0)+,$a6-$a0(a6)
.noPa:		
			tst.w	d0
			beq.s	.noInst
			moveq	#0,d1
			move.l	m_lspInstruments-4(a1),a2	; instrument table
			lea		.resetv+12(pc),a4
			lea		3*16(a6),a5
			moveq	#4-1,d2
.vloop:		add.w	d0,d0
			bcs.s	.setIns
			add.w	d0,d0
			bcc.s	.skip
			move.l	(a4),a3
			move.l	(a3)+,(a5)
			move.w	(a3)+,4(a5)
			bra.s	.skip
.setIns:	add.w	(a0)+,a2
			add.w	d0,d0
			bcc.s	.noReset
			bset	d2,d1
			move.w	d1,$96-$a0(a6)
.noReset:	move.l	(a2)+,(a5)
			move.w	(a2)+,4(a5)
			move.l	a2,(a4)
.skip:		subq.w	#4,a4
			lea		-16(a5),a5
			dbf		d2,.vloop
			move.l	m_dmaconPatch-4(a1),a3		; dmacon patch
			move.b	d1,(a3)						; dmacon			
.noInst:	move.l	a0,(a1)			; store word stream (or byte stream if coming from early out)
			rts
.cextended:	addi.w	#$100,d0
			move.b	(a0)+,d0
			beq.s	.cextended
			add.w	d0,d0
			move.w	0(a2,d0.w),d0			; code
			cmp.w	m_escCodeRewind(a1),d0
			beq.s	.r_rewind
			cmp.w	m_escCodeSetBpm(a1),d0
			beq.s	.r_chgbpm
			cmp.w	m_escCodeGetPos(a1),d0
			bne		.cmdExec
.r_setPos:	move.b	(a0)+,(m_currentSeq+1)(a1)
			bra		.process
.r_rewind:	
			move.l	m_byteStreamLoop(a1),a0
			move.l	m_wordStreamLoop(a1),m_wordStream(a1)
			bra		.process
.r_chgbpm:	move.b	(a0)+,(m_currentBpm+1)(a1)	; BPM
			bra		.process
.resetv:	dc.l	0,0,0,0
;------------------------------------------------------------------
;
;	LSP_MusicSetPos
;
;		In: d0: seq position (from 0 to last seq of the song)
;		Out:None
;
;	Force the replay pointer to a seq position. If music wasn't converted
;	using -setpos option, this func does nothing
;
;------------------------------------------------------------------
LSP_MusicSetPos:
			lea		LSP_State(pc),a3
			move.w	m_seqCount(a3),d1
			beq.s	.noTimingInfo
			cmp.w	d1,d0
			bge.s	.noTimingInfo
			move.w	d0,m_currentSeq(a3)
			move.l	m_seqTable(a3),a0
			lsl.w	#3,d0
			add.w	d0,a0
			move.l	(a0)+,m_wordStream(a3)
			move.l	(a0)+,m_byteStream(a3)
.noTimingInfo:
			rts
;------------------------------------------------------------------
;
;	LSP_MusicGetPos
;
;		In: None
;		Out: d0:  seq position (from 0 to last seq of the song)
;
;	Get the current seq position. If music wasn't converted with
;	-getpos option, this func just returns 0
;
;------------------------------------------------------------------
LSP_MusicGetPos:			
			move.w	(LSP_State+m_currentSeq)(pc),d0
			rts
	rsreset
	
m_byteStream:		rs.l	1	;  0 byte stream
m_wordStream:		rs.l	1	;  4 word stream
m_dmaconPatch:		rs.l	1	;  8 m_lfmDmaConPatch
m_codeTableAddr:	rs.l	1	; 12 code table addr
m_escCodeRewind:	rs.w	1	; 16 rewind special escape code
m_escCodeSetBpm:	rs.w	1	; 18 set BPM escape code
m_lspInstruments:	rs.l	1	; 20 LSP instruments table addr
m_relocDone:		rs.w	1	; 24 reloc done flag
m_currentBpm:		rs.w	1	; 26 current BPM
m_byteStreamLoop:	rs.l	1	; 28 byte stream loop point
m_wordStreamLoop:	rs.l	1	; 32 word stream loop point
m_seqCount:			rs.w	1
m_seqTable:			rs.l	1
m_currentSeq:		rs.w	1
m_escCodeGetPos:	rs.w	1
sizeof_LSPVars:		rs.w	0
LSP_State:			ds.b	sizeof_LSPVars		
lspend:	
	
	rts
	; ***********  Defining procedure : c2p_convert
	;    Procedure type : User-defined procedure
	jmp block34
chunkybuffer	dc.l	0
bplbuffer	dc.l	0
	 	CNOP 0,4
block34
c2p_convert
	
	move.w  #1,$100
	move.w	#CHUNKYXMAX,d0
	move.w	#CHUNKYYMAX,d1
	moveq	#0,d2			; Not used by this c2p
	moveq	#0,d3			
	move.l	#BPLX/8,d4		
	move.l	#BPLSIZE,d5		; Only partially used by this c2p	
	move.l	#CHUNKYXMAX,d6		; Not used by this c2p
	bsr	    c2p1x1_5_c5_030_init	; Init c2p	
	move.l  chunkybuffer,a0
	move.l  bplbuffer,a1
	bsr     c2p1x1_5_c5_030
	
	rts
	; ***********  Defining procedure : Load_c2p
	;    Procedure type : User-defined procedure
Load_c2p
BPLX	EQU	320
BPLY	EQU	512
BPLSIZE	EQU	BPLX*BPLY/8
MINUBPLSIZEMINUS4 EQU -BPLSIZE-4
BPLSIZEX2 EQU BPLSIZE*2
BPLSIZEX3 EQU BPLSIZE*3
CHUNKYXMAX EQU	BPLX
CHUNKYYMAX EQU	BPLY
    rts
;				modulo	max res	fscreen	compu
; c2p1x1_5_c5_030		no	320x256?  no	030
; d0.w	chunkyx [chunky-pixels]
; d1.w	chunkyy [chunky-pixels]
; d2.w	(scroffsx) [screen-pixels]
; d3.w	scroffsy [screen-pixels]
; d4.w	(rowlen) [bytes] -- offset between one row and the next in a bpl
; d5.l	(bplsize) [bytes] -- offset between one row in one bpl and the next bpl
	XDEF	_c2p1x1_5_c5_030_init
	XDEF	c2p1x1_5_c5_030_init
_c2p1x1_5_c5_030_init
c2p1x1_5_c5_030_init
	movem.l	d2-d3,-(sp)
	andi.l	#$ffff,d0
	mulu.w	d0,d3
	lsr.l	#3,d3
	move.l	d3,c2p1x1_5_c5_030_scroffs
	mulu.w	d0,d1
	move.l	d1,c2p1x1_5_c5_030_pixels
	movem.l	(sp)+,d2-d3
	rts
; a0	c2pscreen
; a1	bitplanes
	XDEF	_c2p1x1_5_c5_030
	XDEF	c2p1x1_5_c5_030
_c2p1x1_5_c5_030
c2p1x1_5_c5_030
	move.w  #1,$100
	movem.l	d2-d7/a2-a6,-(sp)
	move.l	#$33333333,a6
	add.l	#BPLSIZE,a1
	add.l	c2p1x1_5_c5_030_scroffs,a1
	lea	c2p1x1_5_c5_030_tempbuf,a3
	move.l	c2p1x1_5_c5_030_pixels,a2
	add.l	a0,a2
	cmp.l	a0,a2
	beq	.none
	move.l	a1,-(sp)
	move.l	(a0)+,d1
	move.l	(a0)+,d5
	move.l	(a0)+,d0
	move.l	(a0)+,d6
	move.l	#$0f0f0f0f,d4		; Swap 4x1, part 1
	move.l	d5,d7
	lsr.l	#4,d7
	eor.l	d1,d7
	and.l	d4,d7
	eor.l	d7,d1
	lsl.l	#4,d7
	eor.l	d7,d5
	move.l	d6,d7
	lsr.l	#4,d7
	eor.l	d0,d7
	and.l	d4,d7
	eor.l	d7,d0
	lsl.l	#4,d7
	eor.l	d7,d6
	move.l	(a0)+,d3
	move.l	(a0)+,d2
	move.l	d2,d7			; Swap 4x1, part 2
	lsr.l	#4,d7
	eor.l	d3,d7
	and.l	d4,d7
	eor.l	d7,d3
	lsl.l	#4,d7
	eor.l	d7,d2
	move.w	d3,d7			; Swap 16x4, part 1
	move.w	d1,d3
	swap	d3
	move.w	d3,d1
	move.w	d7,d3
	lsl.l	#2,d1			; Swap/Merge 2x4, part 1
	or.l	d1,d3
	move.l	d3,(a3)+
	move.l	(a0)+,d1
	move.l	(a0)+,d3
	move.l	d3,d7
	lsr.l	#4,d7
	eor.l	d1,d7
	and.l	d4,d7
	eor.l	d7,d1
	lsl.l	#4,d7
	eor.l	d7,d3
	move.w	d1,d7			; Swap 16x4, part 2
	move.w	d0,d1
	swap	d1
	move.w	d1,d0
	move.w	d7,d1
	lsl.l	#2,d0			; Swap/Merge 2x4, part 2
	or.l	d0,d1
	move.l	d1,(a3)+
	bra.s	.start1
.x1
	move.l	(a0)+,d1
	move.l	(a0)+,d5
	move.l	(a0)+,d0
	move.l	(a0)+,d6
	move.l	d7,BPLSIZE(a1)
	move.l	#$0f0f0f0f,d4		; Swap 4x1, part 1
	move.l	d5,d7
	lsr.l	#4,d7
	eor.l	d1,d7
	and.l	d4,d7
	eor.l	d7,d1
	lsl.l	#4,d7
	eor.l	d7,d5
	move.l	d6,d7
	lsr.l	#4,d7
	eor.l	d0,d7
	and.l	d4,d7
	eor.l	d7,d0
	lsl.l	#4,d7
	eor.l	d7,d6
	move.l	(a0)+,d3
	move.l	(a0)+,d2
	move.l	a4,(a1)+
	move.l	d2,d7			; Swap 4x1, part 2
	lsr.l	#4,d7
	eor.l	d3,d7
	and.l	d4,d7
	eor.l	d7,d3
	lsl.l	#4,d7
	eor.l	d7,d2
	move.w	d3,d7			; Swap 16x4, part 1
	move.w	d1,d3
	swap	d3
	move.w	d3,d1
	move.w	d7,d3
	lsl.l 	#2,d1 			; Swap/Merge 2x4, part 1
	or.l 	d1,d3
	move.l 	d3,(a3)+
	move.l	(a0)+,d1
	move.l	(a0)+,d3
	move.l	a5,MINUBPLSIZEMINUS4(a1)
	move.l	d3,d7
	lsr.l	#4,d7
	eor.l	d1,d7
	and.l	d4,d7
	eor.l	d7,d1
	lsl.l	#4,d7
	eor.l	d7,d3
	move.w	d1,d7			; Swap 16x4, part 2
	move.w	d0,d1
	swap	d1
	move.w	d1,d0
	move.w	d7,d1
	lsl.l	#2,d0			; Swap/Merge 2x4, part 2
	or.l	d0,d1
	move.l	d1,(a3)+
.start1
	move.w	d2,d7			; Swap 16x4, part 3 & 4
	move.w	d5,d2
	swap	d2
	move.w	d2,d5
	move.w	d7,d2
	move.w	d3,d7
	move.w	d6,d3
	swap	d3
	move.w	d3,d6
	move.w	d7,d3
	move.l	a6,d0
	move.l	d2,d7			; Swap/Merge 2x4, part 3 & 4
	lsr.l	#2,d7
	eor.l	d5,d7
	and.l	d0,d7
	eor.l	d7,d5
	lsl.l	#2,d7
	eor.l	d7,d2
	move.l	d3,d7
	lsr.l	#2,d7
	eor.l	d6,d7
	and.l	d0,d7
	eor.l	d7,d6
	lsl.l	#2,d7
	eor.l	d7,d3
	move.l	#$00ff00ff,d4
	move.l	d6,d7			; Swap 8x2, part 1
	lsr.l	#8,d7
	eor.l	d5,d7
	and.l	d4,d7
	eor.l	d7,d5
	lsl.l	#8,d7
	eor.l	d7,d6
	move.l	#$55555555,d1
	move.l	d6,d7			; Swap 1x2, part 1
	lsr.l	d7
	eor.l	d5,d7
	and.l	d1,d7
	eor.l	d7,d5
	move.l  a1,d0
	add.l   #BPLSIZEX2, a1
	move.l	d5,(a1)
	move.l  d0,a1
	add.l	d7,d7
	eor.l	d6,d7
	
	move.l	d3,d5			; Swap 8x2, part 2
	lsr.l	#8,d5
	eor.l	d2,d5
	and.l	d4,d5
	eor.l	d5,d2
	lsl.l	#8,d5
	eor.l	d5,d3
	move.l	d3,d5			; Swap 1x2, part 2
	lsr.l	d5
	eor.l	d2,d5
	and.l	d1,d5
	eor.l	d5,d2
	add.l	d5,d5
	eor.l	d5,d3
	move.l	d2,a4
	move.l	d3,a5
	cmpa.l	a0,a2
	bne	.x1
.x1end
	move.l	d7,BPLSIZE(a1)
	move.l	a4,(a1)+
	move.l	a5,MINUBPLSIZEMINUS4(a1)
	move.l	(sp)+,a1
	add.l	#BPLSIZEX3,a1
	move.l	#$00ff00ff,d3
	lea	c2p1x1_5_c5_030_tempbuf,a0
	move.l	c2p1x1_5_c5_030_pixels,d0
	lsr.l	#2,d0
	lea	(a0,d0.l),a2
	move.l	(a0)+,d0
	move.l	(a0)+,d1
	bra.s	.start2
.x2
	move.l	(a0)+,d0
	move.l	(a0)+,d1
	move.l	d2,(a1)+
.start2
	move.l	d1,d2			; Swap 8x2
	lsr.l	#8,d2
	eor.l	d0,d2
	and.l	d3,d2
	eor.l	d2,d0
	lsl.l	#8,d2
	eor.l	d1,d2
	add.l	d0,d0			; Merge 1x2
	add.l	d0,d2
	cmpa.l	a0,a2
	bne.s	.x2
.x2end
	move.l	d2,(a1)+
.none
	movem.l	(sp)+,d2-d7/a2-a6
	rts
c2p1x1_5_c5_030_scroffs ds.l 1
c2p1x1_5_c5_030_pixels ds.l 1
	rts
	; ***********  Defining procedure : CookieCut
	;    Procedure type : User-defined procedure
	jmp block36
cc_src	dc.l	0
cc_dst	dc.l	0
cc_mask	dc.l	0
cc_size	dc.w	0
	 	CNOP 0,4
block36
CookieCut
waitforblitter37
	btst	#14,DMACONR
	bne.s	waitforblitter37
	; Poke command
	move.l #$DFF000,a0
	add.w #$50,a0; cc_mask
	move.l cc_mask,(a0)
	
; //BLTAPT
	; Poke command
	move.l #$DFF000,a0
	add.w #$4c,a0; cc_src
	move.l cc_src,(a0)
	
; //BLTBPT
	; Poke command
	move.l #$DFF000,a0
	add.w #$48,a0; cc_dst
	move.l cc_dst,(a0)
	
; //BLTCPT	
	; Poke command
	move.l #$DFF000,a0
	add.w #$54,a0; cc_dst
	move.l cc_dst,(a0)
	
; //BLTDPT		
	; Poke command
	move.l #$DFF000,a0
	add.w #$40,a0; #$FCA
	move.w #$FCA,(a0)
	
; //BLTCON0	
	; Poke command
	move.l #$DFF000,a0
	add.w #$58,a0; cc_size
	move.w cc_size,(a0)
	rts
	
; //BLTSIZE*
; ///All Channels / Cookie Cut
	; ***********  Defining procedure : DistortCopperLine
	;    Procedure type : User-defined procedure
DistortCopperLine
	moveq.l #0,d1
	move.w i,d1          ; Loadvar regular end
	moveq.l #0,d2
	move.w  row,d2 
	; Array is integer, so multiply with 2
	add.w d1,d1
	lea sine4Copper,a0             ; LoadVariable:: is array
	move.w (a0,d1),d0             ; LoadVariable:: is array
	; Store variable : current
	lsr.w #$8,d0 ; Optimization: simple A := A op Const MUL DIV SHR etc
	cmp.w #$1,d0
	bls c_eblock39
c_ctb38: ;Main true block ;keep 
	move.l d6,(a5)+
	move.l d5,(a5)+
	cmp.w d7,d2
	bne c_edblock91
c_ctb89: ;Main true block ;keep 
	move.l a3,(a5)+
c_edblock91
	add.w #$100,d2 ; Optimization: simple A := A op Const ADD SUB OR AND
	move.w d2,(a5)+
	move.w #$fffe,(a5)+
	move.l d4,(a5)+
	move.l d3,(a5)+
	cmp.w d7,d2
	bne c_edblock97
c_ctb95: ;Main true block ;keep 
	move.l a3,(a5)+
c_edblock97
	bra.s c_edblock40
c_eblock39
	cmp.w #$0,d0
	bls c_eblock103
c_ctb102: ;Main true block ;keep 
	move.l d6,(a5)+
	move.l d5,(a5)+
	cmp.w d7,d2
	bne c_edblock123
c_ctb121: ;Main true block ;keep 
	move.l a3,(a5)+
c_edblock123
	move.w #$0,curbplmod ; Simple a:=b optimization 
	bra.s c_edblock104
c_eblock103
	move.l a6,(a5)+
	move.l a4,(a5)+
	cmp.w d7,d2
	bne c_edblock130
c_ctb128: ;Main true block ;keep 
	move.l a3,(a5)+
c_edblock130
c_edblock104
c_edblock40
	cmp.w #$fe,i
	bhs c_eblock135
c_ctb134: ;Main true block ;keep 
	add.w #$1,i ; Optimization: simple A := A op Const ADD SUB OR AND
	bra.s c_edblock136
c_eblock135
	move.w #$0,i ; Simple a:=b optimization 
c_edblock136
	move.w d2,row
	rts
	
	rts
	; ***********  Defining procedure : ColorCycle
	;    Procedure type : User-defined procedure
ColorCycle
	move.w #$1,colorcycled ; Simple a:=b optimization 
	move.l	a5,curcopperpos
	
	move.w #$1f,d0
	move.l #image_palette_cycled,a0
	move.l curcopperpos,a1
memcpy40
	move.l (a0)+,(a1)+
	dbf d0,memcpy40
	add.l #128,a5
	
	rts
	; ***********  Defining procedure : ColorCycleRestore
	;    Procedure type : User-defined procedure
ColorCycleRestore
	move.w #$2,colorcycled ; Simple a:=b optimization 
	move.l	a5,curcopperpos
	
	move.w #$1f,d0
	move.l #image_palette,a1
	move.l curcopperpos,a0
memcpy42
	move.l (a1)+,(a0)+
	dbf d0,memcpy42
	add.l #128,a5
	
	rts
	; ***********  Defining procedure : CopperEffects
	;    Procedure type : User-defined procedure
CopperEffects
	move.w istart,i ; Simple a:=b optimization 
	move.w #$2c01,row ; Simple a:=b optimization 
		moveq.l #0,d7
		move.w #$ff01,d7	
		move.l #$1080000,d6
		move.l #$10a0000,d5
		move.l #$108ffd8,d4
		move.l #$10affd8,d3
		move.l #$1080028,a6
		move.l #$10a0028,a4
		move.l #$ffdffffe,a3
	
	lea copper_custom,a5
while44
loopstart48
	move.w lightypos,d1          ; Loadvar regular end
	move.w row,d0
	cmp.w d1,d0
	bhi edblock47
ctb45: ;Main true block ;keep 
	move.w row,(a5)+
	move.w #$fffe,(a5)+
	cmp.w #$0,beerinput
	bls edblock61
ctb59: ;Main true block ;keep 
	jsr DistortCopperLine
edblock61
	add.w #$100,row ; Optimization: simple A := A op Const ADD SUB OR AND
	jmp while44
edblock47
loopend49
	cmp.w #$6,effectNumber
	bne edblock67
ctb65: ;Main true block ;keep 
	move.w row,(a5)+
	move.w #$fffe,(a5)+
	cmp.w #$0,beerinput
	bls edblock79
ctb77: ;Main true block ;keep 
	jsr DistortCopperLine
edblock79
	jsr ColorCycle
	add.w #$100,row ; Optimization: simple A := A op Const ADD SUB OR AND
edblock67
while82
loopstart86
	; Swapped comparison expressions
	moveq #0,d0
	move.w lightypos,d0     ; BOP move
	add.w #$1000,d0 ; simple bop
	cmp.w row,d0
	blo edblock85
ctb83: ;Main true block ;keep 
	move.w row,(a5)+
	move.w #$fffe,(a5)+
	cmp.w #$0,beerinput
	bls edblock99
ctb97: ;Main true block ;keep 
	jsr DistortCopperLine
edblock99
	add.w #$100,row ; Optimization: simple A := A op Const ADD SUB OR AND
	jmp while82
edblock85
loopend87
	cmp.w #$6,effectNumber
	bne edblock105
ctb103: ;Main true block ;keep 
	move.w row,(a5)+
	move.w #$fffe,(a5)+
	jsr ColorCycleRestore
	cmp.w #$0,beerinput
	bls edblock117
ctb115: ;Main true block ;keep 
	jsr DistortCopperLine
edblock117
	add.w #$100,row ; Optimization: simple A := A op Const ADD SUB OR AND
edblock105
while120
loopstart124
	cmp.w #$2c01,row
	blo edblock123
ctb121: ;Main true block ;keep 
	move.w row,(a5)+
	move.w #$fffe,(a5)+
	cmp.w #$0,beerinput
	bls edblock137
ctb135: ;Main true block ;keep 
	jsr DistortCopperLine
edblock137
	add.w #$100,row ; Optimization: simple A := A op Const ADD SUB OR AND
	jmp while120
edblock123
loopend125
while140
loopstart144
	cmp.w #$2c01,row
	bhs edblock143
ctb141: ;Main true block ;keep 
	move.w row,(a5)+
	move.w #$fffe,(a5)+
	cmp.w #$0,beerinput
	bls edblock157
ctb155: ;Main true block ;keep 
	jsr DistortCopperLine
edblock157
	add.w #$100,row ; Optimization: simple A := A op Const ADD SUB OR AND
	jmp while140
edblock143
loopend145
	move.w #$ffff,(a5)+
	move.w #$fffe,(a5)+
	cmp.w #$ff,istart
	bhs eblock162
ctb161: ;Main true block ;keep 
	add.w #$1,istart ; Optimization: simple A := A op Const ADD SUB OR AND
	jmp edblock163
eblock162
	move.w #$0,istart ; Simple a:=b optimization 
edblock163
	rts
	
; //Poke16(#$dff180,0,$000);			
	; ***********  Defining procedure : DistortMore
	;    Procedure type : User-defined procedure
DistortMore
	move.w #$0,i ; Simple a:=b optimization 
forloop169
	moveq #0,d0
	move.l #0,d2
	move.w i,d2          ; Loadvar regular end
	; Array is integer, so multiply with 2
	lsl #1,d2
	lea sine4Copper,a0             ; LoadVariable:: is array
	move.w (a0,d2),d1             ; LoadVariable:: is array
	move.w d1,d0     ; BOP move
	move.l #0,d2
	move.w i,d2          ; Loadvar regular end
	; Array is integer, so multiply with 2
	lsl #1,d2
	lea sine4CopperAdd,a0             ; LoadVariable:: is array
	move.w (a0,d2),d1             ; LoadVariable:: is array
	add.w d1,d0 ; simple bop
	; Store variable : sine4Copper
	move.w i,d2          ; Loadvar regular end
	lsl #1,d2
	lea sine4Copper,a0
	move.w d0,(a0,d2)
loopstart170
	; Create increasecounter
	add.w #$1,i ; Optimization: simple A := A op Const ADD SUB OR AND
	; end increasecounter
	move #$ff,d0
	cmp.w i,d0
	bne forloop169
loopend171
	rts
	; ***********  Defining procedure : BeerFoam
	;    Procedure type : User-defined procedure
	jmp block174
bf_dstimage	dc.l	0
foamsize	dc.w	0
foampos	dc.w	0
	 	CNOP 0,4
block174
BeerFoam
	
; //ablit description:	
; // - SrcImage 
; // - DstImage
; // - SrcShiftBytes: Start Byte to Blit From
; // - XOffset: X Offset in Bytes (8 Pixel) to Blit To
; // - YOffset: YOffset to Blit to
; // - BlitWidth: With in Bytes of the Blit
; // - BlitSize: Complete Size of the Blit
; // - BlitAmod
; // - BlitDmod
; // - BlitB + BlitCmod
; // - Channels and Minterm
	move.l #imageFoam,srcimage ; Simple a:=b optimization 
	move.l #imageMask,imagemask ; Simple a:=b optimization 
	moveq #0,d0
	move.l imagemask,d0     ; BOP move
	moveq #0,d1
	move.w #$c,d1     ; BOP move
	; LHS is byte, so initiate advanced op
	; is advanced bop
	moveq #0,d3
	move.w foampos,d3     ; BOP move
	sub.w #$3e,d3 ; simple bop
	; Reset register
	moveq #0,d2
	move.w d3,d2     ; Advanced movee
	mulu.w d2,d1
	add.l d1,d0 ; simple bop
	; Store variable : imagemask
	move.l d0,imagemask
	moveq #0,d0
	moveq #0,d1
	move.l bf_dstimage,d1     ; BOP move
	add.l #$e,d1 ; simple bop
	move.l d1,d0     ; BOP move
	moveq #0,d1
	move.w foampos,d1     ; BOP move
	; ORG TYPE of foampos INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d2
	move.w #$28,d2     ; Advanced movee
	mulu.w d2,d1
	add.l d1,d0 ; simple bop
	; Store variable : bf_dstimage
	move.l d0,bf_dstimage
waitforblitter175
	btst	#14,DMACONR
	bne.s	waitforblitter175
	; Poke command
	move.l #$DFF000,a0
	add.w #$44,a0; #$FFFFFFFF
	move.l #$FFFFFFFF,(a0)
	
; //BltAfwm+BltAlwm
	; Poke command
	move.l #$DFF000,a0
	add.w #$60,a0; #$1c
	move.w #$1c,(a0)
	
; //BLTCMOD
	; Poke command
	move.l #$DFF000,a0
	add.w #$62,a0; #$0
	move.w #$0,(a0)
	
; //BLTBMOD
	; Poke command
	move.l #$DFF000,a0
	add.w #$64,a0; #$0
	move.w #$0,(a0)
	
; //BLTAMOD
	; Poke command
	move.l #$DFF000,a0
	add.w #$66,a0; #$1c
	move.w #$1c,(a0)
	
; //BLTDMOD		
	; Poke command
	move.l #$DFF000,a0
	add.w #$42,a0; #$0
	move.w #$0,(a0)
	
; //BLTCON1		
	moveq #0,d0
	moveq #0,d1
	move.w foamsize,d1     ; BOP move
	lsl.w #$6,d1 ; simple bop
	move.w d1,d0     ; BOP move
	add.w #$6,d0 ; simple bop
	; Store variable : bltsize
	move.w d0,bltsize
	move.l srcimage,cc_src ; Simple a:=b optimization 
	move.l bf_dstimage,cc_dst ; Simple a:=b optimization 
	move.l imagemask,cc_mask ; Simple a:=b optimization 
	move.w bltsize,cc_size ; Simple a:=b optimization 
	jsr CookieCut
	add.l #$e4,srcimage ; Optimization: simple A := A op Const ADD SUB OR AND
	add.l #$57d0,bf_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
	move.l srcimage,cc_src ; Simple a:=b optimization 
	move.l bf_dstimage,cc_dst ; Simple a:=b optimization 
	move.l imagemask,cc_mask ; Simple a:=b optimization 
	move.w bltsize,cc_size ; Simple a:=b optimization 
	jsr CookieCut
	add.l #$e4,srcimage ; Optimization: simple A := A op Const ADD SUB OR AND
	add.l #$57d0,bf_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
	move.l srcimage,cc_src ; Simple a:=b optimization 
	move.l bf_dstimage,cc_dst ; Simple a:=b optimization 
	move.l imagemask,cc_mask ; Simple a:=b optimization 
	move.w bltsize,cc_size ; Simple a:=b optimization 
	jsr CookieCut
	add.l #$e4,srcimage ; Optimization: simple A := A op Const ADD SUB OR AND
	add.l #$57d0,bf_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
	move.l srcimage,cc_src ; Simple a:=b optimization 
	move.l bf_dstimage,cc_dst ; Simple a:=b optimization 
	move.l imagemask,cc_mask ; Simple a:=b optimization 
	move.w bltsize,cc_size ; Simple a:=b optimization 
	jsr CookieCut
	add.l #$e4,srcimage ; Optimization: simple A := A op Const ADD SUB OR AND
	add.l #$57d0,bf_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
	move.l srcimage,cc_src ; Simple a:=b optimization 
	move.l bf_dstimage,cc_dst ; Simple a:=b optimization 
	move.l imagemask,cc_mask ; Simple a:=b optimization 
	move.w bltsize,cc_size ; Simple a:=b optimization 
	jsr CookieCut
	rts
	; ***********  Defining procedure : FillDrinkBeer
	;    Procedure type : User-defined procedure
	jmp block176
dstimage dc.l 0
yoffset	dc.w	0
fd_srcimage	dc.l	0
fd_srcimageoffset	dc.l	0
	 	CNOP 0,4
block176
FillDrinkBeer
	
; //ablit description:	
; // - SrcImage 
; // - DstImage
; // - SrcShiftBytes: Start Byte to Blit From
; // - XOffset: X Offset in Bytes (8 Pixel) to Blit To
; // - YOffset: YOffset to Blit to
; // - BlitWidth: With in Bytes of the Blit
; // - BlitSize: Complete Size of the Blit
; // - BlitAmod
; // - BlitDmod
; // - BlitB + BlitCmod
; // - Channels and Minterm
; //	fd_srcimage := #imageCupFull;
waitforblitter177
	btst	#14,DMACONR
	bne.s	waitforblitter177
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l fd_srcimage,a0
	move.l dstimage,a1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	; ORG TYPE of yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	add.w #$52,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$86,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	moveq #0,d0
	move.l fd_srcimageoffset,d0     ; BOP move
	add.l fd_srcimage,d0 ; simple bop
	; Store variable : fd_srcimage
	move.l d0,fd_srcimage
	add.l #$57d0,dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter178
	btst	#14,DMACONR
	bne.s	waitforblitter178
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l fd_srcimage,a0
	move.l dstimage,a1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	; ORG TYPE of yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	add.w #$52,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$86,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	moveq #0,d0
	move.l fd_srcimageoffset,d0     ; BOP move
	add.l fd_srcimage,d0 ; simple bop
	; Store variable : fd_srcimage
	move.l d0,fd_srcimage
	add.l #$57d0,dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter179
	btst	#14,DMACONR
	bne.s	waitforblitter179
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l fd_srcimage,a0
	move.l dstimage,a1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	; ORG TYPE of yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	add.w #$52,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$86,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	moveq #0,d0
	move.l fd_srcimageoffset,d0     ; BOP move
	add.l fd_srcimage,d0 ; simple bop
	; Store variable : fd_srcimage
	move.l d0,fd_srcimage
	add.l #$57d0,dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter180
	btst	#14,DMACONR
	bne.s	waitforblitter180
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l fd_srcimage,a0
	move.l dstimage,a1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	; ORG TYPE of yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	add.w #$52,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$86,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	moveq #0,d0
	move.l fd_srcimageoffset,d0     ; BOP move
	add.l fd_srcimage,d0 ; simple bop
	; Store variable : fd_srcimage
	move.l d0,fd_srcimage
	add.l #$57d0,dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter181
	btst	#14,DMACONR
	bne.s	waitforblitter181
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l fd_srcimage,a0
	move.l dstimage,a1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	; ORG TYPE of yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w yoffset,d0     ; BOP move
	add.w #$52,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$86,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	rts
	
; //	Flips rendering buffer and updates copper list & pointers
; //
	; ***********  Defining procedure : FlipBuffers
	;    Procedure type : User-defined procedure
FlipBuffers
	cmp.w #$0,curBuf
	bne eblock185
ctb184: ;Main true block ;keep 
	move.l #image1,screen ; Simple a:=b optimization 
	moveq #0,d0
	move.l screen,d0     ; BOP move
	add.l screenOffset,d0 ; simple bop
	; Store variable : screen
	move.l d0,screen
	move.l #image2,offscreen ; Simple a:=b optimization 
	moveq #0,d0
	move.l offscreen,d0     ; BOP move
	add.l screenOffset,d0 ; simple bop
	; Store variable : offscreen
	move.l d0,offscreen
	jmp edblock186
eblock185
	move.l #image2,screen ; Simple a:=b optimization 
	moveq #0,d0
	move.l screen,d0     ; BOP move
	add.l screenOffset,d0 ; simple bop
	; Store variable : screen
	move.l d0,screen
	move.l #image1,offscreen ; Simple a:=b optimization 
	moveq #0,d0
	move.l offscreen,d0     ; BOP move
	add.l screenOffset,d0 ; simple bop
	; Store variable : offscreen
	move.l d0,offscreen
edblock186
	; setcopperlist32
	move.l offscreen,a1
	move.l a1,d0
	move.l #copper_bitplane0,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	; setcopperlist32
	moveq #0,d1
	move.l offscreen,d1     ; BOP move
	add.l #$57d0,d1 ; simple bop
	move.l d1,d0
	move.l #copper_bitplane1,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	; setcopperlist32
	moveq #0,d1
	move.l offscreen,d1     ; BOP move
	; NodeBinop : both are pure numeric optimization : #$afa0
	add.l #$afa0,d1 ; simple bop
	move.l d1,d0
	move.l #copper_bitplane2,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	; setcopperlist32
	moveq #0,d1
	move.l offscreen,d1     ; BOP move
	; NodeBinop : both are pure numeric optimization : #$10770
	add.l #$10770,d1 ; simple bop
	move.l d1,d0
	move.l #copper_bitplane3,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	; setcopperlist32
	moveq #0,d1
	move.l offscreen,d1     ; BOP move
	; NodeBinop : both are pure numeric optimization : #$15f40
	add.l #$15f40,d1 ; simple bop
	move.l d1,d0
	move.l #copper_bitplane4,a0
	move.w d0,6(a0)
	swap d0
	move.w d0,2(a0)
	moveq #0,d0
	moveq #0,d1
	move.w curBuf,d1     ; BOP move
	add.w #$1,d1 ; simple bop
	move.w d1,d0     ; BOP move
	and.w #$1,d0 ; simple bop
	; Store variable : curBuf
	move.w d0,curBuf
	rts
	; ***********  Defining procedure : RemoveFoam
	;    Procedure type : User-defined procedure
	jmp block191
rf_dstimage dc.l 0
rf_yoffset	dc.w	0
	 	CNOP 0,4
block191
RemoveFoam
	cmp.w #$94,rf_yoffset
	bls edblock195
ctb193: ;Main true block ;keep 
	
; //ablit description:	
; // - SrcImage 
; // - DstImage
; // - SrcShiftBytes: Start Byte to Blit From
; // - XOffset: X Offset in Bytes (8 Pixel) to Blit To
; // - YOffset: YOffset to Blit to
; // - BlitWidth: With in Bytes of the Blit
; // - BlitSize: Complete Size of the Blit
; // - BlitAmod
; // - BlitDmod
; // - BlitB + BlitCmod
; // - Channels and Minterm
	move.w #$94,rf_yoffset ; Simple a:=b optimization 
edblock195
	move.l #imageRestoreCup,srcimage ; Simple a:=b optimization 
waitforblitter198
	btst	#14,DMACONR
	bne.s	waitforblitter198
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rf_dstimage,a1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	; ORG TYPE of rf_yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	add.w #$3e,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$146,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	add.l #$798,srcimage ; Optimization: simple A := A op Const ADD SUB OR AND
	add.l #$57d0,rf_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter199
	btst	#14,DMACONR
	bne.s	waitforblitter199
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rf_dstimage,a1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	; ORG TYPE of rf_yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	add.w #$3e,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$146,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	add.l #$798,srcimage ; Optimization: simple A := A op Const ADD SUB OR AND
	add.l #$57d0,rf_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter200
	btst	#14,DMACONR
	bne.s	waitforblitter200
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rf_dstimage,a1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	; ORG TYPE of rf_yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	add.w #$3e,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$146,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	add.l #$798,srcimage ; Optimization: simple A := A op Const ADD SUB OR AND
	add.l #$57d0,rf_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter201
	btst	#14,DMACONR
	bne.s	waitforblitter201
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rf_dstimage,a1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	; ORG TYPE of rf_yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	add.w #$3e,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$146,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	add.l #$798,srcimage ; Optimization: simple A := A op Const ADD SUB OR AND
	add.l #$57d0,rf_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter202
	btst	#14,DMACONR
	bne.s	waitforblitter202
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rf_dstimage,a1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	; ORG TYPE of rf_yoffset INTEGER
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	move.w d0,d6
	move.w #$e,d1
	moveq #0,d0
	move.w rf_yoffset,d0     ; BOP move
	add.w #$3e,d0 ; simple bop
	move.w d0,d2
	move.w #$28,d3
	move.w #$146,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	rts
	; ***********  Defining procedure : EffBeerFoam
	;    Procedure type : User-defined procedure
EffBeerFoam
	add.w #$1,foamCounter ; Optimization: simple A := A op Const ADD SUB OR AND
	move.l screen,bf_dstimage ; Simple a:=b optimization 
	move.w foamCounter,foamsize ; Simple a:=b optimization 
	moveq #0,d0
	move.w #$d7,d0     ; BOP move
	sub.w foamCounter,d0 ; simple bop
	; Store variable : foampos
	move.w d0,foampos
	jsr BeerFoam
	rts
	; ***********  Defining procedure : EffBeerFill
	;    Procedure type : User-defined procedure
EffBeerFill
	move.l screen,dstimage ; Simple a:=b optimization 
	move.w yOffset,yoffset ; Simple a:=b optimization 
	move.l #imageCupFull,fd_srcimage ; Simple a:=b optimization 
	moveq #0,d0
	move.w #$69c,d0
	move.l d0,fd_srcimageoffset
	jsr FillDrinkBeer
	cmp.w #$1,yOffset
	blo edblock208
ctb206: ;Main true block ;keep 
	sub.w #$1,yOffset ; Optimization: simple A := A op Const ADD SUB OR AND
	add.w #$1,foamCounter ; Optimization: simple A := A op Const ADD SUB OR AND
edblock208
	cmp.w #$13,foamCounter
	bhi eblock213
ctb212: ;Main true block ;keep 
	move.l screen,bf_dstimage ; Simple a:=b optimization 
	move.w foamCounter,foamsize ; Simple a:=b optimization 
	moveq #0,d0
	move.w #$d8,d0     ; BOP move
	sub.w foamCounter,d0 ; simple bop
	; Store variable : foampos
	move.w d0,foampos
	jsr BeerFoam
	jmp edblock214
eblock213
	move.l screen,bf_dstimage ; Simple a:=b optimization 
	move.w #$13,foamsize ; Simple a:=b optimization 
	moveq #0,d0
	move.w #$d8,d0     ; BOP move
	sub.w foamCounter,d0 ; simple bop
	; Store variable : foampos
	move.w d0,foampos
	jsr BeerFoam
edblock214
	rts
	; ***********  Defining procedure : EffBeerDrink
	;    Procedure type : User-defined procedure
EffBeerDrink
	move.l screen,rf_dstimage ; Simple a:=b optimization 
	move.w yOffset,rf_yoffset ; Simple a:=b optimization 
	jsr RemoveFoam
	cmp.w #$13,foamCounter
	bhi eblock222
ctb221: ;Main true block ;keep 
	move.l screen,bf_dstimage ; Simple a:=b optimization 
	move.w foamCounter,foamsize ; Simple a:=b optimization 
	moveq #0,d0
	move.w #$d8,d0     ; BOP move
	sub.w foamCounter,d0 ; simple bop
	; Store variable : foampos
	move.w d0,foampos
	jsr BeerFoam
	jmp edblock223
eblock222
	move.l screen,bf_dstimage ; Simple a:=b optimization 
	move.w #$13,foamsize ; Simple a:=b optimization 
	moveq #0,d0
	move.w #$d8,d0     ; BOP move
	sub.w foamCounter,d0 ; simple bop
	; Store variable : foampos
	move.w d0,foampos
	jsr BeerFoam
edblock223
	rts
	; ***********  Defining procedure : EffScrollup
	;    Procedure type : User-defined procedure
EffScrollup
	sub.l #$28,screenOffset ; Optimization: simple A := A op Const ADD SUB OR AND
	rts
	; ***********  Defining procedure : EffScrolldown
	;    Procedure type : User-defined procedure
EffScrolldown
	add.l #$28,screenOffset ; Optimization: simple A := A op Const ADD SUB OR AND
	rts
	; ***********  Defining procedure : RestoreCup
	;    Procedure type : User-defined procedure
	jmp block230
rc_srcimage	dc.l	0
rc_dstimage	dc.l	0
rc_yoffset	dc.w	0
rc_height	dc.l	0
	 	CNOP 0,4
block230
RestoreCup
	
; //ablit description:	
; // - SrcImage 
; // - DstImage
; // - SrcShiftBytes: Start Byte to Blit From
; // - XOffset: X Offset in Bytes (8 Pixel) to Blit To
; // - YOffset: YOffset to Blit to
; // - BlitWidth: With in Bytes of the Blit
; // - BlitSize: Complete Size of the Blit
; // - BlitAmod
; // - BlitDmod
; // - BlitB + BlitCmod
; // - Channels and Minterm
	move.l rc_srcimage,srcimage ; Simple a:=b optimization 
	moveq #0,d0
	move.l rc_height,d0     ; BOP move
	; ORG TYPE of rc_height LONG
	; LHS is byte, so initiate advanced op
	; is advanced bop
	; Reset register
	moveq #0,d1
	move.w #$c,d1     ; Advanced movee
	mulu.w d1,d0
	; Store variable : planeoffset
	move.l d0,planeoffset
	moveq #0,d0
	moveq #0,d1
	move.l rc_height,d1     ; BOP move
	lsl.l #$6,d1 ; simple bop
	move.l d1,d0     ; BOP move
	add.l #$6,d0 ; simple bop
	; Store variable : bltsize
	move.w d0,bltsize
waitforblitter231
	btst	#14,DMACONR
	bne.s	waitforblitter231
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rc_dstimage,a1
	move.w #$0,d6
	move.w #$e,d1
	move.w rc_yoffset,d2
	move.w #$28,d3
	move.w bltsize,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	moveq #0,d0
	move.l planeoffset,d0     ; BOP move
	add.l srcimage,d0 ; simple bop
	; Store variable : srcimage
	move.l d0,srcimage
	add.l #$57d0,rc_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter232
	btst	#14,DMACONR
	bne.s	waitforblitter232
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rc_dstimage,a1
	move.w #$0,d6
	move.w #$e,d1
	move.w rc_yoffset,d2
	move.w #$28,d3
	move.w bltsize,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	moveq #0,d0
	move.l planeoffset,d0     ; BOP move
	add.l srcimage,d0 ; simple bop
	; Store variable : srcimage
	move.l d0,srcimage
	add.l #$57d0,rc_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter233
	btst	#14,DMACONR
	bne.s	waitforblitter233
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rc_dstimage,a1
	move.w #$0,d6
	move.w #$e,d1
	move.w rc_yoffset,d2
	move.w #$28,d3
	move.w bltsize,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	moveq #0,d0
	move.l planeoffset,d0     ; BOP move
	add.l srcimage,d0 ; simple bop
	; Store variable : srcimage
	move.l d0,srcimage
	add.l #$57d0,rc_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter234
	btst	#14,DMACONR
	bne.s	waitforblitter234
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rc_dstimage,a1
	move.w #$0,d6
	move.w #$e,d1
	move.w rc_yoffset,d2
	move.w #$28,d3
	move.w bltsize,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	moveq #0,d0
	move.l planeoffset,d0     ; BOP move
	add.l srcimage,d0 ; simple bop
	; Store variable : srcimage
	move.l d0,srcimage
	add.l #$57d0,rc_dstimage ; Optimization: simple A := A op Const ADD SUB OR AND
waitforblitter235
	btst	#14,DMACONR
	bne.s	waitforblitter235
	moveq.l #0,d6
	lea     $dff000,a6 ; Hardware registers
	move.l srcimage,a0
	move.l rc_dstimage,a1
	move.w #$0,d6
	move.w #$e,d1
	move.w rc_yoffset,d2
	move.w #$28,d3
	move.w bltsize,d4
	move.w #$0,BLTAMOD(a6)
	move.w #$0,BLTBMOD(a6)
	move.w #$0,BLTCMOD(a6)
	move.w #$1c,BLTDMOD(a6)
	move.w #$9f0,d0
	move.w  #0,BLTCON1(a6) ;    issa 0   BLTCON1
	jsr blitter
	rts
	; ***********  Defining procedure : Get_Musicpos
	;    Procedure type : User-defined procedure
Get_Musicpos
		move.w	(LSP_State+m_currentSeq)(pc),musicPos
	
	rts
	 	CNOP 0,4
block1
	moveq #0,d0
	move.w #$0,d0
	move.l d0,curcopperpos
	move.l #music,cs_music ; Simple a:=b optimization 
	move.l #bank,cs_bank ; Simple a:=b optimization 
	move.w #$0,cs_vbr ; Simple a:=b optimization 
	move.w #$0,cs_palntsc ; Simple a:=b optimization 
	jsr LSP_CIAStart
	jsr Load_c2p
	move.l #imagechunky,chunkybuffer ; Simple a:=b optimization 
	move.l #image1,bplbuffer ; Simple a:=b optimization 
	jsr c2p_convert
	move.l #image1,Graphics_pa ; Simple a:=b optimization 
	move.w #$5,Graphics_bpl ; Simple a:=b optimization 
	jsr Graphics_SetupNonInterlacedScreen
	jsr FlipBuffers
	move.w #$1f,d0
	move.l #image_palette,a0
	move.l #copper_palette,a1
memcpy237
	move.l (a0)+,(a1)+
	dbf d0,memcpy237
while238
loopstart242
	cmp.w #$0,isDone
	bne edblock239
ctb237: ;Main true block ;keep 
waitVB451
	move.l VPOSR,d0
	and.l #$1ff00,d0
	cmp.l #300<<8,d0
	bne waitVB451
	move.w #$0,colorcycled ; Simple a:=b optimization 
	jsr FlipBuffers
	jsr Get_Musicpos
	move #$1,d0
	cmp.w effectNumber,d0
	bne casenext453
	add.w #$1,eff0Counter ; Optimization: simple A := A op Const ADD SUB OR AND
	cmp.w #$1e,eff0Counter
	blo edblock458
ctb456: ;Main true block ;keep 
	move.w #$2,effectNumber ; Simple a:=b optimization 
edblock458
	jmp caseend452
casenext453
	move #$2,d0
	cmp.w effectNumber,d0
	bne casenext461
	cmp.w #$c,foamCounter
	bhi eblock465
ctb464: ;Main true block ;keep 
	jsr EffBeerFoam
	jmp edblock466
eblock465
	move.w #$3,effectNumber ; Simple a:=b optimization 
edblock466
	jsr CopperEffects
	jmp caseend452
casenext461
	move #$3,d0
	cmp.w effectNumber,d0
	bne casenext471
	jsr EffBeerFill
	cmp.w #$4,musicPos
	bne edblock476
ctb474: ;Main true block ;keep 
	move.w #$4,effectNumber ; Simple a:=b optimization 
edblock476
	jsr CopperEffects
	jmp caseend452
casenext471
	move #$4,d0
	cmp.w effectNumber,d0
	bne casenext479
	cmp.l #$0,screenOffset
	bls eblock483
ctb482: ;Main true block ;keep 
	jsr EffScrollup
	jmp edblock484
eblock483
	move.w #$5,effectNumber ; Simple a:=b optimization 
edblock484
	jsr CopperEffects
	move.w #$0,tmp ; Simple a:=b optimization 
	jmp caseend452
casenext479
	move #$5,d0
	cmp.w effectNumber,d0
	bne casenext489
	cmp.w #$8,musicPos
	bne localfailed497
	jmp ctb492
localfailed497: ;keep
	; ; logical OR, second chance
	cmp.w #$23,musicPos
	bne localfailed496
	jmp ctb492
localfailed496: ;keep
	; ; logical OR, second chance
	cmp.w #$38,musicPos
	bne localfailed498
	jmp ctb492
localfailed498: ;keep
	; ; logical OR, second chance
	cmp.w #$53,musicPos
	bne edblock494
ctb492: ;Main true block ;keep 
	move.w #$6,effectNumber ; Simple a:=b optimization 
edblock494
	cmp.w #$2,tmp
	bhs edblock503
ctb501: ;Main true block ;keep 
	move.l #imageCupFull,rc_srcimage ; Simple a:=b optimization 
	move.l screen,rc_dstimage ; Simple a:=b optimization 
	move.w #$152,rc_yoffset ; Simple a:=b optimization 
	moveq #0,d0
	move.w #$8d,d0
	move.l d0,rc_height
	jsr RestoreCup
	moveq #0,d0
	move.l screen,d0     ; BOP move
	add.l #$2800,d0 ; simple bop
	; Store variable : tmp2
	move.l d0,tmp2
	move.l tmp2,bf_dstimage ; Simple a:=b optimization 
	move.w #$13,foamsize ; Simple a:=b optimization 
	move.w #$40,foampos ; Simple a:=b optimization 
	jsr BeerFoam
edblock503
	add.w #$1,tmp ; Optimization: simple A := A op Const ADD SUB OR AND
	jsr CopperEffects
	jmp caseend452
casenext489
	move #$6,d0
	cmp.w effectNumber,d0
	bne casenext506
	jsr CopperEffects
	cmp.w #$8901,lightypos
	bhi eblock510
ctb509: ;Main true block ;keep 
	add.w #$100,lightypos ; Optimization: simple A := A op Const ADD SUB OR AND
	jmp edblock511
eblock510
	move.w #$3001,lightypos ; Simple a:=b optimization 
edblock511
	cmp.w #$10,musicPos
	bne localfailed522
	jmp ctb517
localfailed522: ;keep
	; ; logical OR, second chance
	cmp.w #$28,musicPos
	bne localfailed521
	jmp ctb517
localfailed521: ;keep
	; ; logical OR, second chance
	cmp.w #$40,musicPos
	bne localfailed523
	jmp ctb517
localfailed523: ;keep
	; ; logical OR, second chance
	cmp.w #$58,musicPos
	bne edblock519
ctb517: ;Main true block ;keep 
	move.w #$7,effectNumber ; Simple a:=b optimization 
edblock519
	jmp caseend452
casenext506
	move #$7,d0
	cmp.w effectNumber,d0
	bne casenext525
	jsr CopperEffects
	cmp.l #$2800,screenOffset
	bhs eblock529
ctb528: ;Main true block ;keep 
	jsr EffScrolldown
	jmp edblock530
eblock529
	move.w #$8,effectNumber ; Simple a:=b optimization 
	move.w #$0,frameCounter ; Simple a:=b optimization 
edblock530
	jmp caseend452
casenext525
	move #$8,d0
	cmp.w effectNumber,d0
	bne casenext535
	cmp.w #$18,musicPos
	bne localfailed543
	jmp ctb538
localfailed543: ;keep
	; ; logical OR, second chance
	cmp.w #$2c,musicPos
	bne localfailed542
	jmp ctb538
localfailed542: ;keep
	; ; logical OR, second chance
	cmp.w #$48,musicPos
	bne localfailed544
	jmp ctb538
localfailed544: ;keep
	; ; logical OR, second chance
	cmp.w #$64,musicPos
	bne edblock540
ctb538: ;Main true block ;keep 
	move.w #$9,effectNumber ; Simple a:=b optimization 
	move.w musicPos,musicPosOld ; Simple a:=b optimization 
edblock540
	cmp.w #$64,musicPos
	bne edblock549
ctb547: ;Main true block ;keep 
	move.w #$5b,effectNumber ; Simple a:=b optimization 
	move.w musicPos,musicPosOld ; Simple a:=b optimization 
edblock549
	jsr CopperEffects
	jmp caseend452
casenext535
	move #$9,d0
	cmp.w effectNumber,d0
	bne casenext552
	move.w musicPosOld,d1          ; Loadvar regular end
	move.w musicPos,d0
	cmp.w d1,d0
	bls edblock557
ctb555: ;Main true block ;keep 
	move.w musicPos,musicPosOld ; Simple a:=b optimization 
	move.w #$0,frameCounter ; Simple a:=b optimization 
edblock557
	cmp.w #$1,foamCounter
	bls eblock562
ctb561: ;Main true block ;keep 
	add.w #$1,frameCounter ; Optimization: simple A := A op Const ADD SUB OR AND
	cmp.w #$18,frameCounter
	bls localfailed591
localsuccess592: ;keep
	; ; logical AND, second requirement
	cmp.w #$23,frameCounter
	bhs localfailed591
	jmp ctb587
localfailed591: ;keep
	; ; logical OR, second chance
	cmp.w #$58,frameCounter
	bls edblock589
localsuccess593: ;keep
	; ; logical AND, second requirement
	cmp.w #$63,frameCounter
	bhs edblock589
ctb587: ;Main true block ;keep 
	sub.w #$1,foamCounter ; Optimization: simple A := A op Const ADD SUB OR AND
	add.w #$1,yOffset ; Optimization: simple A := A op Const ADD SUB OR AND
edblock589
	jsr EffBeerDrink
	jmp edblock563
eblock562
	move.l #imageRestoreCup,rc_srcimage ; Simple a:=b optimization 
	move.l screen,rc_dstimage ; Simple a:=b optimization 
	move.w #$3d,rc_yoffset ; Simple a:=b optimization 
	moveq #0,d0
	move.w #$a2,d0
	move.l d0,rc_height
	jsr RestoreCup
	cmp.w #$20,musicPos
	bne localfailed602
	jmp ctb597
localfailed602: ;keep
	; ; logical OR, second chance
	cmp.w #$34,musicPos
	bne localfailed601
	jmp ctb597
localfailed601: ;keep
	; ; logical OR, second chance
	cmp.w #$4,musicPos
	bne localfailed604
	jmp ctb597
localfailed604: ;keep
	; ; logical OR, second chance
	cmp.w #$50,musicPos
	bne localfailed603
	jmp ctb597
localfailed603: ;keep
	; ; logical OR, second chance
	cmp.w #$6c,musicPos
	bne edblock599
ctb597: ;Main true block ;keep 
	move.w #$a,effectNumber ; Simple a:=b optimization 
edblock599
edblock563
	jsr CopperEffects
	jmp caseend452
casenext552
	move #$5b,d0
	cmp.w effectNumber,d0
	bne casenext606
	move.w musicPosOld,d1          ; Loadvar regular end
	move.w musicPos,d0
	cmp.w d1,d0
	bls edblock611
ctb609: ;Main true block ;keep 
	move.w musicPos,musicPosOld ; Simple a:=b optimization 
	move.w #$0,frameCounter ; Simple a:=b optimization 
edblock611
	cmp.w #$1,foamCounter
	bls eblock616
ctb615: ;Main true block ;keep 
	add.w #$1,frameCounter ; Optimization: simple A := A op Const ADD SUB OR AND
	cmp.w #$18,frameCounter
	bls edblock641
localsuccess643: ;keep
	; ; logical AND, second requirement
	cmp.w #$2e,frameCounter
	bhs edblock641
ctb639: ;Main true block ;keep 
	sub.w #$1,foamCounter ; Optimization: simple A := A op Const ADD SUB OR AND
	add.w #$1,yOffset ; Optimization: simple A := A op Const ADD SUB OR AND
edblock641
	jsr EffBeerDrink
	jmp edblock617
eblock616
	move.l #imageRestoreCup,rc_srcimage ; Simple a:=b optimization 
	move.l screen,rc_dstimage ; Simple a:=b optimization 
	move.w #$3d,rc_yoffset ; Simple a:=b optimization 
	moveq #0,d0
	move.w #$a2,d0
	move.l d0,rc_height
	jsr RestoreCup
	cmp.w #$20,musicPos
	bne localfailed652
	jmp ctb647
localfailed652: ;keep
	; ; logical OR, second chance
	cmp.w #$34,musicPos
	bne localfailed651
	jmp ctb647
localfailed651: ;keep
	; ; logical OR, second chance
	cmp.w #$4,musicPos
	bne localfailed654
	jmp ctb647
localfailed654: ;keep
	; ; logical OR, second chance
	cmp.w #$50,musicPos
	bne localfailed653
	jmp ctb647
localfailed653: ;keep
	; ; logical OR, second chance
	cmp.w #$6c,musicPos
	bne edblock649
ctb647: ;Main true block ;keep 
	move.w #$a,effectNumber ; Simple a:=b optimization 
edblock649
edblock617
	jsr CopperEffects
	jmp caseend452
casenext606
	move #$a,d0
	cmp.w effectNumber,d0
	bne casenext656
	add.w #$1,beerinput ; Optimization: simple A := A op Const ADD SUB OR AND
	jsr DistortMore
	move.w #$0,eff0Counter ; Simple a:=b optimization 
	move.w #$4,effectNumber ; Simple a:=b optimization 
	move.w #$97,foamCounter ; Simple a:=b optimization 
	move.w #$1,yOffset ; Simple a:=b optimization 
casenext656
caseend452
	jmp while236
edblock239
loopend241
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
music
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/music/terra-mesta4.lsmusic"
	 	CNOP 0,4
	 	CNOP 0,4
bank
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/music/terra-mesta4.lsbank"
	 	CNOP 0,4
	 	CNOP 0,4
imageRestoreCup
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/images/restorecup.BPL"
	 	CNOP 0,4
	 	CNOP 0,4
image1
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/images/cupempty.BPL"
	 	CNOP 0,4
	 	CNOP 0,4
image2
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/images/cupempty.BPL"
	 	CNOP 0,4
	 	CNOP 0,4
imageCupFull
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/images/cupfull.BPL"
	 	CNOP 0,4
	 	CNOP 0,4
imageFoam
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/images/foam.BPL"
	 	CNOP 0,4
	 	CNOP 0,4
imageMask
	incbin "C:/Users/uersu/Documents/GitData/compofiller///resources/images/mask.BPL"
	 	CNOP 0,4
