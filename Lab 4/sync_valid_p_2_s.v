module sync_valid_p_2_s(
	input tx_sclk_n_i,
	input tx_srst_n_i,
	input tx_pdata_valid_i,
	output reg tx2_pdata_valid_o
);

reg tx1_pdata_valid_o;

always@(posedge tx_sclk_n_i)
	if(!tx_srst_n_i)
		begin
			tx2_pdata_valid_o <= 1'b0;
			tx1_pdata_valid_o <= 1'b0;
		end
	else
		begin
			tx2_pdata_valid_o <= tx1_pdata_valid_o;
			tx1_pdata_valid_o	<= tx_pdata_valid_i;
		end

endmodule