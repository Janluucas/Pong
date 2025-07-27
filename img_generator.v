`define BALL_RADIUS 9

`define PLAYER_HEIGHT 60
`define PLAYER_WIDTH 12

`define FRAME_WIDTH 640
`define FRAME_HEIGHT 480

`define INITIAL_BALL_X_POS 318
`define INITIAL_BALL_Y_POS 238
`define INITIAL_PLAYER_Y_POS 210

`define PLAYER_1_X_POS 13
`define PLAYER_2_X_POS 615

`define DEFAULT_PLAYER_SPEED 30

`define INITIAL_BALL_DIRECTION 0

`define COLLISION_OFFSET 3
`define BALL_CENTER_OFFSET 5

`define HIT_ZONE_1    0
`define HIT_ZONE_2   11
`define HIT_ZONE_3   23
`define HIT_ZONE_4   35
`define HIT_ZONE_5   47
`define HIT_ZONE_MAX 59

module img_generator (
    input wire CLOCK_25,
    input wire[11:0] x, 
    input wire[11:0] y,
    input wire player_1_a,
    input wire player_1_b,
    input wire player_1_switch,
    input wire player_2_a,
    input wire player_2_b,
    input wire player_2_switch,

    output wire[2:0] color
);
    reg BALL_CLOCK;
    ball_clock ballzzz(
        .CLOCK_25(CLOCK_25),
        .BALL_CLOCK(BALL_CLOCK)
    );

    reg player_1_up = 0;
    reg player_1_down = 0;
    reg player_2_up = 0;
    reg player_2_down = 0;

    player_input player1_input(
        .clk(CLOCK_25),
        .in_a(player_1_a),
        .in_b(player_1_b),
        .switch(1'b0), // No switch input
        .up(player_1_up),
        .down(player_1_down),
        .button() // Not used
    );

    player_input player2_input(
        .clk(CLOCK_25),
        .in_a(player_2_up),
        .in_b(player_2_down),
        .switch(1'b0), // No switch input
        .up(player_2_up),
        .down(player_2_down),
        .button() // Not used
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
    ) ? 3'b100 : 3'b000 | 3*{(x == 640 || x == 1 || y == 480 || y == 1) ? 3'b010 : 3'b000};

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

        // Ball Collision on Y-Axis
        if ((ball_y_pos >= 0) && (ball_y_pos <= `COLLISION_OFFSET)) begin
            ball_direction_top <= 0;
        end else if ((`FRAME_HEIGHT - `COLLISION_OFFSET) <= (ball_y_pos + `BALL_RADIUS) && (ball_y_pos + `BALL_RADIUS) <= `FRAME_HEIGHT) begin
            ball_direction_top <= 1;
        end

        // Ball Collision on X_Axis
        if ((`PLAYER_1_X_POS + `PLAYER_WIDTH) <= ball_x_pos && ball_x_pos <= (`PLAYER_1_X_POS + `PLAYER_WIDTH + `COLLISION_OFFSET)) begin
            // ball is on x level of player 1
            if ((ball_y_pos + `BALL_CENTER_OFFSET) < player_1_y_pos) begin
                // center pixel of ball is above player; corner hit still possible
                if ((player_1_y_pos - 1) <= (ball_y_pos + `BALL_RADIUS) && (ball_y_pos + `BALL_RADIUS) <= player_1_y_pos + `HIT_ZONE_2) begin
                    // Hit at top corner of player
                    ball_direction_left <= 0;
                    ball_direction_top  <= 1;

                    current_ball_x_movement <= 1;
                    current_ball_y_movement <= 3;
                end else begin
                    // MISS

                end

            end else if ((ball_y_pos + `BALL_CENTER_OFFSET) > (player_1_y_pos + `PLAYER_HEIGHT)) begin
                // center pixel of ball is below player; corner hit still possible
                if ((player_1_y_pos + `HIT_ZONE_5) <= ball_y_pos && ball_y_pos <= (player_1_y_pos + `PLAYER_HEIGHT + 1)) begin
                    // Hit at bottom corner of player
                    ball_direction_left <= 0;
                    ball_direction_top  <= 0;

                    current_ball_x_movement <= 1;
                    current_ball_y_movement <= 3;
                end else begin
                    // MISS
                end

            end else if (
                `HIT_ZONE_1 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) <= (`HIT_ZONE_2 - 1)
            ) begin
                // Hit in ZONE 1
                ball_direction_left <= 0;
                ball_direction_top  <= 1;

                current_ball_x_movement <= 2;
                current_ball_y_movement <= 2;
            end else if (
                `HIT_ZONE_2 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) <= (`HIT_ZONE_3 - 1)
            ) begin
                // Hit in ZONE 2
                ball_direction_left <= 0;
                ball_direction_top  <= 1;

                current_ball_x_movement <= 3;
                current_ball_y_movement <= 1;
            end else if (
                `HIT_ZONE_3 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) <= (`HIT_ZONE_4 - 1)
            ) begin
                // Hit in ZONE 3
                ball_direction_left <= 0;

                current_ball_x_movement <= 4;
                current_ball_y_movement <= 0;
            end else if (
                `HIT_ZONE_4 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) <= (`HIT_ZONE_5 - 1)
            ) begin
                // Hit in ZONE 4
                ball_direction_left <= 0;
                ball_direction_top  <= 0;

                current_ball_x_movement <= 3;
                current_ball_y_movement <= 1;
            end else if (
                `HIT_ZONE_5 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_1_y_pos) <= (`HIT_ZONE_MAX - 1)
            ) begin
                // Hit in ZONE 5
                ball_direction_left <= 0;
                ball_direction_top  <= 0;

                current_ball_x_movement <= 2;
                current_ball_y_movement <= 2;
            end



        end else if ((`PLAYER_2_X_POS - `COLLISION_OFFSET) <= (ball_x_pos + `BALL_RADIUS) && (ball_x_pos + `BALL_RADIUS) <= `PLAYER_2_X_POS) begin
            // ball is on x level of player 2
            if ((ball_y_pos + `BALL_CENTER_OFFSET) < player_2_y_pos) begin
                // center pixel of ball is above player; corner hit still possible
                if ((player_2_y_pos - 1) <= (ball_y_pos + `BALL_RADIUS) && (ball_y_pos + `BALL_RADIUS) <= player_2_y_pos + `HIT_ZONE_2) begin
                    // Hit at top corner of player
                    ball_direction_left <= 1;
                    ball_direction_top  <= 1;

                    current_ball_x_movement <= 1;
                    current_ball_y_movement <= 3;
                end else begin
                    // MISS
                end

            end else if ((ball_y_pos + `BALL_CENTER_OFFSET) > (player_2_y_pos + `PLAYER_HEIGHT)) begin
                // center pixel of ball is below player; corner hit still possible
                if ((player_2_y_pos + `HIT_ZONE_5) <= ball_y_pos && ball_y_pos <= (player_2_y_pos + `PLAYER_HEIGHT + 1)) begin
                    // Hit at bottom corner of player
                    ball_direction_left <= 1;
                    ball_direction_top  <= 0;

                    current_ball_x_movement <= 1;
                    current_ball_y_movement <= 3;
                end else begin
                    // MISS
                end

            end else if (
                `HIT_ZONE_1 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) <= (`HIT_ZONE_2 - 1)
            ) begin
                // Hit in ZONE 1
                ball_direction_left <= 1;
                ball_direction_top  <= 1;

                current_ball_x_movement <= 2;
                current_ball_y_movement <= 2;
            end else if (
                `HIT_ZONE_2 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) <= (`HIT_ZONE_3 - 1)
            ) begin
                // Hit in ZONE 2
                ball_direction_left <= 1;
                ball_direction_top  <= 1;

                current_ball_x_movement <= 3;
                current_ball_y_movement <= 1;
            end else if (
                `HIT_ZONE_3 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) <= (`HIT_ZONE_4 - 1)
            ) begin
                // Hit in ZONE 3
                ball_direction_left <= 1;

                current_ball_x_movement <= 4;
                current_ball_y_movement <= 0;
            end else if (
                `HIT_ZONE_4 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) <= (`HIT_ZONE_5 - 1)
            ) begin
                // Hit in ZONE 4
                ball_direction_left <= 1;
                ball_direction_top  <= 0;

                current_ball_x_movement <= 3;
                current_ball_y_movement <= 1;
            end else if (
                `HIT_ZONE_5 <= ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) &&
                ((ball_y_pos + `BALL_CENTER_OFFSET) - player_2_y_pos) <= (`HIT_ZONE_MAX - 1)
            ) begin
                // Hit in ZONE 5
                ball_direction_left <= 1;
                ball_direction_top  <= 0;

                current_ball_x_movement <= 2;
                current_ball_y_movement <= 2;
            end
        end
    end

    always@(posedge CLOCK_25) begin
        // Player 1 Movement Logic
        if (player_1_up) player_1_y_pos <= player_1_y_pos - `DEFAULT_PLAYER_SPEED;
        if (player_1_down) player_1_y_pos <= player_1_y_pos + `DEFAULT_PLAYER_SPEED;
        // Player 2 Movement Logic
        if (player_2_up) player_2_y_pos <= player_2_y_pos - `DEFAULT_PLAYER_SPEED;
        if (player_2_down) player_2_y_pos <= player_2_y_pos + `DEFAULT_PLAYER_SPEED;
    end
    
endmodule
