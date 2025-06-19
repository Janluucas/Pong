
module test_bench();
  reg [1:0] clk = 2'b0;
  always 
    #1 clk = clk + 1;
  always @(posedge clk[1])  
    $display("%b %b  %b %b %b", hs, vs, rs, gs, bs);
  initial #1000000000 $finish();

  // VGA-Output
  vga mon(.CLOCK_50	(clk[0]), 
          .i_sel	(2'b00),
          .o_hsync	(hs), 
          .o_vsync	(vs),
          .o_red	(rs),
          .o_grn	(gs),
          .o_blu	(bs) );

endmodule

