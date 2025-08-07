module player_movement (
	input wire clk,
	input wire wire1,
	input wire wire2,
	input wire wire3,
	output wire wire4,
	output wire wire5,
	output wire wire6,
	output wire wire7,
	output wire wire8,
	output wire up,
	output wire down,
);

reg key;
keypad player_input(
	.clk(clk),
	.wire1(wire1),
	.wire2(wire2),
	.wire3(wire3),
	.wire4(wire4),
	.wire5(wire5),
	.wire6(wire6),
	.wire7(wire7),
	.wire8(wire8),
	.key(key)
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