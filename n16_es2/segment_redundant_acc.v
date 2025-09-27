`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/28 14:35:03
// Design Name: 
// Module Name: segment_redundant_acc
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
module segment_redundant_acc(
    input   wire    clk_i,
    input   wire    rst_i,
    
    input   wire            posit_sign_i,               
    input   wire    [7:0]   posit_exp_value_i,  
    input   wire    [23:0]  posit_frac_value_i,     
    input   wire            posit_is_NAN_i,             
    input   wire            posit_is_Zero_i,             
    input   wire            posit_valid_i,
    input   wire            posit_last_i,
    
    output  wire            acc_is_NAN_o, 
    output  wire            acc_is_Zero_o,
    
    output  wire    [1:0]   acc_exp_sel_o,
    output  wire    [127:0] acc_result_o,
    output  wire            acc_sign_o, 
    output  wire            acc_valid_o,  
    output  wire            acc_last_o       

    );
    
    
    reg [127:0]     frac_value_1;   
    reg             segment_h_sel_1;
    reg             segment_l_sel_1;
    reg             segment_h_en_1;
    reg             posit_sign_1;
    reg             posit_valid_1;
    reg             posit_last_1 ;
    
    reg [63:0]     frac_segment_l;     
    reg [63:0]     frac_segment_h; 
    reg            sign_segment_l;
    reg            sign_segment_h;
    
    wire[127:0]    frac_value_com;
    wire           segment_all_zero;
    reg            segment_h_sel_2;
    reg            segment_l_sel_2;
    reg            posit_valid_2;
    reg            posit_last_2 ;
    
    
    
    wire    eliminate_redundant;       
    
    wire              segment_h_sel;
    wire              segment_l_sel;
    wire              eliminate_h_sel; 
    wire              eliminate_l_sel;
    
    wire    [79:0]     segment_l_data_i;
    wire    [79:0]     segment_l_data_o;
    wire    [79:0]     segment_h_data_i;
    wire    [79:0]     segment_h_data_o;
    
    
    reg             posit_last_3 ;
    wire            segment_h_en_o;
    
    reg     acc_is_NAN;
    reg     acc_is_Zero;
    
    wire    [8:0]   posit_exp_value;    
    wire    [7:0]   bias;
    wire    [24:0]  posit_frac_value;
    
    assign   bias = posit_frac_value_i[23] ? 8'b0000_0001 : 8'b0000_0000;
    assign   posit_exp_value = posit_exp_value_i + bias;
    assign   posit_frac_value = posit_frac_value_i[23] ? {1'b0,posit_frac_value_i}:{posit_frac_value_i,1'b0};

  
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            frac_value_1    <=   128'b0;
            segment_h_sel_1 <=   1'b0;
            segment_l_sel_1 <=   1'b0;
            segment_h_en_1  <=   1'b0;
            posit_sign_1    <=   1'b0;
            posit_valid_1   <=   1'b0;
            posit_last_1    <=   1'b0;
        end
        else begin
            frac_value_1    <= {62'b0,posit_frac_value,41'b0} << posit_exp_value[5:0];
            segment_h_sel_1 <= posit_exp_value[7] - {1'b0,~posit_exp_value[6]};
            segment_l_sel_1 <= posit_exp_value[7] ;
            segment_h_en_1  <= posit_exp_value[6];
            posit_sign_1    <= posit_sign_i;
            posit_valid_1   <= posit_valid_i; 
            posit_last_1    <= posit_last_i;  
        end
    end
    

     assign segment_all_zero    =   frac_value_1[63:0] == 64'b0;
     assign frac_value_com  = posit_sign_1 ? {~frac_value_1[127:64] + 1'b1,~frac_value_1[63:0] + 1'b1} : frac_value_1;
     
     always@(posedge clk_i)begin
        if(rst_i)begin
            segment_h_sel_2 <=  1'b0;
            segment_l_sel_2 <=  1'b0;
            posit_valid_2   <=  1'b0;
            posit_last_2    <=  1'b0;  
        end
        else begin
            segment_h_sel_2 <=  segment_h_sel_1;
            segment_l_sel_2 <=  segment_l_sel_1;
            posit_valid_2   <=  posit_valid_1;
            posit_last_2    <=  posit_last_1 ;
        end
     end
    
     always@(posedge clk_i)begin
        if(rst_i)begin
            {frac_segment_h,frac_segment_l} <= 128'b0;
            sign_segment_l  <=  1'b0;
            sign_segment_h  <=  1'b0;
        end
        else if(segment_h_en_1)begin
            {frac_segment_h,frac_segment_l} <= frac_value_com;
            sign_segment_l  <=  posit_sign_1 & (~segment_all_zero); 
            sign_segment_h  <=  posit_sign_1; 
        end
        else begin
            {frac_segment_l,frac_segment_h} <= frac_value_com;
            sign_segment_h  <=  posit_sign_1 & (~segment_all_zero); 
            sign_segment_l  <=  posit_sign_1; 
        end
     end
    
    
    
    assign  segment_h_sel   =   eliminate_redundant ?   eliminate_h_sel :   segment_h_sel_2;           
    assign  segment_l_sel   =   eliminate_redundant ?   eliminate_l_sel :   segment_l_sel_2;      
    
    assign  segment_l_data_i    =   segment_l_data_o +  {{16{sign_segment_l}},frac_segment_l};
    assign  segment_h_data_i    =   segment_h_data_o +  {{16{sign_segment_h}},frac_segment_h};

    
    always@(posedge clk_i)begin
        if(rst_i)begin
            posit_last_3    <=  1'b0;
        end
        else begin
            posit_last_3    <=  posit_last_2;
        end
    end
    

    segment inst_segement_l(         
        .clk_i(clk_i),
        .rst_i(rst_i),
        .clear_i(eliminate_redundant & (~segment_h_en_o)),
   
        .sel_i(segment_l_sel ),
        .valid_i(posit_valid_2),
   
        .data_i(segment_l_data_i),
        .data_o(segment_l_data_o)
    );
    
    
    segment inst_segement_h(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .clear_i(eliminate_redundant & segment_h_en_o),
   
        .sel_i(segment_h_sel),
        .valid_i(posit_valid_2),
   
        .data_i(segment_h_data_i),
        .data_o(segment_h_data_o)
    );
    
    
    
    
    eliminate_redundant inst_eliminate_redundant(
        .clk_i  (clk_i),
        .rst_i  (rst_i),
    
        .eliminate_en_i  (posit_last_3),
        .segment_data_h_i(segment_h_data_o),
        .segment_data_l_i(segment_l_data_o),
    
        .eliminate_en_o  (eliminate_redundant),
        .segment_h_en_o  (segment_h_en_o),
        .segment_l_sel_o (eliminate_l_sel),
        .segment_h_sel_o (eliminate_h_sel),
        .acc_exp_sel_o   (acc_exp_sel_o),
        .acc_result_o    (acc_result_o),   
        .acc_sign_o      (acc_sign_o  ),
        .acc_valid_o     (acc_valid_o ),
        .acc_last_o      (acc_last_o  )
    );
    



    
    
    always@(posedge clk_i)begin
        if(rst_i | acc_valid_o)begin
            acc_is_NAN  <=  1'b0;  
        end
        else if(posit_is_NAN_i)begin
            acc_is_NAN  <=  1'b1;  
        end
        else begin
            acc_is_NAN  <=  acc_is_NAN; 
        end
    end
    
    
    
    assign  acc_is_NAN_o = acc_is_NAN;

    
endmodule
`default_nettype wire