
module top_level(
  input  wire 		CLOCK_50,
  output wire		GPIO_000, GPIO_001, GPIO_003, GPIO_005, GPIO_007,
  output reg [7:0] 	led,
  input  wire		key0, key1,
  output wire GPIO_033, GPIO_031, GPIO_017, // Player 1 output
  input wire GPIO_015, GPIO_013, GPIO_011, GPIO_009, GPIO_025 //Player 1 inputs
);

  reg player_1_up = 0;
  reg player_1_down = 0;
  reg player_2_up = 0;
  reg player_2_down = 0;

  /*always @(posedge CLOCK_25) begin
    led <= {player_1_up, GPIO_033, GPIO_031, GPIO_025, 3'b0, player_1_down};
  end*/
  

  // VGA-Output
  vga mon(.CLOCK_50	(CLOCK_50), 
          .i_sel	({~key1,~key0}),
          .o_hsync	(GPIO_000), 
          .o_vsync	(GPIO_001),
          .o_red	(GPIO_007),
          .o_grn	(GPIO_005),
          .o_blu	(GPIO_003),
          .player_1_up(player_1_up),
          .player_1_down(player_1_down),
          .player_2_up(player_2_up),
          .player_2_down(player_2_down)
);

// Clocks 25
  reg CLOCK_25 = 0;
  always @(posedge CLOCK_50) CLOCK_25 = ~CLOCK_25;

//Player 1 Controll
keypad player_1(
  .clk(CLOCK_25),
  .wire1(GPIO_033),
  .wire2(0),
  .wire3(GPIO_031),
  .wire4(0),
  .wire5(0),
  .wire6(GPIO_025),
  .wire7(0),
  .wire8(0),
  .up(player_1_up),
  .down(player_1_down)  
);

endmodule
