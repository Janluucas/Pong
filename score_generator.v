`include "global_symbols.vh"

// Module to generate score digit display for Pong game
module score_generator (
    input wire clk,                      // Clock input
    input wire[11:0] x,                  // Current pixel x coordinate
    input wire[11:0] y,                  // Current pixel y coordinate
    input wire[2:0] score,               // 3-bit score value (0-7)
    input wire[11:0] horizontal_offset,  // Horizontal offset for digit placement
    output wire out                     // Output: 1 if pixel is part of digit, 0 otherwise
);
    reg out_r;                           // Register to hold output value
    assign out = out_r;                  // Assign register to output

    always @(posedge clk) begin
        case (score)
            // Digit 0
            3'b000: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 4)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 4) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 24)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 4))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 4) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 24)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 24) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 8) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 12)) &&
                    ((horizontal_offset + 8) <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 12) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 16)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 8))
                );
            end
            // Digit 1
            3'b001: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                );
            end
            // Digit 2
            3'b010: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 4)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 4) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 12)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 12) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 16)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 16) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 4))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 24) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 16))
                );
            end
            // Digit 3
            3'b011: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 4)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 4) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 12)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 12) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 16)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 16) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 24)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 24) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 12))
                );
            end
            // Digit 4
            3'b100: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 12)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 4))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 12) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 16)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 12))
                );
            end
            // Digit 5
            3'b101: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 4)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 4) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 16)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 4))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 12) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 16)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 16) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 24)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 24) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 12))
                );
            end
            // Digit 6
            3'b110: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 4)) &&
                    ((horizontal_offset + 8) <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 4) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 8)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 8))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 8) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 24)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 4))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 12) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 16)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 16) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 24)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 24) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 12))
                );
            end
            // Digit 7
            3'b111: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                ) || (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 4)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 12))
                );
            end
        endcase
    end
endmodule
