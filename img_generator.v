`include "global_symbols.vh"

module img_generator (
    input wire CLOCK_25,
    input wire[11:0] x, 
    input wire[11:0] y,
    input wire [3:0]  keys_1, // Player 1 inputs
    input wire [3:0]  keys_2, // Player 2 inputs
    input wire key0,
    input wire key1,
    output wire[2:0] color,

    // For Animation
    output wire[7:0] led
);
    // Animation
    reg goal_player_1 = 0;
    reg goal_player_2 = 0;
    reg win_player_1  = 0;
    reg win_player_2  = 0;
    
    reg[7:0] led_r;
    assign led = led_r;
    
    animation(
        .BALL_CLOCK(BALL_CLOCK),
        .goal_player_1(goal_player_1),
        .goal_player_2(goal_player_2),
        .win_player_1(win_player_1),
        .win_player_2(win_player_2),
        .led(led_r)
    );

    always @(posedge BALL_CLOCK) begin
        win_player_1 <= last_winner_color == `PLAYER_1_COLOR;
        win_player_2 <= last_winner_color == `PLAYER_2_COLOR;
    end

    reg paused = 1;   // yes, by default the game is supposed to be paused
    reg pause_request_active_low = 1; // active low signal to request pause

    // Pause Logic
    always @(negedge key0 or negedge pause_request_active_low) begin
        if (!pause_request_active_low) begin
            paused <= 1;
        end else begin
            paused <= ~paused;
        end
    end

    reg BALL_CLOCK;
    ball_clock ballzzz(
        .CLOCK_25(CLOCK_25),
        .BALL_CLOCK(BALL_CLOCK)
    );

    

    // Player Logic
    always @(posedge BALL_CLOCK) begin
        if (!paused) begin
            // Player 1 Movement Logic
            if (keys_1 == 4'd2) begin
                if (player_1_y_pos <= `DEFAULT_PLAYER_SPEED) begin
                    player_1_y_pos <= 1;
                end else begin
                    player_1_y_pos <= player_1_y_pos - `DEFAULT_PLAYER_SPEED; 
                end
            end
            else if (keys_1 == 4'd8) begin
                if ((`FRAME_HEIGHT - `DEFAULT_PLAYER_SPEED) <= (player_1_y_pos + `PLAYER_HEIGHT)) begin
                    player_1_y_pos <= `FRAME_HEIGHT - `PLAYER_HEIGHT - 1;
                end else begin
                    player_1_y_pos <= player_1_y_pos + `DEFAULT_PLAYER_SPEED;
                end
            end

            // Player 2 Movement Logic
            if (keys_2 == 4'd2) begin
                if (player_2_y_pos <= `DEFAULT_PLAYER_SPEED) begin
                    player_2_y_pos <= 1;
                end else begin
                    player_2_y_pos <= player_2_y_pos - `DEFAULT_PLAYER_SPEED; 
                end
            end
            else if (keys_2 == 4'd8) begin
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

    reg[2:0] ball_color = 3'b111;

    assign color = (
        // Draw Ball
        x >= ball_x_pos && x <= (ball_x_pos + `BALL_SIZE) &&
        y >= ball_y_pos && y <= (ball_y_pos + `BALL_SIZE)
    ) ? `BALL_COLOR : (
        // Draw Score 1
        score_1_out
    ) ? `PLAYER_1_COLOR : (
        // Draw Score 2
        score_2_out
    ) ? `PLAYER_2_COLOR : (
        // Draw Player 1
        x >= `PLAYER_1_X_POS && x <= (`PLAYER_1_X_POS + `PLAYER_WIDTH) &&
        y >= player_1_y_pos && y <= (player_1_y_pos + `PLAYER_HEIGHT)
    ) ? `PLAYER_1_COLOR : (
        // Draw Player 2
        x >= `PLAYER_2_X_POS && x <= (`PLAYER_2_X_POS + `PLAYER_WIDTH) &&
        y >= player_2_y_pos && y <= (player_2_y_pos + `PLAYER_HEIGHT)
    ) ? `PLAYER_2_COLOR : 3'b000 | 3*{(x == 640 || x == 1 || y == 480 || y == 1) ? 3'b010 : 3'b000};

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

    reg[6:0] current_ball_movement_offset = 0;

    // Ball Logic
    always@(posedge BALL_CLOCK) begin
        current_ball_movement_offset <= current_ball_x_movement * current_ball_y_movement;
        pause_request_active_low <= 1;

        if (!paused) begin
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
        end else if ((`FRAME_HEIGHT - `COLLISION_OFFSET) <= (ball_y_pos + `BALL_SIZE) && (ball_y_pos + `BALL_SIZE) <= `FRAME_HEIGHT) begin
            ball_direction_top <= 1;
        end

        if (miss_indicator) begin
            // Ball reset logic
            if (
                (1 <= ball_x_pos && ball_x_pos <= 5) ||
                ((`FRAME_WIDTH - `BALL_SIZE) <= ball_x_pos && ball_x_pos <= (`FRAME_WIDTH - 1))
            ) begin
                ball_x_pos <= `INITIAL_BALL_X_POS;
                ball_y_pos <= (ball_x_pos < `HALF_FRAME_WIDTH) ? player_1_y_pos + `HALF_PLAYER_HEIGHT - `BALL_CENTER_OFFSET : player_2_y_pos + `HALF_PLAYER_HEIGHT - `BALL_CENTER_OFFSET; // in prev. version: `INITIAL_BALL_Y_POS;
                current_ball_y_movement <= 0;
                current_ball_x_movement <= 4;
                miss_indicator <= 0;

                if (score_player_1 == 0 && score_player_2 == 0) begin
                    pause_request_active_low <= 0;
                end
            end
        end else begin
        
        // Ball Collision on X_Axis
        
        // Check whether ball is on height level of player 1
        if (((`PLAYER_1_X_POS + `PLAYER_WIDTH) <= ball_x_pos) && (ball_x_pos <= (`PLAYER_1_X_POS + `PLAYER_WIDTH + current_ball_x_movement))) begin
            // Ball intersects hitbox
            if (((player_1_y_pos - `CORNER_HIT_ZONE_SIZE) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < player_1_y_pos)) begin
                ball_direction_left <= 0;
                ball_direction_top <= 1;

                current_ball_x_movement <= 1;
                current_ball_y_movement <= 3;

                goal_player_2 <= 0;
            end else if (((player_1_y_pos + `HIT_ZONE_1) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_1_y_pos + `HIT_ZONE_2))) begin
                ball_direction_left <= 0;
                ball_direction_top <= 1;

                current_ball_x_movement <= 2;
                current_ball_y_movement <= 2;

                goal_player_2 <= 0;
            end else if (((player_1_y_pos + `HIT_ZONE_2) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_1_y_pos + `HIT_ZONE_3))) begin
                ball_direction_left <= 0;
                ball_direction_top <= 1;

                current_ball_x_movement <= 3;
                current_ball_y_movement <= 1;

                goal_player_2 <= 0;
            end else if (((player_1_y_pos + `HIT_ZONE_3) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_1_y_pos + `HIT_ZONE_4))) begin
                ball_direction_left <= 0;

                current_ball_x_movement <= 4;
                current_ball_y_movement <= 0;

                goal_player_2 <= 0;
            end else if (((player_1_y_pos + `HIT_ZONE_4) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_1_y_pos + `HIT_ZONE_5))) begin
                ball_direction_left <= 0;
                ball_direction_top <= 0;

                current_ball_x_movement <= 3;
                current_ball_y_movement <= 1;

                goal_player_2 <= 0;
            end else if (((player_1_y_pos + `HIT_ZONE_5) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_1_y_pos + `HIT_ZONE_MAX))) begin
                ball_direction_left <= 0;
                ball_direction_top <= 0;

                current_ball_x_movement <= 2;
                current_ball_y_movement <= 2;

                goal_player_2 <= 0;
            end else if (((player_1_y_pos + `HIT_ZONE_MAX) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_1_y_pos + `HIT_ZONE_MAX + `CORNER_HIT_ZONE_SIZE))) begin
                ball_direction_left <= 0;
                ball_direction_top <= 0;

                current_ball_x_movement <= 1;
                current_ball_y_movement <= 3;

                goal_player_2 <= 0;
            end else begin
                // Miss -> Player 2 scores
                miss_indicator <= 1;
                if (score_player_2 == 7) begin
                    score_player_1 <= 0;
                    score_player_2 <= 0;
                    
                    last_winner_color <= `PLAYER_2_COLOR;
                    
                end else begin
                    score_player_2 <= score_player_2 + 1'b1;
                    goal_player_2 <= 1;
                end
            end
        end

        // Check whether ball is on height level of player 2
        if (((`PLAYER_2_X_POS - current_ball_x_movement) <= (ball_x_pos + `BALL_SIZE)) && ((ball_x_pos + `BALL_SIZE) <= `PLAYER_2_X_POS)) begin
            // Ball intersects hitbox
            if (((player_2_y_pos - `CORNER_HIT_ZONE_SIZE) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < player_2_y_pos)) begin
                ball_direction_left <= 1;
                ball_direction_top <= 1;

                current_ball_x_movement <= 1;
                current_ball_y_movement <= 3;

                goal_player_1 <= 0;
            end else if (((player_2_y_pos + `HIT_ZONE_1) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_2_y_pos + `HIT_ZONE_2))) begin
                ball_direction_left <= 1;
                ball_direction_top <= 1;

                current_ball_x_movement <= 2;
                current_ball_y_movement <= 2;

                goal_player_1 <= 0;
            end else if (((player_2_y_pos + `HIT_ZONE_2) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_2_y_pos + `HIT_ZONE_3))) begin
                ball_direction_left <= 1;
                ball_direction_top <= 1;

                current_ball_x_movement <= 3;
                current_ball_y_movement <= 1;

                goal_player_1 <= 0;
            end else if (((player_2_y_pos + `HIT_ZONE_3) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_2_y_pos + `HIT_ZONE_4))) begin
                ball_direction_left <= 1;

                current_ball_x_movement <= 4;
                current_ball_y_movement <= 0;

                goal_player_1 <= 0;
            end else if (((player_2_y_pos + `HIT_ZONE_4) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_2_y_pos + `HIT_ZONE_5))) begin
                ball_direction_left <= 1;
                ball_direction_top <= 0;

                current_ball_x_movement <= 3;
                current_ball_y_movement <= 1;

                goal_player_1 <= 0;
            end else if (((player_2_y_pos + `HIT_ZONE_5) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_2_y_pos + `HIT_ZONE_MAX))) begin
                ball_direction_left <= 1;
                ball_direction_top <= 0;

                current_ball_x_movement <= 2;
                current_ball_y_movement <= 2;

                goal_player_1 <= 0;
            end else if (((player_2_y_pos + `HIT_ZONE_MAX) <= (ball_y_pos + `BALL_CENTER_OFFSET)) && ((ball_y_pos + `BALL_CENTER_OFFSET) < (player_2_y_pos + `HIT_ZONE_MAX + `CORNER_HIT_ZONE_SIZE))) begin
                ball_direction_left <= 1;
                ball_direction_top <= 0;

                current_ball_x_movement <= 1;
                current_ball_y_movement <= 3;

                goal_player_1 <= 0;
            end else begin
                // Miss -> Player 1 scores
                miss_indicator <= 1;
                if (score_player_1 == 7) begin
                    score_player_1 <= 0;
                    score_player_2 <= 0;
                    
                    last_winner_color <= `PLAYER_1_COLOR;
                end else begin
                    score_player_1 <= score_player_1 + 1'b1;

                    goal_player_1 <= 1;
                end
            end
        end

        end
    end

    reg[2:0] last_winner_color = 3'b000;
    
endmodule
