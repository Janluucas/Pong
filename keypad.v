module keypad (
	input wire clk,
	output wire wire1,
	output wire wire2,
	output wire wire3,
	output wire wire4,
	input wire wire5,
	input wire wire6,
	input wire wire7,
	input wire wire8,
	output wire up,
	output wire down
);
	reg keypressed = 0;
	reg [3:0] keycode;

	reg high = 1'b1; // High signal for the keypad wires
	assign wire1 = (state == 2'b00) ? high : 0;
	assign wire2 = (state == 2'b01) ? high : 0;
	assign wire3 = (state == 2'b10) ? high : 0;
	assign wire4 = (state == 2'b11) ? high : 0;

	reg [1:0] state;
	always @(posedge clk) begin
		state <= state + 1;
		case ({state, wire5, wire6, wire7, wire8})
			6'b001000: begin keypressed <= 1; keycode <= 4'b0000; end // Key 1
			6'b000100: begin keypressed <= 1; keycode <= 4'b0001; end // Key 2
			6'b000010: begin keypressed <= 1; keycode <= 4'b0010; end // Key 3
			6'b000001: begin keypressed <= 1; keycode <= 4'b0011; end // Key A
			6'b011000: begin keypressed <= 1; keycode <= 4'b0100; end // Key 4
			6'b010100: begin keypressed <= 1; keycode <= 4'b0101; end // Key 5
			6'b010010: begin keypressed <= 1; keycode <= 4'b0110; end // Key 6
			6'b010001: begin keypressed <= 1; keycode <= 4'b0111; end // Key B
			6'b101000: begin keypressed <= 1; keycode <= 4'b1000; end // Key 7
			6'b100100: begin keypressed <= 1; keycode <= 4'b1001; end // Key 8
			6'b100010: begin keypressed <= 1; keycode <= 4'b1010; end // Key 9
			6'b100001: begin keypressed <= 1; keycode <= 4'b1011; end // Key C
			6'b111000: begin keypressed <= 1; keycode <= 4'b1100; end // Key *
			6'b110100: begin keypressed <= 1; keycode <= 4'b1101; end // Key 0
			6'b110010: begin keypressed <= 1; keycode <= 4'b1110; end // Key #
			6'b110001: begin keypressed <= 1; keycode <= 4'b1111; end // Key D
			default: keypressed <= 0; // No key pressed
		endcase
	end

	// Debouncer
	reg[23:0] dead_zone = 24'b0;

	always @(posedge clk) begin
		dead_zone <= dead_zone + 1'b1;
	end

	assign up = (keypressed && dead_zone == 0 && keycode == 4'b0001);
	assign down = (keypressed && dead_zone == 0 && keycode == 4'b1001);

endmodule