
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
    assign up = out? up_r : 0;
    assign down = out? down_r : 0;

    always @(negedge in_a) begin 
        if (in_b) begin
            up_r = 1;
            down_r = 0;
        end else begin
            up_r = 0;
            down_r = 1;
        end
    end

    always @(posedge clk) begin
        out <= 1;
    end

    always @(negedge clk) begin
        out <= 0;
        up_r <= 0;
        down_r <= 0;
    end
endmodule
