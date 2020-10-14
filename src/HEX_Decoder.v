module HEX_Decoder(input[3:0] Input, output[6:0] Output);
	
	wire v0 = ~Input[3] & ~Input[2] & ~Input[1] & ~Input[0];
	wire v1 = ~Input[3] & ~Input[2] & ~Input[1] & Input[0];
	wire v2 = ~Input[3] & ~Input[2] & Input[1] & ~Input[0];
	wire v3 = ~Input[3] & ~Input[2] & Input[1] & Input[0];
	wire v4 = ~Input[3] & Input[2] & ~Input[1] & ~Input[0];
	wire v5 = ~Input[3] & Input[2] & ~Input[1] & Input[0];
	wire v6 = ~Input[3] & Input[2] & Input[1] & ~Input[0];
	wire v7 = ~Input[3] & Input[2] & Input[1] & Input[0];
	wire v8 = Input[3] & ~Input[2] & ~Input[1] & ~Input[0];
	wire v9 = Input[3] & ~Input[2] & ~Input[1] & Input[0];
	wire va = Input[3] & ~Input[2] & Input[1] & ~Input[0];
	wire vb = Input[3] & ~Input[2] & Input[1] & Input[0];
	wire vc = Input[3] & Input[2] & ~Input[1] & ~Input[0];
	wire vd = Input[3] & Input[2] & ~Input[1] & Input[0];
	wire ve = Input[3] & Input[2] & Input[1] & ~Input[0];
	wire vf = Input[3] & Input[2] & Input[1] & Input[0];
	
	assign Output[0] = v1 | v4 | vb | vd;
	assign Output[1] = v5 | v6 | vb | vc | ve | vf;
	assign Output[2] = v2 | vc | ve | vf;
	assign Output[3] = v1 | v4 | v7 | v9 | va | vf;
	assign Output[4] = v1 | v3 | v4 | v5 | v7 | v9;
	assign Output[5] = v1 | v2 | v3 | v7 | vd;
	assign Output[6] = v0 | v1 | v7 | vc;
	
endmodule
