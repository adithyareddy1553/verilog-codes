`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA
// Create Date: 07/19/2016 09:01:16 PM
// Design Name: 
// Module Name: sqrt
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


module sqrt#
(
    parameter ADDR_WIDTH   = 6,
              DATA_WIDTH   = 32 // C2 and C1 constants
 )
 (
   //Input data
    input iClk,
    input iRst,
    input [5:0] iExp_f,
    input [25:0] iX_f,
    
   //Output data    
    output [21:0] oY_f
 );
 
   // Adding memory with sqrt constants
   reg [DATA_WIDTH-1:0] mem_sqt1 [2**ADDR_WIDTH-1:0];
   reg [DATA_WIDTH-1:0] mem_sqt2 [2**ADDR_WIDTH-1:0];
   
   initial 
    begin
       $readmemb("sqrt1.mif", mem_sqt1, 0, 63); // reading constants 
       $readmemb("sqrt2.mif", mem_sqt2, 0, 63);       
    end
   
   wire [5:0] wAddr1;
   wire [5:0] wAddr2;
   
   assign wAddr1 = {iX_f[23:18]};
   assign wAddr2 = {iX_f[24:19]};
   
   //Intializations
   reg [21:0] rYo;
   reg [31:0] rData;
   reg [31:0] rData1;
   reg [11:0] rC1;
   reg [19:0] rC0,rC_0;
   reg [21:0] rD0;
   reg  [9:0] rX_f;
   
   always@(posedge iClk, posedge iRst)
   begin
    if(iRst)
     begin
       rData  <= 0;
       rData1 <= 0;
     end
    else
     begin
      if(iExp_f[0] == 1'b1)
       begin 
        rData  <=   mem_sqt1[wAddr1];
        rX_f   <=   iX_f[25:16];
        rD0    <=   rC1 * rX_f;
        rC_0   <=   rC0;
        rYo    <=   rD0 + {2'b00,rC_0};

       end
      else
        begin 
         rData  <=   mem_sqt2[wAddr2];
         rX_f   <=   iX_f[25:16];
         rD0    <=   rC1 * rX_f;
         rC_0   <=   rC0;
         rYo    <=   rD0 + {2'b00,rC_0};         
        end       
     end
   end   
   
   always@*
    begin
     rC1     =   rData[31:20];     
     rC0     =   rData[19:0];
    end
   
   assign oY_f  =   rYo;
endmodule
