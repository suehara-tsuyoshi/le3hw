module mux8 #(parameter WIDTH = 1)
  (input [WIDTH-1:0] data1,
   input [WIDTH-1:0] data2,
   input [WIDTH-1:0] data3,
   input [WIDTH-1:0] data4,
   input [WIDTH-1:0] data5,
   input [WIDTH-1:0] data6,
   input [WIDTH-1:0] data7,
   input [WIDTH-1:0] data8,
   input [2:0] op,
   output reg [WIDTH-1:0] res);

  always @* begin
    case (op)
    3'b000: res <= data1;
    3'b001: res <= data2;
    3'b010: res <= data3;
    3'b011: res <= data4;
    3'b100: res <= data5;
    3'b101: res <= data6;
    3'b110: res <= data7;
    3'b111: res <= data8;
    default: res <= 0;
    endcase
  end
endmodule