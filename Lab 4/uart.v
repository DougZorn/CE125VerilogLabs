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




endmodule
