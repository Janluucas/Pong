
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

  reg CLOCK_TINY = 0;
  reg[9:0] cnt = 0;
  always @(posedge CLOCK_50) begin
    cnt <= cnt + 1'b1;
    if (cnt == 0) CLOCK_TINY = ~CLOCK_TINY;
  end

  reg [3:0] keys_1 = 0;
  reg [3:0] keys_2 = 0;

  // VGA-Output
  vga mon(.CLOCK_50	(CLOCK_50), 
          .i_sel	({~key1,~key0}),
          .o_hsync	(GPIO_000), 
          .o_vsync	(GPIO_001),
          .o_red	(GPIO_007),
          .o_grn	(GPIO_005),
          .o_blu	(GPIO_003),
          .keys_1(keys_1),
          .keys_2(keys_2),
          .key0(key0),
          .key1(key1),

          // For animation
          .led(led)
);

//Player1
keypad player1(
  .clk(CLOCK_25),
  .cols({GPIO_009, GPIO_011, GPIO_013, GPIO_015}),
  .rows({GPIO_017, GPIO_019, GPIO_021, GPIO_023}),
  .keycode(keys_1)
);

//Player2
keypad player2(
  .clk(CLOCK_25),
  .cols({GPIO_008, GPIO_010, GPIO_012, GPIO_014}),
  .rows({GPIO_016, GPIO_018, GPIO_020, GPIO_022}),
  .keycode(keys_2)
);

endmodule
