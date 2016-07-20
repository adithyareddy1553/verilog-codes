`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2016 07:13:51 AM
// Design Name: 
// Module Name: main
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


module main
(
    input  iClk,
    input  iReset,
    input  [31:0] iUrng_seed1,
    input  [31:0] iUrng_seed2,
    input  [31:0] iUrng_seed3,
    input  [31:0] iUrng_seed4,
    input  [31:0] iUrng_seed5,
    input  [31:0] iUrng_seed6,
    
    output [15:0] oAwgn1,
    output [15:0] oAwgn2
);


endmodule
