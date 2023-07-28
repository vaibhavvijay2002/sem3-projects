module mux2_16 (input wire [15:0] i0, i1, input wire j, output wire [15:0] o);
  assign o = (j==0)? i0 : i1;
endmodule

module mux4_16 (input wire [15:0] i0, i1, i2, i3,
	     input wire j0, j1, output wire [15:0] o);
  wire [15:0] t0, t1;
  mux2_16 mux2_0 (i0, i1, j1, t0);
  mux2_16 mux2_1 (i2, i3, j1, t1);
  mux2_16 mux2_2 (t0, t1, j0, o);
endmodule

module mux8_16 (input wire [15:0] i [0:7],
		input wire [0:2]   j,
		output wire [15:0] o);
   wire [15:0] t0, t1;
   mux4_16 mux4_0 (i[0], i[1], i[2], i[3], j[1], j[2], t0);
   mux4_16 mux4_1 (i[4], i[5], i[6], i[7], j[1], j[2], t1);
   mux2_16 mux2_0 (t0, t1, j[0], o);
endmodule // mux8_16

module d_ff (input wire d, clk, w_enable, output reg o);
   reg q;
   always @(posedge clk) begin
      if (w_enable) q <= d;
   end
   assign o = q;
endmodule // d_ff

module reg_16b (input wire [15:0] d,
		input wire  clk, enable,
		output wire [15:0] q);

   d_ff dffinst_0 (d[0], clk, enable, q[0]);
   d_ff dffinst_1 (d[1], clk, enable, q[1]);
   d_ff dffinst_2 (d[2], clk, enable, q[2]);
   d_ff dffinst_3 (d[3], clk, enable, q[3]);
   d_ff dffinst_4 (d[4], clk, enable, q[4]);
   d_ff dffinst_5 (d[5], clk, enable, q[5]);
   d_ff dffinst_6 (d[6], clk, enable, q[6]);
   d_ff dffinst_7 (d[7], clk, enable, q[7]);
   d_ff dffinst_8 (d[8], clk, enable, q[8]);
   d_ff dffinst_9 (d[9], clk, enable, q[9]);
   d_ff dffinst_10 (d[10], clk, enable, q[10]);
   d_ff dffinst_11 (d[11], clk, enable, q[11]);
   d_ff dffinst_12 (d[12], clk, enable, q[12]);
   d_ff dffinst_13 (d[13], clk, enable, q[13]);
   d_ff dffinst_14 (d[14], clk, enable, q[14]);
   d_ff dffinst_15 (d[15], clk, enable, q[15]);

endmodule // reg_16b

module dem8(input wire in, input wire [0:2] s, output reg [0:7] out);

   always_comb begin
      if (in == 1'b1)
	case(s)
	  3'b000: out = 8'd1;
	  3'b001: out = 8'd2;
	  3'b010: out = 8'd4;
	  3'b011: out = 8'd8;
	  3'b100: out = 8'd16;
	  3'b101: out = 8'd32;
	  3'b110: out = 8'd64;
	  3'b111: out = 8'd128;
	endcase
      else out = 8'd0;
   end
   
endmodule // dem8

module reg_file (input wire 	    clk, reset, wr,
		 input wire [2:0]   rd_addr_a, rd_addr_b, wr_addr,
		 input wire [15:0]  d_in,
		 output wire [15:0] d_out_a, d_out_b);

   wire [7:0] 			    w_enb;
   wire [15:0] 			    q[7:0];

   dem8 w_mux(wr, wr_addr, w_enb);
   reg_16b r0(d_in, clk, w_enb[0], q[0]);
   reg_16b r1(d_in, clk, w_enb[1], q[1]);
   reg_16b r2(d_in, clk, w_enb[2], q[2]);
   reg_16b r3(d_in, clk, w_enb[3], q[3]);
   reg_16b r4(d_in, clk, w_enb[4], q[4]);
   reg_16b r5(d_in, clk, w_enb[5], q[5]);
   reg_16b r6(d_in, clk, w_enb[6], q[6]);
   reg_16b r7(d_in, clk, w_enb[7], q[7]);

   mux8_16 m_a(q, rd_addr_a, d_out_a);
   mux8_16 m_b(q, rd_addr_b, d_out_b);

endmodule //reg_file
