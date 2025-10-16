`timescale 1ns / 1ps

// Engineer: 
// Create Date: 06/01/2025 12:20:09 AM

module top_module_tb();

    wire is_10M, is_20M, is_5M;

    // Parameters
    parameter T1 = 10;  // clk1 = 10ns period -> 100 MHz
    real T2 = 5.0; // clk2 = 5ns period -> 200 MHz  
     
   // Inputs to top module
    reg clk1,clk2;
    reg reset;
    reg signal;

    // Internal wires
    wire synced_signal;
    wire out;
    wire done_tick;
    wire [15:0] period;
    wire [15:0] period2;
    wire [15:0] prd2t;

    // Instantiate the synchronizer
   dff_synchronizer synchronizer_inst (
       .clk1(clk1),       // same clock for simplicity
        .clk2(clk2),
       .rst(reset),
       .din(signal),
      .dout(synced_signal)
    );
    
   
  
    period_counter period_counter_inst (
        .clk(clk2),
        .reset(reset),
       .si(synced_signal),
        .done_tick(done_tick),
       .prd2(period2)
   );
   
   
    frequency_classifier classifier_inst (
        .clk(clk2),
        .reset(reset),
        .done_tick(done_tick),
        .prd2(period2),
        .is_10M(is_10M),
        .is_20M(is_20M),
        .is_5M(is_5M)
       
    );
    
     // Generate source clock (clk1) and destination clock (clk2)
    initial clk1 = 0;
    initial clk2 = 0;
    always #(T1/2) clk1 = ~clk1;
    always #(T2/2) clk2 = ~clk2;

    integer i;

    // Stimulus
    initial begin
        reset = 1;
        signal = 0;

        // Hold reset active for 2 clock cycles
        #(2*T1);
        reset = 0;
        signal=1;
        #(2*T1) signal = 0;

        // Pulse 1
        #(2*T1) signal = 1;
        #(2*T1) signal = 0;

        
        #(10*T1) signal = 1;
        #(10*T1) signal = 0;
        
        
        //detecting 10MHz
        #(50) signal = 1;  // half period
        #(50) signal = 0;
        #50 signal=1;
        #(50) signal = 0;  // half period
        #(50) signal = 1;
        #50 signal=0;
        

        #(100);
        //detecting 20MHz
        #20 signal=1;
        #30 signal=0;
        #20 signal=1;
        #30 signal=0;
        #20 signal=1;
        #30 signal=0;
        #20 signal=1;
        #30 signal=0;
        
        // Several quick pulses
       // repeat(4) begin
        //    #(T1) signal = 1;
      //      #(T1) signal = 0;
       // end
       
       #(10*T1) signal=1;
       #(10*T1) signal=0;
       #25;
    
       
       #20 signal=1;
       #40 signal=0;
       #60 signal=1;
       #80 signal=0;
       #100 signal=1;
       #100 signal=0;
       
       //detecting the frequency 5MHz
       #30 signal=1;
       #100 signal=0;
       #100 signal=1;
       #100 signal=0;
       #100 signal=1;
       
       
       #20 signal=0;
       #20 signal=1;
               
         for (i = 0; i < 10; i = i + 1) begin
        @(posedge clk1);
        signal = 1'b1;
        @(posedge clk1);
        signal = 1'b0;
        end
  repeat(150) @(posedge clk2);
    repeat(150) @(posedge clk1);

#1000000 $finish;  // 1ms
  $finish;
        // Wait and end
    end
    // Monitor output
        initial begin
        $monitor("Time=%0t | clk1=%b | clk2=%b | rst=%b | signal=%b | synced=%b | out=%b | period=%d | done=%b | 10M=%b | 20M=%b | 5M=%b ",
                 $time, clk1, clk2, reset, signal, synced_signal, out, prd2t, done_tick,
                 is_10M, is_20M, is_5M );
    end
    
endmodule

