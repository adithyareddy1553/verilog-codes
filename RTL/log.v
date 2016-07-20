`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA 
// 
// Create Date: 07/19/2016 02:34:38 PM
// Design Name: 
// Module Name: log
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module log #
(
    parameter ADDR_WIDTH   = 8,
              DATA_WIDTH1  = 36, // C2 and C1 constants
              DATA_WIDTH2  = 31  // C0 constants
)
(  
   //input data
    input iClk,
    input iRst,
    input   [5:0] iExp_e,
    input  [48:0] iUo,
    output  [5:0] oExp_e2,
    
    //Output data
    output [28:0] oY_e
);

   // Register values intializations
    reg  [31:0] rY_e;
    reg  [31:0] rY_e1;
    wire [7:0] wAddr;
 
    reg [23:0] rC1, rC_1;
    reg  [8:0]  rR, rR1, rR2;
    
    //   reg [12:0] rC2;
    wire [12:0] wC2;
    
    reg [35:0] rData;
    reg [30:0] rData1,rData2,rData3,rData4;
       
    reg [22:0] rDC2;
    reg [23:0] rDC1;
    reg [31:0] rDC0;
    
    reg [5:0] rExp_e1, rExp_e2, rExp_e3, rExp_e4, rExp_e5;
    
    reg [DATA_WIDTH1-1:0] mem1 [2**ADDR_WIDTH-1:0];
    reg [DATA_WIDTH2-1:0] mem2 [2**ADDR_WIDTH-1:0];
    
    reg [23:0] i;
    reg [22:0] j;
    
    initial 
         begin
            $readmemb("log.mif", mem1, 0, 255); // reading constants 
            $readmemb("log1.mif", mem2, 0, 255);       
         end
   
   assign wAddr  =  {iUo[47:40]};
   assign wC2    =  rData[35:23];

   
   always@(posedge iClk, posedge iRst)
   begin
      if(iRst)
       begin
        rData  <= 0;
        rData1 <= 0;
       end
      else
       begin
        rExp_e1 <= iExp_e;
        rExp_e2 <= rExp_e1;
        rExp_e3 <= rExp_e2;
        rExp_e4 <= rExp_e3;
        rExp_e5 <= rExp_e4;
        
        //pull the constant data from memory 
        rData  <= mem1[wAddr];
        rData1 <= mem2[wAddr];
        rR     <= iUo[48:40];  

       
        rDC2    <= wC2 * rR; 
        rC1     <= {1'b0, rData[22:0]};
        rR1     <= rR;
        rData2  <= rData1;        

        rDC1    <= {~rC1+1} + {rDC2,1'b0};
        rR2     <= rR1;
        rData3  <= rData2;
        
        rDC0    <= j * rR2;
        rData4  <= rData3;
        
        rY_e    <= {rDC0} - {1'b0,rData4}; 
       end
   end
   
   always@*
   begin
       i       = ~rDC1 + 1;
       j       =  i[22:0];
   end
   
  //truncating the data 
  assign oY_e    = rY_e[31:3];
  assign oExp_e2 = rExp_e5;

 endmodule
