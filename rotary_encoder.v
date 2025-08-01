
module rotary_encoder (
    input wire clk,
    input wire in_a,
    input wire in_b,
    input wire switch,

    output wire up,
    output wire down,
    output wire button
);
    reg a_low_first = 0;
    reg b_low_first = 0;

    reg up_r = 0;
    reg down_r = 0;
    assign up = (dead_zone == 32'hFFFFFFFF) ? up_r : 0;
    assign down = (dead_zone == 32'hFFFFFFFF) ? down_r : 0;

    reg signal_sent = 0;

    reg[31:0] dead_zone = 32'b0;

    always @(posedge clk) begin
        casez ({in_a, in_b, a_low_first, b_low_first, signal_sent})
            2'b??_??_1: begin
                dead_zone <= dead_zone + 1'b1;
                if (dead_zone == 32'hFFFFFFFF) begin
                    signal_sent <= 0;
                    up_r <= 0;
                    down_r <= 0;
                    a_low_first <= 0;
                    b_low_first <= 0;
                end
            end

            2'b01_01_0: begin
                up_r <= 1;
                signal_sent <= 1;
            end
            2'b10_10_0: begin
                down_r <= 1;
                signal_sent <= 1;
            end

            2'b01_00_0: a_low_first <= 1;
            2'b10_00_0: b_low_first <= 1;
        endcase
    end

endmodule
