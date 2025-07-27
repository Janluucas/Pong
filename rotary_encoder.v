
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
    assign up = up_r;
    assign down = down_r;

    reg signal_sent = 0;

    always @(posedge clk) begin
        if (!signal_sent) begin
            if (!a_low_first && !b_low_first) begin
                if (!in_a) begin
                    a_low_first <= 1;
                end else if (!in_b) begin
                    b_low_first <= 1;
                end
                up_r <= 0;
                down_r <= 0;
            end else if (a_low_first) begin
                if (!in_b) begin
                    up_r <= 1;
                    a_low_first <= 0;
                    b_low_first <= 0;
                    signal_sent <= 1;
                end
            end else if (b_low_first) begin
                if (!in_a) begin
                    down_r <= 1;
                    a_low_first <= 0;
                    b_low_first <= 0;
                    signal_sent <= 1;
                end
            end
        end else begin
            a_low_first <= 0;
            b_low_first <= 0;
            up_r <= 0;
            down_r <= 0;
            signal_sent <= 0;
        end
    end

endmodule
