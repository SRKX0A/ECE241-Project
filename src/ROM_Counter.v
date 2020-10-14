module ROM_Counter(input clock, reset, enable, sync_load, output reg loaded, output reg[8:0] x_rom, y_rom);

	parameter ROM_WIDTH = 0;
	parameter ROM_HEIGHT = 0;
	
	initial x_rom = 0;
	initial y_rom = 0;
	initial loaded = 0;
	
	always@(posedge clock) 
		begin
			if(!reset) begin
				x_rom <= 0;
				y_rom <= 0;
				loaded <= 0;
			end
			else if (sync_load && loaded) begin
				x_rom <= 0;
				y_rom <= 0;
				loaded <= 0;
			end
			else if (enable) begin
				if (x_rom == ROM_WIDTH && y_rom == ROM_HEIGHT) begin
					loaded <= 1;
				end
				else if (x_rom != ROM_WIDTH) begin
					x_rom <= x_rom + 1'b1;
				end
				else begin
					x_rom <= 0;
					y_rom <= y_rom + 1;
				end
			end
		end

endmodule
