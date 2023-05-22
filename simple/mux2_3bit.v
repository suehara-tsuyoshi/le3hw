module mux2_3bit(
  input [2:0] data1,
  input [2:0] data2,
  input op,
  output reg [2:0] res);

  always @* begin
    if(op == 1'b0) begin
      res <= data1;
    end 
    else begin
      res <= data2;
    end
  end
endmodule