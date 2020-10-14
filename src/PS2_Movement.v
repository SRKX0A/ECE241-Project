
module PS2_Movement(input clock, reset, inout ps2_clk, ps2_dat, output reg[7:0] ps2_key_data, output ps2_key_pressed);


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires

wire[7:0] data;

reg flag = 0;

// State Machine Registers

always @(posedge clock)
	begin
		if (!reset) begin
			ps2_key_data <= 0;
		end
		else if (!ps2_key_pressed) begin
			if (flag) begin
				ps2_key_data <= data;
			end
			else if (~flag) begin
				ps2_key_data <= 0;
			end
			else if (ps2_key_data == 8'hf0) begin
				flag <= 0;
			end
			
		end
		else if (ps2_key_pressed) begin
			flag <= 1;
		end
	end



PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(clock),
	.reset				(!reset),

	// Bidirectionals
	.PS2_CLK			(ps2_clk),
 	.PS2_DAT			(ps2_dat),

	// Outputs
	.received_data		(data),
	.received_data_en	(ps2_key_pressed)
);

endmodule
