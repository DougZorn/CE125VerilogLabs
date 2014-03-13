module uart(
  input master_reset,
  //Transmitter  
  input [7:0]tx_pdata_i,
  input pdata_valid_i,
  input CLK_IN1,
  output tx_pready_o,
  output tx_sdata_o,
  //Receiver   
  input rx_sdata_i,
  input read_ready_i, // downstream logic into FIFO p read
  output [7:0] rx_pdata_o, // reg?
  output rx_pdata_valid_o,
  output rx_pdata_err_o
);

//clocks
wire clk1_w;
wire p_clk_w;
wire tx_sclk_w;
wire rx_sclk_w;
//resets
wire master_rst_w;

clockgen test(
	.CLK_IN1(CLK_IN1),	
	.CLK_OUT1(clk1_w), // not used
	.CLK_OUT2(tx_sclk_w),
	.CLK_OUT3(rx_sclk_w),
	.CLK_OUT4(p_clk_w)
);

//tx input
wire [7:0] tx_pdata_w;
assign tx_pdata_w = tx_pdata_i;
wire  pdata_valid_w;
assign pdata_valid_w = pdata_valid_i;
//tx output
wire tx_pready_w;
assign tx_pready_o = tx_pready_w; // for upstream logic

//rx input

wire [8:0] wdata_w; //to async fifo then output
wire winc_w; // to async fifo 

wire [8:0] read_data_plus_parity_w;
assign rx_pdata_o = read_data_plus_parity_w[7:0];
assign rx_pdata_err_o = read_data_plus_parity_w[8];

uart_tx uart_tx_0(
	.pclk_i(p_clk_w),
	.prst_n_i(master_rst_w),
	.tx_pdata_i(tx_pdata_w),
	.tx_pdata_valid_i(tx_pdata_valid_w),
	.tx_sclk_i(tx_sclk_w),
	.tx_srst_n_i(master_rst_w),
	.tx_sdata_o(tx_sdata_o),
	.tx_pready_o(tx_pready_w)	
);

uart_rx uart_rx_0(
	.rx_sclk_i(rx_sclk_w),
	.rx_data_i(rx_sdata_i),
	.rx_srst_n_i(master_rst_w),
	.wdata_o(wdata_w), 
	.winc_o(winc_w),
	.pclk_i(p_clk_w),
	.prst_n_i(master_rst_w)       
);

async_fifo #(.FIFO_WIDTH(9),.FIFO_DEPTH(128),.ADDR_WIDTH(7)) asycn_fifo_0 ( //change this width to 9 once you get rid of the stop bit 
	.write_clock_i(rx_sclk_w),         // Write clock, posedge used in this case 80MHz
	.write_reset_n_i(master_rst_w),       // Reset in the write clock domain: active low, synchronous
	.write_data_i(wdata_w), // Data from upstream [FIFO_WIDTH-1:0] 
  .write_data_valid_i(winc_w),    // Valid for write data
	.write_ready_o(write_ready_w),    // Ready to external logic, but in this case that is the UART Rx?////////////////////////////////////////////////////////////////////////////////revist me
   // Read-side interface
  .read_clock_i(p_clk_w),         //Read clock, posedge used 1MHz
  .read_reset_n_i(master_rst_w),       // Reset in the read clock domain: active low, synchronous
  .read_data_o(read_data_plus_parity_w), // Data to downstream logic [FIFO_WIDTH-1:0]
  .read_data_valid_o(rx_pdata_valid_o),    // Valid for read data
  .read_ready_i(read_ready_i) // downstream logic ready to receive data
);

endmodule
