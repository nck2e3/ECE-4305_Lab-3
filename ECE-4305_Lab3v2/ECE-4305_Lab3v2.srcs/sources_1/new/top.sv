`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2024 11:36:31 PM
// Design Name: 
// Module Name: top
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

module top(
    input logic clk,
    input logic rst,          
    input logic button_in,
    output logic button_out,
    output logic button_out_debounced 
    );

    assign button_out = button_in;

    logic db_signal;

    db_fsm_early db_inst (
        .clk(clk),
        .reset(rst), 
        .sw(button_in), 
        .db(db_signal)  
    );

    assign button_out_debounced = db_signal;

endmodule
