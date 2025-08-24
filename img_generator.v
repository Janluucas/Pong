`include "global_symbols.vh"

// Image generator module for Pong game
module img_generator (
    input wire CLOCK_25,
    input wire[11:0] x,              // Current pixel x coordinate
    input wire[11:0] y,              // Current pixel y coordinate
    input wire [4:0]  keys_1,        // Player 1 input keys
    input wire [4:0]  keys_2,        // Player 2 input keys
    input wire key0,                 // FPGA key 0
    input wire key1,                 // FPGA key 1
    output wire[2:0] color,          // Output color for current pixel

    output wire[7:0] led             // LED output for animation
);

    // Animation state registers
    reg goal_player_1 = 0;
    reg goal_player_2 = 0;
    reg win_player_1  = 0;
    reg win_player_2  = 0;
    
    reg[7:0] led_r;
    assign led = led_r;
    
    // Animation module instantiation
    animation(
        .BALL_CLOCK(BALL_CLOCK),
        .goal_player_1(goal_player_1),
        .goal_player_2(goal_player_2),
        .win_player_1(win_player_1),
        .win_player_2(win_player_2),
        .led(led_r)
    );

    // Last winner color register
    reg[2:0] last_winner_color = 3'b000;

    // Update win state on BALL_CLOCK
    always @(posedge BALL_CLOCK) begin
        win_player_1 <= last_winner_color == `PLAYER_1_COLOR;
        win_player_2 <= last_winner_color == `PLAYER_2_COLOR;
    end

    reg paused = 1;   // Game starts paused
    reg pause_request_active_low = 1; // Pause/reset request (active low)
    reg reset = 0;

    // Pause and reset logic (triggered on key press or by pause request, send if a player wins)
    always @(negedge key0 or negedge key1 or negedge pause_request_active_low) begin
        if (!pause_request_active_low) begin // pause and reset on win
            paused <= 1;
            reset <=1;
        end else if (!key1) begin   // reset game and pause it if key1 on FPGA is pressed
            reset <= 1;
            paused <= 1;
        end else begin  // toggle pause state if key0 on FPGA is pressed
            reset <= 0;
            paused <= ~paused;
        end
    end

    // Ball movement clock generator
    reg BALL_CLOCK;
    ball_clock ballzzz(
        .CLOCK_25(CLOCK_25),
        .BALL_CLOCK(BALL_CLOCK)
    );

    // Player positions and movement logic

    // Player positions
    reg[11:0] player_1_y_pos = `INITIAL_PLAYER_Y_POS;
    reg[11:0] player_2_y_pos = `INITIAL_PLAYER_Y_POS;

    always @(posedge BALL_CLOCK) begin
        if (reset) begin // Reset player positions if reset is triggered
            player_1_y_pos <= `INITIAL_PLAYER_Y_POS;
            player_2_y_pos <= `INITIAL_PLAYER_Y_POS;
        end

        if (!paused) begin //deactivate movement if paused
            // Player 1 movement
            if (keys_1 == {4'd2,1'b1}) begin // Up
                if (player_1_y_pos <= `DEFAULT_PLAYER_SPEED) begin // Boundary check
                    player_1_y_pos <= 1;
                end else begin
                    player_1_y_pos <= player_1_y_pos - `DEFAULT_PLAYER_SPEED; 
                end
            end
            else if (keys_1 == {4'd8,1'b1}) begin // Down
                if ((`FRAME_HEIGHT - `DEFAULT_PLAYER_SPEED) <= (player_1_y_pos + `PLAYER_HEIGHT)) begin // Boundary check
                    player_1_y_pos <= `FRAME_HEIGHT - `PLAYER_HEIGHT - 1;
                end else begin
                    player_1_y_pos <= player_1_y_pos + `DEFAULT_PLAYER_SPEED;
                end
            end

            // Player 2 movement
            if (keys_2 == {4'd2,1'b1}) begin // Up
                if (player_2_y_pos <= `DEFAULT_PLAYER_SPEED) begin // Boundary check
                    player_2_y_pos <= 1;
                end else begin
                    player_2_y_pos <= player_2_y_pos - `DEFAULT_PLAYER_SPEED; 
                end
            end
            else if (keys_2 == {4'd8,1'b1}) begin // Down
                if ((`FRAME_HEIGHT - `DEFAULT_PLAYER_SPEED) <= (player_2_y_pos + `PLAYER_HEIGHT)) begin // Boundary check
                    player_2_y_pos <= `FRAME_HEIGHT - `PLAYER_HEIGHT - 1;
                end else begin
                    player_2_y_pos <= player_2_y_pos + `DEFAULT_PLAYER_SPEED;
                end
            end
        end
    end

    // Win screen generator
    win_screen ws(
        .clk(CLOCK_25),
        .x(x), .y(y),
        .winner(last_winner_color),
        .out(win_out)
    );
    reg win_out = 0;

    // Ball position and movement registers
    reg[11:0] ball_x_pos = `INITIAL_BALL_X_POS;
    reg[11:0] ball_y_pos = `INITIAL_BALL_Y_POS;

    reg ball_direction_top  = 0;     // Ball vertical direction
    reg ball_direction_left = 0;     // Ball horizontal direction

    reg[2:0] current_ball_x_movement = 4; // Ball speed X
    reg[2:0] current_ball_y_movement = 0; // Ball speed Y

    reg[2:0] ball_color = 3'b111;    // Ball color

    // Color assignment for each pixel (priority: ball > score > win > players > border)
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
        // Draw Win Screen
        win_out
    ) ? last_winner_color : (
        // Draw Player 1
        x >= `PLAYER_1_X_POS && x <= (`PLAYER_1_X_POS + `PLAYER_WIDTH) &&
        y >= player_1_y_pos && y <= (player_1_y_pos + `PLAYER_HEIGHT)
    ) ? `PLAYER_1_COLOR : (
        // Draw Player 2
        x >= `PLAYER_2_X_POS && x <= (`PLAYER_2_X_POS + `PLAYER_WIDTH) &&
        y >= player_2_y_pos && y <= (player_2_y_pos + `PLAYER_HEIGHT)
    ) ? `PLAYER_2_COLOR : 3'b000 | 3*{(x == 640 || x == 1 || y == 480 || y == 1) ? 3'b010 : 3'b000}; // Draw Border


    // Score registers
    reg[2:0] score_player_1 = 0;
    reg[2:0] score_player_2 = 0;
    reg[2:0] winner_color = 3'b000;

    reg miss_indicator = 0; // Indicates if player missed ball

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

    // Current ball movement offset (for collision detection, as ball speed may vary)
    reg[6:0] current_ball_movement_offset = 0;

    // Ball movement and collision logic
    always@(posedge BALL_CLOCK) begin
        current_ball_movement_offset <= current_ball_x_movement * current_ball_y_movement;
        pause_request_active_low <= 1;

        if (reset) begin
            // Reset ball and scores, if reset is triggered
            ball_x_pos <= `INITIAL_BALL_X_POS;
            ball_y_pos <= `INITIAL_BALL_Y_POS;
            score_player_1 <= 0;
            score_player_2 <= 0;
            current_ball_x_movement <= 4;
            current_ball_y_movement <= 0;
            ball_direction_left <= 0;
            ball_direction_top <= 0;
        end

        if (!paused) begin // Deactivate ball movement if paused
            if (!miss_indicator) begin
                last_winner_color <= 3'b000; // Reset last winner color
            end

            // Ball movement (X and Y)
            case (ball_direction_left)
                0: ball_x_pos <= ball_x_pos + current_ball_x_movement;
                1: ball_x_pos <= ball_x_pos - current_ball_x_movement;
            endcase

            case (ball_direction_top)
                0: ball_y_pos <= ball_y_pos + current_ball_y_movement;
                1: ball_y_pos <= ball_y_pos - current_ball_y_movement;
            endcase
        end

        // Ball collision with top/bottom walls (Y axis)
        if ((ball_y_pos >= 0) && (ball_y_pos <= `COLLISION_OFFSET)) begin
            ball_direction_top <= 0;
        end else if ((`FRAME_HEIGHT - `COLLISION_OFFSET) <= (ball_y_pos + `BALL_SIZE) && (ball_y_pos + `BALL_SIZE) <= `FRAME_HEIGHT) begin
            ball_direction_top <= 1;
        end

        if (miss_indicator) begin
            // Ball reset after miss
            if (
                (1 <= ball_x_pos && ball_x_pos <= 5) ||
                ((`FRAME_WIDTH - `BALL_SIZE) <= ball_x_pos && ball_x_pos <= (`FRAME_WIDTH - 1))
            ) begin
                ball_x_pos <= `INITIAL_BALL_X_POS;
                ball_y_pos <= (ball_x_pos < `HALF_FRAME_WIDTH) ? player_1_y_pos + `HALF_PLAYER_HEIGHT - `BALL_CENTER_OFFSET : player_2_y_pos + `HALF_PLAYER_HEIGHT - `BALL_CENTER_OFFSET;
                current_ball_y_movement <= 0;
                current_ball_x_movement <= 4;
                miss_indicator <= 0;

                if (score_player_1 == 0 && score_player_2 == 0) begin
                    pause_request_active_low <= 0;
                end
            end
        end else begin
        
        // Ball collision with players (X axis)
        
        // Collision with player 1 (Check whether ball is on height level of player 1)
        if (((`PLAYER_1_X_POS + `PLAYER_WIDTH) <= ball_x_pos) && (ball_x_pos <= (`PLAYER_1_X_POS + `PLAYER_WIDTH + current_ball_x_movement))) begin
            // Check which part of player is hit for angle/speed
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

        // Collision with player 2 (Check whether ball is on height level of player 2)
        else
        if (((`PLAYER_2_X_POS - current_ball_x_movement) <= (ball_x_pos + `BALL_SIZE)) && ((ball_x_pos + `BALL_SIZE) <= `PLAYER_2_X_POS)) begin
            // Check which part of player is hit for angle/speed
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
endmodule
