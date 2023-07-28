`timescale 1ns/100ps

module tb;
   reg [15:0] d_in, d_out_a, d_out_b;
   reg [2:0]  wr_addr, rd_addr_a, rd_addr_b;
   reg 	      clk, reset, wr, shift_dir, shift;
   
   initial begin
      $dumpfile("tb_reg_shifter.vcd");
      $dumpvars(0,tb);
   end

   initial begin
      reset = 1'b0;
      wr = 1'b0;
      rd_addr_a = 3'b0;
      rd_addr_b = 3'b0;
      d_in = 16'b0;
      shift_dir = 1'b0;
      shift = 1'b0;
      clk = 1'b0;
   end

   always #5 clk = ~clk;

   reg_shifter r(clk, reset, wr, shift_dir, shift, rd_addr_a, rd_addr_b, wr_addr, d_in, d_out_a, d_out_b);
   
   initial begin
      @(posedge clk);
      wr = 1'b1;
      wr_addr = 3'b0;
      d_in = 16'b1001011;

      @(posedge clk);
      wr = 1'b0;

      @(posedge clk);
      shift = 1'b1;

      @(posedge clk);
      shift = 1'b0;
      wr_addr = 3'b1;
      wr = 1'b1;
      d_in = 16'b110111;

      @(posedge clk);
      wr = 1'b0;
      shift_dir = 1'b1;
      shift = 1'b1;
      rd_addr_a = 3'b1;

      @(posedge clk);
      shift = 1'b0;
      d_in = 16'b0;
      wr = 1'b1;
      wr_addr = 3'b0;

      @(posedge clk);
      wr_addr = 3'b1;

      #20;

      $finish;
   end
endmodule // tb
