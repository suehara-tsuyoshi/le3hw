module mux3 #(parameter WIDTH = 1)
  (input [WIDTH-1:0] data1,
   input [WIDTH-1:0] data2,
   input [WIDTH-1:0] data3,
   input [1:0] op,
   output reg [WIDTH-1:0] res);

  always @* begin
    case (op)
    2'b00: res <= data1;
    2'b01: res <= data2;
    2'b10: res <= data3;
    default: res <= 16'bxxxx_xxxx_xxxx_xxxx;
    endcase
  end
   
endmodule 