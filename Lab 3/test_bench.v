module tbench(
	//Inputs
	//signal comes from module clock_gen
	input clock_i,
	//signals come from module fsm
	input reg green_northsouth_o,
  input reg red_northsouth_o,
  input reg yellow_northsouth_o,
  input reg green_eastwest_o,
  input reg red_eastwest_o, 
  input reg yellow_eastwest_o, 
  input reg [15:0] transition_count_o,
 	//Outputs
	//signals go to modole fsm
	output reg reset_n_o,
	output reg [2:0] vcount_northbound_o,
  output reg [2:0] vcount_southbound_o,
  output reg [2:0] vcount_eastbound_o,
  output reg [2:0] vcount_westbound_o,
  output reg ped_button_ns_o,
  output reg ped_button_ew_o,
  output reg test_mode_o
);

initial 
	begin
		reset_n_o = 1'b1;
		@(negedge clock_i);
		reset_n_o = 1'b0;
		//repeat (2) @(negedge clock);
		@(negedge clock_i);
		reset_n_o = 1'b1;
	end
endmodule