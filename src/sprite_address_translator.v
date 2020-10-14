module sprite_address_translator(x, y, address);
	parameter TYPE = "PLAYER";
	
	input[6:0] x;
	input[5:0] y;
	output reg[16:0] address;
	
	wire[16:0] res_55x35 = {1'b0, y, 5'd0} + {1'b0, y, 4'd0} + {1'b0, y, 2'd0} + {1'b0, y, 1'd0} + {1'b0, y} + {1'b0, x};
	wire[16:0] res_20x35 = {1'b0, y, 4'd0} + {1'b0, y, 2'd0} + {1'b0, x};
	wire[16:0] res_31x65 = {1'b0, y, 4'd0} + {1'b0, y, 3'd0} + {1'b0, y, 2'd0} + {1'b0, y, 1'd0} + {1'b0, y} + {1'b0, x};
	
	
	always @(*)
		begin
			if (TYPE == "PLAYER") begin
				address <= res_20x35;
			end
			else if (TYPE == "RED_ENEMY") begin
				address <= res_55x35;
			end
			else if (TYPE == "PURPLE_ENEMY") begin
				address <= res_31x65;
			end
		end
	
endmodule
