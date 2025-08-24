`include "global_symbols.vh"

module win_screen (
    input wire clk,

    input wire[11:0] x,
    input wire[11:0] y,

    input wire winner,

    output wire out
);
    reg out_r;
    assign out = out_r;

    always @(posedge clk) begin
        if (winner) begin
            out_r <= (
                // === 'M' (schöner, symmetrisch, 16px breit) ===
                ((`MENU_TEXT_X_POS <= x) &&
                (x < `MENU_TEXT_X_POS + 3) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

                ((`MENU_TEXT_X_POS + 3 <= x) &&
                (x < `MENU_TEXT_X_POS + 5) &&
                (`MENU_TEXT_Y_POS + 4 <= y) &&
                (y < `MENU_TEXT_Y_POS + 12)) ||

                ((`MENU_TEXT_X_POS + 5 <= x) &&
                (x < `MENU_TEXT_X_POS + 7) &&
                (`MENU_TEXT_Y_POS + 8 <= y) &&
                (y < `MENU_TEXT_Y_POS + 20)) ||

                ((`MENU_TEXT_X_POS + 7 <= x) &&
                (x < `MENU_TEXT_X_POS + 9) &&
                (`MENU_TEXT_Y_POS + 4 <= y) &&
                (y < `MENU_TEXT_Y_POS + 12)) ||

                ((`MENU_TEXT_X_POS + 9 <= x) &&
                (x < `MENU_TEXT_X_POS + 12) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

                // === 'E' ===
                ((`MENU_TEXT_X_POS + 16 <= x) &&
                (x < `MENU_TEXT_X_POS + 20) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

                ((`MENU_TEXT_X_POS + 20 <= x) &&
                (x < `MENU_TEXT_X_POS + 28) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 4)) ||

                ((`MENU_TEXT_X_POS + 20 <= x) &&
                (x < `MENU_TEXT_X_POS + 28) &&
                (`MENU_TEXT_Y_POS + 12 <= y) &&
                (y < `MENU_TEXT_Y_POS + 16)) ||

                ((`MENU_TEXT_X_POS + 20 <= x) &&
                (x < `MENU_TEXT_X_POS + 28) &&
                (`MENU_TEXT_Y_POS + 24 <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

                // === 'N' (schön, 16px breit, diagonale) ===
                ((`MENU_TEXT_X_POS + 32 <= x) &&
                (x < `MENU_TEXT_X_POS + 36) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

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

                ((`MENU_TEXT_X_POS + 48 <= x) &&
                (x < `MENU_TEXT_X_POS + 52) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

                // === 'U' (verschoben) ===
                ((`MENU_TEXT_X_POS + 56 <= x) &&
                (x < `MENU_TEXT_X_POS + 60) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 24)) ||

                ((`MENU_TEXT_X_POS + 60 <= x) &&
                (x < `MENU_TEXT_X_POS + 68) &&
                (`MENU_TEXT_Y_POS + 24 <= y) &&
                (y < `MENU_TEXT_Y_POS + 28)) ||

                ((`MENU_TEXT_X_POS + 68 <= x) &&
                (x < `MENU_TEXT_X_POS + 72) &&
                (`MENU_TEXT_Y_POS <= y) &&
                (y < `MENU_TEXT_Y_POS + 24))
            );
        end else begin
            out_r <= 0;
        end
    end

endmodule
