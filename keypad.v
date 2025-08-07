module keypad (
	input wire clk,
	input wire wire1,
	input wire wire2,
	input wire wire3,
	input wire wire4,
	output wire wire5,
	output wire wire6,
	output wire wire7,
	output wire wire8,
	output wire up,
	output wire down,
	output wire[7:0] led
);
	reg keypressed = 0;
	reg [3:0] keycode;
	reg[7:0] led_r;
	assign led = led_r;

	assign wire5 = (state == 2'b00) ? 1'b1 : 1'b0;
	assign wire6 = (state == 2'b01) ? 1'b1 : 1'b0;
	assign wire7 = (state == 2'b10) ? 1'b1 : 1'b0;
	assign wire8 = (state == 2'b11) ? 1'b1 : 1'b0;

	reg [1:0] state;
	always @(posedge clk) begin
		state <= state + 1;
		case ({state, wire1, wire2, wire3, wire4})
			6'b001000: begin keypressed <= 1; keycode <= 4'b0000; end // Key 1
			6'b000100: begin keypressed <= 1; keycode <= 4'b0001; led_r <= 8'b01000000; end // Key 2
			6'b000010: begin keypressed <= 1; keycode <= 4'b0010; end // Key 3
			6'b000001: begin keypressed <= 1; keycode <= 4'b0011; end // Key A
			6'b011000: begin keypressed <= 1; keycode <= 4'b0100; end // Key 4
			6'b010100: begin keypressed <= 1; keycode <= 4'b0101; end // Key 5
			6'b010010: begin keypressed <= 1; keycode <= 4'b0110; end // Key 6
			6'b010001: begin keypressed <= 1; keycode <= 4'b0111; end // Key B
			6'b101000: begin keypressed <= 1; keycode <= 4'b1000; end // Key 7
			6'b100100: begin keypressed <= 1; keycode <= 4'b1001; led_r <= 8'b00000001; end // Key 8
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