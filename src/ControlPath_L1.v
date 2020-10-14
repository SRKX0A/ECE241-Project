module ControlPath_L1(
								input 
										clock, 
										reset,
										
										won, 
										lost,
										start_screen_drawn,
										game_over_drawn,
										transition_screen_drawn,
										
										player_movement, 
										player_enable, 
										player_erased, 
										player_loaded, 
										
										enemy1_enable,
										enemy1_erased,
										enemy1_loaded,
										
										enemy2_enable,
										enemy2_erased,
										enemy2_loaded,
										
								output reg
										s_plot,
										s_erase_player,
										s_draw_player,
										s_erase_enemy1,
										s_draw_enemy1,
										s_erase_enemy2,
										s_draw_enemy2,
										s_move_player,
										s_move_enemy1,
										s_move_enemy2,
										
										s_stop_pps_counter,
										
										s_start_level2,
										s_game_over,
										s_start_screen,
										s_transition_screen,
										
								output[4:0]
										state
			
							); 


/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/
				
	reg[4:0] current_state = RESET,
				next_state = RESET;	
				
	assign state = current_state;
				
/*********************************************************************/
/*								LOCAL PARAMETERS										*/
/*********************************************************************/
	
	localparam  RESET = 5'd0,
					CHECK_GAME_STATE = 5'd1,
					PLAYER_MOVEMENT = 5'd2,
					WAIT_PLAYER = 5'd3,
					ERASE_PLAYER = 5'd4,
					DRAW_PLAYER = 5'd5,
					WAIT_ENEMY_1 = 5'd6,
					ERASE_ENEMY_1 = 5'd7,
					DRAW_ENEMY_1 = 5'd8,
					WAIT_ENEMY_2 = 5'd9,
					ERASE_ENEMY_2 = 5'd10,
					DRAW_ENEMY_2 = 5'd11,
					VICTORY = 5'd12,
					DEFEAT = 5'd13,
					MOVE_PLAYER = 5'd14,
					MOVE_ENEMY_1 = 5'd15,
					MOVE_ENEMY_2 = 5'd16,
					GAME_OVER_SCREEN = 5'd17,
					START_L2 = 5'd18,
					FINISHED = 5'd19,
					START_SCREEN = 5'd20,
					TRANSITION_SCREEN = 5'd21,
					MOVE_WAIT = 5'd22;
					
					
/*********************************************************************/
/*									STATE TABLE											*/
/*********************************************************************/
	
	always @(*) 
		begin
			case(current_state)
				RESET: 						next_state = TRANSITION_SCREEN;
				TRANSITION_SCREEN:		next_state = (transition_screen_drawn) ? START_SCREEN : TRANSITION_SCREEN;
				START_SCREEN:				next_state = (start_screen_drawn) ? PLAYER_MOVEMENT : START_SCREEN;
				CHECK_GAME_STATE: 		next_state = (won) ? VICTORY : (lost) ? DEFEAT : PLAYER_MOVEMENT;
				VICTORY:						next_state = START_L2;
				START_L2:					next_state = (lost) ? DEFEAT : START_L2;
				DEFEAT:						next_state = GAME_OVER_SCREEN;
				GAME_OVER_SCREEN:			next_state = (game_over_drawn) ? FINISHED : GAME_OVER_SCREEN;
				FINISHED:					next_state = FINISHED;
				
				PLAYER_MOVEMENT:			next_state = WAIT_PLAYER;
				WAIT_PLAYER:				next_state = (player_enable) ? ERASE_PLAYER : WAIT_PLAYER;
				ERASE_PLAYER:				next_state = (player_erased) ? DRAW_PLAYER : ERASE_PLAYER;
//				MOVE_PLAYER:				next_state = DRAW_PLAYER;
				DRAW_PLAYER:				next_state = (player_loaded) ? WAIT_ENEMY_1 : DRAW_PLAYER;
				
				WAIT_ENEMY_1:				next_state = (enemy1_enable) ? ERASE_ENEMY_1 : WAIT_ENEMY_1;
				ERASE_ENEMY_1:				next_state = (enemy1_erased) ? DRAW_ENEMY_1 : ERASE_ENEMY_1;
//				MOVE_ENEMY_1:				next_state = DRAW_ENEMY_1;
				DRAW_ENEMY_1:				next_state = (enemy1_loaded) ? WAIT_ENEMY_2 : DRAW_ENEMY_1;
				
				WAIT_ENEMY_2:				next_state = (enemy2_enable) ? ERASE_ENEMY_2 : WAIT_ENEMY_2;
				ERASE_ENEMY_2:				next_state = (enemy2_erased) ? DRAW_ENEMY_2 : ERASE_ENEMY_2;
//				MOVE_ENEMY_2:				next_state = DRAW_ENEMY_2;
				DRAW_ENEMY_2:				next_state = (enemy2_loaded) ? CHECK_GAME_STATE : DRAW_ENEMY_2;
				
				default:						next_state = RESET;
			endcase
		end
	
/*********************************************************************/
/*									STATE TRANSITIONS									*/
/*********************************************************************/	

	always @(*) 
		begin	
			
			s_plot = 0;
			s_erase_player = 0;
			s_draw_player = 0;
			s_erase_enemy1 = 0;
			s_draw_enemy1 = 0;
			s_erase_enemy2 = 0;
			s_draw_enemy2 = 0;
			s_move_player = 0;
			s_move_enemy1 = 0;
			s_move_enemy2 = 0;
			s_start_level2 = 0;
			s_game_over = 0;
			s_start_screen = 0;
			s_stop_pps_counter = 0;
			s_transition_screen = 0;
		
			case(current_state)
				TRANSITION_SCREEN:
					begin
						s_transition_screen = 1;
						s_plot = 1;
					end
				START_L2:
					begin
						s_start_level2 = 1;
						s_stop_pps_counter = 1;
					end
				GAME_OVER_SCREEN:
					begin
						s_plot = 1;
						s_game_over = 1;
					end
				START_SCREEN:
					begin
						s_plot = 1;
						s_start_screen = 1;
					end
				ERASE_PLAYER: 
					begin
						s_plot = 1;
						s_erase_player = 1;
					end
				MOVE_PLAYER:
					begin
						s_move_player = 0;
					end
				DRAW_PLAYER: 
					begin
						s_plot = 1;
						s_draw_player = 1;
						s_move_player = 1;
					end
				ERASE_ENEMY_1: 
					begin
						s_plot = 1;
						s_erase_enemy1 = 1;
					end
				MOVE_ENEMY_1:
					begin
						s_move_enemy1 = 0;
					end
				DRAW_ENEMY_1: 
					begin
						s_plot = 1;
						s_draw_enemy1 = 1;
						s_move_enemy1 = 1;
					end
				ERASE_ENEMY_2: 
					begin
						s_plot = 1;
						s_erase_enemy2 = 1;
					end
				MOVE_ENEMY_2:
					begin
						s_move_enemy2 = 0;
					end
				DRAW_ENEMY_2: 
					begin
						s_plot = 1;
						s_draw_enemy2 = 1;
						s_move_enemy2 = 1;
					end
				default:
					begin
						s_plot = 0;
						s_erase_player = 0;
						s_draw_player = 0;
						s_erase_enemy1 = 0;
						s_draw_enemy1 = 0;
						s_erase_enemy2 = 0;
						s_draw_enemy2 = 0;	
						s_move_player = 0;
						s_move_enemy1 = 0;
						s_move_enemy2 = 0;
					end
			endcase
		end
		
/*********************************************************************/
/*								FINITE STATE MACHINE									*/
/*********************************************************************/

	always @(posedge clock)
		begin
			if (!reset) begin
				current_state <= RESET;
			end
			else begin
				current_state <= next_state;	
			end
		end	
endmodule
