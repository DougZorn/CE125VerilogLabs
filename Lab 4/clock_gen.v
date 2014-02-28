`timescale 1ns/100ps
module clock_gen #(parameter CLOCK_PERIOD = 1000)
(output reg clock_i);

	initial clock_i = 0;
	always
		begin
			#(CLOCK_PERIOD/2) clock_i = ~clock_i;
		end
	endmodule
