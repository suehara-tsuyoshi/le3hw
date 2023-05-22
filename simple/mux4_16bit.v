module mux4_16bit(
  input [15:0] data1,
  input [15:0] data2,
  input [15:0] data3,
  input [15:0] data4,
  input [1:0] op,
  output reg [15:0] res);

  always @* begin
    case (op)
    2'b00: res <= data1;
    2'b01: res <= data2;
    2'b10: res <= data3;
    2'b11: res <= data4;
    default: res <= 16'b0000_0000_0000_0000;
    endcase
  end
endmodule