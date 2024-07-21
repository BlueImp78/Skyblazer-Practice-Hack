lorom

org $008000    
	incsrc defines.asm
	incsrc hijacks.asm

org freerom
	incsrc wrappers.asm

warnpc freerom|$FFFF



org expanded
	incsrc code.asm

warnpc expanded|$FFFF


org $20B000
	incsrc data.asm

