`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/28 19:49:00
// Design Name: 
// Module Name: segment
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
module segment(
    input   wire    clk_i,
    input   wire    rst_i,
    input   wire    clear_i,
    
    input   wire            valid_i,
    
    input   wire    [79:0]  data_i,
    output  wire    [79:0]  data_o
    
    );
    
    reg  [79:0]     segement;
    
     
    always@(posedge clk_i)begin
        if(rst_i)begin
            segement <= 80'b0;
        end
        else if(valid_i)begin
            segement <=  data_i;
        end
        else if(clear_i)begin
            segement <=  80'b0;
        end
        else begin
            segement <=  segement;
        end
    end 
    
    
    assign  data_o  =   segement;
     

endmodule
`default_nettype wire