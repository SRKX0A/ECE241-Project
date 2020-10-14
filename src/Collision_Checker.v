module Collision_Checker(input[8:0] x_position, y_position, output collision_left, collision_right, collision_up, collision_down);

/*********************************************************************/
/*									PARAMETERS											*/
/*********************************************************************/

	parameter LEFT_LIMIT = 0;
	parameter RIGHT_LIMIT = 0;
	parameter TOP_LIMIT = 0;
	parameter BOTTOM_LIMIT = 0;
	parameter PLAYER_WIDTH = 20;
	parameter PLAYER_HEIGHT = 35;
		
/*********************************************************************/
/*									COLLISION CHECKING								*/
/*********************************************************************/	
	
	assign collision_left = (x_position == RIGHT_LIMIT && y_position + PLAYER_HEIGHT > TOP_LIMIT && y_position < BOTTOM_LIMIT) ? 1'b1 : 1'b0;
	assign collision_right = (x_position + PLAYER_WIDTH == LEFT_LIMIT && y_position + PLAYER_HEIGHT > TOP_LIMIT && y_position < BOTTOM_LIMIT) ? 1'b1 : 1'b0;
	assign collision_up = ((y_position == BOTTOM_LIMIT || y_position == BOTTOM_LIMIT - 1) && x_position + PLAYER_WIDTH > LEFT_LIMIT && x_position < RIGHT_LIMIT) ? 1'b1 : 1'b0;
	assign collision_down = ((y_position + PLAYER_HEIGHT == TOP_LIMIT || y_position + PLAYER_HEIGHT == TOP_LIMIT + 1) && x_position + PLAYER_WIDTH > LEFT_LIMIT && x_position < RIGHT_LIMIT) ? 1'b1 : 1'b0;
	
endmodule
