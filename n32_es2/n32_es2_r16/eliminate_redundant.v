`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/28 21:32:56
// Design Name: 
// Module Name: eliminate_redundant
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
module eliminate_redundant(
    input   wire    clk_i,
    input   wire    rst_i,
    
    input   wire            eliminate_en_i,
    input   wire    [79:0]  segment_data_h_i,
    input   wire    [79:0]  segment_data_l_i,
    
    output  wire            eliminate_en_o,
    output  wire    [1:0]   segment_l_sel_o,
    output  wire    [1:0]   segment_h_sel_o,
    output  wire            segment_h_en_o,
    output  wire    [2:0]   acc_exp_sel_o,
    output  wire    [127:0] acc_result_o,       
    output  wire            acc_sign_o,
    output  wire            acc_valid_o,
    output  wire            acc_last_o
    
    );
    
    
    reg     [2:0]   sel_1;
    reg             eliminate_en_1;
    wire            sel_msb;
    
    reg     [2:0]    sel_2;
    reg     [15:0]   carry_bits;
    reg     [63:0]   frac_bits;
    wire    [79:0]   eliminate_bits;
    wire    [79:0]   redundant_sum;
    
    wire                skip;
    reg     [127:0]     acc_result;
    reg     [2:0]       sel_3;     
    wire    [63:0]      acc_result_l;
    reg                 acc_sign;
    
    reg     acc_last_1;
    reg     acc_last_2;
    reg     acc_last_3;

    
    
    assign  sel_msb =   sel_1   ==  3'b011;     
    
    always@(posedge clk_i)begin
         if(rst_i | eliminate_en_i)begin
            sel_1   <=  3'b100;
         end
         else if(sel_msb)begin
            sel_1   <=  sel_1;
         end
         else begin
            sel_1   <=  sel_1 + 3'b001;
         end
    end            
    
    
    always@(posedge clk_i)begin
         if(eliminate_en_i)begin
            eliminate_en_1  <=  1'b1;
         end
         else if(sel_msb | rst_i)begin
            eliminate_en_1  <=  1'b0;
         end
         else begin
            eliminate_en_1  <=  eliminate_en_1; 
         end
    end
    
    
    
    assign  segment_l_sel_o =   sel_1[2:1];   
    assign  segment_h_sel_o =   sel_1[2:1]  -   {1'b0,~sel_1[0]};        
    assign  segment_h_en_o  =   sel_1[0];
    assign  eliminate_en_o  =   eliminate_en_1;

    

    assign  eliminate_bits  =   segment_h_en_o ?  segment_data_h_i : segment_data_l_i;     
    assign  redundant_sum   =   eliminate_bits + {{64{carry_bits[15]}},carry_bits};     
    
    
    
    always@(posedge clk_i)begin
        if(rst_i | eliminate_en_i)begin
            carry_bits  <=  16'b0;
            frac_bits   <=  64'b0;
            sel_2       <=  3'b100;
        end
        else begin
            carry_bits  <=  redundant_sum[79:64];
            frac_bits   <=  redundant_sum[63:0];   
            sel_2       <=  sel_1;    
        end
    end
    
    
    assign  skip    =   frac_bits == {64{carry_bits[15]}};
    
    assign  acc_result_l = (sel_2 == sel_3 + 1'b1) ? acc_result[127:64] : 64'b0; 
    
    always@(posedge clk_i)begin 
        if(rst_i)begin
            acc_result[127:64]  <=  64'b0;
            acc_result[63:0]    <=  64'b0;
            sel_3               <=  3'b100;
        end
        else if(skip)begin
            acc_result[127:64]  <=  acc_result[127:64]; 
            acc_result[63:0]    <=  acc_result[63:0];   
            sel_3               <=  sel_3;
        end
        else begin
            acc_result[127:64]  <=  frac_bits; 
            acc_result[63:0]    <=  acc_result_l;   
            sel_3               <=  sel_2;
        end
    end
    
    
    
    
    

    always@(posedge clk_i)begin
        if(rst_i)begin
            acc_sign    <=  1'b0;
        end
        else if(acc_last_2)begin
            acc_sign    <=  carry_bits[15];  
        end
        else begin
            acc_sign    <=  acc_sign; 
        end
    end
    
    
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            acc_last_1  <=  1'b0;
            acc_last_2  <=  1'b0;
            acc_last_3  <=  1'b0;
        end
        else begin
            acc_last_1  <=   sel_msb & eliminate_en_1;
            acc_last_2  <=   acc_last_1;    
            acc_last_3  <=   acc_last_2;
        end
    end
    
    
    
    assign  acc_result_o =  acc_result;
   
    assign  acc_valid_o =  acc_last_3; 
    assign  acc_last_o  =   acc_last_3;     
    assign  acc_sign_o  =   acc_sign;  
    assign  acc_exp_sel_o   =   sel_3;    


endmodule
`default_nettype wire