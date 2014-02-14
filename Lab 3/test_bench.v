`timescale 1us/100ns
module test_bench(
	//Inputs
	//signal comes from module clock_gen
	input clock_i,
	//signals come from module fsm
	input reg green_northsouth_i,
  input reg red_northsouth_i,
  input reg yellow_northsouth_i,
  input reg green_eastwest_i,
  input reg red_eastwest_i, 
  input reg yellow_eastwest_i, 
  input reg [15:0] transition_count_i,
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

	reg [31:0] outfile;

initial 
	begin

		outfile = $fopen("C:/Users/dzorn/Desktop/lab3modelsim/lab3_out.dat");
    $fwrite(outfile, "Simulation output for Lab 3\n\n");
		reset_n_o = 1'b1;
		@(negedge clock_i);
		reset_n_o = 1'b0;
		repeat (2) @(negedge clock_i);
		reset_n_o = 1'b1;	
		test_mode_o = 1'b1;
 	  vcount_northbound_o = 3'd0;
	  vcount_southbound_o = 3'd0;
	  vcount_eastbound_o = 3'd0;
    vcount_westbound_o = 3'd1;
    ped_button_ns_o = 1'd0;
    ped_button_ew_o = 1'd0;
    
    $fwrite(outfile, "The NS Green light counter is %d\n", transition_count_i);


		repeat (2) @(posedge clock_i);	
		$fwrite(outfile, "The current time is:%0d us\n" ,$time);
		$fwrite(outfile, "The NS Green light counter is %d\n", transition_count_i);
		$fwrite(outfile, "NS Green light status: %d\n", green_northsouth_i); 
		$fwrite(outfile, "NS Yellow light status: %d\n", yellow_northsouth_i);
		$fwrite(outfile, "NS Red light status: %d\n", red_northsouth_i); 
		$fwrite(outfile, "EW Green light status: %d\n", green_eastwest_i);
		$fwrite(outfile, "EW Yellow light status: %d\n", yellow_eastwest_i);
		$fwrite(outfile, "EW Red light status: %d\n", red_eastwest_i); 
		$fwrite(outfile, "N vehicle count: %d\n", vcount_northbound_o);
		$fwrite(outfile, "S vehicle count: %d\n", vcount_southbound_o);
		$fwrite(outfile, "E vehicle count: %d\n", vcount_eastbound_o);
		$fwrite(outfile, "W vehicle count: %d\n\n", vcount_westbound_o);
		
		repeat (200) @(posedge clock_i);
		
		vcount_eastbound_o = 3'd4;
    vcount_westbound_o = 3'd2;
    
    $fwrite(outfile, "The current time is:%0d us\n" ,$time);
    $fwrite(outfile, "The NS Green light counter is %d\n", transition_count_i);
		$fwrite(outfile, "NS Green light status: %d\n", green_northsouth_i); 
		$fwrite(outfile, "NS Yellow light status: %d\n", yellow_northsouth_i);
		$fwrite(outfile, "NS Red light status: %d\n", red_northsouth_i); 
		$fwrite(outfile, "EW Green light status: %d\n", green_eastwest_i);
		$fwrite(outfile, "EW Yellow light status: %d\n", yellow_eastwest_i);
		$fwrite(outfile, "EW Red light status: %d\n", red_eastwest_i); 
		$fwrite(outfile, "N vehicle count: %d\n", vcount_northbound_o);
		$fwrite(outfile, "S vehicle count: %d\n", vcount_southbound_o);
		$fwrite(outfile, "E vehicle count: %d\n", vcount_eastbound_o);
		$fwrite(outfile, "W vehicle count: %d\n\n", vcount_westbound_o);
    
    repeat (1000) @(posedge clock_i);
    
    vcount_eastbound_o = 3'd0;
    vcount_westbound_o = 3'd0;

		repeat (1200) @(posedge clock_i);
		$fwrite(outfile, "The current time is:%0d us\n" ,$time);
		$fwrite(outfile, "The NS Green light counter is %d\n", transition_count_i);
		$fwrite(outfile, "NS Green light status: %d\n", green_northsouth_i); 
		$fwrite(outfile, "NS Yellow light status: %d\n", yellow_northsouth_i);
		$fwrite(outfile, "NS Red light status: %d\n", red_northsouth_i); 
		$fwrite(outfile, "EW Green light status: %d\n", green_eastwest_i);
		$fwrite(outfile, "EW Yellow light status: %d\n", yellow_eastwest_i);
		$fwrite(outfile, "EW Red light status: %d\n", red_eastwest_i); 
		$fwrite(outfile, "N vehicle count: %d\n", vcount_northbound_o);
		$fwrite(outfile, "S vehicle count: %d\n", vcount_southbound_o);
		$fwrite(outfile, "E vehicle count: %d\n", vcount_eastbound_o);
		$fwrite(outfile, "W vehicle count: %d\n\n", vcount_westbound_o);

		repeat (20) @(posedge clock_i);
		$fwrite(outfile, "The current time is:%0d us\n" ,$time);
		$fwrite(outfile, "The NS Green light counter is %d\n", transition_count_i);
		$fwrite(outfile, "NS Green light status: %d\n", green_northsouth_i); 
		$fwrite(outfile, "NS Yellow light status: %d\n", yellow_northsouth_i);
		$fwrite(outfile, "NS Red light status: %d\n", red_northsouth_i); 
		$fwrite(outfile, "EW Green light status: %d\n", green_eastwest_i);
		$fwrite(outfile, "EW Yellow light status: %d\n", yellow_eastwest_i);
		$fwrite(outfile, "EW Red light status: %d\n", red_eastwest_i); 
		$fwrite(outfile, "N vehicle count: %d\n", vcount_northbound_o);
		$fwrite(outfile, "S vehicle count: %d\n", vcount_southbound_o);
		$fwrite(outfile, "E vehicle count: %d\n", vcount_eastbound_o);
		$fwrite(outfile, "W vehicle count: %d\n\n", vcount_westbound_o);	


		@(negedge clock_i);
		ped_button_ew_o = 1'b1;
		@(negedge clock_i);
		$fwrite(outfile,"The EW pedestrian button was press at %0d \n\n", $time);  
		@(posedge clock_i);
    ped_button_ew_o = 1'b0;
    $fwrite(outfile, "The current time is:%0d us\n" ,$time);
    $fwrite(outfile, "The NS Green light counter is %d\n", transition_count_i);
		$fwrite(outfile, "NS Green light status: %d\n", green_northsouth_i); 
		$fwrite(outfile, "NS Yellow light status: %d\n", yellow_northsouth_i);
		$fwrite(outfile, "NS Red light status: %d\n", red_northsouth_i); 
		$fwrite(outfile, "EW Green light status: %d\n", green_eastwest_i);
		$fwrite(outfile, "EW Yellow light status: %d\n", yellow_eastwest_i);
		$fwrite(outfile, "EW Red light status: %d\n", red_eastwest_i); 
		$fwrite(outfile, "N vehicle count: %d\n", vcount_northbound_o);
		$fwrite(outfile, "S vehicle count: %d\n", vcount_southbound_o);
		$fwrite(outfile, "E vehicle count: %d\n", vcount_eastbound_o);
		$fwrite(outfile, "W vehicle count: %d\n\n", vcount_westbound_o);    
    
    repeat (50) @(posedge clock_i); 
    vcount_northbound_o = 3'd4;
    vcount_southbound_o = 3'd2;
    
    $fwrite(outfile, "The current time is:%0d us\n" ,$time);
    $fwrite(outfile, "The NS Green light counter is %d\n", transition_count_i);
		$fwrite(outfile, "NS Green light status: %d\n", green_northsouth_i); 
		$fwrite(outfile, "NS Yellow light status: %d\n", yellow_northsouth_i);
		$fwrite(outfile, "NS Red light status: %d\n", red_northsouth_i); 
		$fwrite(outfile, "EW Green light status: %d\n", green_eastwest_i);
		$fwrite(outfile, "EW Yellow light status: %d\n", yellow_eastwest_i);
		$fwrite(outfile, "EW Red light status: %d\n", red_eastwest_i); 
		$fwrite(outfile, "N vehicle count: %d\n", vcount_northbound_o);
		$fwrite(outfile, "S vehicle count: %d\n", vcount_southbound_o);
		$fwrite(outfile, "E vehicle count: %d\n", vcount_eastbound_o);
		$fwrite(outfile, "W vehicle count: %d\n\n", vcount_westbound_o);
    
    repeat (150) @(posedge clock_i);
    vcount_northbound_o = 3'd0;
    vcount_southbound_o = 3'd0;
    
    $fwrite(outfile, "The current time is:%0d us\n" ,$time);
    $fwrite(outfile, "The NS Green light counter is %d\n", transition_count_i);
		$fwrite(outfile, "NS Green light status: %d\n", green_northsouth_i); 
		$fwrite(outfile, "NS Yellow light status: %d\n", yellow_northsouth_i);
		$fwrite(outfile, "NS Red light status: %d\n", red_northsouth_i); 
		$fwrite(outfile, "EW Green light status: %d\n", green_eastwest_i);
		$fwrite(outfile, "EW Yellow light status: %d\n", yellow_eastwest_i);
		$fwrite(outfile, "EW Red light status: %d\n", red_eastwest_i); 
		$fwrite(outfile, "N vehicle count: %d\n", vcount_northbound_o);
		$fwrite(outfile, "S vehicle count: %d\n", vcount_southbound_o);
		$fwrite(outfile, "E vehicle count: %d\n", vcount_eastbound_o);
		$fwrite(outfile, "W vehicle count: %d\n\n", vcount_westbound_o);    

		$fclose(outfile);
		
	end
endmodule
