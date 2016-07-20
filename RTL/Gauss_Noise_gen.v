`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ADITHYA 
// 
// Create Date: 07/19/2016 10:20:37 PM
// Design Name: 
// Module Name: Gauss_Noise_gen
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

module Gauss_Noise_gen
 (  
    input iClk,
    input iRst,
    input [31:0] iUrng_seed1,
    input [31:0] iUrng_seed2,
    input [31:0] iUrng_seed3,
    input [31:0] iUrng_seed4,
    input [31:0] iUrng_seed5,
    input [31:0] iUrng_seed6,
    
    output [15:0] oAwgn1,
    output [15:0] oAwgn2,
    output oValid
);

//--------------------------Generate U0 and U1------------------------------------//

   wire [31:0] wA; 
   wire [31:0] wB; 
   
   wire [47:0] wU0;
   wire [15:0] wU1;
   
   //Generate random variables using tausworthe algorithm
   taus taus1
   ( .iClk(iClk), .iReset(iRst), .iUrng_seed1(iUrng_seed1), 
                  .iUrng_seed2(iUrng_seed2), .iUrng_seed3(iUrng_seed3), 
                  .oTaus(wA)
   );
   
   taus taus2
   ( .iClk(iClk), .iReset(iRst), .iUrng_seed1(iUrng_seed4), 
                  .iUrng_seed2(iUrng_seed5), .iUrng_seed3(iUrng_seed6), 
                  .oTaus(wB)
   );     
   
   // Concation to represent upto 8.1?
   assign wU0 = {wA, wB[31:16]};
   assign wU1 = {wB[15:0]};
 //----------------------------Evaluate e = -2ln(u0)------------------------------//
    reg  [47:0] rU0;
    wire  [5:0] wExp_e, wExp;
    reg  [48:0] rX_e;
    wire [28:0] wY_e;
    wire [30:0] wE;
    wire  [5:0] wExp_e2;
    
    //Range reconstruction
    assign wExp = wExp_e + 1;
   
    always@*
    begin
       rU0 = {wA, wB[31:16]};
       rX_e = rU0 << {wExp};
    end
    
     //64 bit LZD  proposed by Oklobdzija method
    LZD lzd1(.data_in(rU0), .data_out(wExp_e)); 
    
    //Approximating -ln(x_e) where x_e =[1,2)
    log #( .ADDR_WIDTH(8), .DATA_WIDTH1(36), .DATA_WIDTH2(31))
    log_opr( .iClk(iClk), .iRst(iRst), .iUo(rX_e), .oY_e(wY_e), .iExp_e(wExp), .oExp_e2(wExp_e2));    
   
   //Range Reconstruction
    Range_reconst Range_reconst1
    (.iExp_e(wExp_e2), .iY_e(wY_e[27:0]), .iSign(wY_e[28]), .oE(wE));
   
   //----------------------Evaluate f = sqrt(e)---------------------------------------//   
   wire [25:0] wX_f;
   wire [5:0]  wExp_f;
   wire [5:0]  wExp_f1;
   wire [21:0] wY_f;
   wire [16:0] wF;

// Range Reduction
   sqrt_range_reduction sqrt_mdl_1(.iE(wE), .oX_f(wX_f), .oExp_f(wExp_f), .oExp_f1(wExp_f1));
   
// Approximation of sqrt(x_f) where x_f =[1,4) 
   sqrt#(.ADDR_WIDTH(6),  .DATA_WIDTH(32))
   sqrt_mdl_2( .iClk(iClk), .iRst(iRst), .iX_f(wX_f), .iExp_f(wExp_f), .oY_f(wY_f) );
    
// Range reconstruction
   sqrt_range_reconst sqrt_mdl_3(.iClk(iClk), .iExp_f1(wExp_f1), .iY_f(wY_f), .oF(wF));
    
//----------------------------------Evaluate g0=Sin(2*pi*u1)---------------------------//
//----------------------------------Evaluate g1=Cos(2*pi*u1)--------------------------//

//  Range Reduction
 //  wire [1:0] wQuad;
   wire [13:0] wX_g_a;
   wire [13:0] wX_g_b;
   
   wire [15:0] wY_g_a;
   wire [15:0] wY_g_b;
   
   wire [16:0] wg0;
   wire [16:0] wg1;
            
   reg [1:0] rQuad ;
   assign wX_g_a = wU1[13:0];
   assign wX_g_b = {14'b11111111111111} - {wU1[13:0]};
   
// Approxiamte  cos(x_g_a*pi/2)
   Cos_sin #( .ADDR_WIDTH(7), .DATA_WIDTH(32))x_g_a( .iClk(iClk), .iRst(iRst), .iCx_g(wX_g_a[13:0]), .oY_g(wY_g_a));

// Approxiamte  cos(x_g_b*pi/2)   
   Cos_sin #( .ADDR_WIDTH(7), .DATA_WIDTH(32))x_g_b( .iClk(iClk), .iRst(iRst), .iCx_g(wX_g_b[13:0]), .oY_g(wY_g_b));
   
   always@(posedge iClk)
   rQuad <= wU1[15:14];
   
// Cos sine Range Reconstruction
   Cos_sine_reconst cosine_reconst( .iQuad(rQuad), .iClk(iClk), .iY_g_a(wY_g_a), .iY_g_b(wY_g_b), .og0(wg0), .og1(wg1));
   
//----------------------------------Compute x0 and x1---------------------------------------------------//
 
  //Multiplication of f*g0 and f*g1
   Multip mul(.iClk(iClk), .iF(wF), .iG0(wg0), .iG1(wg1), .oX0(oAwgn1), .oX1(oAwgn2),.rValid(oValid));

endmodule
