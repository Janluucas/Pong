// Simple LED animation controller for game
module animation (
    input wire BALL_CLOCK,         // Clock signal for animation timing
    input wire goal_player_1,      // Trigger for player 1 goal animation
    input wire goal_player_2,      // Trigger for player 2 goal animation
    input wire win_player_1,       // Trigger for player 1 win animation
    input wire win_player_2,       // Trigger for player 2 win animation

    output wire[7:0] led           // 8-bit output to drive LEDs
);

    // Animation trigger flags for each event
    reg goal_1_animation_triggered = 0;
    reg goal_2_animation_triggered = 0;
    reg win_1_animation_triggered = 0;
    reg win_2_animation_triggered = 0;

    reg[7:0] led_r;
    assign led = led_r;

    // Counter for animation repetitions
    reg[1:0] repetitions = 0;

    // Delay counter for animation speed control
    reg[1:0] delay = 2'b00;

    always @(posedge BALL_CLOCK) begin
        // Player 1 goal animation (LEDs move left to right)
        if (goal_1_animation_triggered && (repetitions != 2'b0)) begin
            casez ({delay, led_r})
                // Wait for delay to expire
                10'b10_????????: delay <= delay - 1;
                10'b01_????????: delay <= delay - 1;

                // Step through LED positions
                10'b00_00000000: begin led_r <= 8'b10000000; delay <= 2'b10; end
                10'b00_10000000: begin led_r <= 8'b01000000; delay <= 2'b10; end
                10'b00_01000000: begin led_r <= 8'b00100000; delay <= 2'b10; end
                10'b00_00100000: begin led_r <= 8'b00010000; delay <= 2'b10; end
                10'b00_00010000: begin led_r <= 8'b00001000; delay <= 2'b10; end
                10'b00_00001000: begin led_r <= 8'b00000100; delay <= 2'b10; end
                10'b00_00000100: begin led_r <= 8'b00000010; delay <= 2'b10; end
                10'b00_00000010: begin led_r <= 8'b00000001; delay <= 2'b10; end
                // End of animation, decrement repetitions
                10'b00_00000001: begin
                    led_r <= 8'b00000000;
                    repetitions <= repetitions - 1;
                end
                default: led_r <= 0;
            endcase

        // Player 2 goal animation (LEDs move right to left)
        end else if (goal_2_animation_triggered && (repetitions != 2'b0)) begin
            casez ({delay, led_r})
                10'b10_????????: delay <= delay - 1;
                10'b01_????????: delay <= delay - 1;

                10'b00_00000000: begin led_r <= 8'b00000001; delay <= 2'b10; end
                10'b00_00000001: begin led_r <= 8'b00000010; delay <= 2'b10; end
                10'b00_00000010: begin led_r <= 8'b00000100; delay <= 2'b10; end
                10'b00_00000100: begin led_r <= 8'b00001000; delay <= 2'b10; end
                10'b00_00001000: begin led_r <= 8'b00010000; delay <= 2'b10; end
                10'b00_00010000: begin led_r <= 8'b00100000; delay <= 2'b10; end
                10'b00_00100000: begin led_r <= 8'b01000000; delay <= 2'b10; end
                10'b00_01000000: begin led_r <= 8'b10000000; delay <= 2'b10; end
                // End of animation, decrement repetitions
                10'b00_10000000: begin
                    led_r <= 8'b00000000;
                    repetitions <= repetitions - 1;
                end 
                default: led_r <= 0;
            endcase

        // Player 1 win animation (LEDs expand from edges to center, then fill left)
        end else if (win_1_animation_triggered && (repetitions != 2'b0)) begin
            casez ({delay, led_r})
                10'b10_????????: delay <= delay - 1;
                10'b01_????????: delay <= delay - 1;

                10'b00_00000000: begin led_r <= 8'b10000001; delay <= 2'b10; end
                10'b00_10000001: begin led_r <= 8'b01000010; delay <= 2'b10; end
                10'b00_01000010: begin led_r <= 8'b00100100; delay <= 2'b10; end
                10'b00_00100100: begin led_r <= 8'b00011000; delay <= 2'b10; end
                10'b00_00011000: begin led_r <= 8'b00111000; delay <= 2'b10; end
                10'b00_00111000: begin led_r <= 8'b01111000; delay <= 2'b10; end
                10'b00_01111000: begin led_r <= 8'b11111000; delay <= 2'b10; end
                // Hold filled state for extra delay
                10'b00_11111000: begin
                    led_r <= 8'b11111000;
                    delay <= 2'b11;
                end
                // Clear LEDs and decrement repetitions
                10'b11_11111000: begin
                    led_r <= 8'b00000000;
                    delay <= delay - 1;
                    repetitions <= repetitions - 1;
                end
                default: led_r <= 0;
            endcase

        // Player 2 win animation (LEDs expand from edges to center, then fill right)
        end else if (win_2_animation_triggered && (repetitions != 2'b0)) begin
            casez ({delay, led_r})
                10'b10_????????: delay <= delay - 1;
                10'b01_????????: delay <= delay - 1;

                10'b00_00000000: begin led_r <= 8'b10000001; delay <= 2'b10; end
                10'b00_10000001: begin led_r <= 8'b01000010; delay <= 2'b10; end
                10'b00_01000010: begin led_r <= 8'b00100100; delay <= 2'b10; end
                10'b00_00100100: begin led_r <= 8'b00011000; delay <= 2'b10; end
                10'b00_00011000: begin led_r <= 8'b00011100; delay <= 2'b10; end
                10'b00_00011100: begin led_r <= 8'b00011110; delay <= 2'b10; end
                10'b00_00011110: begin led_r <= 8'b00011111; delay <= 2'b10; end
                // Hold filled state for extra delay
                10'b00_00011111: begin
                    led_r <= 8'b00011111;
                    delay <= 2'b11;
                end
                // Clear LEDs and decrement repetitions
                10'b11_00011111: begin
                    led_r <= 8'b00000000;
                    delay <= delay - 1;
                    repetitions <= repetitions - 1;
                end
                default: led_r <= 0;
            endcase

        // Idle state: check for new triggers and set flags
        end else begin
            led_r <= 8'b0;
            if (win_player_1) begin
                win_1_animation_triggered <= 1;
                win_2_animation_triggered <= 0;
                goal_1_animation_triggered <= 0;
                goal_2_animation_triggered <= 0;

            end if (win_player_2) begin
                win_1_animation_triggered <= 0;
                win_2_animation_triggered <= 1;
                goal_1_animation_triggered <= 0;
                goal_2_animation_triggered <= 0;

            end if (goal_player_1) begin
                win_1_animation_triggered <= 0;
                win_2_animation_triggered <= 0;
                goal_1_animation_triggered <= 1;
                goal_2_animation_triggered <= 0;

            end if (goal_player_2) begin
                win_1_animation_triggered <= 0;
                win_2_animation_triggered <= 0;
                goal_1_animation_triggered <= 0;
                goal_2_animation_triggered <= 1;
            end

            // Set repetitions if any animation is triggered
            if (win_player_1 || win_player_2 || goal_player_1 || goal_player_2) begin
                repetitions <= 2'b01;
            end else begin
                repetitions <= 2'b00;
            end
        end
    end

endmodule
