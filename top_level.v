
module top_level(
  input  wire 		CLOCK_50,
  output wire		GPIO_000, GPIO_001, GPIO_003, GPIO_005, GPIO_007,
  output reg [7:0] 	led,
  input  wire		key0, key1,
  input wire GPIO_032, GPIO_030, GPIO_024, // Player 1 inputs
  input wire GPIO_033, GPIO_031, GPIO_025 // Player 2 inputs
);

  // VGA-Output
  vga mon(.CLOCK_50	(CLOCK_50), 
          .i_sel	({~key1,~key0}),
          .o_hsync	(GPIO_000), 
          .o_vsync	(GPIO_001),
          .o_red	(GPIO_007),
          .o_grn	(GPIO_005),
          .o_blu	(GPIO_003),
          .player_1_a(GPIO_032),
          .player_1_b(GPIO_030),
          .player_1_switch(GPIO_024),
          .player_2_a(GPIO_033),
          .player_2_b(GPIO_031),
          .player_2_switch(GPIO_025)
);

endmodule
