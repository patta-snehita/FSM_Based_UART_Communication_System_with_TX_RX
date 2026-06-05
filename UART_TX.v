`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module UART_TX(
       input clk,
       input rst,
       input tx_start,
       input [7:0]data_in,
       
       input baud_tick,
       
       output reg tx,
       output reg tx_done ,
       output reg tx_busy,
       output reg [7:0] tx_count    //0-255 transmission count  
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
    
    //state register +shift logic
    //sequential logic
    always@(posedge clk or posedge rst)
    begin
      if(rst)
      begin
        ps<=s0;
        bit_count<=0;
        data_reg<=0;
        tx_count<=0;
        parity_bit<=0;
        tx<=1;
        tx_done<=0;
        tx_busy<=0;
        
      end
      else
      begin
        ps<=ns;
     
        if(ps==s1)begin
          data_reg<=data_in; //load data
          parity_bit<=^data_in;  //even parity
          bit_count<=0;
          end
        else if(ps==s2 && baud_tick)begin
          data_reg<=data_reg>>1;   //shift the bits to right
          bit_count<=bit_count+1;     //increase the bit count so that we can have count of bits transmitted
        end
        if (ps==s3 && baud_tick)begin
          tx_count<=tx_count+1;
        end
       end 
   end
   
   //next state logic
   
   always@(*)
   begin
      case(ps)
      s0:begin
      if(tx_start)
        ns=s1;
      else
        ns=s0;
      end
      
      s1:begin
      if(baud_tick)
      ns=s2;
      else
      ns=s1;
      end
      
      s2:begin
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
      s3:begin
      if(baud_tick)
        ns=s4;
      else
        ns=s3;
      end
      s4:begin
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
  tx=1;
  tx_done=0;
  tx_busy=0;
  case(ps)
  s0:begin
  tx=1;
  tx_busy=0;
  end
  
  s1:begin
  tx=0;
  tx_busy=1;
  end
  
  s2:begin
  tx=data_reg[0];
  tx_busy=1;
  end
  
  s3:begin
  tx=parity_bit;
  tx_busy=1;
  end
  
  s4:begin
  tx=1;
  tx_busy=1;
  if(baud_tick)
    tx_done=1;
  else
    tx_done=0;
   
  end
  
  endcase
  end
endmodule
