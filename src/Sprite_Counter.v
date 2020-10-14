module Sprite_Counter(input clock, reset, enable, sync_load, input[8:0] x_current, y_current, output reg loaded, output reg[8:0] x_sprite, y_sprite);
	
	parameter X_START = 140;
	parameter Y_START = 100;
	parameter HEIGHT = 14;
	parameter WIDTH = 20;

	initial x_sprite = X_START;
	initial y_sprite = Y_START;
	initial loaded = 0;
	
	always @(posedge clock)
		begin
			if (!reset) begin
				x_sprite <= X_START;
				y_sprite <= Y_START;
				loaded <= 0;
			end
			else if (sync_load && loaded) begin
				x_sprite <= x_current;
				y_sprite <= y_current;
				loaded <= 0;
			end
			else if (enable) begin
				if (x_sprite == x_current + WIDTH && y_sprite == y_current + HEIGHT) begin
					loaded <= 1;
				end
				else if (x_sprite != x_current + WIDTH) begin
					x_sprite <= x_sprite + 1'b1;
				end
				else begin
					x_sprite <= x_current;
					y_sprite <= y_sprite + 1'b1;
				end
			end
		end
	
endmodule
