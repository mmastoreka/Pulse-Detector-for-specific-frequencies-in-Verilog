`timescale 1ns / 1ps
// Engineer: 
// Create Date: 05/31/2025 11:17:59 PM
// Module Name: top_module

module top_module(   input wire clk1,
    input wire clk2,
    input wire rst,
    input wire din,
   
    output wire done_tick,
    output wire is_10M,
    output wire is_20M,
    output wire is_5M
 );
 wire synced_signal;
 wire [15:0] prd2t;
    // Instantiate the synchronizer
    dff_synchronizer sync_inst (
        .clk1(clk1),
        .clk2(clk2),
        .rst(rst),
        .din(din),
        .dout(synced_signal)
    );

    period_counter period_cnt_inst (
        .clk(clk2),
        .reset(rst),
       // .start(1'b1),       
        .si(synced_signal),       
        
        .done_tick(done_tick),
       // .prd2(prd),
        .prd2(prd2t)
    );
    
   
    
     frequency_classifier classifier_inst (
        .clk(clk2),
        .reset(rst),
        .done_tick(done_tick),
        .prd2(prd2t),
        .is_10M(is_10M),
        .is_20M(is_20M),
        .is_5M(is_5M) );
endmodule
