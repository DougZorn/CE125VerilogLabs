`timescale 1ns/100ps
module test_bench(
	input p_clk_i,
	input tx_sclk_i,
	input rx_sclk_i,
	output reg master_rst_o,
	output reg read_ready_o,
	//output reg prst_n_o,
	//output reg rx_srst_n_o, 
	//output reg tx_srst_n_o,
	output reg tx_pdata_valid_o,
	output reg [7:0] tx_pdata_o
);

initial
	begin
		tx_pdata_valid_o = 1'b0; //initial values
		read_ready_o = 1'b0;

		master_rst_o = 1'b1;
		@(negedge p_clk_i);
		master_rst_o = 1'b0;
		repeat (2) @(negedge p_clk_i);
		master_rst_o = 1'b1;
/*
		prst_n_o = 1'b1;
		@(negedge p_clk_i);
		prst_n_o = 1'b0;
		repeat (2) @(negedge p_clk_i);
		prst_n_o = 1'b1;

		repeat (4) @(posedge p_clk_i);
		tx_pdata_o = 8'd197;
	
		tx_pdata_valid_o = 1'b1;
		@(negedge tx_sclk_i);
		tx_pdata_valid_o = 1'b0;
		

		repeat (2) @(negedge rx_sclk_i);
		rx_srst_n_o = 1'b1;
		@(negedge rx_sclk_i);
		rx_srst_n_o = 1'b0;
		@(negedge rx_sclk_i);
		rx_srst_n_o = 1'b1;
		*/
		
		repeat (2) @(posedge p_clk_i);
		
		
		
		@(negedge p_clk_i);
		tx_pdata_o = 8'd197;
		tx_pdata_valid_o = 1'b1;

		read_ready_o = 1'b1;


		repeat(11)@(posedge tx_sclk_i);
		tx_pdata_o = 8'd97;

		repeat(11)@(negedge tx_sclk_i);
		tx_pdata_o = 8'd64;
		read_ready_o = 1'b0;

		repeat(11)@(negedge tx_sclk_i);
		tx_pdata_o = 8'd12;

		repeat(11)@(negedge tx_sclk_i);
		tx_pdata_o = 8'd254;
		
		@(posedge p_clk_i);
		tx_pdata_valid_o = 1'b0;

		repeat(11)@(posedge p_clk_i);
		read_ready_o = 1'b1;
	 	repeat(2)@(posedge p_clk_i);
		read_ready_o = 1'b0;


		
		
		//@(negedge p_clk_i);
		//tx_pdata_valid_o = 1'b0;


	end //initial
endmodule
