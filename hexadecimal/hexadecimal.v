module hexadecimal(
  input [3:0] data,
  output [7:0] seg,
  output [3:0] sel);

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

  assign seg = decode(data);
  assign sel = 4'b0000;
endmodule