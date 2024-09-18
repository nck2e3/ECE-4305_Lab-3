`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2024 05:32:51 AM
// Design Name: 
// Module Name: test_top
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

module test_top;
    logic clk;
    logic rst;
    logic button_in;
    logic button_out;
    logic button_out_debounced;

    top uut (
        .clk(clk),
        .rst(rst),
        .button_in(button_in),
        .button_out(button_out),
        .button_out_debounced(button_out_debounced)
    );

    //Clock generation (100 MHz)...
    always #5 clk = ~clk;  //100 MHz clock

    //Test sequence with bouncing simulation...
    initial begin
        //Initialize signals...
        clk = 0;
        rst = 1;
        button_in = 0;

        //Apply reset for a few clock cycles...
        #100;
        rst = 0;

        //Wait before starting the button press...
        #1000000;

        //Simulate bouncing on the rising edge (between 1 and 20 ms)...
        #2000; button_in = 1; //2 us (initial press)...
        #2000000; button_in = 0; //2 ms later (bounce off)...
        #1500000; button_in = 1; //1.5 ms later (bounce on)...
        #5000000; button_in = 0; //5 ms later (bounce off)...
        #3000000; button_in = 1; //3 ms later (bounce on)...
        #1000000; button_in = 0; //1 ms later (bounce off)...
        #5000000; button_in = 1; //5 ms later (final press)...

        #25000000; //Button held down for 25 ms...

        //Simulate bouncing on the falling edge (between 1 and 20 ms)...
        #1500000; button_in = 0; //1.5 ms later (bounce off)...
        #1700000; button_in = 1; //1.7 ms later (bounce on)...
        #1000000; button_in = 0; //1 ms later (bounce off)...
        #1200000; button_in = 1; //1.2 ms later (bounce on)...
        #1000000; button_in = 0; //1 ms later (bounce off)...

        
        #20000000; //20 ms to observe behavior after the final release...
        $finish;
    end
endmodule



