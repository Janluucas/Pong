
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
    reg out = 0;
    reg triggered = 0;
    reg triggered_old = 0;
    reg[23:0] dead_zone = 24'b0;
    assign up = out? up_r : 0;
    assign down = out? down_r : 0;

    always @(negedge in_a) begin 
        triggered <= ~triggered;
        if (in_b) begin
            up_r = 1;
            down_r = 0;
        end else begin
            up_r = 0;
            down_r = 1;
        end
    end

    always @(posedge clk) begin
        if (triggered != triggered_old && dead_zone == 24'b0) begin
            out <= 1;
            triggered_old <= triggered;
            dead_zone <= dead_zone + 1'b1;
        end
        else begin
            out <= 0;
            if (dead_zone != 24'b0) begin
                dead_zone <= dead_zone + 1'b1;
                
            end
        end
    end
endmodule
