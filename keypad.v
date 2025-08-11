module keypad (
	input wire clk,
	input wire [3:0] cols,
	output wire [3:0] rows,
	output wire [3:0] keys,
	output wire keypressed
);
	reg keypressed_r = 0;
	reg [3:0] keycode;

	assign keys = keycode;
	assign keypressed = keypressed_r;

	reg [1:0] state;
	always @(posedge clk) begin
		state <= state + 1;
		rows <= ~(4'b0001 << state);

		keypressed_r <= 0; // Reset keypressed_r on each clock cycle
			case ({~rows, ~cols})
				8'b0001_0001: begin keypressed_r = 1; keycode <= 4'd1; end	// '1'
				8'b0001_0010: begin keypressed_r = 1; keycode <= 4'd2; end 	// '2'
				8'b0001_0100: begin keypressed_r = 1; keycode <= 4'd3; end	// '3'
				8'b0001_1000: begin keypressed_r = 1; keycode <= 4'd10; end	// 'A'
				8'b0010_0001: begin keypressed_r = 1; keycode <= 4'd4; end	// '4'
				8'b0010_0010: begin keypressed_r = 1; keycode <= 4'd5; end	// '5'
				8'b0010_0100: begin keypressed_r = 1; keycode <= 4'd6; end	// '6'
				8'b0010_1000: begin keypressed_r = 1; keycode <= 4'd11; end	// 'B'
				8'b0100_0001: begin keypressed_r = 1; keycode <= 4'd7; end	// '7'
				8'b0100_0010: begin keypressed_r = 1; keycode <= 4'd8; end	// '8'
				8'b0100_0100: begin keypressed_r = 1; keycode <= 4'd9; end	// '9'
				8'b0100_1000: begin keypressed_r = 1; keycode <= 4'd12; end	// 'C'
				8'b1000_0001: begin keypressed_r = 1; keycode <= 4'd14; end	// '*'
				8'b1000_0010: begin keypressed_r = 1; keycode <= 4'd0; end	// '0'
				8'b1000_0100: begin keypressed_r = 1; keycode <= 4'd15; end	// '#'
				8'b1000_1000: begin keypressed_r = 1; keycode <= 4'd13; end	// 'D'
				default:      begin keypressed_r = 0; keycode <= keycode; end
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