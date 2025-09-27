`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 15:50:06
// Design Name: 
// Module Name: time_test
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
module time_test(
    input   wire    clk_i,
    input   wire    rst_i
    );
    
    (* DONT_TOUCH = "true" *)
    reg [31:0]      posit_num_a     ;   
    (* DONT_TOUCH = "true" *) 
    reg             posit_valid_a   ;   
    (* DONT_TOUCH = "true" *)        
    reg             posit_last_a    ;   
    (* DONT_TOUCH = "true" *)         
    reg [31:0]      posit_num_b     ;     
    (* DONT_TOUCH = "true" *)
    reg             posit_valid_b   ;     
    (* DONT_TOUCH = "true" *)      
    reg             posit_last_b    ;          
    
    wire[31:0]      posit_num_o     ;   
    wire            posit_valid_o   ;   
    wire            posit_last_o    ; 
    (* DONT_TOUCH = "true" *)                              
    reg [31:0]      posit_num_r     ;   
    (* DONT_TOUCH = "true" *)    
    reg             posit_valid_r   ;  
    (* DONT_TOUCH = "true" *)           
    reg             posit_last_r    ;               
    
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            posit_num_a     <=   32'b0;
            posit_valid_a   <=   1'b0;
            posit_last_a    <=   1'b0;
        end
        else begin
            posit_num_a     <=   posit_num_a + 1'b1;
            posit_valid_a   <=   1'b1;
            posit_last_a    <=   1'b1;   
        end   
    end
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            posit_num_b     <=   32'b0;
            posit_valid_b   <=   1'b0;
            posit_last_b    <=   1'b0;
        end
        else begin
            posit_num_b     <=   posit_num_b + 1'b1;
            posit_valid_b   <=   1'b1;
            posit_last_b    <=   1'b1;   
        end   
    end
    
    
    always@(posedge clk_i)begin
        if(rst_i)begin
            posit_num_r     <=   32'b0;
            posit_valid_r   <=   1'b0;
            posit_last_r    <=   1'b0;
        end
        else begin
            posit_num_r     <=   posit_num_o  ;
            posit_valid_r   <=   posit_valid_o;
            posit_last_r    <=   posit_last_o ;
        end                      
    end
    
    
    (* DONT_TOUCH = "true" *)
    posit_mac_32_0  inst_posit_mac_32_0(
        .clk_i              (clk_i),
        .rst_i              (rst_i),
        .posit_num_a_i      (posit_num_a   ),
        .posit_valid_a_i    (posit_valid_a ),
        .posit_last_a_i     (posit_last_a  ),
        .posit_num_b_i      (posit_num_b   ),
        .posit_valid_b_i    (posit_valid_b ),
        .posit_last_b_i     (posit_last_b  ),
        .posit_num_o        (posit_num_o   ),
        .posit_valid_o      (posit_valid_o ),      
        .posit_last_o       (posit_last_o  )       
    );
    
    
    
endmodule
`default_nettype wire