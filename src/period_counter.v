`timescale 1ns / 1ps
module period_counter(  
    input wire clk, reset,
    input wire si,
    output reg done_tick,
    output reg [15:0] prd2
);

    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;

    reg [1:0] state_next, state_reg;
    reg [15:0] period_reg, period_prev;
    reg delay_reg;
    reg si_d1;
    wire edge1;

    assign edge1 = ~delay_reg & si;

    always @(posedge clk or posedge reset) begin 
        if (reset) begin
            state_reg   <= A;
            period_reg  <= 16'd0;
            period_prev <= 16'd0;
            prd2        <= 16'd0;
            si_d1       <= 1'b0;
            delay_reg   <= 1'b0;
        end else begin
            state_reg   <= state_next;
            period_prev <= period_reg;
            prd2        <= period_prev;
            si_d1       <= si; 
            delay_reg   <= si_d1;

            if (state_reg == A || state_reg == C)
                period_reg <= period_reg + 1;
            else if (state_reg == B)
                period_reg <= 16'd0;
        end
    end

    always @(*) begin 
        done_tick = 1'b0;
        case (state_reg)
            A: if (edge1) begin 
                    state_next = B; 
                    done_tick = 1'b1; 
               end else state_next = A;
            B: if (edge1) 
                    state_next = C;
               else 
                    state_next = A;
            C: state_next = A;
            default: state_next = A;
        endcase 
    end

endmodule