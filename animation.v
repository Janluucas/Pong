
/*
    default := 00

    pause mode := 01
    goal mode := 10
    win mode := 11
*/
module animation (
    input wire BALL_CLOCK,
    input wire[1:0] mode,

    output wire[7:0] led
);
    reg busy = 0;
    reg[1:0] repetitions = 0;

    reg[7:0] led_r = 8'b0;
    assign led = led_r;

    always @(posedge BALL_CLOCK) begin
        if (repetitions == 3) begin
            repetitions <= 0;
            busy <= 0;
            led_r <= 8'b00000000;

        // goal animation
        end else if (busy && (repetitions <= 3) && (mode == 2'b10)) begin
            case (led_r)
                8'b00000000: led_r <= 8'b00000001;
                8'b10000000: begin
                    led_r <= 8'b00000001;
                    repetitions <= repetitions + 1;
                end
                default: led_r <= {led_r[6:0], led_r[7]};
            endcase

        // win animation
        end else if (busy && (repetitions <= 3) && (mode == 2'b11)) begin
            case (led_r)
                8'b00000000: led_r <= 8'b00011000;
                8'b10000001: begin
                    led_r <= 8'b00011000;
                    repetitions <= repetitions + 1;
                end
                default: led_r <= {led_r[6:4], led_r[7], led_r[0], led_r[3:1]};
            endcase

        // pause "animation"
        end else if (busy && (mode == 2'b01)) begin
            led_r <= 8'b11111111;
        
        // default
        end else begin
            led_r <= 8'b00000000;
        end
    end
    
endmodule
