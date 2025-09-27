`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/01 20:32:29
// Design Name: 
// Module Name: posit_mac_32_2
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
module posit_mac_16_1(
    input   wire    clk_i,
    input   wire    rst_i,
    input   wire    [15:0]  posit_num_a_i,
    input   wire    posit_valid_a_i,
    input   wire    posit_last_a_i,
    input   wire    [15:0]  posit_num_b_i,
    input   wire    posit_valid_b_i,
    input   wire    posit_last_b_i,
    
    output  wire    [15:0]  posit_num_o,
    output  wire    posit_valid_o,      
    output  wire    posit_last_o       

    
    );
    
    
                                                  
    wire    sign_a              ;                                           
    wire    [5:0]   exp_value_a ;       
    wire    [12:0]  frac_value_a;      
    wire    posit_valid_a       ;                                    
    wire    posit_last_a        ;                                     
    wire    is_NAN_a            ;                                         
    wire    is_Zero_a           ;   
    
    wire    sign_b              ;                                           
    wire    [5:0]   exp_value_b ;              
    wire    [12:0]  frac_value_b;       
    wire    posit_valid_b       ;                                    
    wire    posit_last_b        ;                                     
    wire    is_NAN_b            ;                                         
    wire    is_Zero_b           ;        
    
    
        
    wire            multiply_sign          ;                                  
    wire    [6:0]   multiply_exp_value     ;            
    wire    [25:0]  multiply_frac_value    ;      
    wire            multiply_posit_valid   ;                               
    wire            multiply_posit_last    ;                            
    wire            multiply_is_NAN        ;                                
    wire            multiply_is_Zero       ;    
    
    
    
    wire            acc_valid               ;
    wire            acc_is_NAN              ;
    wire            acc_is_Zero             ;
    wire            acc_exp_sel             ;
    wire    [127:0] acc_result              ;
    wire            acc_sign                ;   
    wire            acc_last                ;                               
    
    
    
    posit_extract inst_posit_extract_a(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .posit_num_i    (posit_num_a_i),
        .posit_valid_i  (posit_valid_a_i),
        .posit_last_i   (posit_last_a_i),
    
        .sign_o         (sign_a),
        .exp_value_o    (exp_value_a),    
        .frac_value_o   (frac_value_a),   
        .posit_valid_o  (posit_valid_a),
        .posit_last_o   (posit_last_a),
        .is_NAN_o       (is_NAN_a    ),
        .is_Zero_o      (is_Zero_a   )
    );
    
    
    
    posit_extract inst_posit_extract_b(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .posit_num_i    (posit_num_b_i),
        .posit_valid_i  (posit_valid_b_i),
        .posit_last_i   (posit_last_b_i),
    
        .sign_o         (sign_b),
        .exp_value_o    (exp_value_b),    
        .frac_value_o   (frac_value_b),   
        .posit_valid_o  (posit_valid_b),
        .posit_last_o   (posit_last_b),
        .is_NAN_o       (is_NAN_b    ),
        .is_Zero_o      (is_Zero_b   )
    );
    
    
    
    posit_multiply inst_posit_multiply(
        .clk_i(clk_i),
        .rst_i(rst_i),
   
        .posit_a_sign_i         (sign_a),                     
        .posit_a_exp_value_i    (exp_value_a),   
        .posit_a_frac_value_i   (frac_value_a),     
        .posit_a_is_NAN_i       (is_NAN_a    ),             
        .posit_a_is_Zero_i      (is_Zero_a   ),             
        .posit_a_valid_i        (posit_valid_a),
        .posit_a_last_i         (posit_last_a),
  
        .posit_b_sign_i         (sign_b),                     
        .posit_b_exp_value_i    (exp_value_b),   
        .posit_b_frac_value_i   (frac_value_b),    
        .posit_b_is_NAN_i       (is_NAN_b    ),             
        .posit_b_is_Zero_i      (is_Zero_b   ),             
        .posit_b_valid_i        (posit_valid_b),
        .posit_b_last_i         (posit_last_b),
    
        .sign_o                 (multiply_sign          ),                                             
        .exp_value_o            (multiply_exp_value     ),              
        .frac_value_o           (multiply_frac_value    ),        
        .posit_valid_o          (multiply_posit_valid   ),                                      
        .posit_last_o           (multiply_posit_last    ),                                       
        .is_NAN_o               (multiply_is_NAN        )                                                
    );
    
    
    segment_redundant_acc inst_segment_redundant_acc(
        .clk_i(clk_i),
        .rst_i(rst_i),
    
        .posit_sign_i       (multiply_sign        ),               
        .posit_exp_value_i  (multiply_exp_value   ),  
        .posit_frac_value_i (multiply_frac_value  ),     
        .posit_is_NAN_i     (multiply_is_NAN      ),             
        .posit_is_Zero_i    (multiply_is_Zero     ),             
        .posit_valid_i      (multiply_posit_valid ),
        .posit_last_i       (multiply_posit_last  ),
    
        .acc_is_NAN_o       (acc_is_NAN           ),
        .acc_is_Zero_o      (acc_is_Zero          ),
        .acc_exp_sel_o      (acc_exp_sel          ),
        .acc_result_o       (acc_result           ),
        .acc_sign_o         (acc_sign             ), 
        .acc_valid_o        (acc_valid            ), 
        .acc_last_o         (acc_last             )       
    );
    
    
    
    posit_normalization inst_posit_normalization(
        .clk_i(clk_i),
        .rst_i(rst_i),
        
        .is_NAN_i       (acc_is_NAN     ),
        .is_Zero_i      (acc_is_Zero    ),
        .segment_sel_i  (acc_exp_sel    ),
        .sign_i         (acc_sign       ),
        .data_i         (acc_result     ),
        .valid_i        (acc_valid      ),
        .last_i         (acc_last       ),
    
        .data_o          (posit_num_o   ),
        .valid_o         (posit_valid_o ),
        .last_o          (posit_last_o  )
    

    ); 
  
    
    
    
endmodule
`default_nettype wire