`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/27 15:38:27
// Design Name: 
// Module Name: posit_extract
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
module posit_extract(
    input   wire    clk_i,
    input   wire    rst_i,
    input   wire    [31:0]  posit_num_i,
    input   wire    posit_valid_i,
    input   wire    posit_last_i,
    
    output  wire    sign_o,
    output  wire    [6:0]   exp_value_o,   
    output  wire    [28:0]  frac_value_o,  
    output  wire    posit_valid_o,
    output  wire    posit_last_o,
    output  wire    is_NAN_o,
    output  wire    is_Zero_o
    );     
    
    wire    [30:0]  posit_num_com;
    wire    all_zero;  
    
    reg    is_NAN_1;
    reg    is_Zero_1;
    reg    [31:0]  posit_num_1;
    reg    posit_valid_1;      
    reg    posit_last_1;  
    
    wire  [4:0]     pos;
    wire  [31:0]    posit_num_lzc;    
    
    wire  [5:0]    sign_pos;
    wire  [31:0]   posit_num_shift; 
    
    reg    is_NAN_2;
    reg    is_Zero_2;
    reg    posit_valid_2;      
    reg    posit_last_2;  
    
    wire   [5:0]    regime_com;
    reg             sign_2;
    reg    [5:0]    regime_2;
    reg             exponent_2;
    reg    [28:0]   frac_2;
    

    
    assign  posit_num_com  =   posit_num_i[31] ? (~posit_num_i[30:0] + 31'b1) : posit_num_i[30:0];
    assign  all_zero = ~(| posit_num_i[30:0]);
    
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            is_NAN_1        <=  1'b0;
            is_Zero_1       <=  1'b0;
            posit_num_1     <=  32'b0;
            posit_valid_1   <=  1'b0;
            posit_last_1    <=  1'b0;
        end
        else begin
            is_NAN_1        <=  posit_num_i[31] & all_zero;
            is_Zero_1       <=  (~posit_num_i[31]) & all_zero;
            posit_num_1     <=  {posit_num_i[31],posit_num_com};
            posit_valid_1   <=  posit_valid_i;
            posit_last_1    <=  posit_last_i; 
        end
    end
    
    
    assign  posit_num_lzc   =   posit_num_1[30] ?   {~posit_num_1[29:0],2'b0} : {posit_num_1[29:0],2'b0}; 
    
    LUT_LZC_32 inst_LUT_LZC_32(
        .x(posit_num_lzc),
        .z(pos),
        .v()     
    );
    
    assign  sign_pos    =   {posit_num_1[30],pos};       
    assign  posit_num_shift = {posit_num_1[31],posit_num_1[30:0]<<pos};
    
    assign  regime_com  =   sign_pos[5] ? {~sign_pos[5],sign_pos[4:0]} : {~sign_pos[5],~sign_pos[4:0]} ;
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            is_NAN_2        <=  1'b0; 
            is_Zero_2       <=  1'b0; 
            sign_2          <=  1'b0; 
            regime_2        <=  6'b0; 
            exponent_2      <=  1'b0;
            frac_2          <=  29'b0;  
            posit_valid_2   <=  1'b0; 
            posit_last_2    <=  1'b0; 
        end
        else begin
            is_NAN_2        <=  is_NAN_1;
            is_Zero_2       <=  is_Zero_1;
            sign_2          <=  posit_num_shift[31];
            regime_2        <=  regime_com;
            exponent_2      <=  posit_num_shift[28];
            frac_2          <=  {~is_Zero_1,posit_num_shift[27:0]};
            posit_valid_2   <=  posit_valid_1;
            posit_last_2    <=  posit_last_1; 
        end
    end
    
    
    assign  is_NAN_o    =   is_NAN_2 & posit_valid_2;     
    assign  is_Zero_o   =   is_Zero_2 & posit_valid_2;    
    assign  sign_o      =   sign_2;       
    assign  exp_value_o =   {regime_2,exponent_2};
    assign  frac_value_o    =   frac_2;       
    assign  posit_valid_o   =   posit_valid_2;
    assign  posit_last_o    =   posit_last_2; 
    
 
    
endmodule
`default_nettype wire



