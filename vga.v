
/*
  VGA-Pinout Stecker (männlich), Aufsicht:
  
  --------------------------------------------
  \       R      G       B     ID2   DDC-GND /
   \ R_GND  G_GND   B_GND   NC   VH-GND     /
    \    ID0  ID1/SDA  HSYNC  VSYNC    SCL /
     \------------------------------------/
*/  


// 640x480@60Hz 25.175MHz
`define BASECLK CLOCK_25	// Pixel Clock
`define HRES 640		// horizontal resolution
`define HSRT 658		// hsync pulse start
`define HEND 752		// hsync pulse end
`define HTOT 800		// line end
`define VRES 480		// vertical resolution
`define VSRT 490		// vsync pulse start
`define VEND 492		// vsync pulse end
`define VTOT 525		// frame end


module hsync(
  input  wire i_clk,
  output reg  o_hsync,
  output reg  o_hblank
);
  
  reg [11:0] count = 0;

  always @(posedge i_clk) begin
    count    <= (count >= `HTOT)                  ? 0 : count + 1;
    o_hsync  <= (count >= `HSRT && count < `HEND) ? 0 : 1;
    o_hblank <= (count <= `HRES)                  ? 0 : 1;
  end
endmodule 


module vsync(
  input  wire i_clk,
  output reg  o_vsync,
  output reg  o_vblank
);
  
  reg [11:0] count = 0;

  always @(posedge i_clk) begin
    count    <= (count >= `VTOT)                  ? 0 : count + 1;
    o_vsync  <= (count >= `VSRT && count < `VEND) ? 0 : 1;
    o_vblank <= (count <= `VRES)                  ? 0 : 1;
  end
endmodule 



module vga(
  input  wire     	CLOCK_50,
  input  wire [1:0]	i_sel,
  output wire     	o_hsync,
  output wire     	o_vsync, 
  output wire     	o_red,
  output wire     	o_grn,
  output wire     	o_blu,
  input wire [4:0]  keys_1, // Player 1 inputs
  input wire [4:0]  keys_2, // Player 2 inputs
  input wire key0,
  input wire key1,

  // For Animation
  output wire[7:0] led
);  

  // Clocks
  reg CLOCK_25 = 0;
  always @(posedge CLOCK_50) CLOCK_25 = ~CLOCK_25;
  wire pixclk = `BASECLK;

  // Sync-Signale
  hsync   hs(.i_clk	(pixclk), 
            .o_hsync	(o_hsync), 
            .o_hblank	(hblank));

  vsync   vs(.i_clk	(o_hsync), 
            .o_vsync	(o_vsync), 
            .o_vblank	(vblank));   


  // x,y Position
  reg [11:0] x = 0;
  reg [11:0] y = 0;

  always @(posedge pixclk) 
    x <= hblank ? 0 : x + 1;

  always @(negedge hblank) 
    y <= vblank ? 0 : y + 1;

  reg [2:0] color = 3'b0;
  assign {o_red, o_grn, o_blu} = color;

  reg[7:0] led_r;
  assign led = led_r;

  img_generator ig(
    .CLOCK_25(CLOCK_25),
    .x(x),
    .y(y),
    .color(color),
    .keys_1(keys_1),
    .keys_2(keys_2),
    .key0(key0),
    .key1(key1),
    
    .led(led_r)
  );

endmodule 
