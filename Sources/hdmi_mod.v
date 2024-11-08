`timescale 1ns / 1ps

module hdmi_mod(
	input clk_100MHz,      // from Basys 3
	input reset,
	input [3:0] red_i,
	input [3:0] green_i,
	input [3:0] blue_i,
	input done,
	output [3:0] red,
	output [3:0] green,
	output [3:0] blue,
	output vsync,     // 12 FPGA pins for RGB(4 per color)
	output hsync
);
	
	// Signal Declaration
	reg [3:0] red_reg;
	reg [3:0] green_reg;    // register for Basys 3 12-bit RGB DAC 
	reg [3:0] blue_reg;
	wire video_on;         // Same signal as in controller

    // Instantiate VGA Controller
    vga_controller vga_c(.clk_100MHz(clk_100MHz), .reset(reset), .hsync(hsync), .vsync(vsync),
                         .video_on(video_on), .p_tick(), .x(), .y());
    // RGB Buffer
    always @(posedge clk_100MHz or posedge reset)
    if (reset)
       red_reg <= 0;
    else begin
       red_reg = red_i;
       green_reg <= green_i;
       blue_reg <= blue_i;
    end   
 

    
    // Output
    assign red = (video_on) ? red_reg : 4'b0;  
    assign green = (video_on) ? green_reg : 4'b0;
    assign blue = (video_on) ? red_reg : 4'b0; // while in display area RGB color = sw, else all OFF
        
endmodule