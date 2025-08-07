`include "global_symbols.vh"

module img_generator (
    input wire CLOCK_25,
    input wire[11:0] x, 
    input wire[11:0] y,
    input wire player_1_a,
    input wire player_1_b,
    input wire player_1_switch,
    input wire player_2_a,
    input wire player_2_b,
    input wire player_2_switch,/*

    // FPGA buttons (TODO: suspected to be active low)
    input wire key0,
    input wire key1,

    // FPGA led
    output wire[7:0] led*/
    output wire[2:0] color
);
    reg BALL_CLOCK;
    ball_clock ballzzz(
        .CLOCK_25(CLOCK_25),
        .BALL_CLOCK(BALL_CLOCK)
    );

    reg pause_active_low = 0;   // yes, by default the game is supposed to be paused

/*    always @(posedge BALL_CLOCK) begin
        // key1 == continue
        if (key1 == 0) begin
            pause_active_low <= 1;

        // key0 == pause
        end else if (key0 == 0) begin
            pause_active_low <= 0
        end
    end*/

    /*reg[1:0] mode;
    // Animations on FPGA LEDs
    animation a0(
        .BALL_CLOCK(BALL_CLOCK),
        .mode(mode),
        .
    );*/

    reg player_1_up = 0;
    reg player_1_down = 0;
    reg player_2_up = 0;
    reg player_2_down = 0;

    reg button_player_1 = 0;
    reg button_player_2 = 0;

    rotary_encoder player1_input(
        .clk(CLOCK_25),
        .in_a(player_1_a),
        .in_b(player_1_b),
        .switch(1'b0), // No switch input
        .up(player_1_up),
        .down(player_1_down),
        .button(button_player_1) // Not used
    );

    rotary_encoder player2_input(
        .clk(CLOCK_25),
        .in_a(player_2_a),
        .in_b(player_2_b),
        .switch(1'b0), // No switch input
        .up(player_2_up),
        .down(player_2_down),
        .button(button_player_2) // Not used
    );

    // Player Logic
    always @(posedge CLOCK_25) begin
        if (pause_active_low == 0) begin
            // Player 1 Movement Logic
            if (player_1_up) begin
                if (player_1_y_pos <= `DEFAULT_PLAYER_SPEED) begin
                    player_1_y_pos <= 1;
                end else begin
                    player_1_y_pos <= player_1_y_pos - `DEFAULT_PLAYER_SPEED; 
                end
            end
            if (player_1_down) begin
                if ((`FRAME_HEIGHT - `DEFAULT_PLAYER_SPEED) <= (player_1_y_pos + `PLAYER_HEIGHT)) begin
                    player_1_y_pos <= `FRAME_HEIGHT - `PLAYER_HEIGHT - 1;
                end else begin
                    player_1_y_pos <= player_1_y_pos + `DEFAULT_PLAYER_SPEED;
                end
            end

            // Player 2 Movement Logic
            if (player_2_up) begin
                if (player_2_y_pos <= `DEFAULT_PLAYER_SPEED) begin
                    player_2_y_pos <= 1;
                end else begin
                    player_2_y_pos <= player_2_y_pos - `DEFAULT_PLAYER_SPEED; 
                end
            end
            if (player_2_down) begin
                if ((`FRAME_HEIGHT - `DEFAULT_PLAYER_SPEED) <= (player_2_y_pos + `PLAYER_HEIGHT)) begin
                    player_2_y_pos <= `FRAME_HEIGHT - `PLAYER_HEIGHT - 1;
                end else begin
                    player_2_y_pos <= player_2_y_pos + `DEFAULT_PLAYER_SPEED;
                end
            end
        end
    end

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
        // Draw Score 1
        score_1_out
    ) ? 3'b001 : (
        // Draw Score 2
        score_2_out
    ) ? 3'b100 : (
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

    reg[2:0] score_player_1 = 0;
    reg[2:0] score_player_2 = 0;
    reg[2:0] winner_color = 3'b000;

    reg miss_indicator = 0;

    reg score_1_out;
    reg score_2_out;

    // Score Logic
    score_generator score_1(
        .clk(CLOCK_25),
        .x(x), .y(y),
        .score(score_player_1),
        .horizontal_offset(`HORIZONTAL_SCORE_OFFSET),
        .out(score_1_out)
    );
    score_generator score_2(
        .clk(CLOCK_25),
        .x(x), .y(y),
        .score(score_player_2),
        .horizontal_offset(`FRAME_WIDTH - `HORIZONTAL_SCORE_OFFSET - `SCORE_WIDTH - 1),
        .out(score_2_out)
    );

    // Ball Logic
    always@(posedge BALL_CLOCK) begin
        if (pause_active_low == 0) begin
            case (ball_direction_left)
                0: ball_x_pos <= ball_x_pos + current_ball_x_movement;
                1: ball_x_pos <= ball_x_pos - current_ball_x_movement;
            endcase

            case (ball_direction_top)
                0: ball_y_pos <= ball_y_pos + current_ball_y_movement;
                1: ball_y_pos <= ball_y_pos - current_ball_y_movement;
            endcase
        end

        // Ball Collision on Y-Axis
        if ((ball_y_pos >= 0) && (ball_y_pos <= `COLLISION_OFFSET)) begin
            ball_direction_top <= 0;
        end else if ((`FRAME_HEIGHT - `COLLISION_OFFSET) <= (ball_y_pos + `BALL_RADIUS) && (ball_y_pos + `BALL_RADIUS) <= `FRAME_HEIGHT) begin
            ball_direction_top <= 1;
        end

        if (miss_indicator) begin
            if (
                (1 <= ball_x_pos && ball_x_pos <= `BALL_RADIUS) ||
                ((`FRAME_WIDTH - `BALL_RADIUS) <= ball_x_pos && ball_x_pos <= (`FRAME_WIDTH - 1))
            ) begin
                ball_x_pos <= `INITIAL_BALL_X_POS;
                ball_y_pos <= `INITIAL_BALL_Y_POS;
                miss_indicator <= 0;
            end
        end else begin

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
                    // MISS => Player 2 scores
                    score_player_2 <= score_player_2 + 1;
                    miss_indicator <= 1;
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
                    // MISS => Player 2 scores
                    score_player_2 <= score_player_2 + 1;
                    miss_indicator <= 1;
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
                    // MISS => Player 1 scores
                    score_player_1 <= score_player_1 + 1;
                    miss_indicator <= 1;
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
                    // MISS => Player 1 scores
                    score_player_1 <= score_player_1 + 1;
                    miss_indicator <= 1;
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
    end
    
endmodule
