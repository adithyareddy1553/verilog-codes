`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA
// 
// Create Date: 07/19/2016 10:16:36 AM
// Design Name: 
// Module Name: Cos_sin
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


module Cos_sin
 #(
    parameter ADDR_WIDTH= 2,
              DATA_WIDTH = 32
  )
  (
    // Inputs
    input  iClk,
    input  iRst,
    input  [13:0]iCx_g,
    //Outputs
    output [15:0]oY_g
  );

    reg [31:0]rData;
    reg [19:0]rPout; 
    
    reg  [6:0]rCx_g;
    reg [19:0]rY_g;
    reg [18:0]rCo;
    reg [12:0]rC1;
    
    wire [6:0] wAddr;
    
    assign wAddr = iCx_g[13:7];

   // Dual Port block RAM declaration
   reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];
   
   //Reading cosine constraints
   initial 
     begin
        $readmemb("data.mif", mem, 0, 127); // reading constants 
     end
   
   //read data from block RAM
   always@(posedge iClk, posedge iRst)
    begin
     if(iRst == 1'b1)
      begin
       rData  <= 0;
       rPout   = 0;
      end
     else
      begin
       rData  <= mem[wAddr];
       rCx_g  <= iCx_g[13:7];

      end
    end
    
    always@*
     begin
          rC1     = rData[31:19];       
          rCo     = rData[18:0];
          rPout   = rC1 * rCx_g;
          rY_g    = {rCo,1'b0} - rPout;
      end   
      
    assign oY_g = rY_g[19:4];
endmodule
