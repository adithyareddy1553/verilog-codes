`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA
// 
// Create Date: 07/19/2016 11:44:54 AM
// Design Name: 
// Module Name: Sqrt_Range_Reduction
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

module sqrt_range_reduction
(
   // Input data
   input  wire [30:0] iE,
   
   // Onput data
   output wire [25:0] oX_f,
   output wire  [5:0] oExp_f,
   output wire  [5:0] oExp_f1
 );
    //Intermediate data 
    wire [5:0] wExp_f1;
    
    reg [5:0] rExp_f;
    reg [5:0] rExp_fr;
    
    reg [30:0] rX_f;
    reg [30:0] rX_f1;
    
    wire [25:0] wX_f1;
    
    wire [19:0] wY_f;
    reg  [19:0] rf;
    
    //3 bit leading zero detector
    LZD1 lzd2(.data_in(iE), .data_out(wExp_f1));   

   always@*
   begin
   //when input data >1.0000
    if(wExp_f1 <= 5)
      begin
       rExp_f = {6'b000101} - {wExp_f1};
       rX_f1  = iE >> {rExp_f};
      end
     //when input data =1.0000
    else
      if(wExp_f1 == 6)
       begin
         rX_f1  = iE ;
         rExp_f = 0;
       end
       //when input data <1.0000
     else
       begin
        rExp_f =  {wExp_f1} - {3'd5};
        rX_f1  =  iE << {rExp_f};
       end
      
   //   rX_f1  = wE >> {wExp_f};
      if(rExp_f[0] == 1'b1)
        rX_f = rX_f1 >> 1'b1;
      else
        rX_f = rX_f1;
   end  
     
        assign wX_f1   = rX_f1[25:0];
        assign oX_f    = rX_f[25:0];
        assign oExp_f  = rExp_f;
        assign oExp_f1 = wExp_f1;
endmodule
