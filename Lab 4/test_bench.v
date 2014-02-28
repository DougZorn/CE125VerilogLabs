`timescale 1ns/100ps
module test_bench(
	input p_clk,
	input tx_sclk,
	output reg prst_n_o, 
	output reg tx_srst_n_o,
	output reg tx_pdata_valid_o
);

initial
	begin
		tx_pdata_valid_o = 1'b0; //initial values

		tx_srst_n_o = 1'b1;
		@(negedge tx_sclk);
		tx_srst_n_o = 1'b0;
		repeat (2) @(negedge tx_sclk);
		tx_srst_n_o = 1'b1;

		prst_n_o = 1'b1;
		@(negedge p_clk);
		prst_n_o = 1'b0;
		repeat (2) @(negedge p_clk);
		prst_n_o = 1'b1;

		repeat (4) @(posedge p_clk);
	
		tx_pdata_valid_o = 1'b1;
		@(negedge tx_sclk);
		tx_pdata_valid_o = 1'b0;
		


	end //initial
endmodule