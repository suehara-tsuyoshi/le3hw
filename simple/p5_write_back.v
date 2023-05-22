module p5_write_back(

  //DRの内容
  input [15:0] data_register,

  //MDRの内容
  input [15:0] memory_data_register,

  //出力を決める制御線
  input op_mem_to_reg,

  //書き込みデータ
  output [15:0] data_for_write);

  mux2_16bit data_for_write_mux(
    .data1(data_register),
    .data2(memory_data_register),
    .op(op_mem_to_reg),
    .res(data_for_write));

endmodule
