module main(input[9:0] SW, input[3:0] KEY, input CLOCK_50, inout PS2_CLK, PS2_DAT, output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, output[7:0] VGA_R, VGA_G, VGA_B, output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, output[9:0]LEDR);
	
/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/	

	wire reset = KEY[0];
	wire movement = 1;
	
/*********************************************************************/
/*								FRAME_COUNTER MODULE									*/
/*********************************************************************/		
	
	wire frame, transition_clock;
	
	Frame_Counter f0(CLOCK_50, reset, frame);
	defparam f0.RATE = 23'd833332;
	
	Frame_Counter f1(CLOCK_50, reset, transition_clock);
	defparam f1.RATE = 4000;
	
/*********************************************************************/
/*								PPS_COUNTER MODULES									*/
/*********************************************************************/
	
	wire player_enable, enemy1_enable_l1, enemy2_enable_l1; 
	
	PPS_Counter pps_player(frame, reset, w_stop_pps_counter_l3, player_enable);
	defparam pps_player.FRAMES_PER_PIXEL = 1;
	
	PPS_Counter pps_enemy1_l1(frame, reset, w_stop_pps_counter_l1, enemy1_enable_l1);
	defparam pps_enemy1_l1.FRAMES_PER_PIXEL = 1;

	PPS_Counter pps_enemy2_l1(frame, reset, w_stop_pps_counter_l1, enemy2_enable_l1);
	defparam pps_enemy2_l1.FRAMES_PER_PIXEL = 1;
	
/*********************************************************************/
/*								PS2_MOVEMENT MODULE									*/
/*********************************************************************/

	wire key_press;

	wire[7:0] keyboard_data;
	
	PS2_Movement k0(CLOCK_50, reset, PS2_CLK, PS2_DAT, keyboard_data, key_press); 
	
/*********************************************************************/
/*								CONTROLPATH_L1 MODULE								*/
/*********************************************************************/
	
	wire w_plot_l1;
	
	wire w_erase_player_l1, w_draw_player_l1;
	
	wire w_erase_enemy1_l1, w_draw_enemy1_l1;
	
	wire w_erase_enemy2_l1, w_draw_enemy2_l1;
	
	wire w_move_player_l1;
	
	wire w_move_enemy1_l1;
	
	wire w_move_enemy2_l1;
	
	wire w_start_level2;
	
	wire w_game_over;
	
	wire w_start_screen_level1;
	
	wire w_transition_screen_level1;
	
	wire w_stop_pps_counter_l1;
	
	ControlPath_L1 c1(
							.clock(CLOCK_50),
							.reset(reset),
							
							.won(win_l1),
							.lost(lose),
							.start_screen_drawn(w_start_screen_level1_drawn),
							.game_over_drawn(w_game_over_drawn),
							.transition_screen_drawn(w_transition_screen_level1_drawn),
							
							.player_movement(movement),
							.player_enable(player_enable),
							.player_erased(w_player_erased_l1),
							.player_loaded(w_player_loaded_l1),
							
							.enemy1_enable(enemy1_enable_l1),
							.enemy1_erased(w_enemy1_erased_l1),
							.enemy1_loaded(w_enemy1_loaded_l1),
							
							.enemy2_enable(enemy2_enable_l1),
							.enemy2_erased(w_enemy2_erased_l1),
							.enemy2_loaded(w_enemy2_loaded_l1),
							
							.s_plot(w_plot_l1),
							.s_erase_player(w_erase_player_l1),
							.s_draw_player(w_draw_player_l1),
							.s_erase_enemy1(w_erase_enemy1_l1),
							.s_draw_enemy1(w_draw_enemy1_l1),
							.s_erase_enemy2(w_erase_enemy2_l1),
							.s_draw_enemy2(w_draw_enemy2_l1),
							.s_move_player(w_move_player_l1),
							.s_move_enemy1(w_move_enemy1_l1),
							.s_move_enemy2(w_move_enemy2_l1),
							
							.s_start_level2(w_start_level2),
							.s_game_over(w_game_over),
							.s_start_screen(w_start_screen_level1),
							.s_transition_screen(w_transition_screen_level1),
							.s_stop_pps_counter(w_stop_pps_counter_l1),
							
							.state(state)
							
						);
								 				
/*********************************************************************/
/*								DATAPATH_L1 MODULE									*/
/*********************************************************************/
 	
	wire lose_l1;
	
	wire lose = lose_l1 | lose_l2 | lose_l3;
	
	wire win_l1;
	
	wire w_start_screen_level1_drawn;
	
	wire w_transition_screen_level1_drawn;
	
	wire w_game_over_drawn;
	
	wire w_player_erased_l1, w_player_loaded_l1;
	
	wire w_enemy1_erased_l1, w_enemy1_loaded_l1;
	
	wire w_enemy2_erased_l1, w_enemy2_loaded_l1;
	
	wire[8:0] vga_x_input_l1, vga_y_input_l1;
	
	wire[2:0] vga_c_input_l1;
	
	DataPath_L1 d1(
						.clock(CLOCK_50),
						.reset(reset),
						.transition_clock(transition_clock),
						
						.player_enable(player_enable),
						.enemy1_enable(enemy1_enable_l1),
						.enemy2_enable(enemy2_enable_l1),
						
						.s_erase_player(w_erase_player_l1),
						.s_draw_player(w_draw_player_l1),
						.s_erase_enemy1(w_erase_enemy1_l1),
						.s_draw_enemy1(w_draw_enemy1_l1),
						.s_erase_enemy2(w_erase_enemy2_l1),
						.s_draw_enemy2(w_draw_enemy2_l1),
						.s_move_player(w_move_player_l1),
						.s_move_enemy1(w_move_enemy1_l1),
						.s_move_enemy2(w_move_enemy2_l1),
						
						.s_start_level2(w_start_level2),
						.s_game_over(w_game_over),
						.s_start_screen(w_start_screen_level1),
						.s_transition_screen(w_transition_screen_level1),
						
						.keyboard_data(keyboard_data),
						
						.win(win_l1),
						.lose(lose_l1),
						.player_erased(w_player_erased_l1),
						.player_loaded(w_player_loaded_l1),
						.enemy1_erased(w_enemy1_erased_l1),
						.enemy1_loaded(w_enemy1_loaded_l1),
						.enemy2_erased(w_enemy2_erased_l1),
						.enemy2_loaded(w_enemy2_loaded_l1),
						
						.game_over_drawn(w_game_over_drawn),
						.start_screen_drawn(w_start_screen_level1_drawn),
						.transition_screen_drawn(w_transition_screen_level1_drawn),
						
						.vga_x_input(vga_x_input_l1),
						.vga_y_input(vga_y_input_l1),
						.vga_c_input(vga_c_input_l1),
						
						.move_player(x_move)
						
					);
	

/*********************************************************************/
/*								PPS_COUNTER MODULES									*/
/*********************************************************************/

	wire enemy1_enable_l2, enemy2_enable_l2, enemy3_enable_l2;
	
	PPS_Counter pps_enemy1_l2(frame, reset, w_stop_pps_counter_l2, enemy1_enable_l2);
	defparam pps_enemy1_l2.FRAMES_PER_PIXEL = 1;

	PPS_Counter pps_enemy2_l2(frame, reset, w_stop_pps_counter_l2, enemy2_enable_l2);
	defparam pps_enemy2_l2.FRAMES_PER_PIXEL = 1;
	
	PPS_Counter pps_enemy3_l2(frame, reset, w_stop_pps_counter_l2, enemy3_enable_l2);
	defparam pps_enemy3_l2.FRAMES_PER_PIXEL = 1;
	
/*********************************************************************/
/*								CONTROLPATH_L2 MODULE								*/
/*********************************************************************/
	
	wire w_plot_l2;
	
	wire w_erase_player_l2, w_draw_player_l2;
	
	wire w_erase_enemy1_l2, w_draw_enemy1_l2;
	
	wire w_erase_enemy2_l2, w_draw_enemy2_l2;
	
	wire w_erase_enemy3_l2, w_draw_enemy3_l2;
	
	wire w_move_player_l2;
	
	wire w_move_enemy1_l2;
	
	wire w_move_enemy2_l2;
	
	wire w_start_level3;
	
	wire w_start_screen_level2;
	
	wire w_transition_screen_level2;
	
	wire w_stop_pps_counter_l2;
	
	ControlPath_L2 c2(
							.clock(CLOCK_50),
							.reset(reset),
							
							.won(win_l2),
							.lost(lose),
							.start_level_2(w_start_level2),
							.start_screen_drawn(w_start_screen_level2_drawn),
							.transition_screen_drawn(w_transition_screen_level2_drawn),
							
							.player_movement(movement),
							.player_enable(player_enable),
							.player_erased(w_player_erased_l2),
							.player_loaded(w_player_loaded_l2),
							
							.enemy1_enable(enemy1_enable_l2),
							.enemy1_erased(w_enemy1_erased_l2),
							.enemy1_loaded(w_enemy1_loaded_l2),
							
							.enemy2_enable(enemy2_enable_l2),
							.enemy2_erased(w_enemy2_erased_l2),
							.enemy2_loaded(w_enemy2_loaded_l2),
							
							.enemy3_enable(enemy3_enable_l2),
							.enemy3_erased(w_enemy3_erased_l2),
							.enemy3_loaded(w_enemy3_loaded_l2),
							
							.s_plot(w_plot_l2),
							.s_erase_player(w_erase_player_l2),
							.s_draw_player(w_draw_player_l2),
							.s_erase_enemy1(w_erase_enemy1_l2),
							.s_draw_enemy1(w_draw_enemy1_l2),
							.s_erase_enemy2(w_erase_enemy2_l2),
							.s_draw_enemy2(w_draw_enemy2_l2),
							.s_erase_enemy3(w_erase_enemy3_l2),
							.s_draw_enemy3(w_draw_enemy3_l2),
							.s_move_player(w_move_player_l2),
							.s_move_enemy1(w_move_enemy1_l2),
							.s_move_enemy2(w_move_enemy2_l2),
							
							.s_start_level3(w_start_level3),
							.s_start_screen(w_start_screen_level2),
							.s_transition_screen(w_transition_screen_level2),
							.s_stop_pps_counter(w_stop_pps_counter_l2)
							
							
						);
								 				
/*********************************************************************/
/*								DATAPATH_L2 MODULE									*/
/*********************************************************************/
 	
	wire reset_l2 = reset && w_start_level2;
	
	wire lose_l2;
	
	wire win_l2;
	
	wire w_start_screen_level2_drawn;
	
	wire w_transition_screen_level2_drawn;
	
	wire w_player_erased_l2, w_player_loaded_l2;
	
	wire w_enemy1_erased_l2, w_enemy1_loaded_l2;
	
	wire w_enemy2_erased_l2, w_enemy2_loaded_l2;
	
	wire w_enemy3_erased_l2, w_enemy3_loaded_l2;
	
	wire[8:0] vga_x_input_l2, vga_y_input_l2;
	
	wire[2:0] vga_c_input_l2;
	
	DataPath_L2 d2(
						.clock(CLOCK_50),
						.reset(reset_l2),
						.transition_clock(transition_clock),
						
						.player_enable(player_enable),
						.enemy1_enable(enemy1_enable_l2),
						.enemy2_enable(enemy2_enable_l2),
						.enemy3_enable(enemy3_enable_l2),
						
						.s_erase_player(w_erase_player_l2),
						.s_draw_player(w_draw_player_l2),
						.s_erase_enemy1(w_erase_enemy1_l2),
						.s_draw_enemy1(w_draw_enemy1_l2),
						.s_erase_enemy2(w_erase_enemy2_l2),
						.s_draw_enemy2(w_draw_enemy2_l2),
						.s_erase_enemy3(w_erase_enemy3_l2),
						.s_draw_enemy3(w_draw_enemy3_l2),
						.s_move_player(w_move_player_l2),
						.s_move_enemy1(w_move_enemy1_l2),
						.s_move_enemy2(w_move_enemy2_l2),
						
						.s_start_level2(w_start_level2),
						.s_start_screen(w_start_screen_level2),
						.s_transition_screen(w_transition_screen_level2),
						
						.keyboard_data(keyboard_data),
						
						.win(win_l2),
						.lose(lose_l2),
						.player_erased(w_player_erased_l2),
						.player_loaded(w_player_loaded_l2),
						.enemy1_erased(w_enemy1_erased_l2),
						.enemy1_loaded(w_enemy1_loaded_l2),
						.enemy2_erased(w_enemy2_erased_l2),
						.enemy2_loaded(w_enemy2_loaded_l2),
						.enemy3_erased(w_enemy3_erased_l2),
						.enemy3_loaded(w_enemy3_loaded_l2),
						
						.start_screen_drawn(w_start_screen_level2_drawn),
						.transition_screen_drawn(w_transition_screen_level2_drawn),
						
						.vga_x_input(vga_x_input_l2),
						.vga_y_input(vga_y_input_l2),
						.vga_c_input(vga_c_input_l2)
					);
					
/*********************************************************************/
/*								PPS_COUNTER MODULES									*/
/*********************************************************************/

	wire enemy1_enable_l3, enemy2_enable_l3, enemy3_enable_l3, enemy4_enable_l3, enemy5_enable_l3;
	
	PPS_Counter pps_enemy1_l3(frame, reset, w_stop_pps_counter_l3, enemy1_enable_l3);
	defparam pps_enemy1_l2.FRAMES_PER_PIXEL = 1;

	PPS_Counter pps_enemy2_l3(frame, reset, w_stop_pps_counter_l3, enemy2_enable_l3);
	defparam pps_enemy2_l3.FRAMES_PER_PIXEL = 1;
	
	PPS_Counter pps_enemy3_l3(frame, reset, w_stop_pps_counter_l3, enemy3_enable_l3);
	defparam pps_enemy3_l3.FRAMES_PER_PIXEL = 1;
	
	PPS_Counter pps_enemy4_l3(frame, reset, w_stop_pps_counter_l3, enemy4_enable_l3);
	defparam pps_enemy4_l3.FRAMES_PER_PIXEL = 1;
	
	PPS_Counter pps_enemy5_l3(frame, reset, w_stop_pps_counter_l3, enemy5_enable_l3);
	defparam pps_enemy5_l3.FRAMES_PER_PIXEL = 1;
	
/*********************************************************************/
/*								CONTROLPATH_L3 MODULE								*/
/*********************************************************************/
	
	wire w_plot_l3;
	
	wire w_erase_player_l3, w_draw_player_l3;
	
	wire w_erase_enemy1_l3, w_draw_enemy1_l3;
	
	wire w_erase_enemy2_l3, w_draw_enemy2_l3;
	
	wire w_erase_enemy3_l3, w_draw_enemy3_l3;
	
	wire w_erase_enemy4_l3, w_draw_enemy4_l3;
	
	wire w_erase_enemy5_l3, w_draw_enemy5_l3;
	
	wire w_move_player_l3;
	
	wire w_move_enemy1_l3;
	
	wire w_move_enemy2_l3;
	
	wire w_win_screen;
	
	wire w_start_screen_level3;
	
	wire w_transition_screen_level3;
	
	wire w_stop_pps_counter_l3;
	
	ControlPath_L3 c3(
							.clock(CLOCK_50),
							.reset(reset),
							
							.won(win_l3),
							.lost(lose),
							.start_level_3(w_start_level3),
							.start_screen_drawn(w_start_screen_level3_drawn),
							.transition_screen_drawn(w_transition_screen_level3_drawn),
							.win_screen_drawn(w_win_screen_drawn),
							
							.player_movement(movement),
							.player_enable(player_enable),
							.player_erased(w_player_erased_l3),
							.player_loaded(w_player_loaded_l3),
							
							.enemy1_enable(enemy1_enable_l3),
							.enemy1_erased(w_enemy1_erased_l3),
							.enemy1_loaded(w_enemy1_loaded_l3),
							
							.enemy2_enable(enemy2_enable_l3),
							.enemy2_erased(w_enemy2_erased_l3),
							.enemy2_loaded(w_enemy2_loaded_l3),
							
							.enemy3_enable(enemy3_enable_l3),
							.enemy3_erased(w_enemy3_erased_l3),
							.enemy3_loaded(w_enemy3_loaded_l3),
							
							.enemy4_enable(enemy4_enable_l3),
							.enemy4_erased(w_enemy4_erased_l3),
							.enemy4_loaded(w_enemy4_loaded_l3),
							
							.enemy5_enable(enemy5_enable_l3),
							.enemy5_erased(w_enemy5_erased_l3),
							.enemy5_loaded(w_enemy5_loaded_l3),
							
							.s_plot(w_plot_l3),
							.s_erase_player(w_erase_player_l3),
							.s_draw_player(w_draw_player_l3),
							.s_erase_enemy1(w_erase_enemy1_l3),
							.s_draw_enemy1(w_draw_enemy1_l3),
							.s_erase_enemy2(w_erase_enemy2_l3),
							.s_draw_enemy2(w_draw_enemy2_l3),
							.s_erase_enemy3(w_erase_enemy3_l3),
							.s_draw_enemy3(w_draw_enemy3_l3),
							.s_erase_enemy4(w_erase_enemy4_l3),
							.s_draw_enemy4(w_draw_enemy4_l3),
							.s_erase_enemy5(w_erase_enemy5_l3),
							.s_draw_enemy5(w_draw_enemy5_l3),
							
							.s_move_player(w_move_player_l3),
							.s_move_enemy1(w_move_enemy1_l3),
							.s_move_enemy2(w_move_enemy2_l3),
							
							.s_start_screen(w_start_screen_level3),
							.s_transition_screen(w_transition_screen_level3),
							.s_win_screen(w_win_screen),
							.s_stop_pps_counter(w_stop_pps_counter_l3)
							
							
						);
						
/*********************************************************************/
/*								DATAPATH_L3 MODULE									*/
/*********************************************************************/
 	
	wire reset_l3 = reset && w_start_level2 && w_start_level3;
	
	wire lose_l3;
	
	wire win_l3;
	
	wire w_start_screen_level3_drawn;
	
	wire w_transition_screen_level3_drawn;
	
	wire w_win_screen_drawn;
	
	wire w_player_erased_l3, w_player_loaded_l3;
	
	wire w_enemy1_erased_l3, w_enemy1_loaded_l3;
	
	wire w_enemy2_erased_l3, w_enemy2_loaded_l3;
	
	wire w_enemy3_erased_l3, w_enemy3_loaded_l3;
	
	wire w_enemy4_erased_l3, w_enemy4_loaded_l3;
	
	wire w_enemy5_erased_l3, w_enemy5_loaded_l3;
	
	wire[8:0] vga_x_input_l3, vga_y_input_l3;
	
	wire[2:0] vga_c_input_l3;
	
	DataPath_L3 d3(
						.clock(CLOCK_50),
						.reset(reset_l3),
						.transition_clock(transition_clock),
						
						.player_enable(player_enable),
						.enemy1_enable(enemy1_enable_l3),
						.enemy2_enable(enemy2_enable_l3),
						.enemy3_enable(enemy3_enable_l3),
						.enemy4_enable(enemy4_enable_l3),
						.enemy5_enable(enemy5_enable_l3),
						
						.s_erase_player(w_erase_player_l3),
						.s_draw_player(w_draw_player_l3),
						.s_erase_enemy1(w_erase_enemy1_l3),
						.s_draw_enemy1(w_draw_enemy1_l3),
						.s_erase_enemy2(w_erase_enemy2_l3),
						.s_draw_enemy2(w_draw_enemy2_l3),
						.s_erase_enemy3(w_erase_enemy3_l3),
						.s_draw_enemy3(w_draw_enemy3_l3),
						.s_erase_enemy4(w_erase_enemy4_l3),
						.s_draw_enemy4(w_draw_enemy4_l3),
						.s_erase_enemy5(w_erase_enemy5_l3),
						.s_draw_enemy5(w_draw_enemy5_l3),
						
						.s_move_player(w_move_player_l3),
						.s_move_enemy1(w_move_enemy1_l3),
						.s_move_enemy2(w_move_enemy2_l3),
						
						
						.s_start_level3(w_start_level3),
						.s_start_screen(w_start_screen_level3),
						.s_transition_screen(w_transition_screen_level3),
						.s_win_screen(w_win_screen),
						
						.keyboard_data(keyboard_data),
						
						.win(win_l3),
						.lose(lose_l3),
						.player_erased(w_player_erased_l3),
						.player_loaded(w_player_loaded_l3),
						.enemy1_erased(w_enemy1_erased_l3),
						.enemy1_loaded(w_enemy1_loaded_l3),
						.enemy2_erased(w_enemy2_erased_l3),
						.enemy2_loaded(w_enemy2_loaded_l3),
						.enemy3_erased(w_enemy3_erased_l3),
						.enemy3_loaded(w_enemy3_loaded_l3),
						.enemy4_erased(w_enemy4_erased_l3),
						.enemy4_loaded(w_enemy4_loaded_l3),
						.enemy5_erased(w_enemy5_erased_l3),
						.enemy5_loaded(w_enemy5_loaded_l3),
						
						.start_screen_drawn(w_start_screen_level3_drawn),
						.transition_screen_drawn(w_transition_screen_level3_drawn),
						.win_screen_drawn(w_win_screen_drawn),
						
						.vga_x_input(vga_x_input_l3),
						.vga_y_input(vga_y_input_l3),
						.vga_c_input(vga_c_input_l3)

					);
/*********************************************************************/
/*									VGA_ADAPTER MODULE								*/
/*********************************************************************/

	
	wire w_plot = w_plot_l1 | w_plot_l2 | w_plot_l3;
	
	reg[8:0] vga_x_input, vga_y_input;
	
	reg[2:0] vga_c_input;
	
	always @(*) 
		begin
			if (w_plot_l1) begin
				vga_x_input <= vga_x_input_l1;
				vga_y_input <= vga_y_input_l1;
				vga_c_input <= vga_c_input_l1;
			end
			else if (w_plot_l2) begin
				vga_x_input <= vga_x_input_l2;
				vga_y_input <= vga_y_input_l2;
				vga_c_input <= vga_c_input_l2;
			end
			else if (w_plot_l3) begin
				vga_x_input <= vga_x_input_l3;
				vga_y_input <= vga_y_input_l3;
				vga_c_input <= vga_c_input_l3;
			end
		end
	
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(reset),
			.clock(CLOCK_50),
			.colour(vga_c_input),
			.x(vga_x_input),
			.y(vga_y_input),
			.plot(w_plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
/*********************************************************************/
/*										DEBUGGING										*/
/*********************************************************************/
	
	wire[4:0] state;
	assign LEDR[9] = movement;
	wire x_move, something;
	
	assign LEDR[8] = x_move;
	assign LEDR[7] = something;
	assign LEDR[6] = (state == 5'd19) ? 1 : 0;
	
	assign LEDR[0] = w_win_screen;
	HEX_Decoder h0(state[3:0], HEX0);
	HEX_Decoder h1({3'b000,state[4]}, HEX1);
	
	HEX_Decoder h2(vga_x_input[3:0], HEX2);
	HEX_Decoder h3(vga_x_input[7:4], HEX3);
	
	HEX_Decoder h4(vga_y_input[3:0], HEX4);
	HEX_Decoder h5(vga_y_input[7:4], HEX5);

endmodule




