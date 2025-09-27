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
    
    input   wire    [1:0]   sel_i,
    input   wire            valid_i,
    
    input   wire    [95:0]  data_i,
    output  wire    [95:0]  data_o
    
    );
    
    reg  [95:0]     segement  [3:0];
     
     
    always@(posedge clk_i)begin
        if(rst_i)begin
            segement[0] <= 96'b0;
            segement[1] <= 96'b0;
            segement[2] <= 96'b0;
            segement[3] <= 96'b0;
        end
        else if(valid_i)begin
            segement[sel_i] <=  data_i;
        end
        else if(clear_i)begin
            segement[sel_i] <=  96'b0;
        end
        else begin
            segement[sel_i] <=  segement[sel_i];
        end
    end 
    
    
    assign  data_o  =   segement[sel_i];
     

endmodule
`default_nettype wire