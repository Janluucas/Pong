
module img_generator (
    input wire CLOCK_25,
    input wire[11:0] x,
    input wire[11:0] y,

    output wire[2:0] color
);
    reg [2:0] frame [0:639][0:479];
    assign color = frame[x][y];

    integer i, j;
    initial begin
        for (i = 0; i < 640; i = i + 1) begin
            for (j = 0; j < 480; j = j + 1) begin
                frame[i][j] = 3'b000;
            end
        end
    end

    wire[11:0] top_player_1 = ;
    wire[11:0] top_player_2 = ;

    wire[11:0]

    always @(posedge CLOCK_25) begin
        
    end
endmodule
