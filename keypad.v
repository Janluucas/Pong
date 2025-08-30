module keypad(
    input  wire       clk,
    input  wire [3:0] cols,
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
		case ({~rows, ~cols})
			8'b0001_0001: begin keycode <= {4'd1,flag}; flag <= flag;	end// '1'
			8'b0001_0010: begin keycode <= {4'd2,~flag}; flag <= ~flag;	end 	// '2'
			8'b0001_0100: begin keycode <= {4'd3,flag}; flag <= flag;	end	// '3'
			8'b0001_1000: begin keycode <= {4'd10,flag}; flag <= flag;	end	// 'A'
			8'b0010_0001: begin keycode <= {4'd4,flag}; flag <= flag;	end	// '4'
			8'b0010_0010: begin keycode <= {4'd5,flag}; flag <= flag;	end	// '5'
			8'b0010_0100: begin keycode <= {4'd6,flag}; flag <= flag;	end	// '6'
			8'b0010_1000: begin keycode <= {4'd11,flag}; flag <= flag;	end	// 'B'
			8'b0100_0001: begin keycode <= {4'd7,flag}; flag <= flag;	end	// '7'
			8'b0100_0010: begin keycode <= {4'd8,~flag}; flag <= ~flag;	end	// '8'
			8'b0100_0100: begin keycode <= {4'd9,flag}; flag <= flag;	end	// '9'
			8'b0100_1000: begin keycode <= {4'd12,flag}; flag <= flag;	end	// 'C'
			8'b1000_0001: begin keycode <= {4'd14,flag}; flag <= flag;	end	// '*'
			8'b1000_0010: begin keycode <= {4'd0,flag}; flag <= flag;	end 	// '0'
			8'b1000_0100: begin keycode <= {4'd15,flag}; flag <= flag;	end // '#'
			8'b1000_1000: begin keycode <= {4'd13,flag}; flag <= flag;	end	// 'D'

			// To-Do: Detect key release
			default:      keycode <= keycode; // No key pressed (deactivated feature)
		endcase
	end

endmodule