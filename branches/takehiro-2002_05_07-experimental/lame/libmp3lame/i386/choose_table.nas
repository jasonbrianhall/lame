; ix_max()
;	part of this code is origined from
;	new GOGO-no-coda (1999, 2000)
;	Copyright (C) 1999 shigeo
;	modified by Keiichi SAKAI

;	Copyright 2004 Takehiro TOMINAGA/LAME Project

%include "nasm.h"

;
; int ix_max_MMX(int *ix, int *end)
;
	segment_code
	proc	ix_max_MMX
	mov	ecx, [esp+4]	;ecx = begin
	mov	edx, [esp+8]	;edx = end

	sub	ecx, edx	;ecx = begin-end(should be minus)
	test	ecx, 8
 	pxor	mm1, mm1	;mm1=[0:0]
	movq	mm0, [edx+ecx]
	jz	.lp

	add	ecx,8
	jz	.exit

	loopalign	16
.lp:
	movq	mm4, [edx+ecx]
	movq	mm5, [edx+ecx+8]
	add	ecx, 16
; below operations should be done as dword (32bit),
; but an MMX has no such instruction.
; but! because the maximum value of IX is 8191+15,
; we can safely use "word(16bit)" operation.
	psubusw	mm4, mm0
	psubusw	mm5, mm1
	paddw	mm0, mm4
	paddw	mm1, mm5
	jnz	.lp

	psubusw	mm1, mm0
	paddw	mm0, mm1
.exit:
	movq	mm4, mm0
	punpckhdq	mm4, mm4
	psubusw	mm4, mm0
	paddw	mm0, mm4
	movd	eax, mm0
	emms
	ret

	end