`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA 
// 
// Create Date: 06/17/2016 08:21:34 AM
// Design Name: 
// Module Name: Range_reconst
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


module Range_reconst
(
  input [5:0] iExp_e,
  input [27:0] iY_e,
//   input iClk,
   input iSign,
   output [30:0] oE
);
   
   reg [32:0] rln2;
   reg [38:0] rMul;
   reg [33:0] rEdif;
   reg [33:0] rE;
   reg [33:0] rE1;
   
   // ln(2) = 0.6931
   initial 
    begin
      rln2  = 33'b0101_1000_1011_1001_0010_0011_1010_0010_1; 
    end
    
    //Range reconstruction
    always@*
     begin
       //multiplication
       rMul  = rln2 * iExp_e; 
       rEdif = rMul[38:5];
       
       if(iSign == 0)
          rE =  {rEdif - {6'b00000,iY_e}};  
          
       rE1 = {rE[33:0]} << 1;
     end
     
   assign oE = rE1[33:3];
   
endmodule
