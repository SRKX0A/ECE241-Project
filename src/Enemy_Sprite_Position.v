module Enemy_Sprite_Position(input clock, reset, input[8:0] x_player, y_player, output reg[8:0] X, Y, output reg x_direction, y_direction, lose);
	
/*********************************************************************/
/*									PARAMETERS											*/
/*********************************************************************/
	
	parameter X_ENABLE = 0;
	parameter Y_ENABLE = 0;
	parameter X_START = 0;
	parameter Y_START = 0;
	parameter X_END = 0;
	parameter Y_END = 0;
	parameter X_DIRECTION = 0;
	parameter Y_DIRECTION = 0;
	parameter WIDTH = 0;
	parameter HEIGHT = 0;
	
/*********************************************************************/
/*							OUTPUT REGISTER INITIALIZATION						*/
/*********************************************************************/
	
	initial X = X_START;
	initial Y = Y_START;
	initial x_direction = X_DIRECTION;
	initial y_direction = Y_DIRECTION;
	initial lose = 0;

/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/

	wire collision;
		
/*********************************************************************/
/*						ENEMY_COLLISION_CHECKER MODULES							*/
/*********************************************************************/

	Enemy_Collision_Checker enemy(x_player, y_player, X, Y, collision);
	defparam enemy.ENEMY_WIDTH = WIDTH;
	defparam enemy.ENEMY_HEIGHT = HEIGHT;

/*********************************************************************/
/*									POSITION COUNTER									*/
/*********************************************************************/
	
	always @(posedge clock or negedge reset)
		begin
			if (!reset) begin
				X <= X_START;
				Y <= Y_START;
				x_direction <= X_DIRECTION;
				y_direction <= Y_DIRECTION;
				lose <= 0;
			end	
			else begin
				if (collision) begin
					lose <= 1;
				end
				if (X_ENABLE) begin
					if (X == X_START || X == X_END) begin
						x_direction = ~x_direction;
					end
					if (x_direction) begin
						X <= X + 1'b1;
					end
					else begin
						X <= X - 1'b1;
					end
				end
				
				if (Y_ENABLE) begin
					if (Y == Y_START || Y == Y_END) begin
						y_direction = ~y_direction;
					end
					if (y_direction) begin
						Y <= Y + 1'b1;
					end
					else begin
						Y <= Y - 1'b1;
					end
				end
			end
		end
		
endmodule
