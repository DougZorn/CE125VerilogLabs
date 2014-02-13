`timescale 1ns/100ps
module clock_gen #(parameter CLOCK_PERIOD = 100)
(output reg clock);

	initial clock = 0;
	always
		begin
			#(CLOCK_PERIOD/2) clock = ~clock;
		end
	endmodule
