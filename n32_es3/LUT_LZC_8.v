`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/03 15:58:01
// Design Name: 
// Module Name: LUT_LZC_8
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

`default_nettype none
module LUT_LZC_8(
    input   wire    [7:0]   x,
    output  wire    [2:0]   z,
    output  wire            v       
    );

    wire    lp1_int;
    wire    lp1;
    wire    lp2;
    wire    lp3;
    wire    lp4;
    
    assign  lp1_int =  (x[2] & (~x[3]) & (~x[5]) & (~x[7])) | ((x[6]) & (~x[7])) |  ((x[4]) & (~x[5]) & (~x[7]));     
    
    assign  lp2 = (((~x[2]) & (~x[3])) | x[4] | ((~x[4]) & (x[5]))) & ((~x[6]) & (~x[7]));
    
    assign  lp3 = (~x[4]) & (~x[5]) & (~x[6]) & (~x[7]);
    
    assign  lp1 = lp1_int | ((~x[1])&lp2&lp3);
    
    assign  lp4 = (~x[0]) & (~x[1]) & (~lp1_int) & lp2 & lp3; 
    
    
    assign  z = {lp3,lp2,lp1};
    assign  v = lp4;
    
endmodule


`default_nettype wire