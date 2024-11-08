`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 03:33:53 PM
// Design Name: 
// Module Name: rgb_to_grayscale_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define clk_period 10

module rgb_to_grayscale_tb();

reg clk,rst;
reg [7:0] red_i,green_i,blue_i;
reg done_i;

wire [7:0] grayscale_o;
wire done_o;

rgb_to_grayscale RGB_TO_GRAYSCALE(
     clk,
     rst,
     red_i,
     green_i,
     blue_i,
     done_i,
     grayscale_o,
     done_o
    );

initial clk = 1'b1;
always #(`clk_period) clk=~clk;

initial begin 
      rst = 1'b1;
      done_i = 1'b0;
      red_i = 8'd0;
      green_i = 8'd0;
      blue_i = 8'd0;
      
      #(`clk_period);
      rst = 1'b0;
      red_i = 8'b0000_0100;
      green_i = 8'b0000_0010;
      blue_i = 8'b0001_0000;
      done_i = 1'b1;
      
      #(`clk_period);
      done_i = 1'b0;
      
      #(`clk_period);
      $stop;
      
 end              
    
endmodule
