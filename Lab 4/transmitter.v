module transmitter(
	input pclk_i,
	input prst_n_i,
	input [7:0] tx_pdata_i,
	input tx_pdata_valid_i,
	input tx_sclk_i,
	input tx_srst_n_i,
	output reg tx_sdata_o,
	output reg tx_pready_o
);
endmodule