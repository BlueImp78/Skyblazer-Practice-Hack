include

send_to_map:
	LDA $1F35
	CMP #$47
	BEQ +
	LDA #$14
send_to_map_in_current_level:
	SEP #$20
	STA !level_number
-:
	LDA #$01
	STA $5AC
	STZ $1F39
	JML $008208

+:
	STZ $1F38
	LDA !level_number
	CMP #$15
	BEQ .goto_2nd_continent
	CMP #$16
	BEQ .back_to_1st_continent
	CMP #$19
	BEQ .back_to_2nd_continent
	CMP #$1E
	BEQ .goto_3rd_continent
	RTL

.back_to_1st_continent:
	LDA #$15
	STA !level_number
	LDA #$74
	STA $7E5010
	LDA #$C9
	STA $7E5011
	LDA #$04
	STA $7E5018
	BRA -

.goto_2nd_continent:
	LDA #$16
	STA !level_number
	LDA #$86
	STA $7E5010
	LDA #$C9
	STA $7E5011
	LDA #$0A
	STA $7E5018
	BRA -

.back_to_2nd_continent:
	LDA #$1E
	STA !level_number
	LDA #$14
	STA $7E5010
	LDA #$CA
	STA $7E5011
	LDA #$08
	STA $7E5018
	BRA - 

.goto_3rd_continent:
	LDA #$19
	STA !level_number
	LDA #$B8
	STA $7E5010
	LDA #$C9
	STA $7E5011
	LDA #$02
	STA $7E5018
	BRL -


every_frame:
  	REP #$10 			;hijacked instruction
  	STA $003C  			;hijacked instruction
	LDA !level_number
	CMP #$14
	BCS .done 			;if in old man's hut, return to not softlock
	JSR button_checks
	LDA !active_frame_counter
	BIT #$03
	BNE .done
	LDA !rng1
	JSR hex_to_decimal
	BMI .negative
-:
	CMP !lives
	BNE + 
	DEC
+:
	STA !lives
.done:
	RTL

.negative:
	EOR #$FF
	INC
	BRA -


button_checks:
	LDA !screen_brightness
	CMP #$0F
	BCC .done
	LDA $0BB0
	CMP #$39
	BNE .check_select
.check_a:
	LDA !player_pressed_low
	BIT #$80
	BEQ .check_x
	PHA 
	LDA !max_health
	STA !health
	PLA
.check_x:
	BIT #$40
	BEQ .check_select
	LDA #$08
	STA !magic
.check_select:
	LDA !player_held_high
	BIT #$20
	BNE reload_room
	LDA !player_released_high
	BIT #$20
	BEQ .done 			;only restore previous health/magic if reloading current room
-:
	LDA $0BB0
	CMP #$39  			;if game is paused and select is pressed, return to world map
	BNE .not_paused
	LDA !level_number
	BNE .not_intro  		;if in intro, set level to 14 (first shrine) to not crash
	LDA #$14
	JMP send_to_map_in_current_level
.not_intro:
	CMP #$08  			;if in citadel, return to map from the ouside area instead to not crash
	BNE .not_citadel
	LDA #$10
.not_citadel:
	JMP send_to_map_in_current_level
.not_paused:
	JSR restore_player_status
	LDA !room_number_mirror
	BRA reload
.done:
	RTS

reload_room:
	LDA !level_number 		;if in intro level, dont allow for changing rooms
	BEQ -
	LDA $0BB0 			;or if paused
	CMP #$39
	BEQ - 
	LDA !player_pressed_high
	BIT #$01
	BNE .cycle_right
	BIT #$02
	BNE .cycle_left
	RTS

.cycle_right:
	JSL preserve_player_status_2
	LDA !level_number
	CMP #$08
	BNE +
	LDA !room_number_mirror
	CMP #$0A
	BNE .check_ashura 		;if warping forward from last corridor, go to ashura instead of cutscene
	LDA #$0C
	BRA reload
.check_ashura:
	CMP #$0C
	BNE +
	LDA #$0E  			;if in ashura room, go to raglan instead of cutscene
	BRA reload
+:
	LDA !room_number_mirror
	INC
	JSR get_room_cap
	CMP !room_number_cap
	BCS .wrap
	BRA reload

.wrap:
	LDA #$00
	BRA reload

.cycle_left:
	JSL preserve_player_status_2
	LDA !level_number
	CMP #$08
	BNE ++
	LDA !room_number_mirror
	CMP #$0C 			;if in ashura room, go to corridor instead of cutscene
	BNE .check_raglan
	LDA #$0A
	BRA reload
.check_raglan:
	CMP #$0E
	BNE ++
	LDA #$0C
	CMP !room_number_mirror
	BRA reload 			;if in raglan room, go to ashura instead of cutscene
++:
	LDA !room_number_mirror
	DEC 
	BPL reload
	JSR get_room_cap
	LDA !room_number_cap
	DEC
reload:
	JSR check_boss_room
	STA !room_number	
  	SEP #$20
	STZ !player_pressed_high
	STZ !player_held_high  		;clear inputs
	STZ !player_released_high
	LDA !boss_death_flag
	BEQ +
	STZ !boss_death_flag  		;if a boss is dying, clear the flag to not crash
+:	
	LDA #$BF
	STA $65  			;set some damage related value to make the game think we're dying, otherwise crashes
	LDA #$01
	STA $6E  			;disable player control
	LDA !room_number
	BNE ++ 				;if going to first room of stage, set proper player status
	PHA
	PHP  				;push flags cuz this game is fucking stupid and changes them CONSTANTLY
	SEP #$10  			
	LDA !level_number
	ASL
	TAX
	JSL set_level_stuff_wrapper
	PLP   
	PLA
++:
	STA !room_number_mirror	
	LDX #$0002  			;if we go to routine below with X not being 2, ugly things happen
	JSL start_fadeout_wrapper
	RTS


get_room_cap:
	PHA
	PHP
	SEP #$30
	LDA !level_number
	TAX
	LDA.l room_number_cap_table,x
	STA !room_number_cap
	SEP #$30
	PLP
	PLA
	RTS



;if warping out of a boss room, dma the proper tiledata
check_boss_room:
	PHA
	SEP #$10
	LDX !level_number
	CPX #$08 			;citadel already does this by default, doing this there would only slow down loads
	BEQ .done  			
	STA !temp_3
	JSR get_room_cap
	LDA !room_number_cap
	DEC
	STA !temp_4
	LDA !room_number
	CMP !temp_4
	BNE .done
	LDA !temp_3
	CMP !temp_4
	BEQ .done
	STZ $1F37 			;clearing this address makes the game do the dma
.done:
	REP #$10
	PLA
	RTS


hex_to_decimal:
        STA !temp_1       
        LSR A
        ADC !temp_1
        ROR A
        LSR A
        LSR A
        ADC !temp_1
        ROR A
        ADC !temp_1
        ROR A
        LSR A
        AND #$3C
        STA !temp_2     
        LSR A 
        ADC !temp_2
        ADC !temp_1
        RTS
	

preserve_player_status:
  	STA !room_number 		;hijacked instruction
	STA !room_number_mirror
preserve_player_status_2:
	JSR preserve_player_stuff
	LDA !level_number
	BNE .done 			;if in intro stage room 1, skip ashura  cutscene and go to map
	LDA !room_number
	CMP #$01
	BNE .done
	JMP send_to_map
.done:
	LDA #$01 			;hijacked instruction
	RTL


;need another one just for raglan citadel
preserve_player_status_3:
	LDA !room_number 		;hijacked instruction
	INC				;hijacked instruction
	STA !room_number		;hijacked instruction
	CMP #$0B
	BNE +
	LDA #$0C 			;if leaving last corridor skip ashura cutscene
+:
	STA !room_number_mirror
	JMP preserve_player_status


preserve_player_stuff:
	LDA !health
	STA !previous_health
	LDA !selected_magic
	STA !previous_selected_magic
	LDA !magic
	STA !previous_magic
	LDA !gems
	STA !previous_gems
	RTS


restore_player_status:
	LDA !previous_health
	STA !health
	LDA !previous_selected_magic
	STA !selected_magic
	LDA !previous_magic
	STA !magic
	LDA !previous_gems
	STA !gems
	RTS


level_entry_set_stuff:
	LDA !level_number
	CMP #$18  			;dont enter shrine #3 (will softlock if entered)
	BEQ .done 
	CMP #$10 			;check if entering citadel
	BEQ .check_start
--:
  	LDA #$01 			;hijacked instruction
  	STA $7E5016			;hijacked instruction
	STZ !room_number
	STZ !room_number_mirror
	LDA !level_number
	CMP #$14
	BEQ .goto_intro
	CMP #$15
	BCS .done
-:
	ASL
	TAX 
	JMP (set_level_stuff,x)


.check_start:
	PHA
	LDA !player_held_high
	AND #$10  			;if start held, skip to boss rush
	BNE .skip_to_boss_rush
	PLA
	BRA --



.skip_to_boss_rush:
	PLA
	LDA #$08
	STA !level_number
  	LDA #$01 			;hijacked instruction
  	STA $7E5016			;hijacked instruction
	STA !room_number
	STA !room_number_mirror
	LDA !level_number
	BRA -
	


.goto_intro:
	LDA #$00
	STA !level_number
	BRA -

.done:
	JMP send_to_map


set_level_stuff_wrapper:
	JMP (set_level_stuff,x)


set_level_stuff:
	dw .intro
	dw .temple_infernus
	dw .tarolisk_tower
	dw .pretrolith_castle
	dw .lair_of_kharyon
	dw .storm_fortress
	dw .caverns_of_shirol
	dw .great_tower
	dw .raglan_citadel_inside
	dw .faltine_woods
	dw .cliffs_of_peril
	dw .sand_rivers
	dw .gateway_of_storms
	dw .falls_of_torment
	dw .fortress_shirol
	dw .dragonhill_forest
	dw .raglan_citadel_outside


.intro:
	LDA #$04
	STA !max_health
	STA !health
.starting_magic:
	LDA #$01
	STA !selected_magic
	STA !available_magic
	LDA #$08
	STA !magic
	JMP .setup_done

.temple_infernus:
	LDA #$05
	STA !max_health
	STA !health
	JMP .starting_magic

.tarolisk_tower:
	LDA #$05
	STA !max_health
	STA !health
	LDA #$02
	STA !selected_magic
	LDA #$03
	STA !available_magic
	LDA #$08
	STA !magic
	JMP .setup_done


.pretrolith_castle
	LDA #$06
	STA !max_health
	STA !health
	LDA #$07
	STA !selected_magic
	LDA #$43
	STA !available_magic
	LDA #$08
	STA !magic
	JMP .setup_done

.lair_of_kharyon:
	LDA #$06
	STA !max_health
	LDA #$04
	STA !health
	LDA #$02
	STA !selected_magic
	LDA #$53
	STA !available_magic
	LDA #$04
	STA !magic
	JMP .setup_done

.storm_fortress:
	LDA #$02
	STA !selected_magic
	LDA #$08
	STA !magic
	JMP .after_rivers

.caverns_of_shirol:
	LDA #$06
	STA !max_health
	STA !health
	LDA #$03
	STA !selected_magic
	LDA #$5F
	STA !available_magic
	LDA #$08
	STA !magic
	JMP .setup_done

.great_tower:
	LDA #$06
	STA !max_health
	STA !health
	STA !magic
	LDA #$02
	STA !selected_magic
	LDA #$7F
	STA !available_magic
	JMP .setup_done

.raglan_citadel_inside:
	LDA #$06
	STA !max_health
	STA !health
	STA !magic
	LDA #$02
	STA !selected_magic
	LDA #$FF 
	STA !available_magic
	JMP .setup_done

.faltine_woods:
	JMP .temple_infernus

.cliffs_of_peril:
	JMP .temple_infernus

.sand_rivers:
	LDA #$08
	STA !magic
	LDA #$04
	STA !selected_magic
.after_rivers:
	LDA #$06
	STA !max_health
	STA !health
	LDA #$5B
	STA !available_magic
	JMP .setup_done

.gateway_of_storms:
	LDA #$04
	STA !magic
	LDA #$02
	STA !selected_magic
	JMP .after_rivers

.falls_of_torment:
	LDA #$06
	STA !max_health
	STA !health
	LDA #$05
	STA !selected_magic
	LDA #$53
	STA !available_magic
	LDA #$08
	STA !magic
	JMP .setup_done

.fortress_shirol:
	LDA #$06
	STA !max_health
	LDA #$03
	STA !health
	STZ !magic
	JMP .setup_done
	
.dragonhill_forest:
	LDA #$06
	STA !max_health
	STA !health
	STA !selected_magic
	LDA #$7F
	STA !available_magic
	LDA #$08
	STA !magic
	JMP .setup_done

.raglan_citadel_outside:
	LDA #$06
	STA !max_health
	STA !health
	LDA #$08
	STA !selected_magic
	STA !magic
	LDA #$FF
	STA !available_magic
.setup_done:
	JSR preserve_player_stuff
	RTL 



;prevent going to citadel in the map (the actual building) to not softlock.
;you can actually go there and go straight to the inside section, would be nice,
;but there is no set path to go back so you're stuck there forever.
restrict_citadel:
  	LDA $0EC7C8,x 			;hijacked instruction
	CPX #$10
	BNE +
	LDA #$01
+:
  	STA $7E5018 			;hijacked instruction
	RTL



;prevent entering shrine 3 to not softlock
restrict_shrine_3:
	LDA !level_number
	CMP #$18
	BEQ .done
  	LDA #$FF 			;hijacked instruction
  	STA $1F35  			;hijacked instruction
.done:
	RTL

skip_title_card_text:
	LDA $1F35
	CMP #$FF
	BEQ .done
	JSL start_fadeout_wrapper_2 	
.done:
	SEP #$20  			;hijacked instruction
	RTL



citadel_room_number_update:
	LDA !level_number 
	CMP #$10 			;if no check here, also activates on ashura death
	BNE .done
 	LDA #$01 			;hijacked instruction
	STA !room_number 		;hijacked instruction
	STA !room_number_mirror
	JSR preserve_player_stuff
.done:
	RTL




advance_citadel_room:
	LDA !level_number
	CMP #$08
	BNE .done
	LDA !room_number
	CMP #$0C 			;if in ashura room, INC 2x to get to raglan
	BNE +
	INC 
+:
	INC 
	STA !room_number
	STA !room_number_mirror
	JSR preserve_player_stuff
	STZ !boss_death_flag		;hijacked instruction
	JML $008208 			;hijacked instruction
.done:
	RTL


;put boss health in gems counter when they spawn.
;this routine is an actual tragedy.
display_boss_health_init:
  	LDA $020006,x  			;hijacked instruction
  	STA $0F90 			;hijacked instruction
	PHA
	SEP #$20
	LDA $1F35  			
	CMP #$FF
	BEQ .done 
	PHY				;tarolisk boss room breaks if we dont push Y 
	JSR get_room_cap 
	PLY
	LDA !level_number
	CMP #$08
	BEQ +  				;skip room cap check if in citadel
	LDA !room_number_cap
	DEC
	CMP !room_number
	BNE .done
+:
	LDA !level_number
	CMP #$08
	BEQ .citadel 			;need to set them manually if in citadel, sadly
	CMP #$02
	BEQ .tarolisk_boss
	CMP #$04
	BEQ .kharyon_boss
	CMP #$05
	BEQ .storm_fortress_boss
	CMP #$07
	BNE .normal_boss
	LDA #$20
	STA !gems
	BRA .done

.normal_boss:
	REP #$20
	PLA
	SEP #$20
	STA !gems
	REP #$20
	RTL

.done:
	REP #$20
	PLA
	RTL



.tarolisk_boss:
	LDA #$07
.store:
	STA !gems
	BRA .done

.kharyon_boss:
	LDA #$40
	BRA .store

.storm_fortress_boss:
	LDA #$16
	BRA .store


.citadel:
	LDA !room_number
	CMP #$01
	BEQ .genie
	CMP #$03
	BEQ .tarolisk_boss
	CMP #$05
	BEQ .demon_wall
	CMP #$07
	BEQ .kharyon_boss
	CMP #$09
	BEQ .demon_wall 		;elephant, same hp as demon wall
	CMP #$0C
	BEQ .demon_wall  		;ashura, same hp as demon wall
	LDA #$10  		 	;raglan
	BRA .store

.genie:
	LDA #$20
	BRA .store

.demon_wall:
	LDA #$30
	BRA .store



;update boss health on gems counter when they take damage
display_boss_health:
	LDA $7EF800,x 			;hijacked instruction
	SEC 				;hijacked instruction
	SBC $0FB5 			;hijacked instruction
	STA $7EF800,x 			;hijacked instruction
	PHA
	BPL update_gem_counter	
	LDA #$00
update_gem_counter:
	STA !gems
	PLA
	RTL


;need another one of these for some dumb reason for tarolisk boss
display_boss_health_2:
  	LDA $7EF800,x  			;hijacked instruction
  	DEC 				;hijacked instruction
  	STA $7EF800,x 	 		;hijacked instruction
	PHA
	JMP update_gem_counter


;this game's code hurts me physically
display_boss_health_3:
	LDA $7EF800,x			;hijacked instruction
	SEC				;hijacked instruction
	SBC $05				;hijacked instruction
	STA $7EF800,x			;hijacked instruction
	PHP
	JMP update_gem_counter
	

;WHY DO THESE DEVS NEED 5 DIFFERENT BOSS DAMAGE ROUTINES HOLY SHIT JUST MAKE IT INTO A SINGLE ONE YOU IDIOTS
display_boss_health_5:
	LDA $7EF83E
	DEC
	STA $7EF83E
	PHA
	JMP update_gem_counter





;reload raglan room instead of triggering ending
skip_ending:
	PHA
	LDA !level_number
	CMP #$08
	BNE .done
	LDA !room_number_mirror
	CMP #$0E
	BNE .done
	LDA !boss_death_flag
	BEQ .done
	JSR restore_player_status
	PLA
	LDA !room_number_mirror
	JMP reload
.done:
	PLA
  	STA $00				;hijacked instruction				
  	STZ $01				;hijacked instruction
	RTL





dma_title_text:
	SEP #$20
	STZ $0C0A 			;clear bg3 scroll
	LDA #$17
	STA $0551 			;enable bg3
	REP #$20


;clear bg1 passwrod text
	LDA #$72EE
	STA !vram_destination
	LDA #zero_fill
	STA !text_to_dma
	LDA #$0012
	STA !dma_size
	JSR DMA_to_VRAM


;clear bg3
	LDA #$7800
	STA !vram_destination
	LDA #zero_fill
	STA !text_to_dma
	LDA #$1000
	STA !dma_size
	JSR DMA_to_VRAM


;dma title screen text
	LDA #$7A27
	STA !vram_destination
	LDA #title_screen_text
	STA !text_to_dma
	LDA #$0224
	STA !dma_size
	JSR DMA_to_VRAM
	SEP #$20
	RTL


DMA_to_VRAM:
	LDA #$0080
	STA $2115 			;transfer mode (to vram)
	LDA !vram_destination
	STA $2116          		;vram address
	LDA !text_to_dma  		;text table address
	STA $4332
	LDA !dma_size         
	STA $4335
	LDA #$1801          		;two registers, write once
	STA $4330
	SEP #$30
	LDY #$20            		;text table bank byte
	STY $4334
	LDA #$08         		;channel 3
	STA $420B          		;enable DMA and pray it works OH MY FUCKING GOD JUST WORK
	REP #$30
	RTS


