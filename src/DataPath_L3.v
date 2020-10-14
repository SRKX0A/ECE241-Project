module DataPath_L3(
							input
									clock,					// from system
									reset,					//
									transition_clock,
												
									player_enable,
									enemy1_enable,
									enemy2_enable,
									enemy3_enable,
									enemy4_enable,
									enemy5_enable,
									
									s_erase_player,		// from ControlPath module
									s_draw_player,			//
									s_erase_enemy1,		// 
									s_draw_enemy1,			//
									s_erase_enemy2,		//
									s_draw_enemy2,
									s_erase_enemy3,
									s_draw_enemy3,			//
									s_erase_enemy4,
									s_draw_enemy4,
									s_erase_enemy5,
									s_draw_enemy5,
									
									s_move_player,
									s_move_enemy1,
									s_move_enemy2,
									
									s_start_level3,
									s_start_screen,
									s_transition_screen,
									s_win_screen,
									
							input[7:0]
									keyboard_data,			// from PS2_Movement module
						
							output							
									win, 						// to ControlPath module
									lose,						//
									player_erased,			// 
									player_loaded,			//
									enemy1_erased,			// 
									enemy1_loaded,			//
									enemy2_erased,			//
									enemy2_loaded,			//
									enemy3_erased,
									enemy3_loaded,
									enemy4_erased,
									enemy4_loaded,
									enemy5_erased,
									enemy5_loaded,
		
									start_screen_drawn,
									transition_screen_drawn,
									win_screen_drawn,
									
							output reg[8:0]						
									vga_x_input,			// to vga module 
									vga_y_input,			//	
																// 
							output reg[2:0]				// 
									vga_c_input				//
																	
									
						);

/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/

	reg[16:0] background_redraw;
	
	wire[16:0] player_address, player_background_address, enemy1_address, enemy1_background_address, enemy2_address, enemy2_background_address, enemy3_address, enemy3_background_address, enemy4_address, enemy4_background_address, enemy5_address, enemy5_background_address, start_screen_address, win_screen_address;
	
	wire[8:0] player_x_position, player_y_position, player_x_sprite, player_y_sprite, player_x_position_rom, player_y_position_rom;
	
	wire[8:0] enemy1_x_position, enemy1_y_position, enemy1_x_sprite, enemy1_y_sprite, enemy1_x_position_rom, enemy1_y_position_rom;
	
	wire[8:0] enemy2_x_position, enemy2_y_position, enemy2_x_sprite, enemy2_y_sprite, enemy2_x_position_rom, enemy2_y_position_rom;
	
	wire[8:0] enemy3_x_position, enemy3_y_position, enemy3_x_sprite, enemy3_y_sprite, enemy3_x_position_rom, enemy3_y_position_rom;
	
	wire[8:0] enemy4_x_position, enemy4_y_position, enemy4_x_sprite, enemy4_y_sprite, enemy4_x_position_rom, enemy4_y_position_rom;
	
	wire[8:0] enemy5_x_position, enemy5_y_position, enemy5_x_sprite, enemy5_y_sprite, enemy5_x_position_rom, enemy5_y_position_rom;
	
	wire[8:0] start_screen_x_position, start_screen_y_position;
	
	wire[8:0] transition_screen_x_position, transition_screen_y_position;
	
	wire[8:0] win_screen_x_position, win_screen_y_position;
	
	wire[2:0] player_color, player_background_color, enemy1_left_color, enemy1_right_color, enemy1_background_color, enemy2_left_color, enemy2_right_color, enemy2_background_color, enemy3_left_color, enemy3_right_color, enemy3_background_color, enemy4_left_color, enemy4_right_color, enemy4_background_color, enemy5_up_color, enemy5_down_color, enemy5_background_color, start_screen_color, win_screen_color, background_color;
	
	wire w_draw_erase_player = s_draw_player | s_erase_player;
	
	wire w_draw_erase_enemy1 = s_draw_enemy1 | s_erase_enemy1;
	
	wire w_draw_erase_enemy2 = s_draw_enemy2 | s_erase_enemy2;
	
	wire w_draw_erase_enemy3 = s_draw_enemy3 | s_erase_enemy3;
	
	wire w_draw_erase_enemy4 = s_draw_enemy4 | s_erase_enemy4;
	
	wire w_draw_erase_enemy5 = s_draw_enemy5 | s_erase_enemy5;
	
	wire w_load_erase_player = w_sprite_load_erase_player & w_rom_load_erase_player;
	
	wire w_load_erase_enemy1 = w_sprite_load_erase_enemy1 & w_rom_load_erase_enemy1;
	
	wire w_load_erase_enemy2 = w_sprite_load_erase_enemy2 & w_rom_load_erase_enemy2;
	
	wire w_load_erase_enemy3 = w_sprite_load_erase_enemy3 & w_rom_load_erase_enemy3;
	
	wire w_load_erase_enemy4 = w_sprite_load_erase_enemy4 & w_rom_load_erase_enemy4;
	
	wire w_load_erase_enemy5 = w_sprite_load_erase_enemy5 & w_rom_load_erase_enemy5;
	
	wire w_sprite_load_erase_player, w_sprite_load_erase_enemy1, w_sprite_load_erase_enemy2, w_sprite_load_erase_enemy3, w_sprite_load_erase_enemy4, w_sprite_load_erase_enemy5;
	
	wire w_rom_load_erase_player, w_rom_load_erase_enemy1, w_rom_load_erase_enemy2, w_rom_load_erase_enemy3, w_rom_load_erase_enemy4, w_rom_load_erase_enemy5;
	
	wire lose_1, lose_2, lose_3, lose_4, lose_5;
	
	wire enemy1_x_direction, enemy1_y_direction, enemy2_x_direction, enemy2_y_direction, enemy3_x_direction, enemy3_y_direction, enemy4_x_direction, enemy4_y_direction, enemy5_x_direction, enemy5_y_direction;
	
/*********************************************************************/
/*						PLAYER_SPRITE_POSITION MODULE								*/
/*********************************************************************/

	Player_Sprite_Position_L3 player(player_enable, reset, keyboard_data, player_x_position, player_y_position, win);
	defparam player.X_START = 9'd30;
	defparam player.Y_START = 9'd72 - 9'd35;
	
/*********************************************************************/
/*						ENEMY_SPRITE_POSITION MODULES								*/
/*********************************************************************/

	Enemy_Sprite_Position enemy1(enemy1_enable, reset, player_x_position, player_y_position, enemy1_x_position, enemy1_y_position, enemy1_x_direction, enemy1_y_direction, lose_1);
	defparam enemy1.X_ENABLE = 1'd1;
	defparam enemy1.Y_ENABLE = 1'd0;
	defparam enemy1.X_START = 9'd0;
	defparam enemy1.Y_START = 9'd179 - 9'd35;
	defparam enemy1.X_END = 9'd125-9'd55;
	defparam enemy1.Y_END = 9'd167 - 9'd35;
	defparam enemy1.X_DIRECTION  = 1'd0;
	defparam enemy1.Y_DIRECTION  = 1'd0;
	defparam enemy1.WIDTH = 55;
	defparam enemy1.HEIGHT = 35;
	
	Enemy_Sprite_Position enemy2(enemy2_enable, reset, player_x_position, player_y_position, enemy2_x_position, enemy2_y_position, enemy2_x_direction, enemy2_y_direction, lose_2);
	defparam enemy2.X_ENABLE = 1'd1;
	defparam enemy2.Y_ENABLE = 1'd0;
	defparam enemy2.X_START = 9'd320-9'd55;
	defparam enemy2.Y_START = 9'd179-9'd35;
	defparam enemy2.X_END = 9'd195;
	defparam enemy2.Y_END = 9'd300;
	defparam enemy2.X_DIRECTION  = 1'd1;
	defparam enemy2.Y_DIRECTION  = 1'd0;
	defparam enemy2.WIDTH = 55;
	defparam enemy2.HEIGHT = 35;
	
	Enemy_Sprite_Position enemy3(enemy3_enable, reset, player_x_position, player_y_position, enemy3_x_position, enemy3_y_position, enemy3_x_direction, enemy3_y_direction, lose_3);
	defparam enemy3.X_ENABLE = 1'd1;
	defparam enemy3.Y_ENABLE = 1'd0;
	defparam enemy3.X_START = 9'd0;
	defparam enemy3.Y_START = 9'd224 - 9'd35;
	defparam enemy3.X_END = 9'd162-9'd55;
	defparam enemy3.Y_END = 9'd108+9'd15;
	defparam enemy3.X_DIRECTION  = 1'd0;
	defparam enemy3.Y_DIRECTION  = 1'd0;
	defparam enemy3.WIDTH = 55;
	defparam enemy3.HEIGHT = 35;
	
	Enemy_Sprite_Position enemy4(enemy4_enable, reset, player_x_position, player_y_position, enemy4_x_position, enemy4_y_position, enemy4_x_direction, enemy4_y_direction, lose_4);
	defparam enemy4.X_ENABLE = 1'd1;
	defparam enemy4.Y_ENABLE = 1'd0;
	defparam enemy4.X_START = 9'd320 - 9'd55;
	defparam enemy4.Y_START = 9'd224 - 9'd35;
	defparam enemy4.X_END = 9'd162;
	defparam enemy4.Y_END = 9'd108+9'd15;
	defparam enemy4.X_DIRECTION  = 1'd1;
	defparam enemy4.Y_DIRECTION  = 1'd0;
	defparam enemy4.WIDTH = 55;
	defparam enemy4.HEIGHT = 35;
	
	Enemy_Sprite_Position enemy5(enemy5_enable, reset, player_x_position, player_y_position, enemy5_x_position, enemy5_y_position, enemy5_x_direction, enemy5_y_direction, lose_5);
	defparam enemy5.X_ENABLE = 1'd0;
	defparam enemy5.Y_ENABLE = 1'd1;
	defparam enemy5.X_START = 9'd138;
	defparam enemy5.Y_START = 9'd16;
	defparam enemy5.X_END = 9'd124-9'd55;
	defparam enemy5.Y_END = 9'd186-9'd35;
	defparam enemy5.X_DIRECTION  = 1'd0;
	defparam enemy5.Y_DIRECTION  = 1'd0;
	defparam enemy5.WIDTH = 31;
	defparam enemy5.HEIGHT = 35;
	
/*********************************************************************/
/*							SPRITE_COUNTER MODULES									*/
/*********************************************************************/

	Sprite_Counter player_sprite(clock, reset, w_draw_erase_player, w_rom_load_erase_player, player_x_position, player_y_position, w_sprite_load_erase_player, player_x_sprite, player_y_sprite);
	defparam player_sprite.X_START = 9'd30;
	defparam player_sprite.Y_START = 9'd72 - 9'd35;
	defparam player_sprite.WIDTH = 20;
	defparam player_sprite.HEIGHT = 35;
	
	Sprite_Counter enemy1_sprite(clock, reset, w_draw_erase_enemy1, w_rom_load_erase_enemy1, enemy1_x_position, enemy1_y_position, w_sprite_load_erase_enemy1, enemy1_x_sprite, enemy1_y_sprite);
	defparam enemy1_sprite.X_START = 9'd0;
	defparam enemy1_sprite.Y_START = 9'd179 - 9'd35;
	defparam enemy1_sprite.WIDTH = 55;
	defparam enemy1_sprite.HEIGHT = 35;
	
	Sprite_Counter enemy2_sprite(clock, reset, w_draw_erase_enemy2, w_rom_load_erase_enemy2, enemy2_x_position, enemy2_y_position, w_sprite_load_erase_enemy2, enemy2_x_sprite, enemy2_y_sprite);
	defparam enemy2_sprite.X_START = 9'd320-9'd55;
	defparam enemy2_sprite.Y_START = 9'd179-9'd35;
	defparam enemy2_sprite.WIDTH = 55;
	defparam enemy2_sprite.HEIGHT = 35;
	
	Sprite_Counter enemy3_sprite(clock, reset, w_draw_erase_enemy3, w_rom_load_erase_enemy3, enemy3_x_position, enemy3_y_position, w_sprite_load_erase_enemy3, enemy3_x_sprite, enemy3_y_sprite);
	defparam enemy3_sprite.X_START = 9'd0;
	defparam enemy3_sprite.Y_START = 9'd224 - 9'd35;
	defparam enemy3_sprite.WIDTH = 55;
	defparam enemy3_sprite.HEIGHT = 35;
	
	Sprite_Counter enemy4_sprite(clock, reset, w_draw_erase_enemy4, w_rom_load_erase_enemy4, enemy4_x_position, enemy4_y_position, w_sprite_load_erase_enemy4, enemy4_x_sprite, enemy4_y_sprite);
	defparam enemy4_sprite.X_START = 9'd320 - 9'd55;
	defparam enemy4_sprite.Y_START = 9'd224 - 9'd35;
	defparam enemy4_sprite.WIDTH = 55;
	defparam enemy4_sprite.HEIGHT = 35;
	
	Sprite_Counter enemy5_sprite(clock, reset, w_draw_erase_enemy5, w_rom_load_erase_enemy5, enemy5_x_position, enemy5_y_position, w_sprite_load_erase_enemy5, enemy5_x_sprite, enemy5_y_sprite);
	defparam enemy5_sprite.X_START = 9'd138;
	defparam enemy5_sprite.Y_START = 9'd16;
	defparam enemy5_sprite.WIDTH = 31;
	defparam enemy5_sprite.HEIGHT = 35;
	
/*********************************************************************/
/*									ROM_COUNTER MODULES								*/
/*********************************************************************/

	ROM_Counter player_rom_counter(clock, reset, w_draw_erase_player, w_sprite_load_erase_player, w_rom_load_erase_player, player_x_position_rom, player_y_position_rom);
	defparam player_rom_counter.ROM_WIDTH = 20;
	defparam player_rom_counter.ROM_HEIGHT = 35;
	
	ROM_Counter enemy1_rom_counter(clock, reset, w_draw_erase_enemy1, w_sprite_load_erase_enemy1, w_rom_load_erase_enemy1, enemy1_x_position_rom, enemy1_y_position_rom);
	defparam enemy1_rom_counter.ROM_WIDTH = 55;
	defparam enemy1_rom_counter.ROM_HEIGHT = 35;
	
	ROM_Counter enemy2_rom_counter(clock, reset, w_draw_erase_enemy2, w_sprite_load_erase_enemy2, w_rom_load_erase_enemy2, enemy2_x_position_rom, enemy2_y_position_rom);
	defparam enemy2_rom_counter.ROM_WIDTH = 55;
	defparam enemy2_rom_counter.ROM_HEIGHT = 35;
	
	ROM_Counter enemy3_rom_counter(clock, reset, w_draw_erase_enemy3, w_sprite_load_erase_enemy3, w_rom_load_erase_enemy3, enemy3_x_position_rom, enemy3_y_position_rom);
	defparam enemy3_rom_counter.ROM_WIDTH = 55;
	defparam enemy3_rom_counter.ROM_HEIGHT = 35;
	
	ROM_Counter enemy4_rom_counter(clock, reset, w_draw_erase_enemy4, w_sprite_load_erase_enemy4, w_rom_load_erase_enemy4, enemy4_x_position_rom, enemy4_y_position_rom);
	defparam enemy4_rom_counter.ROM_WIDTH = 55;
	defparam enemy4_rom_counter.ROM_HEIGHT = 35;
	
	ROM_Counter enemy5_rom_counter(clock, reset, w_draw_erase_enemy5, w_sprite_load_erase_enemy5, w_rom_load_erase_enemy5, enemy5_x_position_rom, enemy5_y_position_rom);
	defparam enemy5_rom_counter.ROM_WIDTH = 31;
	defparam enemy5_rom_counter.ROM_HEIGHT = 35;
	
	ROM_Counter start_screen_counter(clock, reset, s_start_screen, 0, start_screen_drawn, start_screen_x_position, start_screen_y_position);
	defparam start_screen_counter.ROM_WIDTH = 320;
	defparam start_screen_counter.ROM_HEIGHT = 240;
	
	ROM_Counter win_screen_counter(clock, reset, s_win_screen, 0, win_screen_drawn, win_screen_x_position, win_screen_y_position);
	defparam win_screen_counter.ROM_WIDTH = 320;
	defparam win_screen_counter.ROM_HEIGHT = 240;
	
	Transition_Screen transition_screen_counter(transition_clock, reset, s_transition_screen, transition_screen_drawn, transition_screen_x_position, transition_screen_y_position);
	
/*********************************************************************/
/*						SPRITE_ADDRESS_TRANSLATOR MODULES						*/
/*********************************************************************/

	sprite_address_translator player_translator(.x(player_x_position_rom), .y(player_y_position_rom), .address(player_address));
	defparam player_translator.TYPE = "PLAYER";
	
	sprite_address_translator enemy1_translator(.x(enemy1_x_position_rom), .y(enemy1_y_position_rom), .address(enemy1_address));
	defparam enemy1_translator.TYPE = "RED_ENEMY";
	
	sprite_address_translator enemy2_translator(.x(enemy2_x_position_rom), .y(enemy2_y_position_rom), .address(enemy2_address));
	defparam enemy2_translator.TYPE = "RED_ENEMY";
	
	sprite_address_translator enemy3_translator(.x(enemy3_x_position_rom), .y(enemy3_y_position_rom), .address(enemy3_address));
	defparam enemy3_translator.TYPE = "RED_ENEMY";
	
	sprite_address_translator enemy4_translator(.x(enemy4_x_position_rom), .y(enemy4_y_position_rom), .address(enemy4_address));
	defparam enemy4_translator.TYPE = "RED_ENEMY";
	
	sprite_address_translator enemy5_translator(.x(enemy5_x_position_rom), .y(enemy5_y_position_rom), .address(enemy5_address));
	defparam enemy5_translator.TYPE = "PURPLE_ENEMY";
	
/*********************************************************************/
/*						VGA_ADDRESS_TRANSLATOR MODULES							*/
/*********************************************************************/
	
	vga_address_translator start_screen_background(.x(start_screen_x_position), .y(start_screen_y_position), .mem_address(start_screen_address));
	defparam start_screen_background.RESOLUTION = "320x240";
	
	vga_address_translator win_screen_background(.x(win_screen_x_position), .y(win_screen_y_position), .mem_address(win_screen_address));
	defparam win_screen_background.RESOLUTION = "320x240";
	
	vga_address_translator player_background(.x(player_x_sprite), .y(player_y_sprite), .mem_address(player_background_address));
	defparam player_background.RESOLUTION = "320x240";
	
	vga_address_translator enemy1_background(.x(enemy1_x_sprite), .y(enemy1_y_sprite), .mem_address(enemy1_background_address));
	defparam enemy1_background.RESOLUTION = "320x240";
	
	vga_address_translator enemy2_background(.x(enemy2_x_sprite), .y(enemy2_y_sprite), .mem_address(enemy2_background_address));
	defparam enemy2_background.RESOLUTION = "320x240";
	
	vga_address_translator enemy3_background(.x(enemy3_x_sprite), .y(enemy3_y_sprite), .mem_address(enemy3_background_address));
	defparam enemy3_background.RESOLUTION = "320x240";
	
	vga_address_translator enemy4_background(.x(enemy4_x_sprite), .y(enemy4_y_sprite), .mem_address(enemy4_background_address));
	defparam enemy4_background.RESOLUTION = "320x240";
	
	vga_address_translator enemy5_background(.x(enemy5_x_sprite), .y(enemy5_y_sprite), .mem_address(enemy5_background_address));
	defparam enemy5_background.RESOLUTION = "320x240";
	
	always @(*)
		begin
			if (s_start_screen) begin
				background_redraw <= start_screen_address;
			end 
			else if (s_erase_player) begin
				background_redraw <= player_background_address;
			end
			else if (s_erase_enemy1) begin
				background_redraw <= enemy1_background_address;
			end
			else if (s_erase_enemy2) begin
				background_redraw <= enemy2_background_address;
			end
			else if (s_erase_enemy3) begin
				background_redraw <= enemy3_background_address;
			end
			else if (s_erase_enemy4) begin
				background_redraw <= enemy4_background_address;
			end
			else if (s_erase_enemy5) begin
				background_redraw <= enemy5_background_address;
			end
		end
	
/*********************************************************************/
/*										ROM MODULES										*/
/*********************************************************************/

	Win_Screen win_screen_rom(.address(win_screen_address), .clock(clock), .q(win_screen_color));
	
	Background_Level_3 start_screen_rom(.address(background_redraw), .clock(clock), .q(background_color));
	
//	Background_Level_3 player_background_rom(.address(player_background_address), .clock(clock), .q(player_background_color));
	
//	Background_Level_3 enemy1_background_rom(.address(enemy1_background_address), .clock(clock), .q(enemy1_background_color));
	
//	Background_Level_3 enemy2_background_rom(.address(enemy2_background_address), .clock(clock), .q(enemy2_background_color));
	
//	Background_Level_3 enemy3_background_rom(.address(enemy3_background_address), .clock(clock), .q(enemy3_background_color));
	
//	Background_Level_3 enemy4_background_rom(.address(enemy4_background_address), .clock(clock), .q(enemy4_background_color));
	
//	Background_Level_3 enemy5_background_rom(.address(enemy5_background_address), .clock(clock), .q(enemy5_background_color));
	
	Player player_rom(.address(player_address), .clock(clock), .q(player_color));
	
	Enemy_Left enemy1_left_rom(.address(enemy1_address), .clock(clock), .q(enemy1_left_color));
	
	Enemy_Right enemy1_right_rom(.address(enemy1_address), .clock(clock), .q(enemy1_right_color));
	
	Enemy_Left enemy2_left_rom(.address(enemy2_address), .clock(clock), .q(enemy2_left_color));
	
	Enemy_Right enemy2_right_rom(.address(enemy2_address), .clock(clock), .q(enemy2_right_color));
	
	Enemy_Left enemy3_left_rom(.address(enemy3_address), .clock(clock), .q(enemy3_left_color));
	
	Enemy_Right enemy3_right_rom(.address(enemy3_address), .clock(clock), .q(enemy3_right_color));
	
	Enemy_Left enemy4_left_rom(.address(enemy4_address), .clock(clock), .q(enemy4_left_color));
	
	Enemy_Right enemy4_right_rom(.address(enemy4_address), .clock(clock), .q(enemy4_right_color));
	
	Enemy_Up enemy5_up_rom(.address(enemy5_address), .clock(clock), .q(enemy5_up_color));
	
	Enemy_Down enemy5_down_rom(.address(enemy5_address), .clock(clock), .q(enemy5_down_color));
	
	
/*********************************************************************/
/*										DATAPATH											*/
/*********************************************************************/

	always @(*)
		begin
			if (!reset) begin
				vga_x_input <= 0;
				vga_y_input <= 0;
				vga_c_input <= 0;
			end
			else if (s_erase_player) begin
				vga_x_input <= player_x_sprite;
				vga_y_input <= player_y_sprite;
				vga_c_input <= background_color;
			end
			else if (s_draw_player) begin
				vga_x_input <= player_x_sprite;
				vga_y_input <= player_y_sprite;
				vga_c_input <= player_color;
			end
			else if (s_erase_enemy1) begin
				vga_x_input <= enemy1_x_sprite;
				vga_y_input <= enemy1_y_sprite;
				vga_c_input <= background_color;
			end
			else if (s_draw_enemy1) begin
				vga_x_input <= enemy1_x_sprite;
				vga_y_input <= enemy1_y_sprite;
				vga_c_input <= (enemy1_x_direction == 0) ? (enemy1_left_color) : (enemy1_right_color);
			end
			else if (s_erase_enemy2) begin
				vga_x_input <= enemy2_x_sprite;
				vga_y_input <= enemy2_y_sprite;
				vga_c_input <= background_color;
			end
			else if (s_draw_enemy2) begin
				vga_x_input <= enemy2_x_sprite;
				vga_y_input <= enemy2_y_sprite;
				vga_c_input <= (enemy2_x_direction == 0) ? (enemy2_left_color) : (enemy2_right_color);
			end
			else if (s_erase_enemy3) begin
				vga_x_input <= enemy3_x_sprite;
				vga_y_input <= enemy3_y_sprite;
				vga_c_input <= background_color;
			end
			else if (s_draw_enemy3) begin
				vga_x_input <= enemy3_x_sprite;
				vga_y_input <= enemy3_y_sprite;
				vga_c_input <= (enemy3_x_direction == 0) ? (enemy3_left_color) : (enemy3_right_color);
			end
			else if (s_erase_enemy4) begin
				vga_x_input <= enemy4_x_sprite;
				vga_y_input <= enemy4_y_sprite;
				vga_c_input <= background_color;
			end
			else if (s_draw_enemy4) begin
				vga_x_input <= enemy4_x_sprite;
				vga_y_input <= enemy4_y_sprite;
				vga_c_input <= (enemy4_x_direction == 0) ? (enemy4_left_color) : (enemy4_right_color);
			end
			else if (s_erase_enemy5) begin
				vga_x_input <= enemy5_x_sprite;
				vga_y_input <= enemy5_y_sprite;
				vga_c_input <= background_color;
			end
			else if (s_draw_enemy5) begin
				vga_x_input <= enemy5_x_sprite;
				vga_y_input <= enemy5_y_sprite;
				vga_c_input <= (enemy5_y_direction == 0) ? (enemy5_up_color) : (enemy5_down_color);
			end
			else if (s_start_screen) begin
				vga_x_input <= start_screen_x_position;
				vga_y_input <= start_screen_y_position;
				vga_c_input <= background_color;
			end
			else if (s_win_screen) begin
				vga_x_input <= win_screen_x_position;
				vga_y_input <= win_screen_y_position;
				vga_c_input <= win_screen_color;
			end
			else if (s_transition_screen) begin
				vga_x_input <= transition_screen_x_position;
				vga_y_input <= transition_screen_y_position;
				vga_c_input <= 3;
			end
		end

		assign player_erased = s_erase_player & w_load_erase_player;
		assign player_loaded = s_draw_player & w_load_erase_player;
		assign enemy1_erased = s_erase_enemy1 & w_load_erase_enemy1;
		assign enemy1_loaded = s_draw_enemy1 & w_load_erase_enemy1;
		assign enemy2_erased = s_erase_enemy2 & w_load_erase_enemy2;
		assign enemy2_loaded = s_draw_enemy2 & w_load_erase_enemy2;
		assign enemy3_erased = s_erase_enemy3 & w_load_erase_enemy3;
		assign enemy3_loaded = s_draw_enemy3 & w_load_erase_enemy3;
		assign enemy4_erased = s_erase_enemy4 & w_load_erase_enemy4;
		assign enemy4_loaded = s_draw_enemy4 & w_load_erase_enemy4;
		assign enemy5_erased = s_erase_enemy5 & w_load_erase_enemy5;
		assign enemy5_loaded = s_draw_enemy5 & w_load_erase_enemy5;
		
		assign lose = lose_1 | lose_2 | lose_3 | lose_4 | lose_5;
		
endmodule
