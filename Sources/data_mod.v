`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 02:38:13 PM
// Design Name: 
// Module Name: data_mod
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


module data_mod(
     input sys_clk_i,
     input sys_rst_i,
     output [7:0] data_red_o,
     output [7:0] data_green_o,
     output [7:0] data_blue_o,
     output reg data_done_o
    );
reg [14:0] address;
reg ena,wea;
wire [7:0] dinr,ding,dinb;

initial begin
address =0;
ena=1;
wea=0;
end 

blk_mem_gen_1 red (
  .clka(sys_clk_i),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(address),  // input wire [14 : 0] addra
  .dina(dinr),    // input wire [7 : 0] dina
  .douta(data_red_o)  // output wire [7 : 0] douta
);

blk_mem_gen_2 green (
  .clka(sys_clk_i),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(address),  // input wire [14 : 0] addra
  .dina(ding),    // input wire [7 : 0] dina
  .douta(data_green_o)  // output wire [7 : 0] douta
);


blk_mem_gen_3 blue (
  .clka(sys_clk_i),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(address),  // input wire [14 : 0] addra
  .dina(dinb),    // input wire [7 : 0] dina
  .douta(data_blue_o)  // output wire [7 : 0] douta
);

always @(posedge sys_clk_i) begin
     if(sys_rst_i) begin
       address <=0;
     end else begin
          address <= (address < 15'd19210) ? address +1 : address;
          data_done_o <= 1;
     end
 end    
 

endmodule
