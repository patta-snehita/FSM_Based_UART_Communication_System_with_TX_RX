`timescale 1ns / 1ps
module Baud_Generator#(
   parameter clock_freq=100000000,
   parameter baud_rate=25000000
   )
   
   (
   input clk,
   input rst,
   output reg baud_tick
    );
    
    localparam baud_count=clock_freq / baud_rate;
    reg [12:0]count;
    
    always@(posedge clk or posedge rst)
    begin
     if(rst)
     begin
      count<=0;
      baud_tick<=0;
     end
     
     else
     begin
       if(count==baud_count-1)
       begin
          count<=0;
          baud_tick<=1;
       end
       else
       begin
         count<=count+1;
         baud_tick<=0;
       end
     end
   end
endmodule
