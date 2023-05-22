module mux2 #(parameter WIDTH = 1)
  (input [WIDTH-1:0] data1,
   input [WIDTH-1:0] data2,
   input op,
   output reg [WIDTH-1:0] res);

  always @* begin
    case (op)
    1'b0: res <= data1;
    1'b1: res <= data2;
    endcase
  end
   
endmodule 