`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 10:01:01
// Design Name: 
// Module Name: LUT_LZC_16
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
module LUT_LZC_16(
    input   wire    [15:0]   x,
    output  wire    [3:0]    z,
    output  wire             v       
    );
    
    
    wire    [2:0]   z_l;   
    wire    [2:0]   z_h;
    wire            v_l;
    wire            v_h;
    
    assign  z[3]    =   v_h;   
    assign  v       =   v_h & v_l;
    assign  z[2:0]  =   v_h ? z_l : z_h;
    
    
    
    LUT_LZC_8 inst_LUT_LZC_8_l(
        .x(x[7:0]),
        .z(z_l),
        .v(v_l)       
    );
    
    
    LUT_LZC_8 inst_LUT_LZC_8_h(
        .x(x[15:8]),
        .z(z_h),
        .v(v_h)      
    );
    
    
    
    
    
endmodule
`default_nettype wire