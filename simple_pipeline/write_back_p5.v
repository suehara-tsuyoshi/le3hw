module write_back_p5(

  input [15:0] data_register,
  input [15:0] memory_data_register,
  input op_res,
  output [15:0] data_for_res);

  mux2 #(.WIDTH(16)) data_for_res_mux(
    .data1(data_register),
    .data2(memory_data_register),
    .op(op_res),
    .res(data_for_res));

endmodule
