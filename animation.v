
module animation (
    input wire BALL_CLOCK,
    input wire goal_player_1,
    input wire goal_player_2,
    input wire win_player_1,
    input wire win_player_2,

    output wire[7:0] led
);
    reg goal_1_animation_triggered = 0;
    reg goal_2_animation_triggered = 0;
    reg win_1_animation_triggered = 0;
    reg win_2_animation_triggered = 0;

    reg[7:0] led_r;
    assign led = led_r;

    reg[1:0] repetitions = 0;

    always @(posedge BALL_CLOCK) begin
        if (goal_1_animation_triggered && (repetitions != 2'b0)) begin
            case (led_r)
                8'b00000000: led_r <= 8'b10000000;
                8'b10000000: led_r <= 8'b01000000;
                8'b01000000: led_r <= 8'b00100000;
                8'b00100000: led_r <= 8'b00010000;
                8'b00010000: led_r <= 8'b00001000;
                8'b00001000: led_r <= 8'b00000100;
                8'b00000100: led_r <= 8'b00000010;
                8'b00000010: led_r <= 8'b00000001;
                8'b00000001: begin
                    led_r <= 8'b00000000;
                    repetitions <= repetitions - 1;
                end
                default: led_r <= 0;
            endcase

        end else if (goal_2_animation_triggered && (repetitions != 2'b0)) begin
            case (led_r)
                8'b00000000: led_r <= 8'b00000001;
                8'b00000001: led_r <= 8'b00000010;
                8'b00000010: led_r <= 8'b00000100;
                8'b00000100: led_r <= 8'b00001000;
                8'b00001000: led_r <= 8'b00010000;
                8'b00010000: led_r <= 8'b00100000;
                8'b00100000: led_r <= 8'b01000000;
                8'b01000000: led_r <= 8'b10000000;
                8'b10000000: begin
                    led_r <= 8'b00000000;
                    repetitions <= repetitions - 1;
                end 
                default: led_r <= 0;
            endcase

        end else if (win_1_animation_triggered && (repetitions != 2'b0)) begin
            case (led_r)
                8'b00000000: led_r <= 8'b10000001;
                8'b10000001: led_r <= 8'b01000010;
                8'b01000010: led_r <= 8'b00100100;
                8'b00100100: led_r <= 8'b00011000;
                8'b00011000: led_r <= 8'b00111000;
                8'b00111000: led_r <= 8'b01111000;
                8'b01111000: led_r <= 8'b11111000;
                8'b11111000: begin
                    led_r <= 8'b00000000;
                    repetitions <= repetitions - 1;
                end
                default: led_r <= 0;
            endcase

        end else if (win_2_animation_triggered && (repetitions != 2'b0)) begin
            case (led_r)
                8'b00000000: led_r <= 8'b10000001;
                8'b10000001: led_r <= 8'b01000010;
                8'b01000010: led_r <= 8'b00100100;
                8'b00100100: led_r <= 8'b00011000;
                8'b00011000: led_r <= 8'b00011100;
                8'b00011100: led_r <= 8'b00011110;
                8'b00011110: led_r <= 8'b00011111;
                8'b00011111: begin
                    led_r <= 8'b00000000;
                    repetitions <= repetitions - 1;
                end
                default: led_r <= 0;
            endcase

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

            if (win_player_1 || win_player_2 || goal_player_1 || goal_player_2) begin
                repetitions <= 2'b11;
            end
        end
    end

endmodule
