`timescale 1ns / 1ps

module UART_FIFO_TX_TOP(
    input clk,
    input rst,
    input wr_en,
    input [7:0] data_in,
    output tx
    );

    // Baud Generator
    wire baud_tick;
    Baud_Generator bg(clk,rst,baud_tick);

    // FIFO
    wire [7:0] fifo_data_out;
    wire fifo_full;
    wire fifo_empty;
    reg rd_en;

    FIFO fifo(clk,rst,wr_en,rd_en,data_in,fifo_data_out,fifo_full,fifo_empty);
   

    // UART TX
    wire tx_busy;
    wire tx_done;
    wire [7:0] tx_count;
    reg tx_start;
    reg [7:0] tx_data_reg;

    UART_TX dut(clk,rst,tx_start,tx_data_reg,baud_tick,tx,tx_done,tx_busy,tx_count);
    

    // FSM States
    parameter s0 = 3'b000,  // IDLE
              s1 = 3'b001,  // READ
              s2 = 3'b010,  // LOAD
              s3 = 3'b011,  // HOLD
              s4 = 3'b100,  // START
              s5 = 3'b101;  // WAIT

    reg [2:0] ps, ns;

    // State Register
    always @(posedge clk or posedge rst)
    begin
      if(rst)
       ps<= s0;
      else
       ps<= ns;
    end

    // Output Logic
    always @(posedge clk or posedge rst)
    begin
    if(rst)
      begin
       rd_en<=0;
       tx_start<=0;
       tx_data_reg<=0;
      end
    else
      begin
       rd_en<=0;
       tx_start<=0;
       case(ps)
       s1:rd_en<=1;
       s3:tx_data_reg <= fifo_data_out;
       s4:tx_start <= 1;
       endcase
      end
    end
    
    // Next State Logic
    always @(*)
    begin
        case(ps)
        s0:
        begin
         if(!fifo_empty && !tx_busy)
          ns=s1;
         else
          ns=s0;
        end
        s1:ns=s2;
        s2:ns=s3;
        s3:ns=s4;
        s4:ns=s5;
        s5:
        begin
         if(tx_done)
          ns=s0;
         else
          ns=s5;
        end
        default:ns=s0;
        endcase
    end
endmodule
