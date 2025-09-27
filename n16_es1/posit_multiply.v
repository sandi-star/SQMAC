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
    input   wire    [5:0]   posit_a_exp_value_i,  
    input   wire    [12:0]  posit_a_frac_value_i,     
    input   wire            posit_a_is_NAN_i,             
    input   wire            posit_a_is_Zero_i,             
    input   wire            posit_a_valid_i,
    input   wire            posit_a_last_i,
    
    input   wire            posit_b_sign_i,               
    input   wire    [5:0]   posit_b_exp_value_i,  
    input   wire    [12:0]  posit_b_frac_value_i,     
    input   wire            posit_b_is_NAN_i,             
    input   wire            posit_b_is_Zero_i,             
    input   wire            posit_b_valid_i,
    input   wire            posit_b_last_i,
    
    output  wire            sign_o,                                             
    output  wire    [6:0]   exp_value_o,           
    output  wire    [25:0]  frac_value_o,       
    output  wire            posit_valid_o,                                      
    output  wire            posit_last_o,                                       
    output  wire            is_NAN_o                                                                                 

    );   
    
    
    reg     sign_1;
    reg     [6:0]   exp_value_1;
    reg     posit_valid_1;
    reg     posit_last_1;
    reg     is_NAN_1;
    reg     is_Zero_1;

    wire    [6:0]   exp_value_zero;   
    reg     [25:0]  frac_value_1;
    
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            sign_1          <= 1'b0;
            exp_value_1     <= 7'b0;
            posit_valid_1   <= 1'b0; 
            posit_last_1    <= 1'b0; 
            is_NAN_1        <= 1'b0;
            is_Zero_1       <= 1'b0;   
        end
        else begin
            sign_1 <= posit_a_sign_i ^ posit_b_sign_i;
            exp_value_1 <= {posit_a_exp_value_i[5],posit_a_exp_value_i} + {posit_b_exp_value_i[5],posit_b_exp_value_i};
            posit_valid_1 <= posit_a_valid_i & posit_b_valid_i;
            posit_last_1 <= posit_a_last_i | posit_b_last_i;
            is_NAN_1 <=  posit_a_is_NAN_i | posit_b_is_NAN_i;
            is_Zero_1 <= posit_a_is_Zero_i | posit_b_is_Zero_i;    
        end
    end

    assign exp_value_zero   =   is_Zero_1 ? 7'b0 : exp_value_1 ;
    
    always@(posedge clk_i)begin
        if(rst_i)begin
             frac_value_1 <= 26'b0;
        end
        else begin
            frac_value_1 <= posit_a_frac_value_i * posit_b_frac_value_i;
        end
    end

    assign sign_o          =   sign_1;          
    assign exp_value_o     =   exp_value_zero;     
    assign frac_value_o    =   frac_value_1;       
    assign posit_valid_o   =   posit_valid_1;
    assign posit_last_o    =   posit_last_1;  
    assign is_NAN_o        =   is_NAN_1;      
    
    
endmodule
`default_nettype wire