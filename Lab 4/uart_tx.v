module uart_tx(
	input pclk_i,
	input prst_n_i,
	input [7:0] tx_pdata_i,
	input tx_pdata_valid_i,
	input tx_sclk_i,
	input tx_srst_n_i,
	output reg tx_sdata_o,
	output tx_pready_o
);

wire tx2_pdata_valid_w;

sync_valid_p_2_s sync_valid_p_2_s_0(
	.tx_sclk_n_i(tx_sclk_i),
	.tx_srst_n_i(tx_srst_n_i),
	.tx_pdata_valid_i(tx_pdata_valid_i),
	.tx2_pdata_valid_o(tx2_pdata_valid_w)
);


	localparam [1:0] idle = 2'b0, transfer = 2'b1;
	reg [1:0] state;
   reg [1:0] next_state;
	reg [3:0] transfer_index_count; //sync reset
	reg [10:0] s_data;

	always@(*)
    begin
      next_state = 2'b00;
		tx_sdata_o = 1'b1;
		s_data = 11'd0;
      case(1'b1) // synthesis parallel_case
				state[idle]: if(tx2_pdata_valid_w & tx_pready_o) // this is the synchronized p to s valid
											begin
												next_state[transfer] = 1'b1; 
												s_data[4'd0] = 1'b0; 
												s_data[4'd1] = tx_pdata_i[3'd0];
												s_data[4'd2] = tx_pdata_i[3'd1];
												s_data[4'd3] = tx_pdata_i[3'd2];
												s_data[4'd4] = tx_pdata_i[3'd3];
												s_data[4'd5] = tx_pdata_i[3'd4];
												s_data[4'd6] = tx_pdata_i[3'd5];
												s_data[4'd7] = tx_pdata_i[3'd6];
												s_data[4'd8] = tx_pdata_i[3'd7];
												s_data[4'd9] = ~^tx_pdata_i ;
												s_data[4'd10] = 1'b1;							
											end
										 	else
												begin
													tx_sdata_o = 1'b1;
													next_state[idle] = 1'b1;
												end
				state[transfer]: if (transfer_index_count < 4'd9)
												 	begin
												 		next_state[transfer] = 1'b1;												
														tx_sdata_o = s_data[transfer_index_count];
													end
												else
													begin
														next_state[idle] = 1'b1;
														tx_sdata_o = s_data[transfer_index_count];
													end
				default: begin
								next_state[idle] = 1'b1;
								tx_sdata_o = 1'b1;
								s_data = 11'd0;
							end
				endcase
		end//always	 

assign tx_pready_o = state[idle];

	always@(posedge tx_sclk_i)
		if(!tx_srst_n_i) state <= 2'b01;
		else state <= next_state;

/*	always@(posedge tx_sclk_i)
		if(!tx_srst_n_i) tx_pready_o <= 1'b0;
		else tx_pready_o <= state[idle];
*/
	always@(posedge tx_sclk_i)
		if(!tx_srst_n_i) transfer_index_count <= 3'd0;
		 else if (state[transfer]) transfer_index_count <= transfer_index_count + 3'd1;
		  else transfer_index_count <= 3'd0;


endmodule



