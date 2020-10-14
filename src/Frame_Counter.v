module Frame_Counter(input clock, reset, output reg frame);
	
/*********************************************************************/
/*							OUTPUT REGISTER INITIALIZATION						*/
/*********************************************************************/
	
	initial frame = 0;
	parameter RATE = 0;
	
/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/
	
	reg[22:0] Q = RATE;
	
/*********************************************************************/
/*									FRAME COUNTER										*/
/*********************************************************************/
	
	always @(posedge clock)
		begin
			if (!reset) begin
				frame <= 0;
				Q <= RATE;
			end
			else if (Q == 0) begin
				frame <= 1;
				Q <= RATE;
			end
			else begin
				frame <= 0;
				Q <= Q - 1'b1;
			end
		end
		
endmodule
