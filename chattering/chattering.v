module chattering(
	input btn,
	input reset,
	input clock,
	input clock2,
	output reg [7:0] seg,
	output reg [3:0] sel);
	
	reg [3:0] counter;
	reg [23:0] chatter;
  reg [7:0] num2;
	reg [7:0] num;
	
	
   function [7:0] decode;
   input [3:0] a;
   begin
     case (a)
     4'b0000: decode = 8'b11111100;
     4'b0001: decode = 8'b01100000;
     4'b0010: decode = 8'b11011010;
     4'b0011: decode = 8'b11110010;
     4'b0100: decode = 8'b01100110;
     4'b0101: decode = 8'b10110110;
     4'b0110: decode = 8'b10111110;
     4'b0111: decode = 8'b11100000;
     4'b1000: decode = 8'b11111110;
     4'b1001: decode = 8'b11110110;
     4'b1010: decode = 8'b11101110;
     4'b1011: decode = 8'b00111110;
     4'b1100: decode = 8'b10011100;
     4'b1101: decode = 8'b01111010;
     4'b1110: decode = 8'b10011110;
     4'b1111: decode = 8'b10001110;
     default: decode = 8'b00000000;
     endcase
   end
   endfunction
  
  
	always @(posedge clock2 or negedge reset) begin
    if(reset == 1'b0) begin
      num2 <= 8'b00000000;
      chatter <= 24'b000000000000000000000000;
    end
    else if(btn == 1'b0) begin
      chatter <= chatter + 1;
      if(chatter == 24'b000000010000000000000000) begin
        counter <= counter + 1;
      end
    end
    else begin
      chatter <= 24'b000000000000000000000000;
      num2 <= num2 + 1;
    end
  end
	
	always @(posedge clock2 or negedge reset) begin
    if(reset == 1'b0) begin
      num <= 8'b00000000;
      seg <= decode(counter);
      sel <= 4'b1110;
    end
    else if(num == 8'b00100000) begin
      seg <= decode(counter);
      sel <= 4'b1110;
      num <= num + 1;
    end
    else if(num == 8'b01000000) begin
      seg <= decode(counter);
      sel <= 4'b1110;
      num <= num + 1;
    end
    else if(num == 8'b01100000) begin
      seg <= decode(counter);
      sel <= 4'b1110;
      num <= num + 1;
    end
    else if(num == 8'b10000000) begin
      seg <= decode(counter);
      sel <= 4'b1110;
      num = 8'b00000000;
    end
    else begin
      num <= num + 1;
    end
  end
	
	
endmodule

