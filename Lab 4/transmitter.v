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

wire tx2_pdata_valid_w;

sync_valid_p_2_s sync_valid_p_2_s_0(
	.tx_sclk_n_i(tx_sclk_i),
	.tx_srst_n_i(tx_srst_n_i),
	.tx_pdata_valid_i(tx_pdata_valid_i),
	.tx2_pdata_valid_o(tx2_pdata_valid_w)
);




endmodule


