module p5_write_back(

  //DRの内容
  input [15:0] data_register,

  //メモリから取り出した内容
  input [15:0] mem_read_data,

  // 外部入力
  input [15:0] outside_input,

  //出力を決める制御線
  input op_res,

  //書き込みデータ
  output [15:0] data_for_res);


  mux3 #(.WIDTH(16)) data_for_res_mux(
    .data1(data_register),
    .data2(mem_read_data),
    .data3(outside_input),
    .op(op_res),
    .res(data_for_res));

  

endmodule
