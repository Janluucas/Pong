
module top_level(
  input  wire 		CLOCK_50,
  output wire		GPIO_000, GPIO_001, GPIO_003, GPIO_005, GPIO_007,
  output reg [7:0] 	led,
  input  wire		key0, key1
);

  // VGA-Output
  vga mon(.CLOCK_50	(CLOCK_50), 
          .i_sel	({~key1,~key0}),
          .o_hsync	(GPIO_000), 
          .o_vsync	(GPIO_001),
          .o_red	(GPIO_007),
          .o_grn	(GPIO_005),
          .o_blu	(GPIO_003) );

endmodule
