`timescale 1ns / 1ps

// Create Date: 06/03/2025 12:26:26 AM
// Module Name: frequency_classifier
module frequency_classifier (
    input wire clk,
    input wire reset,
    input wire done_tick,    
  //  input wire si,         
    input wire [15:0] prd2,            
    output reg is_10M,
    output reg is_20M,
    output reg is_5M
   
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            is_10M <= 0;
            is_20M <= 0;
            is_5M <= 0;
           
        end else begin
            // Default: 
           is_5M <= 0;
           is_10M <= 0;
           is_20M <= 0;
            
           

            if (done_tick) begin
          
                if (prd2 == 16'd16)
                    is_10M <= 1'b1;
                else if (prd2 == 16'd6)
                    is_20M <= 1'b1;
                else if (prd2 == 16'd36)
                    is_5M <= 1'b1;
                
            end
        end
    end

endmodule
