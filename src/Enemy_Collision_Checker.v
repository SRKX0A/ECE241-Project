module Enemy_Collision_Checker(input[8:0] x_position, y_position, x_enemy_position, y_enemy_position, output collision);


/*********************************************************************/
/*									PARAMETERS											*/
/*********************************************************************/

	parameter PLAYER_WIDTH = 20;
	parameter PLAYER_HEIGHT = 35;
	parameter ENEMY_WIDTH = 20;
	parameter ENEMY_HEIGHT = 35;


/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/	
	
	wire collision_left = (x_position <= x_enemy_position + ENEMY_WIDTH && y_position + PLAYER_HEIGHT > y_enemy_position && y_position < y_enemy_position + ENEMY_HEIGHT) ? 1'b1 : 1'b0;
	wire collision_right = (x_position + PLAYER_WIDTH >= x_enemy_position && y_position + PLAYER_HEIGHT > y_enemy_position && y_position < y_enemy_position + ENEMY_HEIGHT) ? 1'b1 : 1'b0;
	wire collision_up = (y_position >= y_enemy_position + ENEMY_HEIGHT && x_position + PLAYER_WIDTH > x_enemy_position && x_position < x_enemy_position + ENEMY_WIDTH) ? 1'b1 : 1'b0;
	wire collision_down = (y_position + PLAYER_HEIGHT <= y_enemy_position && x_position + PLAYER_WIDTH > x_enemy_position && x_position < x_enemy_position + ENEMY_WIDTH) ? 1'b1 : 1'b0;
	
/*********************************************************************/
/*									COLLISION CHECKING								*/
/*********************************************************************/	

	assign collision = (collision_left & collision_right) | (collision_up & collision_down);
	
endmodule
