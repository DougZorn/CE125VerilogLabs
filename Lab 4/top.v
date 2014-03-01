`timescale 1ns/100ps
module top(

);

wire p_clk_w;
wire tx_sclk_w;
wire prst_n_w;
wire tx_srst_n_w;
wire tx_pdata_valid_w;
wire [7:0] tx_pdata_w;

clock_gen #(.CLOCK_PERIOD(1000)) clock_gen_p_clk_0 (.clock_i(p_clk_w));
clock_gen #(.CLOCK_PERIOD(100)) clock_gen_tx_sclk_0 (.clock_i(tx_sclk_w));

test_bench test_bench_0(
	.tx_pdata_o(tx_pdata_w),
	.tx_pdata_valid_o(tx_pdata_valid_w),
	.p_clk(p_clk_w),
	.tx_sclk(tx_sclk_w),
	.prst_n_o(prst_n_w),
	.tx_srst_n_o(tx_srst_n_w)
);

transmitter transmitter_0(
	.pclk_i(p_clk_w),
	.prst_n_i(prst_n_w),
	.tx_pdata_i(tx_pdata_w),
	.tx_pdata_valid_i(tx_pdata_valid_w),
	.tx_sclk_i(tx_sclk_w),
	.tx_srst_n_i(tx_srst_n_w),
	.tx_sdata_o(),
	.tx_pready_o()
);

endmodule