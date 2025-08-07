`include "global_symbols.vh"

module score_generator (
    input wire clk,
    
    input wire[11:0] x,
    input wire[11:0] y,

    input wire[2:0] score,
    input reg[11:0] horizontal_offset,

    output wire out,
    output wire win
);
    reg out_r;
    assign out = out_r;

    always @(posedge clk) begin
        case (score)
            3'b000: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 4)) &&
                    ((horizontal_offset + 4) <= x) &&
                    (x < (horizontal_offset + 12))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 4) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 20)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 4))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 4) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 20)) &&
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
            3'b001: begin
                out_r <= (
                    (`VERTICAL_SCORE_OFFSET <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    ((horizontal_offset + 12) <= x) &&
                    (x < (horizontal_offset + 16))
                );
            end
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
                    (`VERTICAL_SCORE_OFFSET <= 24) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 12))
                );
            end
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
                    (x < (horizontal_offset + 20))
                ) || (
                    ((`VERTICAL_SCORE_OFFSET + 24) <= y) &&
                    (y < (`VERTICAL_SCORE_OFFSET + 28)) &&
                    (horizontal_offset <= x) &&
                    (x < (horizontal_offset + 12))
                );
            end
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
