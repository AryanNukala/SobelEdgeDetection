`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2024 02:12:55 PM
// Design Name: 
// Module Name: sobel_mod_tb
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

module sobel_mod_tb();
reg clk,rst;
reg [7:0] red_i,green_i,blue_i;
reg done_i;
wire [7:0] red_o,green_o,blue_o;
wire done_o;

 sobel_mod SOBEL_MOD(
      .clk(clk),
      .rst(rst),   
      .data_red_i(red_i),
      .data_green_i(green_i),
      .data_blue_i(blue_i),
      .data_done_i(done_i), 
      .sobel_red_o(red_o),
      .sobel_green_o(green_o),
      .sobel_blue_o(blue_o),
      .sobel_done_o(done_o)
      );
      
initial clk = 1'b1;
always #(`clk_period) clk=~clk;    

 integer i,j;
 localparam RESULT_ARRAY_LEN = 1000*1024;
 reg [7:0] result[0:RESULT_ARRAY_LEN-1];
 
 always @(posedge clk) begin
      if(rst) begin
         j <= 8'd0;
      end else begin
         if(done_o) begin 
            result[j] <= red_o;
            result[j+1] <= green_o;
            result[j+2] <= blue_o;
            j <= j+3;
          end
       end
end               

`define read_fileName "C:\\test\\target1.bmp"
 localparam BMP_ARRAY_LEN = 1000*1024;
 reg [7:0] bmp_data[0:BMP_ARRAY_LEN-1];
 integer bmp_size,bmp_start_pos,bmp_width,bmp_height,biBitCount;

task readBMP;
     integer fileId,i;
     begin 
         fileId = $fopen(`read_fileName,"rb");
         if(fileId == 0) begin
            $display("Error open\n");
            $finish;
         end else begin
             $fread(bmp_data,fileId);
             $fclose(fileId);
             bmp_size = {bmp_data[5],bmp_data[4],bmp_data[3],bmp_data[2]};
             $display("bmp_size = %d!\n", bmp_size);
             bmp_start_pos = {bmp_data[13], bmp_data[12], bmp_data[11],bmp_data[10]};
             $display("bmp_start_pos = %d!\n", bmp_start_pos);
             bmp_width ={bmp_data[21] ,bmp_data[20] ,bmp_data[19],bmp_data[18]};
             $display("bmp_width = %d!\n", bmp_width);
             bmp_height= {bmp_data[25] , bmp_data[24],bmp_data[23],bmp_data[22]};
             $display("bmp_height = %d!\n", bmp_height);
             biBitCount = {bmp_data[29] , bmp_data[28]};
             $display("biBitCount = %d!\n", biBitCount);
             if (biBitCount != 24) begin
                 $display("biBitCount need to be 24bit! Xn");
                 $finish;
             end
             if (bmp_width % 4) begin
                 $display("bmp_width % 4 need to be zero.\n");
                 $finish;
             end
//             for(i=bmp_start_pos; i<bmp_size; i=i+1) begin
//            $display("%h",bmp_data[i]);
//             end
        end 
       end
     endtask     
 
`define write_fileName  "C:\\test\\result.bmp"
task writeBMP;
    integer fileId, i;
    begin
        fileId = $fopen(`write_fileName, "wb");
        for(i=0; i<bmp_start_pos; i=i+1) begin
            $fwrite(fileId, "%c",bmp_data[i]);
        end
        for(i=bmp_start_pos; i<bmp_size; i=i+1) begin
            $fwrite(fileId,"%c" , result[i-bmp_start_pos]);
        end
        $fclose(fileId) ;
        $display("writeBMP: done!\n");
    end
endtask
initial begin
     rst = 1'b1;
     done_i = 1'b0;
     red_i=8'd0;
     green_i= 8'd0;
     blue_i=8'd0;
     readBMP;
     writeBMP;
     #(`clk_period);
     rst = 1'b0;
     for (i=bmp_start_pos; i<bmp_size; i=i+3) begin
          red_i = bmp_data[i+2];
          green_i= bmp_data[i+1];
          blue_i= bmp_data[i];
          #(`clk_period); 
          done_i = 1'b1;
     end
     #(`clk_period) ;
     done_i = 1'b0;
     #(`clk_period) ;
     #(`clk_period) ;
     #(`clk_period) ;
     #(`clk_period) ;
     #(`clk_period) ;
     #(`clk_period) ;
     #(`clk_period) ;
     #(`clk_period) ;
     #(`clk_period) ;
     #(`clk_period) ;
     writeBMP;
     #(`clk_period) ;
     $stop;
end
endmodule
