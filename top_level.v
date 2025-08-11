
module top_level(
  input  wire 		CLOCK_50,
  output wire		GPIO_000, GPIO_001, GPIO_003, GPIO_005, GPIO_007,
  output reg [7:0] 	led,
  input  wire		key0, key1,
  // Player 1
  input GPIO_015, GPIO_013, GPIO_011, GPIO_009,
  output GPIO_023, GPIO_021, GPIO_019, GPIO_017,
  //Player 2
  input GPIO_014, GPIO_012, GPIO_010, GPIO_008,
  output GPIO_022, GPIO_020, GPIO_018, GPIO_016
);

  // Clocks 25
  reg CLOCK_25 = 0;
  always @(posedge CLOCK_50) CLOCK_25 = ~CLOCK_25;

  wire [3:0] keys_1;
  wire keypressed_1;
  wire [3:0] keys_2;
  wire keypressed_2;

  // VGA-Output
  vga mon(.CLOCK_50	(CLOCK_50), 
          .i_sel	({~key1,~key0}),
          .o_hsync	(GPIO_000), 
          .o_vsync	(GPIO_001),
          .o_red	(GPIO_007),
          .o_grn	(GPIO_005),
          .o_blu	(GPIO_003),
          .keys_1(keys_1),
          .keypressed_1(keypressed_1),
          .keys_2(keys_2),
          .keypressed_2(keypressed_2)
);

//Player1
keypad player1(
  .clk(CLOCK_50),
  .cols({GPIO_015, GPIO_013, GPIO_011, GPIO_009}),
  .rows({GPIO_023, GPIO_021, GPIO_019, GPIO_017}),
  .keys(keys_1),
  .keypressed(keypressed_1)
);

//Player2
keypad player2(
  .clk(CLOCK_50),
  .cols({GPIO_014, GPIO_012, GPIO_010, GPIO_008}),
  .rows({GPIO_022, GPIO_020, GPIO_018, GPIO_016}),
  .keys(keys_2),
  .keypressed(keypressed_2)
);

endmodule
