module uart(
  input master_reset,
  //Transmitter
  input pclk_i,
  input [7:0]tx_pdata_i,
  input pdata_valid,
  input tx_sclk_i,
  output tx_pready_o,
  output tx_sdata_o,
  //Receiver  
  input rx_sclk_i,
  input rx_sdata_i,
  output rx_pdata_i,
  output rx_pdata_valid_o,
  output rx_pdata_err_o
);


uart_tx uart_tx_0(
	.pclk_i(p_clk_w),
	.prst_n_i(master_rst_w),
	.tx_pdata_i(tx_pdata_w),
	.tx_pdata_valid_i(tx_pdata_valid_w),
	.tx_sclk_i(tx_sclk_w),
	.tx_srst_n_i(master_rst_w),
	.tx_sdata_o(tx_2_rx_s_data_w),
	.tx_pready_o(tx_pready_w)	
);

uart_rx uart_rx_0(
	.rx_sclk_i(rx_sclk_w),
	.rx_data_i(tx_2_rx_s_data_w),
	.rx_srst_n_i(master_rst_w),
	.wdata_o(wdata_w), 
	.winc_o(winc_w),
	.pclk_i(p_clk_w),
	.prst_n_i(master_rst_w)       
);

endmodule
