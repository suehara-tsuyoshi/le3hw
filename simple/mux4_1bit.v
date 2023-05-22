module mux4_1bit(
  input data1,
  input data2,
  input data3,
  input data4,
  input [1:0] op,
  output reg res);

  always @* begin
    case (op)
    2'b00: res <= data1;
    2'b01: res <= data2;
    2'b10: res <= data3;
    2'b11: res <= data4;
    default: res <= 1'b0;
    endcase
  end
endmodule