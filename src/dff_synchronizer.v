`timescale 1ns / 1ps

// Create Date: 05/31/2025 10:16:15 PM
// Module Name: dff_synchronizer
module dff_synchronizer(
   input wire clk1,
    input wire clk2,
    input wire rst,
    input wire din,
    output reg dout
);
   reg din_flop;
    //, dmeta;
//(* ASYNC_REG = "TRUE" *) reg dmeta2;
(* ASYNC_REG = "TRUE" *) reg dmeta;
    always @(posedge clk1 or posedge rst)begin
        if (rst) din_flop <= 1'b0;
        else       din_flop <= din; end

    always @(posedge clk2 or posedge rst) begin
        if (rst) begin
            dmeta <= 1'b0;
            dout  <= 1'b0;
            dout<=1'b0;
    end else begin
            dmeta <= din_flop;
           // dmeta2  <= dmeta;
            dout <= dmeta;
            end
        end
endmodule
