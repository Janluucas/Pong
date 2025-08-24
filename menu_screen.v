`include "global_symbols.vh"

// menu_screen module: Draws the word "MENU" on the screen
module menu_screen (
    input wire clk,              // Clock signal

    input wire[11:0] x,          // Current pixel x coordinate
    input wire[11:0] y,          // Current pixel y coordinate

    input wire menu,             // (Unused in this code) Menu enable signal

    output wire out              // Output: 1 if current pixel is part of the "MENU" text, 0 otherwise
);
    reg out_r;                   // Register to hold output value
    assign out = out_r;          // Assign register to output

    always @(posedge clk) begin
        // Only display the menu text if 'winner' is high
        if (winner) begin
            out_r <= (
                // === 'M' (wide, 18px) ===
                // Left vertical bar of 'M'
                ((`MENU_TEXT_X_POS <= x) &&
                 (x < `MENU_TEXT_X_POS + 3) &&
                 (`MENU_TEXT_Y_POS <= y) &&
                 (y < `MENU_TEXT_Y_POS + 28)) ||

                // Left diagonal of 'M'
                ((`MENU_TEXT_X_POS + 3 <= x) &&
                 (x < `MENU_TEXT_X_POS + 5) &&
                 (`MENU_TEXT_Y_POS + 4 <= y) &&
                 (y < `MENU_TEXT_Y_POS + 12)) ||

                // Middle diagonal of 'M'
                ((`MENU_TEXT_X_POS + 5 <= x) &&
                 (x < `MENU_TEXT_X_POS + 7) &&
                 (`MENU_TEXT_Y_POS + 8 <= y) &&
                 (y < `MENU_TEXT_Y_POS + 20)) ||

                // Center of 'M'
                ((`MENU_TEXT_X_POS + 7 <= x) &&
                 (x < `MENU_TEXT_X_POS + 9) &&
                 (`MENU_TEXT_Y_POS + 12 <= y) &&
                 (y < `MENU_TEXT_Y_POS + 16)) ||

                // Right diagonal of 'M'
                ((`MENU_TEXT_X_POS + 9 <= x) &&
                 (x < `MENU_TEXT_X_POS + 11) &&
                 (`MENU_TEXT_Y_POS + 8 <= y) &&
                 (y < `MENU_TEXT_Y_POS + 20)) ||

                // Right diagonal of 'M'
                ((`MENU_TEXT_X_POS + 11 <= x) &&
                 (x < `MENU_TEXT_X_POS + 13) &&
                 (`MENU_TEXT_Y_POS + 4 <= y) &&
                 (y < `MENU_TEXT_Y_POS + 12)) ||

                // Right vertical bar of 'M'
                ((`MENU_TEXT_X_POS + 13 <= x) &&
                 (x < `MENU_TEXT_X_POS + 16) &&
                 (`MENU_TEXT_Y_POS <= y) &&
                 (y < `MENU_TEXT_Y_POS + 28)) ||

                // === 'E' ===
                // Left vertical bar of 'E'
                ((`MENU_TEXT_X_POS + 20 <= x) &&
                 (x < `MENU_TEXT_X_POS + 24) &&
                 (`MENU_TEXT_Y_POS <= y) &&
                 (y < `MENU_TEXT_Y_POS + 28)) ||

                // Top horizontal bar of 'E'
                ((`MENU_TEXT_X_POS + 24 <= x) &&
                 (x < `MENU_TEXT_X_POS + 32) &&
                 (`MENU_TEXT_Y_POS <= y) &&
                 (y < `MENU_TEXT_Y_POS + 4)) ||

                // Middle horizontal bar of 'E'
                ((`MENU_TEXT_X_POS + 24 <= x) &&
                 (x < `MENU_TEXT_X_POS + 32) &&
                 (`MENU_TEXT_Y_POS + 12 <= y) &&
                 (y < `MENU_TEXT_Y_POS + 16)) ||

                // Bottom horizontal bar of 'E'
                ((`MENU_TEXT_X_POS + 24 <= x) &&
                 (x < `MENU_TEXT_X_POS + 32) &&
                 (`MENU_TEXT_Y_POS + 24 <= y) &&
                 (y < `MENU_TEXT_Y_POS + 28)) ||

                // === 'N' (nice, 16px wide, diagonal) ===
                // Left vertical bar of 'N'
                ((`MENU_TEXT_X_POS + 32 <= x) &&
                (x < `MENU_TEXT_X_POS + 36) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

                // Diagonal segments of 'N'
                ((`MENU_TEXT_X_POS + 36 <= x) &&
                (x < `MENU_TEXT_X_POS + 40) &&
                (`MENU_TEXT_Y_POS + 4 <= y) &&
                (y < `MENU_TEXT_Y_POS + 12)) ||

                ((`MENU_TEXT_X_POS + 40 <= x) &&
                (x < `MENU_TEXT_X_POS + 44) &&
                (`MENU_TEXT_Y_POS + 8 <= y) &&
                (y < `MENU_TEXT_Y_POS + 16)) ||

                ((`MENU_TEXT_X_POS + 44 <= x) &&
                (x < `MENU_TEXT_X_POS + 48) &&
                (`MENU_TEXT_Y_POS + 12 <= y) &&
                (y < `MENU_TEXT_Y_POS + 20)) ||

                // Right vertical bar of 'N'
                ((`MENU_TEXT_X_POS + 48 <= x) &&
                (x < `MENU_TEXT_X_POS + 52) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

                // === 'U' (shifted) ===
                // Left vertical bar of 'U'
                ((`MENU_TEXT_X_POS + 56 <= x) &&
                (x < `MENU_TEXT_X_POS + 60) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 24)) ||

                // Bottom horizontal bar of 'U'
                ((`MENU_TEXT_X_POS + 60 <= x) &&
                (x < `MENU_TEXT_X_POS + 68) &&
                (`MENU_TEXT_Y_POS + 24 <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

                // Right vertical bar of 'U'
                ((`MENU_TEXT_X_POS + 68 <= x) &&
                (x < `MENU_TEXT_X_POS + 72) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 24))
            );
        end else begin
            out_r <= 0; //if not part of letter, output 0
        end
    end
endmodule
