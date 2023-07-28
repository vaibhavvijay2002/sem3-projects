module shifter(input wire [15:0] in, input wire shift_dir, shift, output wire [15:0] out);
   assign out = (shift == 0? in : (shift_dir == 0? in << 1 : in >> 1));
endmodule // shifter

module mux2_3(input wire [2:0] i1, i2, input wire s, output wire [2:0] o);
   assign o = (s == 0? i1 : i2);
endmodule // mux2_3

module reg_shifter(input wire 	  clk, reset, wr, shift_dir, shift,
		   input wire [2:0]   rd_addr_a, rd_addr_b, wr_addr,
		   input wire [15:0]  d_in,
		   output wire [15:0] d_out_a, d_out_b);
   wire [15:0] 			      r_d_in, s_out;
   wire [2:0] 			      r_w_a;
   wire 			      r_wr;

   mux2_16 data(d_in, s_out, shift, r_d_in);
   mux2_3 addr(wr_addr, rd_addr_a, shift, r_w_a);
   assign r_wr = wr | shift;
   shifter s(d_out_a, shift_dir, shift, s_out);
   reg_file r(clk, reset, r_wr, rd_addr_a, rd_addr_b, r_w_a, r_d_in, d_out_a, d_out_b);

endmodule // reg_shifter
