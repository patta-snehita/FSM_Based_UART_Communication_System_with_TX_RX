`timescale 1ns / 1ps
module UART_TX_tb(

    );
    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0]data_in;
   
    wire tx_done; 
    wire baud_tick;
    wire tx_wire;
    wire [7:0]data_out;
    wire rx_done;
    wire tx_busy;
    wire [7:0]tx_count;
    wire parity_error;
    wire framing_error;
    
    Baud_Generator #(.clock_freq(100000000),.baud_rate(25000000))bg(clk,rst,baud_tick);
    
    UART_TX dut1(clk,rst,tx_start,data_in,baud_tick,tx_wire,tx_done,tx_busy,tx_count);
    
    UART_RX dut2(clk,rst,tx_wire,baud_tick,data_out,rx_done,parity_error,framing_error);
    
    initial begin
    {clk,rst,tx_start,data_in}=0;
    end
    
    always begin
    #5 clk=~clk;
    end
    
    initial
    begin
    
    #10 rst=1;
    #10 rst=0;
    #10;
    data_in  = 8'b10101010;
    tx_start = 1;
    #10;
    tx_start=0;
    #500;
    data_in  = 8'b11000100;
    tx_start = 1;
    #10;
    tx_start=0;
    end
    
    initial
    begin
    $monitor("TIME=%0t | tx_ps=%b|tx_start=%b | data_in=%b | baud_tick=%b |parity=%b|parity_error=%b|framing_error=%b | tx=%b | tx_done=%b | tx_busy=%b |tx_count=%d| TX_bit_count=%d | TX_data_reg=%b|data_out=%b| RX_done=%b",
    $time,dut1.ps,tx_start,data_in,baud_tick,dut1.parity_bit,parity_error,framing_error,tx_wire,tx_done,tx_busy,dut1.tx_count,dut1.bit_count,dut1.data_reg,dut2.data_out,dut2.rx_done);
    end
    
endmodule

