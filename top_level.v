
// Top-level module for Pong game implementation
module top_level(
  input  wire 		CLOCK_50, // 50 MHz system clock
  output wire		GPIO_000, GPIO_001, GPIO_003, GPIO_005, GPIO_007, // VGA outputs
  output reg [7:0] 	led, // LED output for animation/debug
  input  wire		key0, key1, // FPGA Keys
  // Player 1 keypad connections
  input GPIO_015, GPIO_013, GPIO_011, GPIO_009, // Columns
  output GPIO_023, GPIO_021, GPIO_019, GPIO_017, // Rows
  // Player 2 keypad connections
  input GPIO_014, GPIO_012, GPIO_010, GPIO_008, // Columns
  output GPIO_022, GPIO_020, GPIO_018, GPIO_016 // Rows
);

  // Generate a 25 MHz clock from the 50 MHz input clock
  reg CLOCK_25 = 0;
  always @(posedge CLOCK_50) CLOCK_25 = ~CLOCK_25;

  // Registers to store keypad keycodes for both players
  reg [3:0] keys_1 = 0; // Player 1 keycode
  reg [3:0] keys_2 = 0; // Player 2 keycode
  reg key_pressed_1 = 0; // Player 1 key pressed signal
  reg key_pressed_2 = 0; // Player 2 key pressed signal

  // VGA Output module instantiation
  vga mon(
    .CLOCK_50	(CLOCK_50), 
    .i_sel	({~key1,~key0}),
          .o_hsync	(GPIO_000), 
          .o_vsync	(GPIO_001),
          .o_red	(GPIO_007),
          .o_grn	(GPIO_005),
          .o_blu	(GPIO_003),
          .keys_1(keys_1),
          .keys_2(keys_2),
          .key_pressed_1(key_pressed_1),
          .key_pressed_2(key_pressed_2),
          .key0(key0),
          .key1(key1),

          // For animation
          .led(led)
  );

  // Player 1 keypad scanner instantiation
  keypad player1(
    .clk(CLOCK_25), // Use 25 MHz clock for scanning, as we use it everywhere else, to stay in synch
    .cols({GPIO_009, GPIO_011, GPIO_013, GPIO_015}), // Column inputs
    .rows({GPIO_017, GPIO_019, GPIO_021, GPIO_023}), // Row outputs
    .keycode(keys_1), // Output keycode
    .key_pressed(key_pressed_1) // Output key pressed signal
  );

  // Player 2 keypad scanner instantiation
  keypad player2(
    .clk(CLOCK_25), // Use 25 MHz clock for scanning, as we use it everywhere else, to stay in synch
    .cols({GPIO_008, GPIO_010, GPIO_012, GPIO_014}), // Column inputs
    .rows({GPIO_016, GPIO_018, GPIO_020, GPIO_022}), // Row outputs
    .keycode(keys_2), // Output keycode
    .key_pressed(key_pressed_2) // Output key pressed signal
  );

endmodule
