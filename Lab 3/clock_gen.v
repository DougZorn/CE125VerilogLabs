`timescale 1us/500ns
module clock_gen #(parameter CLOCK_PERIOD = 1000)
(output reg clock);

	initial clock = 0;
	always
		begin
			#(CLOCK_PERIOD/2) clock = ~clock;
		end
	endmodule
