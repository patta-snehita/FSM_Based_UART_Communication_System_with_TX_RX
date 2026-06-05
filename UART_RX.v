`timescale 1ns / 1ps
module UART_RX(
    input clk,
    input rst,
    input rx,
       
    input baud_tick,
       
    output reg [7:0]data_out,
    output reg rx_done,
    output reg parity_error,
    output reg framing_error
    );
   parameter s0=3'b000,  //idle
              s1=3'b001,   //start
              s2=3'b010,   //data
              s3=3'b011,   //parity
              s4=3'b100;   //stop
    reg [2:0]ps,ns;
    reg [3:0]bit_count;  //counter
    reg [7:0] data_reg;  //shift register
    reg parity_bit;
    //state register
    //sequenial logic
    always@(posedge clk or posedge rst)
    begin
       if(rst)
       begin
         ps<=s0;
         bit_count<=0;
         data_reg<=0;
         data_out<=0;
         parity_bit<=0;
         framing_error<=0;
       end
       else
       begin
         ps<=ns;
         if(ps==s2 && baud_tick) //receive databits
         begin
            data_reg<={rx,data_reg[7:1]};
            bit_count<=bit_count+1;
         end 
         //receive parity bit
         else if(ps==s3 && baud_tick)begin
         parity_bit<=rx;
         end
         
         //rst counter in idle state
         if(ps==s0)begin
         bit_count<=0;
         end
         if(ps == s4 && baud_tick)begin
            data_out <= data_reg;
            if(rx!=1'b1)
              framing_error<=1;
            else
              framing_error<=0;
         end
        end
     end
     
     //next state logic
     //combinational logic
     always@(*)
     begin
       case(ps)
       
       s0:
       begin
         if(rx==0) //as the start bit is transition from 1-0
           ns=s1;
         else
           ns=s0;
       end
       
       s1:
       begin
        if(baud_tick)
          ns=s2;
        else 
          ns=s1;
       end
       
       s2:
       begin
        if(baud_tick)
        begin
          if(bit_count<7)
            ns=s2;
          else
            ns=s3;
        end
        else
        ns=s2;
       end
       
       s3:
       begin
        if(baud_tick)
          ns=s4;
        else
          ns=s3;
       end
        s4:
       begin
        if(baud_tick)
          ns=s0;
        else
          ns=s4;
       end
       default:ns=s0;
    endcase
   end
       
    //output logic
    always@(*)
    begin
      rx_done=0;
      parity_error=0;
      case(ps)
      s4:
      begin
        rx_done=1;
        if(parity_bit!=^data_reg)
          parity_error=1;
        else
          parity_error=0;
      end
      endcase
    end
            
endmodule


