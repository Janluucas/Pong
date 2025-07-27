
module animation (
    input wire BALL_CLOCK,
    input wire[1:0] mode,

    output wire[7:0] led
);
    reg busy = 0;

    always @(posedge BALL_CLOCK) begin
        
    end
    
endmodule
