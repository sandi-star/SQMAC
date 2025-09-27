`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 10:25:04
// Design Name: 
// Module Name: LUT_LZC_64
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

module LUT_LZC_64(
    input   wire    [63:0]   x,
    output  wire    [5:0]    z,
    output  wire             v       
    );
    
    
    wire    [2:0]   z_0;   
    wire    [2:0]   z_1;
    wire    [2:0]   z_2;   
    wire    [2:0]   z_3;
    wire    [2:0]   z_4;   
    wire    [2:0]   z_5;
    wire    [2:0]   z_6;   
    wire    [2:0]   z_7;
    
    wire    [7:0]   v_p;
    
    reg     [2:0]   sel_l;
    wire    [2:0]   sel_h;
    
    
    assign  v = & v_p;
    assign  z = {sel_h,sel_l};
    
    always@(*)begin
        case(sel_h)
            3'b000: sel_l =z_0;
            3'b001: sel_l =z_1;
            3'b010: sel_l =z_2;
            3'b011: sel_l =z_3;
            3'b100: sel_l =z_4;
            3'b101: sel_l =z_5;
            3'b110: sel_l =z_6;
            3'b111: sel_l =z_7;
        endcase
    end
    
    
   BNE inst_BNE(.a(v_p), .y(sel_h));	
    
    
    
    LUT_LZC_8 inst_LUT_LZC_8_0(
        .x(x[7:0]),
        .z(z_7),
        .v(v_p[7])       
    );
    
    
    LUT_LZC_8 inst_LUT_LZC_8_1(
        .x(x[15:8]),
        .z(z_6),
        .v(v_p[6])      
    );
    
    LUT_LZC_8 inst_LUT_LZC_8_2(
        .x(x[23:16]),
        .z(z_5),
        .v(v_p[5])    
    );
    
    
    LUT_LZC_8 inst_LUT_LZC_8_3(
        .x(x[31:24]),
        .z(z_4),
        .v(v_p[4])     
    );
    
    LUT_LZC_8 inst_LUT_LZC_8_4(
        .x(x[39:32]),
        .z(z_3),
        .v(v_p[3])      
    );
    
    LUT_LZC_8 inst_LUT_LZC_8_5(
        .x(x[47:40]),
        .z(z_2),
        .v(v_p[2])       
    );
    
   LUT_LZC_8 inst_LUT_LZC_8_6(
        .x(x[55:48]),
        .z(z_1),
        .v(v_p[1])   
    );
    
    LUT_LZC_8 inst_LUT_LZC_8_7(
        .x(x[63:56]),
        .z(z_0),
        .v(v_p[0])      
    );
    
    
    
endmodule


module BNE(
	input    wire    [7:0]   a,
	output   wire    [2:0]   y 
	);
			
    assign y[2]=a[0]&a[1]&a[2]&a[3];
    assign y[1]=a[0]&a[1]&(~a[2]|~a[3]|(a[4]&a[5]));
    assign y[0]=a[0]&(~a[1]|(a[2]&~a[3]))|(a[0]&a[2]&a[4]&(~a[5]|a[6]));
    
endmodule


`default_nettype wire