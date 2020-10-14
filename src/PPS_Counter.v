module PPS_Counter(input clock, reset, stop, output reg enable);

/*********************************************************************/
/*									PARAMETERS											*/
/*********************************************************************/

	parameter FRAMES_PER_PIXEL = 12; 
	
/*********************************************************************/
/*							OUTPUT REGISTER INITIALIZATION						*/
/*********************************************************************/
	
	initial enable = 0;
	

/*********************************************************************/
/*							INTERNAL WIRES/REGISTERS								*/
/*********************************************************************/

	reg[3:0] Q = 0;

/*********************************************************************/
/*							PIXELS-PER-SECOND COUNTER								*/
/*********************************************************************/

	always @(posedge clock)
		begin
			if (!reset || stop) begin
				Q <= 0;
				enable <= 0;
			end
			else if (Q == FRAMES_PER_PIXEL) begin
				Q <= 0;
				enable <= 1;
			end
			else begin
				Q <= Q + 1'b1;
				enable <= 0;
			end
		end
		
endmodule
