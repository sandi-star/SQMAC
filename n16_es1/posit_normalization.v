`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/29 15:55:00
// Design Name: 
// Module Name: posit_normalization
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
module posit_normalization(
    input   wire    clk_i,
    input   wire    rst_i,
    
    input   wire                is_NAN_i,
    input   wire                is_Zero_i,
    
    input   wire                segment_sel_i,
    input   wire                sign_i,
    input   wire    [127:0]     data_i,
    input   wire                valid_i,
    input   wire                last_i,
    
    output  wire    [15:0]      data_o,
    output  wire                valid_o,
    output  wire                last_o
    );
    
    
    
    reg     is_NAN_1; 
    reg     is_Zero_1;
    reg     sign_1;
    reg     valid_1;
    reg     last_1;
    reg     [6:0]   exp_1;
    reg     [127:0] data_1;


    
    wire    [63:0]  data_lzc;
    wire    [5:0]   pos;
    wire            zero;
    
        
    reg     is_NAN_2; 
    reg     is_Zero_2;
    reg     sign_2;
    reg     valid_2;
    reg     last_2;
    reg     [6:0]   exp_2;
    reg     signed [15:0] data_2;
    
    wire    exp_bound;
    wire    [127:0] data_shift;
    wire    [11:0]  frac_part;
    
    reg     valid_3;
    reg     last_3;
    reg     [15:0] data_3;
    
    wire    [3:0]  regime_shift; 
    wire    signed [14:0] posit_shift;
    
    wire    [14:0] posit_com;
    
    
    assign  data_lzc = sign_i ? ~data_i[127:64] : data_i[127:64];

    LUT_LZC_64 inst_LUT_LZC_64(
        .x(data_lzc),
        .z(pos),       
        .v(zero)       
    );
    

    always@(posedge clk_i)begin
        if(rst_i)begin
            is_NAN_1    <=  1'b0;
            is_Zero_1   <=  1'b0;
            sign_1      <=  1'b0;
            valid_1     <=  1'b0;
            last_1      <=  1'b0;    
            exp_1       <=  7'b0;
            data_1      <=  128'b0;
        end
        else begin
            is_NAN_1    <=  is_NAN_i;  
            is_Zero_1   <=  zero; 
            sign_1      <=  sign_i;    
            valid_1     <=  valid_i;   
            last_1      <=  last_i;        
            exp_1       <=  {segment_sel_i,pos};
            data_1      <=  data_i;
        end
    end
    

    assign  data_shift = data_1 << exp_1[5:0];
    assign  frac_part = sign_1 ?  (~data_shift[126:115] + 1'b1) : data_shift[126:115];
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            is_NAN_2    <=  1'b0;
            is_Zero_2   <=  1'b0;
            sign_2      <=  1'b0;
            valid_2     <=  1'b0;
            last_2      <=  1'b0;
            exp_2       <=  7'b0;
            data_2      <=  16'b0;
        end
        else begin
            is_NAN_2    <=  is_NAN_1;  
            is_Zero_2   <=  is_Zero_1; 
            sign_2      <=  sign_1;    
            valid_2     <=  valid_1;   
            last_2      <=  last_1;        
            exp_2       <=  {exp_1[6],~exp_1[5:0]};
            data_2      <=  {~exp_1[6],exp_1[6],~exp_1[0],frac_part,1'b0};  
        end
    end
   

    wire    signed [15:0] posit_shift_r;
    wire    signed [14:0] posit_shift_rr;


    assign  exp_bound = (exp_2 > 7'b011_1000) & (exp_2 < 7'b100_1000); 
    assign  regime_shift =  exp_2[5] ? ~exp_2[4:1] : exp_2[4:1];
    
    
    
    assign  posit_shift_r =  data_2  >>> regime_shift;
    assign  posit_shift_rr = posit_shift_r[15:1] + {14'b0,posit_shift_r[0]};
    assign  posit_com   =    sign_2 ? ~posit_shift_rr  + 1'b1: posit_shift_rr ;


    always@(posedge clk_i)begin
        if(rst_i)begin
            valid_3     <=  1'b0;  
            last_3      <=  1'b0; 
        end
        else begin
            valid_3     <=  valid_2;   
            last_3      <=  last_2;      
        end
    end
    
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            data_3 <= 16'h0000;
        end
        else if( is_NAN_2 | exp_bound)begin
            data_3 <= 16'h8000;
        end  
        else if(is_Zero_2)begin
            data_3 <= 16'h0000;
        end  
        else begin
            data_3 <= {sign_2,posit_com};
        end
    end
    
    assign  data_o  =   data_3;   
    assign  valid_o =   valid_3;
    assign  last_o  =   last_3;
     
    
endmodule
`default_nettype wire