module uart_rx(
	input rx_sclk_i,
	input rx_data_i,
	input rx_srst_n_i,
	input pclk_i,
	input prst_n_i,
	output reg [8:0] wdata_o, //Data plus error plus stop bit
	output winc_o             //write enable for data
);

	reg [9:0] sample_data; //Does Not include start bit, Does inlcude data plus tx parity

	localparam [2:0] idle = 3'd0,
									 initial_wait = 3'd1,
									 sample = 3'd2,
									 wait_to_sample = 3'd3,
									 write_to_fifo = 3'd4;           

	reg [3:0] sample_counter;         
	reg [3:0] bit_index;

	localparam [3:0] count_6 = 4'd6, count_10 = 4'd10, all_bits_received = 4'd9;	

  reg [4:0] state;
  reg [4:0] next_state;  
	
	always@(*)
    begin
		wdata_o = 9'd0;	
      next_state = 5'b0_0000; 
      case(1'b1) // synthesis parallel_case
        state[idle]:if(rx_data_i == 0) next_state[initial_wait] = 1'b1;
									  else
											begin
												next_state[idle] = 1'b1;
												wdata_o = 9'd0;
											end
				state[initial_wait]:if(sample_counter == count_10) next_state[sample] = 1'b1;
														else next_state[initial_wait] = 1'b1;
				state[sample]: next_state[wait_to_sample] = 1'b1;
				state[wait_to_sample]:if(sample_counter == count_6) next_state[sample] = 1'b1;
														  else if(bit_index == all_bits_received)
																begin 
																	next_state[write_to_fifo] = 1'b1;
																	wdata_o[8] = sample_data[8]^(~^sample_data[7:0]);	
																 	wdata_o[7:0] = sample_data[7:0]; 																
																end
															else next_state[wait_to_sample] = 1'b1;				
				state[write_to_fifo]: next_state[idle] = 1'b1;
			default: begin
							next_state[idle] = 1'b1;
							wdata_o = 9'd0;							
						end
				
			endcase
		end //always

assign winc_o = state[write_to_fifo];

	always@(posedge rx_sclk_i)
		if(!rx_srst_n_i) state <= 5'b0_0001;
			else state <= next_state;

	always@(posedge rx_sclk_i)
		if(!rx_srst_n_i) sample_counter <= 4'd0;
		  else if(state[sample] || state[write_to_fifo]) sample_counter <= 4'd0;
    		  else if (state[initial_wait] || state[wait_to_sample]) sample_counter <= sample_counter + 4'd1;

	always@(posedge rx_sclk_i)
		if(!rx_srst_n_i | state[write_to_fifo]) bit_index <= 4'd0; 
			else if ((state[wait_to_sample]) && (sample_counter == count_6)) bit_index <= bit_index + 4'd1;
			  
	always@(posedge rx_sclk_i)
	 if(!rx_srst_n_i) sample_data <= 10'b00_0000_0000;
	   else if (state[sample]) sample_data[bit_index] <= rx_data_i;	// keeps old values after transmit consider a reset
			else if (state[idle]) sample_data <= 10'b00_0000_0000;

	     //else // no else condition? I am leaning towards no	 

endmodule
