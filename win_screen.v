`include "global_symbols.vh"

module win_screen (
    input wire clk,

    input wire[11:0] x,
    input wire[11:0] y,

    input wire[2:0] winner,

    input wire out
);
    reg out_r;
    assign out = out_r;


    always @(posedge clk) begin
        case (winner)
            `PLAYER_1_COLOR: out_r <= (
                (
                    // DRAW 'W'
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
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 20)) &&
                    ((`WIN_TEXT_Y_POS + 24) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    ((`WIN_TEXT_PLAYER_1_X_POS + 24) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 28)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || (
                    // DRAW 'I'
                    ((`WIN_TEXT_PLAYER_1_X_POS + 32) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_1_X_POS + 36)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    // DRAW 'N'
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
                )
            );

            `PLAYER_2_COLOR: out_r <= (
                (
                    // DRAW 'W'
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
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 20)) &&
                    ((`WIN_TEXT_Y_POS + 24) <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    ((`WIN_TEXT_PLAYER_2_X_POS + 24) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 28)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 24))
                ) || (
                    // DRAW 'I'
                    ((`WIN_TEXT_PLAYER_2_X_POS + 32) <= x) &&
                    (x < (`WIN_TEXT_PLAYER_2_X_POS + 36)) &&
                    (`WIN_TEXT_Y_POS <= y) &&
                    (y < (`WIN_TEXT_Y_POS + 28))
                ) || (
                    // DRAW 'N'
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
                )
            );

            default: out_r <= 0; 
        endcase
    end
    
endmodule
