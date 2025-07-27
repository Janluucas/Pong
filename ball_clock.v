
module ball_clock (
    input wire CLOCK_25,
    output wire BALL_CLOCK
);
    reg[18:0] cnt;

    always @(posedge CLOCK_25) begin
        cnt <= cnt + 1'b1;
    end

    assign BALL_CLOCK = cnt[18];

    
endmodule
