module Jump_Counter(input clock, enable, input[7:0] start_jump, output reg jump);
	
	parameter JUMP_COUNT = 45;
	
	initial jump = 0;
	
	reg[5:0] count = 0, flag = 0;
	
	always @(posedge clock)
		begin
			if (start_jump == 8'h29 && !jump && enable) begin
				flag <= 1;
				jump <= 1;
			end
			else if (count > JUMP_COUNT) begin
				flag <= 0;
				count <= 0;
				jump <= 0;
			end
			else if (flag) begin
				count <= count + 1;
			end
		end
endmodule
