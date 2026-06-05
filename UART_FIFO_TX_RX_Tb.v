`timescale 1ns / 1ps
module UART_FIFO_TX_TOP_tb(

);

reg clk;
reg rst;
reg wr_en;
reg [7:0] data_in;
wire tx;

wire baud_tick;

wire [7:0] data_out;
wire rx_done;
wire parity_error;
wire framing_error;


UART_FIFO_TX_TOP dut(clk,rst,wr_en,data_in,tx);

Baud_Generator bg(clk,rst,baud_tick);

UART_RX dut2(clk,rst,tx,baud_tick,data_out,rx_done,parity_error,framing_error);

 always #5 clk = ~clk;
  initial
  begin
    clk = 0;
    rst = 1;
    wr_en = 0;
    data_in = 0;
    #20;
    rst = 0;
    #100;
    wr_en = 1;
    data_in = 8'hAA;

    #10;
    data_in = 8'hBB;

    #10;
    data_in = 8'hCC;

    #10;
    data_in = 8'hDD;

    #10;
    wr_en = 0;

    // Wait long enough for UART TX

    #2000000;
    $display("reached 2ms");
    #2000000;
    $display("reached 4ms");
    #2000000;
    $display("reached 6ms");
    

    $finish;

end

initial
begin

$monitor(
"t=%0t | ps=%b|ns=%b|wr_en=%b|data_in=%h||tx_data_reg=%h | fifo_data_out=%h|fifo_empty=%b | rd_en=%b | tx_start=%b |tx_busy=%b| tx_done=%b| tx=%b |tx_count=%d|data_out=%h|,rx_done=%b|,parity_error=%b|,framing_error=%b",
$time,
dut.ps,
dut.ns,
wr_en,
data_in,
dut.tx_data_reg,
dut.fifo_data_out,
dut.fifo_empty,
dut.rd_en,
dut.tx_start,
dut.tx_busy,
dut.tx_done,
tx,
dut.tx_count,
dut2.data_out,
dut2.rx_done,
dut2.parity_error,
dut2.framing_error
);

end

endmodule

