`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA
// 
// Create Date: 07/19/2016 11:10:10 PM
// Design Name: 
// Module Name: Gauss_Noise_gen_tb
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


module Gauss_Noise_gen_tb();

   reg rClk = 1'b0;
   reg rRst;
   reg [31:0] rUrng_seed1;
   reg [31:0] rUrng_seed2;
   reg [31:0] rUrng_seed3;
   reg [31:0] rUrng_seed4;
   reg [31:0] rUrng_seed5;
   reg [31:0] rUrng_seed6;
   
   wire [15:0] wAwgn1;
   wire [15:0] wAwgn2;  
   wire valid_out;
    
   parameter N = 100000;
   
   Gauss_Noise_gen tb
   (
       .iClk(rClk),
       .iRst(rRst),
       .iUrng_seed1(rUrng_seed1),
       .iUrng_seed2(rUrng_seed2),
       .iUrng_seed3(rUrng_seed3),
       .iUrng_seed4(rUrng_seed4),
       .iUrng_seed5(rUrng_seed5),
       .iUrng_seed6(rUrng_seed6),
      
        .oAwgn1(wAwgn1),
        .oAwgn2(wAwgn2),
        .oValid(valid_out)
      );
   
   initial 
    begin
     rUrng_seed1 = 32'd1999;
     rUrng_seed2 = 32'd2995;
     rUrng_seed3 = 32'd3666;
     
     rUrng_seed4 = 32'd3658;
     rUrng_seed5 = 32'd1564;
     rUrng_seed6 = 32'd4578;     
     
   end

    
    parameter ClkPeriod = 20;
    
    always
     #(ClkPeriod/2) rClk = ~rClk;
     
    integer File1;
    integer File2;
    
    initial begin
        File1 = $fopen("guass_noise_data1.txt", "w");
        File2 = $fopen("guass_noise_data2.txt", "w");
    
        rRst = 1'b1;
        
       #1000
        repeat (N) begin
            @(posedge rClk);
            rRst = 1'b0;
        end

        #(ClkPeriod*11)
          $fclose(File1);
          $fclose(File2);
        $stop;
    end    
//    // Record data
    always@(negedge rClk) begin
        if (valid_out)
         begin
          $fwrite(File1, "%b\n", wAwgn1);
          $fwrite(File2, "%b\n", wAwgn2);
         end
    end
endmodule
