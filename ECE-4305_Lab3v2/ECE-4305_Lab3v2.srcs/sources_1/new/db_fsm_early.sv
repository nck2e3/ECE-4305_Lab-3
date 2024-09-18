`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2024 03:25:16 AM
// Design Name: 
// Module Name: db_fsm_early
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

module db_fsm_early (
    input logic clk, reset,
    input logic sw,
    output logic db
    );
    
    //Number of counter bits (2^n * 10ns = 10ms tick)...
    localparam N = 20;
    localparam MAX_COUNT = (2**N) - 1; //Maximum count for 10 ms tick (based on clock period)...
    
    //FSM State Type...
    typedef enum{
        zero, wait1_1, wait1_2, wait1_3,
        one, wait0_1, wait0_2, wait0_3
    } state_type;
    
    //Signal declaration...
    state_type state_reg, state_next;
    logic [N-1:0] q_reg;  //Counter register...
    logic m_tick;  //Tick signal generated every 10ms...
    
    //Counter logic: reset the counter after reaching the max value...
    always_ff @(posedge clk, posedge reset)
        if(reset)
            q_reg <= 0;
        else if(q_reg == MAX_COUNT)
            q_reg <= 0;  //Reset counter after max value...
        else
            q_reg <= q_reg + 1;

    //Tick generation logic (generate a tick when counter reaches MAX_COUNT)...
    assign m_tick = (q_reg == MAX_COUNT) ? 1'b1 : 1'b0;
    
    //State register logic...
    always_ff @(posedge clk, posedge reset)
        if(reset)
            state_reg <= zero;
        else
            state_reg <= state_next;
            
    //Next-State Logic and Output Logic...
    always_comb
    begin
        case(state_reg)
            zero:
                begin
                    db = 1'b0; //db is low in the `zero` state...
                    if(sw)
                        state_next = wait1_1; //Move to wait1_1 on rising edge (sw = 1)...
                end
            wait1_1:
                begin
                    db = 1'b1; //Set db high in the wait1_1 state (after rising edge)...
                    if(m_tick)
                        state_next = wait1_2;
                end
            wait1_2:
                begin
                    db = 1'b1; //Maintain db = 1 in this state...
                    if(m_tick)
                        state_next = wait1_3;
                end
            wait1_3:
                begin
                    db = 1'b1; //Maintain db = 1 in this state...
                    if(m_tick)
                        state_next = one;
                end
         
            one:
                begin
                    db = 1'b1; //Keep db high while in the `one` state...
                    if(~sw) //Falling edge detected, move to wait0_1...
                        state_next = wait0_1;
                end
            wait0_1:
                begin
                    db = 1'b0; //Set db low in the wait0_1 state...
                    if(m_tick)
                        state_next = wait0_2;
                end
            wait0_2:
                begin
                    db = 1'b0; //Maintain db = 0 in this state...
                    if(m_tick)
                        state_next = wait0_3;
                end       
            wait0_3:
                begin
                    db = 1'b0; //Maintain db = 0 in this state...
                    if(m_tick)
                        state_next = zero;
                end
            default: state_next = zero;
        endcase
    end
             
endmodule





