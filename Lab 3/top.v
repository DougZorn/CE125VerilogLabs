`timescale 1us/100ns
module top(
);

wire clock_w;
wire reset_n_w;
wire [2:0] vcount_northbound_w;
wire [2:0] vcount_southbound_w;
wire [2:0] vcount_eastbound_w;
wire [2:0] vcount_westbound_w;
wire ped_button_ns_w;
wire ped_button_ew_w;
wire test_mode_w;
wire green_northsouth_w;
wire red_northsouth_w;
wire yellow_northsouth_w;
wire green_eastwest_w;
wire red_eastwest_w;
wire yellow_eastwest_w;
wire [15:0] transition_count_w;

clock_gen #(.CLOCK_PERIOD(1000)) clock_gen_0 (.clock_i(clock_w));

test_bench test_bench_0 (.clock_i(clock_w),
												 .reset_n_o(reset_n_w),
												 .vcount_northbound_o(vcount_northbound_w),
           							 .vcount_southbound_o(vcount_southbound_w),
					 							 .vcount_eastbound_o(vcount_eastbound_w),
           							 .vcount_westbound_o(vcount_westbound_w),
           							 .ped_button_ns_o(ped_button_ns_w),
           							 .ped_button_ew_o(ped_button_ew_w),
           							 .test_mode_o(test_mode_w),
					 							 .green_northsouth_i(green_northsouth_w),
  				 							 .red_northsouth_i(red_northsouth_w),
  				 							 .yellow_northsouth_i(yellow_northsouth_w),
				    						 .green_eastwest_i(green_eastwest_w), 
							  				 .red_eastwest_i(red_eastwest_w), 
							  				 .yellow_eastwest_i(yellow_eastwest_w),
											   .transition_count_i());

fsm fsm_0 (.clock_i(clock_w),
					 .reset_n_i(reset_n_w),
					 .vcount_northbound_i(vcount_northbound_w),
           .vcount_southbound_i(vcount_southbound_w),
					 .vcount_eastbound_i(vcount_eastbound_w),
           .vcount_westbound_i(vcount_westbound_w),
           .ped_button_ns_i(ped_button_ns_w),
           .ped_button_ew_i(ped_button_ew_w),
           .test_mode_i(test_mode_w),
					 .green_northsouth_o(green_northsouth_w),
  				 .red_northsouth_o(red_northsouth_w),
  				 .yellow_northsouth_o(yellow_northsouth_w),
				   .green_eastwest_o(green_eastwest_w), 
  				 .red_eastwest_o(red_eastwest_w), 
  				 .yellow_eastwest_o(yellow_eastwest_w),
				   .transition_count_o(transition_count_w));
												 

endmodule