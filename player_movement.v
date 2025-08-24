module player_movement (
    input wire clk,          // Clock input
    input wire wire1,        // Keypad input wire 1 (row 1)
    input wire wire2,        // Keypad input wire 2 (row 2)
    input wire wire3,        // Keypad input wire 3 (row 3)
    output wire wire4,       // Keypad output wire 4 (row 4)
    output wire wire5,       // Keypad output wire 5 (column 1)
    output wire wire6,       // Keypad output wire 6 (column 2)
    output wire wire7,       // Keypad output wire 7 (column 3)
    output wire wire8,       // Keypad output wire 8 (column 4)
    output wire up,          // Output: move up
    output wire down,        // Output: move down
);

    // Register to store key value from keypad
    reg key;

    // Instantiate keypad module to read player input
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

    // Internal registers for movement logic
    reg a_low_first = 0;
    reg b_low_first = 0;

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