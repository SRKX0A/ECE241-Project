module Player_Sprite_Position_L1(input clock, reset, input[7:0] keyboard_data, output reg[8:0] X, Y, output reg win);
	
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
	
	wire enemy1_left, enemy1_right, enemy1_up, enemy1_down;
	
	wire enemy2_left, enemy2_right, enemy2_up, enemy2_down;
	
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
	defparam platform1.LEFT_LIMIT = 83;
	defparam platform1.RIGHT_LIMIT = 239;
	defparam platform1.TOP_LIMIT = 167;
	defparam platform1.BOTTOM_LIMIT = 179;
	
	Collision_Checker door(X, Y, door_left, door_right, door_up, door_down);
	defparam door.LEFT_LIMIT = 296;
	defparam door.RIGHT_LIMIT = 306;
	defparam door.TOP_LIMIT = 200;
	defparam door.BOTTOM_LIMIT = 223;
	
/*********************************************************************/
/*								COLLISION_CHECKER MODULES							*/
/*********************************************************************/

	wire on_floor = floor_down || ceiling_down || platform1_down;
	
	Jump_Counter jump_distance(clock, on_floor, keyboard_data, jump);
	defparam jump_distance.JUMP_COUNT = 35;

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
					X <= (X==0 || floor_left || ceiling_left || platform1_left) ? X : X - 1'b1;
				end
				else if (keyboard_data == 8'h74) begin
					X <= (X==320-20 || floor_right || ceiling_right || platform1_right) ? X : X + 1'b1;
				end
				else begin
					X <= X;
				end
				
				if (jump) begin
					Y <= (Y==0 || floor_up || ceiling_up || platform1_up) ? Y : Y - 2;
				end
				else begin
					Y <= (Y==240 || floor_down || ceiling_down || platform1_down) ? Y : Y + 2;
				end
			end
		end
		
endmodule
