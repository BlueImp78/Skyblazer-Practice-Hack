include

org hijack_game_init
	JMP $DAE7


org hijack_demo_timer_check
	NOP #9


org hijack_intro_scrolling_text
	LDA #$0060
	STA $00A2
	BRA $36

org hijack_intro_bg3_text_dma
	JSL dma_title_text
	BRA $18


org hijack_intro_set_bg3
	NOP #5

org hijack_intro_set_bgs
	LDA #$17

org hijack_intro_set_bg3_size
	LDA #$78


org hijack_intro_set_bg3_offset
	LDA #$0000

org hijack_title_pal_override
	BRA $21


;prevent white start text (there devs, fixed your dumb mistake)
org hijack_title_cgram_write
	BRA $1B

;stop cursor from moving
org hijack_title_cursor_move
	NOP #3


org hijack_game_start
	JSL send_to_map


;dont deduct lives on death
org hijack_lives_decrease
	NOP #3


;dont increase lives with 1ups (to not mess up the counter)
org hijack_lives_increase
	NOP #16


;dont update lives counter when dying and obtaining 1ups
org hijack_lives_counter_update_1
	NOP #4


org hijack_every_frame
	JSL every_frame
	NOP


;prevent vanilla feature of pressing select to quit out of beaten stage (conflicts with patch)
org hijack_start_select_check
	NOP #6


org hijack_room_update
	JSL preserve_player_status
	NOP

org hijack_doors_room_update
	JSL preserve_player_status
	NOP

org hijack_raglan_citadel_room_update
	JSL preserve_player_status_3
	NOP #3

org hijack_map_level_beaten_check
	BRA $0A
	NOP #3


org hijack_map_level_beaten_check_2
	BRA $28
	NOP #3


org hijack_level_entry
	JSL level_entry_set_stuff
	NOP #2


org hijack_level_entry_2
	JSL restrict_shrine_3
	NOP


org hijack_map_set_path
	JSL restrict_citadel
	NOP #4


;faster transition into stages (2 seconds lol)
org hijack_stage_title_card
	LDA #$00


;same for 1 extra second
org hijack_stage_title_card_2
	JSL skip_title_card_text
	NOP 

org hijack_initial_boss_health_update
	JSL display_boss_health_init
	NOP #3


org hijack_boss_health_update
	JSL display_boss_health
	NOP #8

org hijack_boss_health_update_2
	JSL display_boss_health_2
	NOP #5

org hijack_boss_health_update_3
	JSL display_boss_health_3
	NOP #7

org hijack_boss_health_update_4
	JSL display_boss_health
	NOP #8

org hijack_boss_health_update_5
	JSL display_boss_health_5
	NOP #5


org hijack_citadel_enter
	JSL citadel_room_number_update
	NOP


org hijack_citadel_boss_death
	NOP #3


org hijack_citadel_boss_flag_clear
	JSL advance_citadel_room
	NOP #3


org hijack_ending_init
	JSL skip_ending