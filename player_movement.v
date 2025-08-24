//deprecated module, possibley needed to debounce keypad input in future
module player_movement (
    input wire clk,          // Clock input
    input wire [3:0] keycode, // 4-bit keycode input from keypad
    output wire up,          // Output: move up
    output wire down,        // Output: move down

);

    // Register to store key value from keypad
    reg key;

    reg up_r = 0;           // Register for up signal
    reg down_r = 0;         // Register for down signal
    reg out = 0;            // Output enable register
    reg triggered = 0;      // Trigger flag
    reg triggered_old = 0;  // Previous trigger flag
    reg[23:0] dead_zone = 24'b0; // Dead zone counter

    // Output assignments: only assert up/down if 'out' is high
    assign up = out ? up_r : 0;
    assign down = out ? down_r : 0;

    // Output pulse and dead zone logic
    always @(posedge clk) begin
        if (triggered != triggered_old && dead_zone == 24'b0) begin
            out <= 1;                   // Enable output pulse
            triggered_old <= triggered; // Update previous trigger
            dead_zone <= dead_zone + 1'b1; // Start dead zone
        end
        else begin
            out <= 0;                   // Disable output
            if (dead_zone != 24'b0) begin
                dead_zone <= dead_zone + 1'b1; // Increment dead zone
            end
        end
    end
endmodule