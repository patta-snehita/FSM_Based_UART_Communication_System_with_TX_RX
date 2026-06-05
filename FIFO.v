`timescale 1ns / 1ps
module FIFO(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0]data_in,
    output reg [7:0]data_out,
    output full,
    output empty
    );
    
    //4*8 fifo
    //4 locations*8 bit data
    
    reg [7:0]fifo_mem[3:0];
    reg [1:0]wr_ptr;
    reg [1:0]rd_ptr;
    reg [2:0]count;
    
    
    //WRITE +READ LOGIC(SEQ LOGIC)
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
          wr_ptr<=0;
          rd_ptr<=0;
          count<=0;
          data_out<=0;
       end
       else
       begin
        
       if(wr_en && !full)
       begin
        fifo_mem[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
       end
       
       if(rd_en && !empty)
       begin
        data_out <= fifo_mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
       end
    case({wr_en && !full, rd_en && !empty})
        2'b10: count <= count + 1;
        2'b01: count <= count - 1;
        2'b11: count <= count;
        default: count <= count;
    endcase
    end 
    end
      
      //status signals
      
      assign full=(count==4);
      assign empty=(count==0);
    
endmodule
