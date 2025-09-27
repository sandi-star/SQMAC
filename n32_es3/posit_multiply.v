`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/27 17:22:03
// Design Name: 
// Module Name: posit_multiply
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
module posit_multiply(
    input   wire    clk_i,
    input   wire    rst_i,
    
    input   wire            posit_a_sign_i,               
    input   wire    [8:0]   posit_a_exp_value_i,  
    input   wire    [26:0]  posit_a_frac_value_i,     
    input   wire            posit_a_is_NAN_i,             
    input   wire            posit_a_is_Zero_i,             
    input   wire            posit_a_valid_i,
    input   wire            posit_a_last_i,
    
    input   wire            posit_b_sign_i,               
    input   wire    [8:0]   posit_b_exp_value_i,  
    input   wire    [26:0]  posit_b_frac_value_i,     
    input   wire            posit_b_is_NAN_i,             
    input   wire            posit_b_is_Zero_i,             
    input   wire            posit_b_valid_i,
    input   wire            posit_b_last_i,
    
    output  wire            sign_o,                                             
    output  wire    [9:0]   exp_value_o,               
    output  wire    [53:0]  frac_value_o,         
    output  wire            posit_valid_o,                                      
    output  wire            posit_last_o,                                       
    output  wire            is_NAN_o                                           
                                       
    );   
    
    
    reg     sign_1;
    reg     [9:0]   exp_value_1;
    reg     posit_valid_1;
    reg     posit_last_1;
    reg     is_NAN_1;
    reg     is_Zero_1;
    
    
    wire    [9:0]   exp_value_zero;  
    
    reg     sign_2;
    reg     [9:0]   exp_value_2;
    reg     posit_valid_2;
    reg     posit_last_2;
    reg     is_NAN_2;
    reg     is_Zero_2;    
    
    
    reg     [40:0]  partial_product_l;
    reg     [39:0]  partial_product_h;
    
    reg    [53:0]  frac_value_2;
    
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            sign_1          <= 1'b0;
            exp_value_1     <= 10'b0;
            posit_valid_1   <= 1'b0; 
            posit_last_1    <= 1'b0; 
            is_NAN_1        <= 1'b0;
            is_Zero_1       <= 1'b0;   
        end
        else begin
            sign_1 <= posit_a_sign_i ^ posit_b_sign_i;
            exp_value_1 <= {posit_a_exp_value_i[8],posit_a_exp_value_i} + {posit_b_exp_value_i[8],posit_b_exp_value_i};
            posit_valid_1 <= posit_a_valid_i & posit_b_valid_i;
            posit_last_1 <= posit_a_last_i | posit_b_last_i;
            is_NAN_1 <=  posit_a_is_NAN_i | posit_b_is_NAN_i;
            is_Zero_1 <= posit_a_is_Zero_i | posit_b_is_Zero_i;    
        end
    end
    
    
    assign exp_value_zero   =   is_Zero_1 ? 10'b0 : exp_value_1 ;
    

    always@(posedge clk_i)begin
        if(rst_i)begin
            sign_2          <= 1'b0;
            exp_value_2     <= 10'b0;
            posit_valid_2   <= 1'b0;
            posit_last_2    <= 1'b0;
            is_NAN_2        <= 1'b0;
        end
        else begin
            sign_2 <= sign_1;
            exp_value_2 <= exp_value_zero;
            posit_valid_2 <= posit_valid_1;
            posit_last_2 <= posit_last_1;
            is_NAN_2 <=  is_NAN_1;    
        end
    end
    
    
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            partial_product_l   <=  41'b0;
            partial_product_h   <=  40'b0;    
        end 
        else begin
            partial_product_l   <=  posit_a_frac_value_i * posit_b_frac_value_i[13:0];
            partial_product_h   <=  posit_a_frac_value_i * posit_b_frac_value_i[26:14];
        end                        
    end
    
    always@(posedge clk_i)begin
        if(rst_i)begin
             frac_value_2 <= 56'b0;
        end
        else begin
            frac_value_2 <= {partial_product_h,14'b0} + {13'b0,partial_product_l};
        end
    end

     assign sign_o          =   sign_2;          
     assign exp_value_o     =   exp_value_2;     
     assign frac_value_o    =   frac_value_2;       
     assign posit_valid_o   =   posit_valid_2;
     assign posit_last_o    =   posit_last_2;  
     assign is_NAN_o        =   is_NAN_2;      

    
    
endmodule
`default_nettype wire