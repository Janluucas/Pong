`define BALL_RADIUS 5

`define PLAYER_HEIGHT 60
`define PLAYER_WIDTH 12

`define FRAME_WIDTH_MINUS_ONE 639
`define FRAME_HEIGHT_MINUS_ONE 479

`define INITIAL_BALL_X_POS 317
`define INITIAL_BALL_Y_POS 237
`define INITIAL_PLAYER_Y_POS 210

`define PLAYER_1_X_POS 24
`define PLAYER_2_X_POS 615

`define DEFAULT_PLAYER_SPEED 30

module img_generator (
    input wire CLOCK_25,
    input wire[11:0] x, 
    input wire[11:0] y,

    output wire[2:0] color
);
    wire BALL_CLOCK;
    ball_clock ballzzz(
        .CLOCK_25(CLOCK_25),
        .BALL_CLOCK(BALL_CLOCK)
    );

    assign color = (
        // Draw Ball
        x >= `INITIAL_BALL_X_POS && x <= (`INITIAL_BALL_X_POS + `BALL_RADIUS) &&
        y >= `INITIAL_BALL_Y_POS && y <= (`INITIAL_BALL_Y_POS + `BALL_RADIUS)
    ) ? 3'b111 : (
        // Draw Player 1
        x >= `PLAYER_1_X_POS && x <= (`PLAYER_1_X_POS + `PLAYER_WIDTH) &&
        y >= `INITIAL_PLAYER_Y_POS && y <= (`INITIAL_PLAYER_Y_POS + `PLAYER_HEIGHT)
    ) ? 3'b001 : (
        // Draw Player 2
        x >= `PLAYER_2_X_POS && x <= (`PLAYER_2_X_POS + `PLAYER_WIDTH) &&
        y >= `INITIAL_PLAYER_Y_POS && y <= (`INITIAL_PLAYER_Y_POS + `PLAYER_HEIGHT)
    ) ? 3'b100 : 3'b000;

    /*wire[11:0] top_player_1 = `INITIAL_PLAYER_Y_POS;
    wire[11:0] top_player_2 = `INITIAL_PLAYER_Y_POS;

    wire[11:0] ball_top  = `INITIAL_BALL_Y_POS;
    wire[11:0] ball_left = `INITIAL_BALL_X_POS;

    reg ball_left = 0; // 1 => going to the left | 0 => going to the right
    reg ball_top  = 0; // 1 => going to the top  | 0 => going to the bottom
    reg ball_x_dir = 0;
    reg ball_y_dir = 0; 

    // Handles Ball-Logic
    always @(posedge BALL_CLOCK) begin
        
    end*/
endmodule
