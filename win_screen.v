`include "global_symbols.vh"

// Module to display the "WIN" text for the winning player on the screen
module win_screen (
    input wire clk,                // Clock signal

    input wire[11:0] x,            // Current pixel x-coordinate
    input wire[11:0] y,            // Current pixel y-coordinate

    input wire[2:0] winner,        // Indicates which player won

    output wire out                // Output: 1 if current pixel is part of the win text, 0 otherwise
);
    reg out_r;
    assign out = out_r;

    always @(posedge clk) begin
        case (winner)
            // If Player 1 wins, draw "WIN" at Player 1's side
            `PLAYER_1_COLOR: begin
                out_r <= ( // DRAW 'W'
                    (`WIN_TEXT_PLAYER_1_X_POS <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 4)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || (
                    ((`WIN_TEXT_PLAYER_1_X_POS + 4) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 12)) &&
                    ((`WIN_TEXT_Y_POS + 24) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    ((`WIN_TEXT_PLAYER_1_X_POS + 12) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 16)) &&
                    ((`WIN_TEXT_Y_POS + 4) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || (
                    ((`WIN_TEXT_PLAYER_1_X_POS + 16) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 24)) &&
                    ((`WIN_TEXT_Y_POS + 24) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    ((`WIN_TEXT_PLAYER_1_X_POS + 24) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 28)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || ( // DRAW 'I'
                    ((`WIN_TEXT_PLAYER_1_X_POS + 32) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 36)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || ( // DRAW 'N'
                    ((`WIN_TEXT_PLAYER_1_X_POS + 40) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 44)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    ((`WIN_TEXT_PLAYER_1_X_POS + 44) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 48)) &&
                    ((`WIN_TEXT_Y_POS + 4) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 12))
                ) || (
                    ((`WIN_TEXT_PLAYER_1_X_POS + 48) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 52)) &&
                    ((`WIN_TEXT_Y_POS + 12) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 16))
                ) || (
                    ((`WIN_TEXT_PLAYER_1_X_POS + 52) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 56)) &&
                    ((`WIN_TEXT_Y_POS + 16) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || (
                    ((`WIN_TEXT_PLAYER_1_X_POS + 56) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 60)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                );
            end

            // If Player 2 wins, draw "WIN" at Player 2's side
            `PLAYER_2_COLOR: begin
                out_r <= ( // DRAW 'W'
                    (`WIN_TEXT_PLAYER_2_X_POS <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 4)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || (
                    ((`WIN_TEXT_PLAYER_2_X_POS + 4) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 12)) &&
                    ((`WIN_TEXT_Y_POS + 24) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    ((`WIN_TEXT_PLAYER_2_X_POS + 12) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 16)) &&
                    ((`WIN_TEXT_Y_POS + 4) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || (
                    ((`WIN_TEXT_PLAYER_2_X_POS + 16) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 24)) &&
                    ((`WIN_TEXT_Y_POS + 24) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    ((`WIN_TEXT_PLAYER_2_X_POS + 24) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 28)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || ( // DRAW 'I'
                    ((`WIN_TEXT_PLAYER_2_X_POS + 32) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 36)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || ( // DRAW 'N'
                    ((`WIN_TEXT_PLAYER_2_X_POS + 40) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 44)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    ((`WIN_TEXT_PLAYER_2_X_POS + 44) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 48)) &&
                    ((`WIN_TEXT_Y_POS + 4) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 12))
                ) || (
                    ((`WIN_TEXT_PLAYER_2_X_POS + 48) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 52)) &&
                    ((`WIN_TEXT_Y_POS + 12) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 16))
                ) || (
                    ((`WIN_TEXT_PLAYER_2_X_POS + 52) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 56)) &&
                    ((`WIN_TEXT_Y_POS + 16) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || (
                    ((`WIN_TEXT_PLAYER_2_X_POS + 56) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 60)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                );
            end

            // Default: no output
            default: out_r <= 0; 
        endcase
    end
    
endmodule
