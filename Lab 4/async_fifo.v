
module async_fifo #
  (
   parameter FIFO_WIDTH = 32, // Width of FIFO RAM
   parameter FIFO_DEPTH = 16, // Depth of FIFO RAM
   parameter ADDR_WIDTH = 4  // Number of address bits for RAM
   )
  (
   // Write-side interface
   input write_clock_i,         // Write clock, posedge used
   input write_reset_n_i,       // Reset in the write clock domain: active low, synchronous
   input [FIFO_WIDTH-1:0] write_data_i, // Data from upstream
   input write_data_valid_i,    // Valid for write data
   output reg write_ready_o,    // Ready to external logic
   // Read-side interface
   input read_clock_i,         // Read clock, posedge used
   input read_reset_n_i,       // Reset in the read clock domain: active low, synchronous
   output reg [FIFO_WIDTH-1:0] read_data_o, // Data to downstream logic
   output reg read_data_valid_o,    // Valid for read data
   input read_ready_i         // Ready from downstream logic   
   );


   reg [ADDR_WIDTH:0]               write_ptr; // Write pointer (extra bit added for full/empty disambiguation)
   reg [ADDR_WIDTH:0] 		    write_ptr_read_clk; // Write pointer synchronized to the read clock domain
   reg [ADDR_WIDTH:0]               read_ptr; // Read pointer (extra bit added for full/empty disambiguation)
   reg [ADDR_WIDTH:0] 		    read_ptr_write_clk; // Read pointer synchronized to the write clock domain
   wire [ADDR_WIDTH:0] 		    read_side_occupancy; // Number of words in the FIFO as seen from read side
   wire [ADDR_WIDTH:0] 		    write_side_occupancy;// Number of words in the FIFO as seen from write side

   reg [ADDR_WIDTH:0] 		    write_ptr_gray; // Write pointer converted to Gray code
   wire [ADDR_WIDTH:0] 		    write_ptr_gray_read_clk; // Gray-coded write pointer synchronized to the read clock domain
   reg [ADDR_WIDTH:0] 		    read_ptr_gray; // Read pointer converted to Gray code
   wire [ADDR_WIDTH:0] 		    read_ptr_gray_write_clk; // Gray-coded read pointer synchronized to the write clock domain

   wire 			    fifo_full;
   wire 			    fifo_almost_full;
   wire 			    fifo_empty;

   reg [FIFO_WIDTH-1:0] 	    ram[FIFO_DEPTH-1:0]; // Memory

 //*******************************************************************************
 // Write-Side Logic
 //*******************************************************************************

 // Subtract the value of read pointer (synchronized to the write clock domain) from
 // the write pointer to determine the FIFO occupancy.

   assign 			    write_side_occupancy = write_ptr- read_ptr_write_clk;

   // Generate FIFO full condition.
   assign 	      fifo_full = write_side_occupancy[ADDR_WIDTH] &&
		      (write_side_occupancy[ADDR_WIDTH-1:0] == {ADDR_WIDTH{1'b0}});

   // Because write_ready is registered, we need to signal the full condition to upstream logic when the FIFO reaches
   // one less than its maximum capacity, so as to avoid overflows.
   // Generate an "almost full" signal for this purpose.
   assign 	      fifo_almost_full = fifo_full ||
		      (~write_side_occupancy[ADDR_WIDTH] &&
		       (write_side_occupancy[ADDR_WIDTH-1:0] == {ADDR_WIDTH{1'b1}}));

   // Generate ready to upstream logic.
   always @(posedge write_clock_i)
     if (~write_reset_n_i)
       write_ready_o <= 1'b0;
     else
       write_ready_o <= fifo_almost_full;

   // Write pointer
   always @(posedge write_clock_i)
     if (~write_reset_n_i)
       write_ptr <= {(ADDR_WIDTH+1){1'b0}};
     else if (~fifo_full & write_data_valid_i)
       write_ptr <= write_ptr + {{ADDR_WIDTH{1'b0}}, 1'b1};

  // Write into RAM 
   always @(posedge write_clock_i)
     if (write_data_valid_i)
       ram[write_ptr[ADDR_WIDTH-1:0]] <= write_data_i;

   // Convert write pointer to Gray code
   always @(posedge write_clock_i)
     if (~write_reset_n_i)
       write_ptr_gray <= {ADDR_WIDTH+1{1'b0}};
     else
       write_ptr_gray <= binary_to_gray(write_ptr);

   // Receive Gray-coded read pointer value from read side and synchronize it to write clock
   
   sync #(ADDR_WIDTH+1) sync_read_ptr(.clock_i(write_clock_i),
			    .reset_n_i(write_reset_n_i),
			    .din(read_ptr_gray),
			    .dout(read_ptr_gray_write_clk)
			    );

   //Convert read pointer value from Gray code back to binary
   always @(posedge write_clock_i)
     if (~write_reset_n_i)
       read_ptr_write_clk <= {ADDR_WIDTH+1{1'b0}};
     else
       read_ptr_write_clk <= gray_to_binary(read_ptr_gray_write_clk);

 //*******************************************************************************
 // Read-Side Logic
 //*******************************************************************************

   // Maintain read-side occupancy
   assign 	      read_side_occupancy = (write_ptr_read_clk - read_ptr);

  // Generate fifo empty condition
   assign 	      fifo_empty = (read_side_occupancy == {(ADDR_WIDTH+1){1'b0}});

   // Read data into output register when (i) FIFO is not empty and (ii) at least
   // one of the following conditions is true:
   // (a) The output register is empty.
   // (b) The downstream logic has asserted ready.
  always @(posedge read_clock_i)
    if (~read_reset_n_i)
      read_data_o <= {FIFO_WIDTH{1'b0}};
    else if ((~read_data_valid_o | read_ready_i) & ~fifo_empty)
      read_data_o <= ram[read_ptr];
   
   // Generate valid for read data
   always @(posedge read_clock_i)
     if (~read_reset_n_i)
       read_data_valid_o <= 1'b0;
     else if (~read_data_valid_o | read_ready_i)
       read_data_valid_o <= ~fifo_empty;

   // Read pointer
   always @(posedge read_clock_i)
     if (~read_reset_n_i)
       read_ptr <= {ADDR_WIDTH+1{1'b0}};
     else if ((~read_data_valid_o | read_ready_i) & ~fifo_empty)
       read_ptr <= read_ptr + {{(ADDR_WIDTH-1){1'b0}}, 1'b1};
   
   // Convert read pointer to Gray code
   always @(posedge read_clock_i)
     if (~read_reset_n_i)
       read_ptr_gray <= {ADDR_WIDTH+1{1'b0}};
     else
       read_ptr_gray <= binary_to_gray(read_ptr);

   // Receive Gray-coded write pointer value from write side and synchronize it to read clock
   
   sync #(ADDR_WIDTH+1) sync_wr_ptr (.clock_i(read_clock_i),
			   .reset_n_i(read_reset_n_i),
			   .din(write_ptr_gray),
			   .dout(write_ptr_gray_read_clk)
			   );

   //Convert write pointer value from Gray code back to binary
   always @(posedge read_clock_i)
     if (~read_reset_n_i)
       write_ptr_read_clk <= {ADDR_WIDTH+1{1'b0}};
     else
       write_ptr_read_clk <= gray_to_binary(write_ptr_gray_read_clk);
   
   //*******************************************************************************//
   // Function to convert binary to Gray code
   //*******************************************************************************//
   function [ADDR_WIDTH:0] binary_to_gray;
      input [ADDR_WIDTH:0] din;
      begin
	 binary_to_gray = din ^ (din >> 1);
      end
   endfunction // binary_to_gray

   
   //*******************************************************************************//
   // Function to convert Gray code to binary
   //*******************************************************************************//
   function [ADDR_WIDTH:0] gray_to_binary;
      input [ADDR_WIDTH:0] din;
      reg [ADDR_WIDTH:0] dout;
      integer i1, j1;
      
      begin
	 for (i1 =0; i1<= ADDR_WIDTH; i1=i1+1)
	   begin
	      dout[i1] =  din[i1];
	      for (j1 =i1+1; j1<= ADDR_WIDTH; j1=j1+1)
		dout[i1] =  dout[i1] ^ din[j1];
	   end
	 gray_to_binary = dout;
      end
   endfunction // gray_to_binary
   
endmodule

//*******************************************************************************//
// 2-stage Synchronizer module
//*******************************************************************************//

module sync
  #(parameter WIDTH = 5)
    (
     input clock_i,
     input reset_n_i,
     input [WIDTH-1:0] din,
     output reg [WIDTH-1:0] dout
     );

   reg [WIDTH-1:0] d1;

   always @(posedge clock_i)
     if (~reset_n_i)
       begin
	  d1 <= {WIDTH{1'b0}};
	  dout <= {WIDTH{1'b0}};
       end
     else
       begin
	  d1 <= din;
	  dout <= d1;
       end
endmodule // sync
//*******************************************************************************//

	  
	  
     
