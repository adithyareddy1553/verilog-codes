`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA 
// 
// Create Date: 07/17/2016 07:37:10 AM
// Design Name: 
// Module Name: taus
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


module taus
(
    // inputs to tausworthe algorithm hardware implementation
    input  iClk,
    input  iReset,
    input  [31:0] iUrng_seed1,
    input  [31:0] iUrng_seed2,
    input  [31:0] iUrng_seed3,
    
    // outputs to tausworthe algorithm hardware implementation    
    output [31:0] oTaus
);

   //register intializations to be used in intermedaite stages
    reg [31:0] rS0;
    reg [31:0] rS1;
    reg [31:0] rS2;
    reg [31:0] rB;
    reg [31:0] rTaus;
    
    reg [31:0] rS0_next;
    reg [31:0] rS1_next;
    reg [31:0] rS2_next;
    reg [31:0] rTaus_next;
    
    
   always@(posedge iClk, posedge iReset)
   //Initial stage
     if(iReset)
      begin
       rS0   <= iUrng_seed1;
       rS1   <= iUrng_seed2;
       rS2   <= iUrng_seed3;  
       rTaus <= 32'b0;
      end
     else
     //next stages
      begin 
       rS0   <= rS0_next;
       rS1   <= rS1_next;
       rS2   <= rS2_next;
       rTaus <= rTaus_next;
      end
   //Tausworthe algorithm implementation
   always@*
       begin
          rB          =     (((rS0 << 13)^rS0) >> 19);
          rS0_next    =     (((rS0 & 32'hFFFF_FFFE) << 12)^rB);
          
          rB          =     (((rS1 << 2)^rS1) >> 25);
          rS1_next    =     (((rS1 & 32'hFFFF_FFF8) << 4)^rB);
          
          rB          =     (((rS2 << 3)^rS2) >> 11);
          rS2_next    =     (((rS2 & 32'hFFFF_FFF0) << 17)^rB);
          
          rTaus_next  =     (rS0_next^rS1_next^rS2_next);      
       end
   
   assign oTaus       =      rTaus;
   
endmodule
