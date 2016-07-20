`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA
// 
// Create Date: 07/19/2016 12:25:38 PM
// Design Name: 
// Module Name: cos_sine_reconst
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


module Cos_sine_reconst
(
  input [1:0]iQuad,
  input iClk,
  input [15:0]iY_g_a,
  input [15:0]iY_g_b,  
  output [16:0]og0,
  output  [16:0]og1  
);
  
  reg [16:0] rg0;
  reg [16:0] rg1;
  
  assign og0 = rg0;
  assign og1 = rg1;
  
  //choose the quadrant
  always@*
   begin
     case(iQuad)
     2'b00: begin
              rg0 = {1'b0, iY_g_b};
              rg1 = {1'b0, iY_g_a};
            end
            
     2'b01: begin
              rg0 = {1'b0, iY_g_a};
              rg1 = {1'b1, iY_g_b};
            end
            
     2'b10: begin
              rg0 = {1'b1, iY_g_b};
              rg1 = {1'b1, iY_g_a}; 
            end
            
     2'b11: begin
              rg0 = {1'b1, iY_g_a};
              rg1 = {1'b0, iY_g_b};    
            end
            
     default : $display("Error in iQuad");   
     endcase
   end                          
endmodule
