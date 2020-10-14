module Player_Sprite_Position_L3(input clock, reset, input[7:0] keyboard_data, output reg[8:0] X, Y, output reg win);
	
/*********************************************************************/
/*									PARAMETERS											*/
/*********************************************************************/

	parameter X_START = 0;
	parameter Y_START = 0;
	
/*********************************************************************/
/*							OUTPUT REGISTER INITIALIZATION						*/
/*********************************************************************/
	
	initial X = X_START;
	initial Y = Y_START;
	initial win = 0;

/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/

	wire floor_left, floor_right, floor_up, floor_down;
	
	wire ceiling_left, ceiling_right, ceiling_up, ceiling_down;
	
	wire platform1_left, platform1_right, platform1_up, platform1_down;
	
	wire platform2_left, platform2_right, platform2_up, platform2_down;
	
	wire platform3_left, platform3_right, platform3_up, platform3_down;
	
	wire platform4_left, platform4_right, platform4_up, platform4_down;
	
	wire platform5_left, platform5_right, platform5_up, platform5_down;
	
	wire door_left, door_right, door_up, door_down;
	
	wire jump;

/*********************************************************************/
/*								COLLISION_CHECKER MODULES							*/
/*********************************************************************/

	Collision_Checker floor(X, Y, floor_left, floor_right, floor_up, floor_down);
	defparam floor.LEFT_LIMIT = 0;
	defparam floor.RIGHT_LIMIT = 320;
	defparam floor.TOP_LIMIT = 223;
	defparam floor.BOTTOM_LIMIT = 240;
	
	Collision_Checker ceiling(X, Y, ceiling_left, ceiling_right, ceiling_up, ceiling_down);
	defparam ceiling.LEFT_LIMIT = 0;
	defparam ceiling.RIGHT_LIMIT = 320;
	defparam ceiling.TOP_LIMIT = 0;
	defparam ceiling.BOTTOM_LIMIT = 16;
	
	Collision_Checker platform1(X, Y, platform1_left, platform1_right, platform1_up, platform1_down);
	defparam platform1.LEFT_LIMIT = 0;
	defparam platform1.RIGHT_LIMIT = 66;
	defparam platform1.TOP_LIMIT = 72;
	defparam platform1.BOTTOM_LIMIT = 77;
	
	Collision_Checker platform2(X, Y, platform2_left, platform2_right, platform2_up, platform2_down);
	defparam platform2.LEFT_LIMIT = 0;
	defparam platform2.RIGHT_LIMIT = 124;
	defparam platform2.TOP_LIMIT = 179;
	defparam platform2.BOTTOM_LIMIT = 186;
	
	Collision_Checker platform3(X, Y, platform3_left, platform3_right, platform3_up, platform3_down);
	defparam platform3.LEFT_LIMIT = 195;
	defparam platform3.RIGHT_LIMIT = 320;
	defparam platform3.TOP_LIMIT = 180;
	defparam platform3.BOTTOM_LIMIT = 188;
	
	Collision_Checker platform4(X, Y, platform4_left, platform4_right, platform4_up, platform4_down);
	defparam platform4.LEFT_LIMIT = 242;
	defparam platform4.RIGHT_LIMIT = 320;
	defparam platform4.TOP_LIMIT = 129;
	defparam platform4.BOTTOM_LIMIT = 136;
	
	Collision_Checker platform5(X, Y, platform5_left, platform5_right, platform5_up, platform5_down);
	defparam platform5.LEFT_LIMIT = 264;
	defparam platform5.RIGHT_LIMIT = 320;
	defparam platform5.TOP_LIMIT = 75;
	defparam platform5.BOTTOM_LIMIT = 82;
	
	Collision_Checker door(X, Y, door_left, door_right, door_up, door_down);
	defparam door.LEFT_LIMIT = 286;
	defparam door.RIGHT_LIMIT = 300;
	defparam door.TOP_LIMIT = 47;
	defparam door.BOTTOM_LIMIT = 70;
	
/*********************************************************************/
/*								COLLISION_CHECKER MODULES							*/
/*********************************************************************/

	wire on_floor = floor_down || ceiling_down || platform1_down || platform2_down || platform3_down || platform4_down || platform5_down;

	Jump_Counter jump_distance(clock, on_floor, keyboard_data, jump);
	defparam jump_distance.JUMP_COUNT = 37;

/*********************************************************************/
/*									POSITION COUNTER									*/
/*********************************************************************/

	always @(posedge clock or negedge reset)
		begin
			if (!reset) begin
				X <= X_START;
				Y <= Y_START;
				win <= 0;
			end 
			else begin
				if (door_left || door_right || door_up || door_down) begin
					win <= 1;
				end
				if (keyboard_data == 8'h6b) begin
					X <= (X==0 || floor_left || ceiling_left || platform1_left || platform2_left || platform3_left || platform4_left || platform5_left) ? X : X - 1'b1;
				end
				else if (keyboard_data == 8'h74) begin
					X <= (X==320-20 || floor_right || ceiling_right || platform1_right || platform2_right || platform3_right || platform4_right || platform5_right) ? X : X + 1'b1;
				end
				else begin
					X <= X;
				end
				
				if (jump) begin
					Y <= (Y==0 || floor_up || ceiling_up || platform1_up || platform2_up || platform3_up || platform4_up || platform5_up) ? Y : Y - 2;
				end
				else begin
					Y <= (Y==240 || floor_down || ceiling_down || platform1_down || platform2_down || platform3_down || platform4_down || platform5_down) ? Y : Y + 2;
				end
			end
		end
		
endmodule
