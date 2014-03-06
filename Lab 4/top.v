`timescale 1ns/100ps
module top(
);

wire p_clk_w;
wire tx_sclk_w;
wire rx_sclk_w;
wire prst_n_w;
wire tx_srst_n_w;
wire tx_pdata_valid_w;
wire [7:0] tx_pdata_w;
wire tx_2_rx_s_data_w;
wire [9:0] wdata_w;
wire winc_w;
wire rx_srst_n_w;
wire tx_pready_w;
wire master_rst_w;

clock_gen #(.CLOCK_PERIOD(1000)) clock_gen_p_clk_0 (.clock_i(p_clk_w));
clock_gen #(.CLOCK_PERIOD(100)) clock_gen_tx_sclk_0 (.clock_i(tx_sclk_w));
clock_gen #(.CLOCK_PERIOD(12.5)) clock_gen_rx_sclk_0 (.clock_i(rx_sclk_w));

test_bench test_bench_0(
	.tx_pdata_o(tx_pdata_w),
	.tx_pdata_valid_o(tx_pdata_valid_w),
	.p_clk_i(p_clk_w),
	.tx_sclk_i(tx_sclk_w),
	.rx_sclk_i(rx_sclk_w),
	//.rx_srst_n_o(rx_srst_n_w),
	//.prst_n_o(prst_n_w),
	//.tx_srst_n_o(tx_srst_n_w)
	.master_rst_o(master_rst_w)
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
