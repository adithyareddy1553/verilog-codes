`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA
// 
// Create Date: 07/19/2016 07:07:23 AM
// Design Name: 
// Module Name: Multip
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


module Multip
(
  //Inputs
  input iClk,
  input [16:0] iF,
  input [16:0] iG0,
  input [16:0] iG1, 
   
  //Outputs 
  output [15:0] oX0,
  output [15:0] oX1,
  output reg rValid =0 
 );

 // Registers in intermediate stages
  reg [16:0] rG0_1,rG0_2, rG0_3, rG0_4, rG0_5, rG0_6, rG0_7, rG0_8, rG0_9;
  reg [16:0] rG1_1,rG1_2, rG1_3, rG1_4, rG1_5, rG1_6, rG1_7, rG1_8, rG1_9;
  reg rG0_s;
  reg rG1_s; 
  
  reg [31:0] rX0;
  reg [31:0] rX1;  
  
  always@(posedge iClk)
   begin
     rG0_1  <= iG0;
     rG0_2  <= rG0_1;
     rG0_3  <= rG0_2;
     rG0_4  <= rG0_3;
     rG0_5  <= rG0_4;
     rG0_6  <= rG0_5;
     rG0_7  <= rG0_6;
     rG0_8  <= rG0_7;
     rG0_9  <= rG0_8;
     rG0_s  <= rG0_8[16];

     rG1_1  <= iG1;
     rG1_2  <= rG1_1;
     rG1_3  <= rG1_2;
     rG1_4  <= rG1_3;
     rG1_5  <= rG1_4;
     rG1_6  <= rG1_5;
     rG1_7  <= rG1_6;
     rG1_8  <= rG1_7;
     rG1_9  <= rG1_8;
     rG1_s  <= rG1_8[16];
          
     rX0    <= iF * rG0_8[14:0];     
     rX1    <= iF * rG1_8[14:0];
   end 
   
   //To indicate a valid output signal
   always@*
    begin
      if(rX0|rX1)
         rValid = 1'b1;
      else
         rValid = 1'b0;
    end
    
   assign oX0 = {rG0_s,rX0[31:17]};
   assign oX1 = {rG1_s,rX1[31:17]};
endmodule
