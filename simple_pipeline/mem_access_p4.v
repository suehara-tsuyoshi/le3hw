module mem_access_p4(
  
  input op_mdr,
  input [15:0] memory_data,
  input [15:0] outside_input,
  output [15:0] memory_data_register_wire);

mux2 #(.WIDTH(16)) memory_data_register_mux(
  .data1(memory_data),
  .data2(outside_input),
  .op(op_mdr),
  .res(memory_data_register_wire)
);
endmodule