`define BALL_RADIUS 9

`define PLAYER_HEIGHT 60
`define PLAYER_WIDTH 12

`define FRAME_WIDTH 640
`define FRAME_HEIGHT 480

`define INITIAL_BALL_X_POS 318
`define INITIAL_BALL_Y_POS 238
`define INITIAL_PLAYER_Y_POS 210

`define PLAYER_1_X_POS 25
`define PLAYER_2_X_POS 615

`define DEFAULT_PLAYER_SPEED 30

`define INITIAL_BALL_DIRECTION = 0

module img_generator (
    input wire CLOCK_25,
    input wire[11:0] x, 
    input wire[11:0] y,

    output wire[2:0] color
);
    reg BALL_CLOCK;
    ball_clock ballzzz(
        .CLOCK_25(CLOCK_25),
        .BALL_CLOCK(BALL_CLOCK)
    );

    reg[11:0] ball_x_pos = `INITIAL_BALL_X_POS;
    reg[11:0] ball_y_pos = `INITIAL_BALL_Y_POS;

    reg ball_direction_top  = 0;
    reg ball_direction_left = 0;

    reg[2:0] current_ball_x_movement = 4;
    reg[2:0] current_ball_y_movement = 0;

    assign color = (
        // Draw Ball
        x >= ball_x_pos && x <= (ball_x_pos + `BALL_RADIUS) &&
        y >= ball_y_pos && y <= (ball_y_pos + `BALL_RADIUS)
    ) ? 3'b111 : (
        // Draw Player 1
        x >= `PLAYER_1_X_POS && x <= (`PLAYER_1_X_POS + `PLAYER_WIDTH) &&
        y >= player_1_y_pos && y <= (player_1_y_pos + `PLAYER_HEIGHT)
    ) ? 3'b001 : (
        // Draw Player 2
        x >= `PLAYER_2_X_POS && x <= (`PLAYER_2_X_POS + `PLAYER_WIDTH) &&
        y >= player_2_y_pos && y <= (player_2_y_pos + `PLAYER_HEIGHT)
    ) ? 3'b100 : 3'b000 | 3*{(x == 640 || x == 1 || y == 480 || y == 1) ? 1'b1 : 1'b0};

    reg[11:0] player_1_y_pos = `INITIAL_PLAYER_Y_POS;
    reg[11:0] player_2_y_pos = `INITIAL_PLAYER_Y_POS;

    // Ball Logic
    always@(posedge BALL_CLOCK) begin
        case (ball_direction_left)
            0: ball_x_pos <= ball_x_pos + current_ball_x_movement;
            1: ball_x_pos <= ball_x_pos - current_ball_x_movement;
        endcase

        case (ball_direction_top)
            0: ball_y_pos <= ball_y_pos + current_ball_y_movement;
            1: ball_y_pos <= ball_y_pos - current_ball_y_movement;
        endcase
    end
    
endmodule
