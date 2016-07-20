`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA
// 
// Create Date: 07/19/2016 03:46:40 PM
// Design Name: 
// Module Name: sqrt_range_reconst
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


module sqrt_range_reconst
(
 input  iClk,
 input  [5:0]  iExp_f1,
 input  [21:0] iY_f,
 output [16:0] oF
 );
  
  reg [23:0] rf = 0;
  
//  wire  [5:0] wExp_f;
  reg  [5:0] wExp_f,wExp_f1,wExp_f2;
  reg  [5:0] rExp_f  = 0;
  reg  [5:0] rExp_fr = 0;
  
//  assign wExp_f = iExp_f1;
  always@(posedge iClk)
  begin
   wExp_f2 <= iExp_f1;
   wExp_f1 <= wExp_f2;
   wExp_f <= wExp_f1;
  end
  
  always@(posedge iClk)
    begin
       if(wExp_f <= 5)
         begin
         rExp_f = {6'b000101} - {wExp_f};
         if(rExp_f[0] == 1'b1)  
           rExp_fr = {rExp_f+1} >> 1;
         else
           rExp_fr = {rExp_f} >> 1;
         rf   = {2'b00, iY_f} << rExp_fr;
         end
       else
         if(wExp_f == 6)
          rf =  {2'b00,iY_f};
         else
          begin
           rExp_f =  {wExp_f} - {3'd5};
            if(rExp_f[0] == 1'b1)  
             rExp_fr = {rExp_f} >> 1;
            else
             rExp_fr = {rExp_f} >> 1;
           rf  = {2'b00, iY_f} >> rExp_fr;
         end
      end 
   assign oF =  rf[23:7];
   endmodule
