module ControlPath_L3(
								input 
										clock, 
										reset,
										
										won, 
										lost,
										start_level_3,
										start_screen_drawn,
										win_screen_drawn,
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
										
										enemy3_enable,
										enemy3_erased,
										enemy3_loaded,
										
										enemy4_enable,
										enemy4_erased,
										enemy4_loaded,
										
										enemy5_enable,
										enemy5_erased,
										enemy5_loaded,
										
								output reg
										s_plot,
										s_erase_player,
										s_draw_player,
										s_erase_enemy1,
										s_draw_enemy1,
										s_erase_enemy2,
										s_draw_enemy2,
										s_erase_enemy3,
										s_draw_enemy3,
										s_erase_enemy4,
										s_draw_enemy4,
										s_erase_enemy5,
										s_draw_enemy5,
										
										s_move_player,
										s_move_enemy1,
										s_move_enemy2,
										
										s_start_screen,
										s_transition_screen,
										s_win_screen,
										s_stop_pps_counter
																
							); 


/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/
					
	reg[4:0] current_state = WAIT,
				next_state = WAIT;	
				
/*********************************************************************/
/*								LOCAL PARAMETERS										*/
/*********************************************************************/
	
	localparam  WAIT = 5'd0,
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
					FINISHED = 5'd19,
					START_SCREEN = 5'd20,
					WAIT_ENEMY_3 = 5'd21,
					ERASE_ENEMY_3 = 5'd22,
					DRAW_ENEMY_3 = 5'd23,
					WAIT_ENEMY_4 = 5'd24,
					ERASE_ENEMY_4 = 5'd25,
					DRAW_ENEMY_4 = 5'd26,
					WAIT_ENEMY_5 = 5'd27,
					ERASE_ENEMY_5 = 5'd28,
					DRAW_ENEMY_5 = 5'd29,
					TRANSITION_SCREEN = 5'd30;
					
					
					
/*********************************************************************/
/*									STATE TABLE											*/
/*********************************************************************/
	
	always @(*) 
		begin
			case(current_state)
				WAIT: 						next_state = (start_level_3) ? TRANSITION_SCREEN : WAIT;						
				TRANSITION_SCREEN:  		next_state = (transition_screen_drawn) ? START_SCREEN : TRANSITION_SCREEN;
				START_SCREEN:				next_state = (start_screen_drawn) ? PLAYER_MOVEMENT : START_SCREEN;
				CHECK_GAME_STATE: 		next_state = (won) ? VICTORY : (lost) ? DEFEAT : PLAYER_MOVEMENT;
				VICTORY:						next_state = (win_screen_drawn) ? FINISHED : VICTORY;
				FINISHED:					next_state = FINISHED;
				DEFEAT:						next_state = DEFEAT;
				
				PLAYER_MOVEMENT:			next_state = WAIT_PLAYER;
				WAIT_PLAYER:				next_state = (player_enable) ? ERASE_PLAYER : WAIT_ENEMY_1;
				ERASE_PLAYER:				next_state = (player_erased) ? DRAW_PLAYER : ERASE_PLAYER;
				DRAW_PLAYER:				next_state = (player_loaded) ? WAIT_ENEMY_1 : DRAW_PLAYER;
				
				WAIT_ENEMY_1:				next_state = (enemy1_enable) ? ERASE_ENEMY_1 : WAIT_ENEMY_2;
				ERASE_ENEMY_1:				next_state = (enemy1_erased) ? DRAW_ENEMY_1 : ERASE_ENEMY_1;
				DRAW_ENEMY_1:				next_state = (enemy1_loaded) ? WAIT_ENEMY_2 : DRAW_ENEMY_1;
				
				WAIT_ENEMY_2:				next_state = (enemy2_enable) ? ERASE_ENEMY_2 : WAIT_ENEMY_3;
				ERASE_ENEMY_2:				next_state = (enemy2_erased) ? DRAW_ENEMY_2 : ERASE_ENEMY_2;
				DRAW_ENEMY_2:				next_state = (enemy2_loaded) ? WAIT_ENEMY_3 : DRAW_ENEMY_2;
				
				WAIT_ENEMY_3:				next_state = (enemy3_enable) ? ERASE_ENEMY_3 : WAIT_ENEMY_4;
				ERASE_ENEMY_3:				next_state = (enemy3_erased) ? DRAW_ENEMY_3 : ERASE_ENEMY_3;
				DRAW_ENEMY_3:				next_state = (enemy3_loaded) ? ERASE_ENEMY_4 : DRAW_ENEMY_3;
				
				WAIT_ENEMY_4:				next_state = (enemy4_enable) ? ERASE_ENEMY_4 : WAIT_ENEMY_5;
				ERASE_ENEMY_4:				next_state = (enemy4_erased) ? DRAW_ENEMY_4 : ERASE_ENEMY_4;
				DRAW_ENEMY_4:				next_state = (enemy4_loaded) ? ERASE_ENEMY_5 : DRAW_ENEMY_4;
				
				WAIT_ENEMY_5:				next_state = (enemy5_enable) ? ERASE_ENEMY_5 : CHECK_GAME_STATE;
				ERASE_ENEMY_5:				next_state = (enemy5_erased) ? DRAW_ENEMY_5 : ERASE_ENEMY_5;
				DRAW_ENEMY_5:				next_state = (enemy5_loaded) ? CHECK_GAME_STATE : DRAW_ENEMY_5;
				
				default: 					next_state = WAIT;
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
			s_erase_enemy3 = 0;
			s_draw_enemy3 = 0;
			s_erase_enemy4 = 0;
			s_draw_enemy4 = 0;
			s_erase_enemy5 = 0;
			s_draw_enemy5 = 0;
										
			s_move_player = 0;
			s_move_enemy1 = 0;
			s_move_enemy2 = 0;
										
			s_start_screen = 0;
			s_transition_screen = 0;
			s_win_screen = 0;
			s_stop_pps_counter = 0;
		
			case(current_state)
				TRANSITION_SCREEN:
					begin
						s_plot = 1;
						s_transition_screen = 1;
					end
				VICTORY:
					begin
						s_plot = 1;
						s_win_screen = 1;
						s_stop_pps_counter = 1;
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
						s_move_player = 1;
					end
				DRAW_PLAYER: 
					begin
						s_plot = 1;
						s_draw_player = 1;
					end
				ERASE_ENEMY_1: 
					begin
						s_plot = 1;
						s_erase_enemy1 = 1;
					end
				MOVE_ENEMY_1:
					begin
						s_move_enemy1 = 1;
					end
				DRAW_ENEMY_1: 
					begin
						s_plot = 1;
						s_draw_enemy1 = 1;
					end
				ERASE_ENEMY_2: 
					begin
						s_plot = 1;
						s_erase_enemy2 = 1;
					end
				MOVE_ENEMY_2:
					begin
						s_move_enemy2 = 1;
					end
				DRAW_ENEMY_2: 
					begin
						s_plot = 1;
						s_draw_enemy2 = 1;
					end
				ERASE_ENEMY_3: 
					begin
						s_plot = 1;
						s_erase_enemy3 = 1;
					end
				DRAW_ENEMY_3: 
					begin
						s_plot = 1;
						s_draw_enemy3 = 1;
					end
				ERASE_ENEMY_4: 
					begin
						s_plot = 1;
						s_erase_enemy4 = 1;
					end
				DRAW_ENEMY_4: 
					begin
						s_plot = 1;
						s_draw_enemy4 = 1;
					end
				ERASE_ENEMY_5: 
					begin
						s_plot = 1;
						s_erase_enemy5 = 1;
					end
				DRAW_ENEMY_5: 
					begin
						s_plot = 1;
						s_draw_enemy5 = 1;
					end
			endcase
		end
		
/*********************************************************************/
/*								FINITE STATE MACHINE									*/
/*********************************************************************/

	always @(posedge clock)
		begin
			if (!reset) begin
				current_state <= WAIT;
			end
			else begin
				current_state <= next_state;	
			end
		end	
endmodule
