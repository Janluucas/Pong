
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
  output wire     	o_blu 
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

  // Testbilder
  reg [9:0] cnt1 = 'b0;
  always @(posedge pixclk) 
    cnt1 <= (vblank || hblank) ? 0 : cnt1 + 1;

  reg [11:0] cnt2 = 'b0;
  always @(posedge o_vsync) 
    cnt2 <= cnt2 + 1;

  reg [6:0] cnt3 = 'b0;
  always @(negedge o_vsync)
    cnt3 =  cnt3 + 1;
  
  reg [2:0] color = 3'b0;
  always @(*) begin
    case (i_sel) 
      // Smiley
      2'd0: color = {1'b0, ((x-420)**2 + (y-160)**2 <= 25**2) ? 1'b1 : 1'b0, 1'b0}		// Ohren
                  | {1'b0, ((x-220)**2 + (y-160)**2 <= 25**2) ? 1'b1 : 1'b0, 1'b0}
                  | {2'b0, ((x-370)**2 + 2*(y-210)**2 <= 20**2) ? 1'b1 : 1'b0}			// Augen
                  | {2'b0, ((x-270)**2 + 2*(y-210)**2 <= 20**2) ? 1'b1 : 1'b0}
                  | {(y>=280 && ((x-320)**2 + (32-cnt2[8:4])*((y-280)**2) <= 40**2)) ? 1'b1 : 1'b0, 2'b0}	// Mund
                  | {1'b0, (315<=x && x<=325 && 230<=y && y<=245) ? 1'b1 : 1'b0, 1'b0}		// Nase
                  | 3*{((2*((x-320)**2)/3 + (y-240)**2 <= 100**2) && 				// Kopf
                        (2*((x-320)**2)/3 + (y-240)**2 >= 95**2)) ? 1'b1 : 1'b0};

      // Gray-Switching
      2'd1: color = 3*{(   (  0<x && x<= 80 && cnt3 % 5 == 0) 
                        || ( 80<x && x<=160 && cnt3 % 4 == 0) 
                        || (160<x && x<=240 && cnt3 % 3 == 0) 
                        || (240<x && x<=320 && cnt3 % 2 == 0) 
                        || (320<x && x<=400 && cnt3 % 3 != 0) 
                        || (400<x && x<=480 && cnt3 % 4 != 0) 
                        || (480<x && x<=560 && cnt3 % 5 != 0) 
                        || (560<x && x<=640 ) 
                        ) ? 1'b1 : 1'b0};

      // Dithering
      2'd2: color = 3*{(   (  0<x && x<= 80 && ((x+y) % 1 == 0 || (x-y) % 1 == 0)) 
                        || ( 80<x && x<=160 && ((x+y) % 2 == 0 || (x-y) % 2 == 0)) 
                        || (160<x && x<=240 && ((x+y) % 3 == 0 || (x-y) % 3 == 0)) 
                        || (240<x && x<=320 && ((x+y) % 4 == 0 || (x-y) % 4 == 0)) 
                        || (320<x && x<=400 && ((x+y) % 5 == 0 || (x-y) % 5 == 0)) 
                        || (400<x && x<=480 && ((x+y) % 6 == 0 || (x-y) % 6 == 0))
                        || (480<x && x<=560 && ((x+y) % 7 == 0 || (x-y) % 7 == 0)) 
                        || (560<x && x<=640 && ((x+y) % 8 == 0 || (x-y) % 8 == 0)) 
                        ) ? 1'b1 : 1'b0};

      // Testbild
      2'd3: color =     {cnt1[6], cnt1[7], cnt1[8]} 
                    | 3*{(x == 640 || x == 1 || y == 480 || y == 1) ? 1'b1 : 1'b0};
    endcase
  end
  
  assign {o_red, o_grn, o_blu} = color;

endmodule 

