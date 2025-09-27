`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 10:12:38
// Design Name: 
// Module Name: LUT_LZC_32
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


module LUT_LZC_32(
    input   wire    [31:0]   x,
    output  wire    [4:0]    z,
    output  wire             v      
    );
    
    wire    [3:0]   z_l;   
    wire    [3:0]   z_h;
    wire            v_l;
    wire            v_h;
    
    assign  z[4]    =   v_h;   
    assign  v       =   v_h & v_l;
    assign  z[3:0]  =   v_h ? z_l : z_h;
    
    
    
    LUT_LZC_16 inst_LUT_LZC_16_l(
        .x(x[15:0]),
        .z(z_l),
        .v(v_l)      
    );
    
    
    LUT_LZC_16 inst_LUT_LZC_16_h(
        .x(x[31:16]),
        .z(z_h),
        .v(v_h)       
    );
    
    
    
    
endmodule
`default_nettype wire