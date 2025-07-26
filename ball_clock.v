
module ball_clock (
    input wire CLOCK_25,
    output wire BALL_CLOCK
);
    reg[9:0] cnt = 10'b0;

    assign BALL_CLOCK = cnt[9];

    always @(posedge CLOCK_25) begin
        cnt <= cnt + 1'b1;
    end
endmodule
