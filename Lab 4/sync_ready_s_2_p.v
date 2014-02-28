module sync_ready_s_2_p(
	input pclk_i,
	input prst_n_i,
	input tx_pready_i,
	output reg tx2_pready_o

);
reg tx1_pready_o;

always@(posedge pclk_i)
	if(!prst_n_i)
		begin
			tx2_pready_o <= 1'b0;
			tx1_pready_o <= 1'b0;
		end
	else
		begin
			tx2_pready_o <= tx1_pready_o;
			tx1_pready_o	<= tx_pready_i;
		end

endmodule
