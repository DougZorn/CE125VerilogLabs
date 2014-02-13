`timescale 1us/100ns
//fsm
module fsm(
//INPUT SIGNALS 
//signal comes from module clock_gen
  input clock_i,
//Signals come from module test_bench
  input reset_n_i,
  input [2:0] vcount_northbound_i,
  input [2:0] vcount_southbound_i,
  input [2:0] vcount_eastbound_i,
  input [2:0] vcount_westbound_i,
  input ped_button_ns_i,
  input ped_button_ew_i,
  input test_mode_i,
//OUTPUT SIGNALS to test_bench
//North and South Lights
  output reg green_northsouth_o, //high on reset
  output reg red_northsouth_o, //low on reset
  output reg yellow_northsouth_o, //low on reset
//East and West Lights
  output reg green_eastwest_o, //low on reset
  output reg red_eastwest_o, //low on reset
  output reg yellow_eastwest_o, //low on reset
//Northbound green count
  output reg [15:0] transition_count_o
);

  localparam [2:0] ns_green_ew_red = 3'd0,  //Green light for NS and Red light for EW
                   ped_ew = 3'd1,           //ES pedestrian signal
                   ns_yellow = 3'd2,        //Yellow light for NS
                   red_delay_ns = 3'd3,     //Red light with one second delay
                   ew_green_ns_red = 3'd4,  //Green light for EW and Red light for NS
                   ped_ns = 3'd5,           //NS pedestrian signal
                   ew_yellow = 3'd6,        //Yellow light for EW
                   red_delay_ew = 3'd7;     //Red light with one second delay
                    

  reg [7:0] state;
  reg [7:0] next_state;
  
  //reg [2:0] car_count_ns = vcount_northbound_i + vcount_southbound_i; //this needs to be reset and not driven by two different drivers
  
  reg [2:0] car_count_ns;
  reg [2:0] car_count_ew;
  reg [16:0] two_minute_30_second_timer;
  reg [10:0] two_second_one_second_yellow_delay;   
  
  
  always@(*)
    begin
      next_state = 8'b0000_0000; //I don't think this needs to be reset since it is a combinational block that executes sequentially but it is a reg, soooo...
      case(1'b1) // synthesis parallel_case
        state[ns_green_ew_red]: if((two_minute_30_second_timer >= 16'd120_000) | (car_count_ew >= 3'd6)) next_state[ns_yellow] = 1'b1;
                                  else if (ped_button_ew_i == 1'b1) next_state[ped_ew] = 1'b1; //you may need to investigate this further due to how the pedestrian pulse works/ how long it lasts
                                    else next_state[ns_green_ew_red] = 1'b1;  
        state[ped_ew]: if ((two_minute_30_second_timer >= 16'd30_000) | (car_count_ew >= 3'd6)) next_state[ns_yellow] = 1'b1;
                        else next_state[ped_ew] = 1'b1;
        state[ns_yellow]: if(two_second_one_second_yellow_delay >= 11'd2000) next_state[red_delay_ns] = 1'b1;
                            else next_state[ns_yellow] = 1'b1;
        state[red_delay_ns]: if(two_second_one_second_yellow_delay >= 11'd3000) next_state[ew_green_ns_red] = 1'b1;
                              else next_state[red_delay_ns] =1'b1;
        state[ew_green_ns_red]: if ((two_minute_30_second_timer >= 16'd30_000) | (car_count_ns >= 3'd6)) next_state[ew_yellow] = 1'b1;
                                  else if (ped_button_ns_i == 1'b1) next_state[ped_ns] = 1'b1; //you may need to investigate this further due to how the pedestrian pulse works/ how long it lasts
                                    else next_state[ew_yellow] = 1'b1; 
        state[ped_ns]: if ((two_minute_30_second_timer >= 16'd30_000) | (car_count_ns >= 3'd6)) next_state[ew_yellow] = 1'b1;
                        else next_state[ped_ns] = 1'b1;
        state[ew_yellow]: if(two_second_one_second_yellow_delay >= 11'd2000) next_state[red_delay_ew] = 1'b1;
                            else next_state[ew_yellow] = 1'b1;
        state[red_delay_ew]: if(two_second_one_second_yellow_delay >= 11'd3000) next_state[ns_green_ew_red] = 1'b1;
                              else next_state[red_delay_ew] = 1'b1;     
      endcase 
    end // always
    
  always@(posedge clock_i)
    if(reset_n_i)
      begin
        state <= 8'b0000_0001;
        //Module outputs set to reset default
        green_northsouth_o <= 1'b1;          
        red_northsouth_o <= 1'b0;
        yellow_northsouth_o <= 1'b0;   
        green_eastwest_o <= 1'b0;   
        red_eastwest_o <= 1'b0;
        yellow_eastwest_o <= 1'b0;
        transition_count_o[15:0] <=16'h0000;
      end      
    else
      begin
        state <= next_state;
        green_northsouth_o <= state[ns_green_ew_red] | state[ped_ew]; 
        red_northsouth_o <= state[red_delay_ns] | state[ew_green_ns_red] | state[ped_ns] | state[ew_yellow] | state[red_delay_ew];
        yellow_northsouth_o <= state[ns_yellow];
        green_eastwest_o <= state[ew_green_ns_red] | state[ped_ns];
        red_eastwest_o <= state[ns_green_ew_red] | state[red_delay_ew] ;
        yellow_eastwest_o <= state[ew_yellow];
        //transition_count_o[15:0] <= 16'd0;  // you need to still increment this somehow only once. a mealy would work just fine I think but think about the clock issue.
      end

	always @(posedge clock_i)
		if (~reset_n_i | red_delay_ew | red_delay_ns)	two_minute_30_second_timer <= 17'd0;
			else two_minute_30_second_timer <= two_minute_30_second_timer + 1;

	always@(posedge clock_i)
		if (~reset_n_i)
			begin
	    	car_count_ns <= 3'd0;
				car_count_ew <= 3'd0;  
			end
		else
			begin
				car_count_ns <= vcount_northbound_i + vcount_southbound_i;
				car_count_ew <= vcount_eastbound_i + vcount_westbound_i;			
			end      

endmodule



