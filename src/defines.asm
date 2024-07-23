include

freerom = $00FF52
expanded = $208000


;hijacks
hijack_game_init = $04DEDD
hijack_demo_timer_check = $04DD34
hijack_intro_scrolling_text = $04DC7D
hijack_intro_set_bgs = $04DBB0
hijack_intro_bg3_text_dma = $04DB74
hijack_title_pal_override = $04DCCF
hijack_intro_set_bg3 = $04DCF9
hijack_intro_set_bg3_size = $04DBCA
hijack_intro_set_bg3_offset = $04DBF1
hijack_title_cursor_move = $04DD07
hijack_title_cgram_write = $04DC0F
hijack_game_start = $04DD13
hijack_lives_decrease = $00BC1E
hijack_lives_increase = $02B86E
hijack_lives_counter_update_1 = $048CD6
hijack_every_frame = $009CE5
hijack_start_select_check = $04846D
hijack_room_update = $019191
hijack_doors_room_update = $01AA79
hijack_room_update_in_map = $04D0AC
hijack_raglan_citadel_room_update = $02B748
hijack_level_number_update = $04D4C9
hijack_map_level_beaten_check = $04D5BE
hijack_map_level_beaten_check_2 = $04D5A0
hijack_level_entry = $04D6BE
hijack_level_entry_2 = $04D6CF
hijack_map_set_path = $04D5CA
hijack_map_room_number_update = $04D0AC
hijack_initial_boss_health_update = $01819C
hijack_boss_health_update = $02FDE6
hijack_boss_health_update_2 = $02DD76
hijack_boss_health_update_3 = $02E589
hijack_boss_health_update_4 = $02FEEF
hijack_boss_health_update_5 = $02EFCB
hijack_stage_title_card = $04DACB
hijack_stage_title_card_2 = $00820C
hijack_citadel_enter = $02B78F
hijack_citadel_boss_death = $02CAEC
hijack_citadel_boss_flag_clear = $00C3B6
hijack_ending_init = $04CBD5



;ram
!global_frame_counter = $20
!active_frame_counter = $22

!player_held_high = $25
!player_released_high = $2D
!player_pressed_high = $35
!player_pressed_low = $34

!rng1 = $9B
!rng2 = $9C

!screen_brightness = $0553

!boss_death_flag = $05AC


!level_number = $1F02
!room_number = $1F03

!max_health = $1F05


!health = $7EF801
!lives = $1F00
!selected_magic = $1F0B
!available_magic = $1F0C
!magic = $1F0D
!gems = $1F0E

!health_disp = $7E200A
!lives_disp = $7E200B
!gems_disp = $7E200C
!magic_disp = $7E200D




;ram used by the hack

!temp_1 = $1F50
!temp_2 = $1F51
!temp_3 = $1F59
!temp_4 = $1F5A

!room_number_cap = $1F58

!previous_health = $1F53
!previous_magic = $1F54
!previous_selected_magic = $1F55
!previous_gems = $1F56

!room_number_mirror = $1F57

!vram_destination = $1F60
!text_to_dma = $1F62
!dma_size = $1F64