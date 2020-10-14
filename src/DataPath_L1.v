module DataPath_L1(
							input
									clock,					// from system
									reset,					//
									transition_clock,
												
									player_enable,
									enemy1_enable,
									enemy2_enable,
									
									s_erase_player,		// from ControlPath module
									s_draw_player,			//
									s_erase_enemy1,		// 
									s_draw_enemy1,			//
									s_erase_enemy2,		//
									s_draw_enemy2,			//
									s_move_player,
									s_move_enemy1,
									s_move_enemy2,
									
									s_start_level2,
									s_game_over,
									s_start_screen,
									s_transition_screen,
									
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
									
									game_over_drawn,
									start_screen_drawn,
									transition_screen_drawn,
									
							output reg[8:0]						
									vga_x_input,			// to vga module 
									vga_y_input,			//	
																// 
							output reg[2:0]				// 
									vga_c_input,				//
									
							output move_player
									
						);

/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/
	
	wire[16:0] player_address, player_background_address, enemy1_address, enemy1_background_address, enemy2_address, enemy2_background_address, game_over_address, start_screen_address;
	
	wire[8:0] player_x_position, player_y_position, player_x_sprite, player_y_sprite, player_x_position_rom, player_y_position_rom;
	
	wire[8:0] enemy1_x_position, enemy1_y_position, enemy1_x_sprite, enemy1_y_sprite, enemy1_x_position_rom, enemy1_y_position_rom;
	
	wire[8:0] enemy2_x_position, enemy2_y_position, enemy2_x_sprite, enemy2_y_sprite, enemy2_x_position_rom, enemy2_y_position_rom;
	
	wire[8:0] game_over_x_position, game_over_y_position;
	
	wire[8:0] start_screen_x_position, start_screen_y_position;
	
	wire[8:0] transition_screen_x_position, transition_screen_y_position;
	
	wire[2:0] player_color, player_background_color, enemy1_left_color, enemy1_right_color, enemy1_background_color, enemy2_left_color, enemy2_right_color, enemy2_background_color, game_over_color, start_screen_color;
	
	wire w_draw_erase_player = s_draw_player | s_erase_player;
	
	wire w_draw_erase_enemy1 = s_draw_enemy1 | s_erase_enemy1;
	
	wire w_draw_erase_enemy2 = s_draw_enemy2 | s_erase_enemy2;
	
	wire w_load_erase_player = w_sprite_load_erase_player & w_rom_load_erase_player;
	
	wire w_load_erase_enemy1 = w_sprite_load_erase_enemy1 & w_rom_load_erase_enemy1;
	
	wire w_load_erase_enemy2 = w_sprite_load_erase_enemy2 & w_rom_load_erase_enemy2;
	
	wire w_sprite_load_erase_player, w_sprite_load_erase_enemy1, w_sprite_load_erase_enemy2;
	
	wire w_rom_load_erase_player, w_rom_load_erase_enemy1, w_rom_load_erase_enemy2;
	
	wire lose_1, lose_2;
	
	wire enemy1_x_direction, enemy1_y_direction, enemy2_x_direction, enemy2_y_direction;
	
/*********************************************************************/
/*						PLAYER_SPRITE_POSITION MODULE								*/
/*********************************************************************/

	Player_Sprite_Position_L1 player(player_enable, reset, keyboard_data, player_x_position, player_y_position, win);
	defparam player.X_START = 9'd30;
	defparam player.Y_START = 9'd223 - 9'd35;
	
	assign move_player = s_move_player;
	assign something =  enemy1_y_position;
	
/*********************************************************************/
/*						ENEMY_SPRITE_POSITION MODULES								*/
/*********************************************************************/

	Enemy_Sprite_Position enemy1(enemy1_enable, reset, player_x_position, player_y_position, enemy1_x_position, enemy1_y_position, enemy1_x_direction, enemy1_y_direction, lose_1);
	defparam enemy1.X_ENABLE = 1'd1;
	defparam enemy1.Y_ENABLE = 1'd0;
	defparam enemy1.X_START = 9'd239 - 9'd55;
	defparam enemy1.Y_START = 9'd167 - 9'd35;
	defparam enemy1.X_END = 9'd83;
	defparam enemy1.Y_END = 9'd167 - 9'd35;
	defparam enemy1.X_DIRECTION  = 1'd1;
	defparam enemy1.Y_DIRECTION  = 1'd0;
	defparam enemy1.WIDTH = 55;
	defparam enemy1.HEIGHT = 35;
	
	Enemy_Sprite_Position enemy2(enemy2_enable, reset, player_x_position, player_y_position, enemy2_x_position, enemy2_y_position, enemy2_x_direction, enemy2_y_direction, lose_2);
	defparam enemy2.X_ENABLE = 1'd1;
	defparam enemy2.Y_ENABLE = 1'd0;
	defparam enemy2.X_START = 9'd60;
	defparam enemy2.Y_START = 9'd223-9'd35;
	defparam enemy2.X_END = 9'd180;
	defparam enemy2.Y_END = 9'd300;
	defparam enemy2.X_DIRECTION  = 1'd0;
	defparam enemy2.Y_DIRECTION  = 1'd0;
	defparam enemy2.WIDTH = 55;
	defparam enemy2.HEIGHT = 35;
	
/*********************************************************************/
/*							SPRITE_COUNTER MODULES									*/
/*********************************************************************/

	Sprite_Counter player_sprite(clock, reset, w_draw_erase_player, w_rom_load_erase_player, player_x_position, player_y_position, w_sprite_load_erase_player, player_x_sprite, player_y_sprite);
	defparam player_sprite.X_START = 9'd30;
	defparam player_sprite.Y_START = 9'd200;
	defparam player_sprite.WIDTH = 20;
	defparam player_sprite.HEIGHT = 35;
	
	Sprite_Counter enemy1_sprite(clock, reset, w_draw_erase_enemy1, w_rom_load_erase_enemy1, enemy1_x_position, enemy1_y_position, w_sprite_load_erase_enemy1, enemy1_x_sprite, enemy1_y_sprite);
	defparam enemy1_sprite.X_START = 9'd200;
	defparam enemy1_sprite.Y_START = 9'd100;
	defparam enemy1_sprite.WIDTH = 55;
	defparam enemy1_sprite.HEIGHT = 35;
	
	Sprite_Counter enemy2_sprite(clock, reset, w_draw_erase_enemy2, w_rom_load_erase_enemy2, enemy2_x_position, enemy2_y_position, w_sprite_load_erase_enemy2, enemy2_x_sprite, enemy2_y_sprite);
	defparam enemy2_sprite.X_START = 9'd200;
	defparam enemy2_sprite.Y_START = 9'd180;
	defparam enemy2_sprite.WIDTH = 55;
	defparam enemy2_sprite.HEIGHT = 35;
	
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
	
	ROM_Counter game_over_counter(clock, reset, s_game_over, 0, game_over_drawn, game_over_x_position, game_over_y_position);
	defparam game_over_counter.ROM_WIDTH = 320;
	defparam game_over_counter.ROM_HEIGHT = 240;
	
	ROM_Counter start_screen_counter(clock, reset, s_start_screen, 0, start_screen_drawn, start_screen_x_position, start_screen_y_position);
	defparam start_screen_counter.ROM_WIDTH = 320;
	defparam start_screen_counter.ROM_HEIGHT = 240;
	
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
	
/*********************************************************************/
/*						VGA_ADDRESS_TRANSLATOR MODULES							*/
/*********************************************************************/
	
	vga_address_translator start_screen_background(.x(start_screen_x_position), .y(start_screen_y_position), .mem_address(start_screen_address));
	defparam enemy2_background.RESOLUTION = "320x240";
	
	vga_address_translator player_background(.x(player_x_sprite), .y(player_y_sprite), .mem_address(player_background_address));
	defparam player_background.RESOLUTION = "320x240";
	
	vga_address_translator enemy1_background(.x(enemy1_x_sprite), .y(enemy1_y_sprite), .mem_address(enemy1_background_address));
	defparam enemy1_background.RESOLUTION = "320x240";
	
	vga_address_translator enemy2_background(.x(enemy2_x_sprite), .y(enemy2_y_sprite), .mem_address(enemy2_background_address));
	defparam enemy2_background.RESOLUTION = "320x240";
	
	vga_address_translator game_over_background(.x(game_over_x_position), .y(game_over_y_position), .mem_address(game_over_address));
	defparam enemy2_background.RESOLUTION = "320x240";
	
/*********************************************************************/
/*										ROM MODULES										*/
/*********************************************************************/
	
	Background_Level_1 start_screen_rom(.address(start_screen_address), .clock(clock), .q(start_screen_color));
	
	Background_Level_1 player_background_rom(.address(player_background_address), .clock(clock), .q(player_background_color));
	
	Background_Level_1 enemy1_background_rom(.address(enemy1_background_address), .clock(clock), .q(enemy1_background_color));
	
	Background_Level_1 enemy2_background_rom(.address(enemy2_background_address), .clock(clock), .q(enemy2_background_color));
	
	Player player_rom(.address(player_address), .clock(clock), .q(player_color));
	
	Enemy_Left enemy1_left_rom(.address(enemy1_address), .clock(clock), .q(enemy1_left_color));
	
	Enemy_Left enemy2_left_rom(.address(enemy2_address), .clock(clock), .q(enemy2_left_color));
	
	Enemy_Right enemy1_right_rom(.address(enemy1_address), .clock(clock), .q(enemy1_right_color));
	
	Enemy_Right enemy2_right_rom(.address(enemy2_address), .clock(clock), .q(enemy2_right_color));
	
	Game_Over game_over_rom(.address(game_over_address), .clock(clock), .q(game_over_color));
	
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
				vga_c_input <= player_background_color;
			end
			else if (s_draw_player) begin
				vga_x_input <= player_x_sprite;
				vga_y_input <= player_y_sprite;
				vga_c_input <= player_color;
			end
			else if (s_erase_enemy1) begin
				vga_x_input <= enemy1_x_sprite;
				vga_y_input <= enemy1_y_sprite;
				vga_c_input <= enemy1_background_color;
			end
			else if (s_draw_enemy1) begin
				vga_x_input <= enemy1_x_sprite;
				vga_y_input <= enemy1_y_sprite;
				vga_c_input <= (enemy1_x_direction == 0) ? (enemy1_left_color) : (enemy1_right_color);
			end
			else if (s_erase_enemy2) begin
				vga_x_input <= enemy2_x_sprite;
				vga_y_input <= enemy2_y_sprite;
				vga_c_input <= enemy2_background_color;
			end
			else if (s_draw_enemy2) begin
				vga_x_input <= enemy2_x_sprite;
				vga_y_input <= enemy2_y_sprite;
				vga_c_input <= (enemy2_x_direction == 0) ? (enemy2_left_color) : (enemy2_right_color);
			end
			else if (s_game_over) begin
				vga_x_input <= game_over_x_position;
				vga_y_input <= game_over_y_position;
				vga_c_input <= game_over_color;
			end
			else if (s_start_screen) begin
				vga_x_input <= start_screen_x_position;
				vga_y_input <= start_screen_y_position;
				vga_c_input <= start_screen_color;
			end
			else if (s_transition_screen) begin
				vga_x_input <= transition_screen_x_position;
				vga_y_input <= transition_screen_y_position;
				vga_c_input <= 1;
			end
		end

		assign player_erased = s_erase_player & w_load_erase_player;
		assign player_loaded = s_draw_player & w_load_erase_player;
		assign enemy1_erased = s_erase_enemy1 & w_load_erase_enemy1;
		assign enemy1_loaded = s_draw_enemy1 & w_load_erase_enemy1;
		assign enemy2_erased = s_erase_enemy2 & w_load_erase_enemy2;
		assign enemy2_loaded = s_draw_enemy2 & w_load_erase_enemy2;
		
		assign lose = lose_1 | lose_2;
		
endmodule
