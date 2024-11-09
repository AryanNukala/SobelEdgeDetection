`timescale 1ns / 1ps


module fpga_sobel_top(
       input clk,
       input sys_rst_i,
       output  [3:0] red,  // Red color output
       output  [3:0] green, // Green color output
       output  [3:0] blue,  // Blue color output
       output  hsync,  // Horizontal sync signal
       output  vsync   // Vertical sync signal
    );
    
   clk_wiz_1 inst
   (
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1
    .sys_clk_i(sys_clk_i),     // output sys_clk_i
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);
  
 wire [7:0] data_red_o,data_green_o,data_blue_o;
 wire  data_done_o,sobel_done_o;
 wire [7:0] sobel_red_o,sobel_blue_o,sobel_green_o;
 
 data_mod DATA_MOD(
      .sys_clk_i(sys_clk_i),
      .sys_rst_i(sys_rst_i),   
      .data_red_o(data_red_o),
      .data_green_o(data_green_o),
      .data_blue_o(data_blue_o),
      .data_done_o(data_done_o)
      );
 
 sobel_mod SOBEL_MOD(
      .clk(sys_clk_i),
      .rst(sys_rst_i),   
      .data_red_i(data_red_o),
      .data_green_i(data_green_o),
      .data_blue_i(data_blue_o),
      .data_done_i(data_done_o), 
      .sobel_red_o(sobel_red_o),
      .sobel_green_o(sobel_green_o),
      .sobel_blue_o(sobel_blue_o),
      .sobel_done_o(sobel_done_o)
      );
      
hdmi_mod HDMI_MOD(
      .clk_100MHz(sys_clk_i),
      .reset(sys_rst_i),   
      .red_i(data_red_o),
      .green_i(data_green_o),
      .blue_i(data_blue_o),
      .done(sobel_done_o),
      .red(red),
      .green(green),
      .blue(blue),
      .hsync(hsync),
      .vsync(vsync)
      );
      
 
ila_0 display (
	.clk(sys_clk_i), // input wire clk
	.probe0(data_red_o), // input wire [7:0]  probe0  
	.probe1(data_green_o), // input wire [7:0]  probe1 
	.probe2(data_blue_o), // input wire [7:0]  probe2 
	.probe3(sobel_red_o), // input wire [7:0]  probe3 
	.probe4(sobel_green_o), // input wire [7:0]  probe4 
	.probe5(sobel_blue_o), // input wire [7:0]  probe5 
	.probe6(sys_rst_i) // input wire [7:0]  probe5
);



    
endmodule
