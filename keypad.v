module keypad(
    input  wire       clk,
    input  wire [3:0] cols,
	input wire flag_in, // Input flag for key press detection
    output reg  [3:0] rows,
    output reg  [4:0] keycode
);

	/*********************************************************************
	* Anmerkung:
	* Die Input-Ports sollten mit einem internen Pull-Up versehen werden.
	* Dies kann in der 'assignments' hinzugefügt werden
	*
	* set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to GPIO_023
	* set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to GPIO_021
	* set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to GPIO_019
	* set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to GPIO_017
	*********************************************************************/

	// Scan-Zyklus über Zeilen
	// Da wir nur Pull-Ups verwenden können, wird das invertierte
	// Tastendrucksignal gemessen, d.h. alle Ausgänge bis auf einen
	// sind 1 in rows und in cols wird die entsprechende Leitung
	// auf 0 gezogen.
	reg [1:0] row_sel = 2'd0;
	reg [9:0] cnt = 0;		// Debounce-Timer
	reg flag = 1'b0;		// Tastendruck-Flag

	always @(posedge clk) begin
		cnt <= cnt + 1;
		// Debouncing Intervall
		if (cnt[9]) begin
			row_sel <= row_sel + 1'b1;		// row to be scanned
			rows    <= ~(4'b0001 << row_sel);		// set rows
		end
	end


	// Zuordnung der gedrückten Taste aus cols
	// mittels kombinatorische Multiplexer- und sequentieller
	// keycode-Schaltung
	always @(posedge clk) begin
		case ({~rows, ~cols, flag_in})
			9'b0001_0001_0: begin keycode <= {4'd1,flag_in}; flag <= flag;	end	// '1'
			9'b0001_0010_0: begin keycode <= {4'd2,flag_in}; flag <= ~flag;	end // '2'
			9'b0001_0100_0: begin keycode <= {4'd3,flag_in}; flag <= flag;	end	// '3'
			9'b0001_1000_0: begin keycode <= {4'd10,flag_in}; flag <= flag;	end	// 'A'
			9'b0010_0001_0: begin keycode <= {4'd4,flag_in}; flag <= flag;	end	// '4'
			9'b0010_0010_0: begin keycode <= {4'd5,flag_in}; flag <= flag;	end	// '5'
			9'b0010_0100_0: begin keycode <= {4'd6,flag_in}; flag <= flag;	end	// '6'
			9'b0010_1000_0: begin keycode <= {4'd11,flag_in}; flag <= flag;	end	// 'B'
			9'b0100_0001_0: begin keycode <= {4'd7,flag_in}; flag <= flag;	end	// '7'
			9'b0100_0010_0: begin keycode <= {4'd8,flag_in}; flag <= ~flag;	end	// '8'
			9'b0100_0100_0: begin keycode <= {4'd9,flag_in}; flag <= flag;	end	// '9'
			9'b0100_1000_0: begin keycode <= {4'd12,flag_in}; flag <= flag;	end	// 'C'
			9'b1000_0001_0: begin keycode <= {4'd14,flag_in}; flag <= flag;	end	// '*'
			9'b1000_0010_0: begin keycode <= {4'd0,flag_in}; flag <= flag;	end // '0'
			9'b1000_0100_0: begin keycode <= {4'd15,flag_in}; flag <= flag;	end // '#'
			9'b1000_1000_0: begin keycode <= {4'd13,flag_in}; flag <= flag;	end	// 'D'

			// To-Do: Detect key release
			default:      keycode <= keycode; // No key pressed (deactivated feature)
		endcase
	end

endmodule