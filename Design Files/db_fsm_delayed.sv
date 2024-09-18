`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2024 11:16:56 PM
// Design Name: 
// Module Name: db_fsm_delayed
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


module db_fsm_delayed
    (
    input logic clk, reset,
    input logic sw,
    output logic db
    );
    
    //Number of counter bits (2^n * 10ns = 10ms tick)
    localparam N = 20;
    
    //FSM State Type
    typedef enum{
        zero, wait1_1, wait1_2, wait1_3,
        one, wait0_1, wait0_2, wait0_3
    } state_type;
    
    //Signal declaration...
    state_type state_reg, state_next;
    logic [N-1:0] q_reg;
    logic [N-1:0] q_next;
    logic m_tick;
    
    always_ff @(posedge clk)
        q_reg <= q_next;
    
    //Next-state logic...
    assign q_next = q_reg + 1;
    assign m_tick = (q_reg == 0) ? 1'b1 : 1'b0;
    
    //State_register...
    always_ff @(posedge clk, posedge reset)
        if(reset)
            state_reg <= zero;
        else
            state_reg <= state_next;
            
    //Next-State Logic and Output Logic...
    always_comb
    begin
        state_next = state_reg;
        db = 1'b0;
        case(state_reg)
            zero:
                if(sw)
                    state_next = wait1_1;
            wait1_1:
                if(~sw)
                    state_next = zero;
                else
                    if(m_tick)
                        state_next = wait1_2;
            wait1_2:
                if(~sw)
                    state_next = zero;      
                else
                    if(m_tick)
                        state_next = wait1_3;
            wait1_3:
                if(~sw)
                    state_next = zero;      
                else
                    if(m_tick)
                        state_next = one;  
         
            one:
                begin
                    db = 1'b1;
                    if(~sw)
                        state_next = wait0_1;
                end
            //Stabilization complete for rising edge phase...
            wait0_1:
                begin
                    db = 1'b1;
                    if(sw)
                        state_next = one;
                    else
                        if(m_tick)
                            state_next = wait0_2;       
                end
            wait0_2:
                begin
                    db = 1'b1;
                    if(sw)
                        state_next = one;
                    else
                        if(m_tick)
                            state_next = wait0_3;       
                end       
            wait0_3:
                begin
                    db = 1'b1;
                    if(sw)
                        state_next = one;
                    else
                        if(m_tick)
                            state_next = zero;       
                end
            //Stabilization complete for falling edge phase...    
            default: state_next = zero;
        endcase
    end             
endmodule
