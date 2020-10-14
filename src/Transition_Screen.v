module Transition_Screen(input clock, reset, enable, output reg done, output reg[8:0] X, Y);

	localparam WIDTH = 320, HEIGHT = 240;
	
	initial X = 0;
	initial Y = 0;
	initial done = 0;
	
	reg[8:0] x_start = 0, y_start = 0;
	reg[8:0] x_end = WIDTH, y_end = HEIGHT;
	reg right = 1, down = 0, left = 0, up = 0;
	
	always @(posedge clock or negedge reset)
		begin
			if (!reset) begin
				X <= 0;
				Y <= 0;
				x_start <= 0;
				y_start <= 0;
				x_end <= WIDTH;
				y_end <= HEIGHT;
				right <= 1;
				down <= 0;
				left <= 0;
				up <= 0;
				done <= 0;
			end
			else if (enable) begin
			
				if (X == 160 && Y == 120) begin
					done <= 1;
				end
				
				if (right) begin
					X = X + 1;
				end
				
				if (down) begin
					Y = Y + 1;
				end
				
				if (left) begin
					X = X - 1;
				end
				
				if (up) begin
					Y = Y - 1;
				end
				
				if (X == x_start && Y == y_start) begin
					right <= 1;
					down <= 0;
					left <= 0;
					up <= 0;
					x_end <= x_end - 1;
				end
				else if (X == x_end && Y == y_start) begin
					right <= 0;
					down <= 1;
					left <= 0;
					up <= 0;
					y_end <= y_end - 1;
				end
				else if (X == x_end && Y == y_end) begin
					right <= 0;
					down <= 0;
					left <= 1;
					up <= 0;
					x_start <= x_start + 1;
				end
				else if (X == x_start && Y == y_end) begin
					right <= 0;
					down <= 0;
					left <= 0;
					up <= 1;
					y_start <= y_start + 1;
				end
			end
		end
endmodule

/*











*/
