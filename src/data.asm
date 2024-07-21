include


title_screen_text:
	;    P      R      A      C      T      I      C      E
	dw $3C9A, $3C9C, $3C8B, $3C8D, $3C9E, $3C93, $3C8D, $3C8F, $0000
	;    H      A      C      K             v       
	dw $3C92, $3C8B, $3C8D, $3C95, $0000, $3CBA
	;    1      .      1
	dw $3C82, $3CC0, $3C82


	padbyte $00 : pad $20B202


   	;    B      Y             B      L      U      E      I      M      P
	dw $3C8C, $3CA3, $0000, $3C8C, $3C96, $3C9F, $3C8F, $3C93, $3C97, $3C9A
        ;            -            2      0      2      4
	dw $0000, $3CBF, $0000, $3C83, $3C81, $3C83, $3C85        



;last room nuber + 1
room_number_cap_table:
        db $01          ;intro
        db $0A          ;temple infernus
        db $14          ;tarolisk tower
        db $08          ;pretrolith castle 
	db $11		;lair of kharyon
	db $04		;storm fortress
	db $0A		;caverns of shirol
	db $10		;great tower
	db $0F 		;raglan's citadel (inside)
	db $01 		;faltine woods
	db $01 		;cliffs of peril
	db $01 		;sand rivers of shirol
	db $01 		;gateway of storms
	db $01 		;falls of torment
	db $01 		;fortress shirol
	db $0E 		;dragonhill forest
	db $01 		;raglan's citadel (outside)


title_pal:
	db $FF, $7F, $0F, $00, $90, $7F, $4E, $7F, $0C, $7F, $08, $20, $FF, $7F


zero_fill:

padbyte $00 : pad $208FFF