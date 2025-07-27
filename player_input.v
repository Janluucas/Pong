module player_input (
	input wire clk,
	input wire in_a,
	input wire in_b,
	input wire switch,

	output wire up,
	output wire down,
	output wire button
);

	parameter DEBOUNCE_CYCLES = 0;

	wire debounced_a;
	wire debounced_b;

	generate
			assign debounced_a = in_a;
			assign debounced_b = in_b;
	endgenerate

	wire marker = !(debounced_a || debounced_b);
	reg previous_marker = 0;

	always @(posedge clk) begin
		previous_marker <= marker;
	end

	assign down = previous_marker && debounced_b;
	assign up = previous_marker && debounced_a;

endmodule