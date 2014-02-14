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

		outfile = $fopen("C:/Users/Doug/Desktop/CE125VerilogLabs/Lab 3/lab3_out.dat");
    $fwrite(outfile, "Simulation output for Lab 3\n\n");
		reset_n_o = 1'b1;
		@(negedge clock_i);
		reset_n_o = 1'b0;
		repeat (2) @(negedge clock_i);
		reset_n_o = 1'b1;	
		test_mode_o = 1'b1;
 	  vcount_northbound_o = 2'd0;
	  vcount_southbound_o = 2'd0;
	  vcount_eastbound_o = 2'd0;
    vcount_westbound_o = 2'd1;
    ped_button_ns_o = 1'd0;
    ped_button_ew_o = 1'd0;

		#100	
		repeat (5) @(posedge clock_i);	
		$fwrite(outfile, "The current time is:%0d us\n" ,$time);
		$fwrite(outfile, "NS Green light status: %d\n", green_northsouth_i); 
		$fwrite(outfile, "NS Yellow light status: %d\n", yellow_northsouth_i);
		$fwrite(outfile, "NS Red light status: %d\n", red_northsouth_i); 
		$fwrite(outfile, "EW Green light status: %d\n", green_eastwest_i);
		$fwrite(outfile, "EW Yellow light status: %d\n", yellow_eastwest_i);
		$fwrite(outfile, "EW Red light status: %d\n", red_eastwest_i); 
		$fwrite(outfile, "N vehicle count: %d\n", vcount_northbound_o);
		$fwrite(outfile, "S vehicle count: %d\n", vcount_southbound_o);
		$fwrite(outfile, "E vehicle count: %d\n", vcount_eastbound_o);
		$fwrite(outfile, "W vehicle count: %d\n", vcount_westbound_o);

/*
		while(green_eastwest_i != 1)
			begin
			end
*/
		$fwrite(outfile, "The current time is:%0d us\n" ,$time);
		$fwrite(outfile, "NS Green light status: %d\n", green_northsouth_i); 
		$fwrite(outfile, "NS Yellow light status: %d\n", yellow_northsouth_i);
		$fwrite(outfile, "NS Red light status: %d\n", red_northsouth_i); 
		$fwrite(outfile, "EW Green light status: %d\n", green_eastwest_i);
		$fwrite(outfile, "EW Yellow light status: %d\n", yellow_eastwest_i);
		$fwrite(outfile, "EW Red light status: %d\n", red_eastwest_i); 
		$fwrite(outfile, "N vehicle count: %d\n", vcount_northbound_o);
		$fwrite(outfile, "S vehicle count: %d\n", vcount_southbound_o);
		$fwrite(outfile, "E vehicle count: %d\n", vcount_eastbound_o);
		$fwrite(outfile, "W vehicle count: %d\n", vcount_westbound_o);


    repeat (10) @(posedge clock_i);
    vcount_eastbound_o = 2'd1;
		repeat (10) @(posedge clock_i);

		@(negedge clock_i);
		ped_button_ns_o = 1'b1;
		@(negedge clock_i);
		@(posedge clock_i);
    ped_button_ns_o = 1'b0;  

		$fclose(outfile);
		$finish;
  
		
    //test_mode_o = 1'd0;
	end
endmodule