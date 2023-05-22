module mem_access(

  input clock,
  input reset,
  input [2:0] phase_counter,
  input op_mdr,
  input [15:0] data_bus,
  input [15:0] outside_input,
  output [15:0] memory_data_register_wire);

reg [15:0] memory_data_register;

mux2 #(.WIDTH(16)) memory_data_register_mux(
  .data1(data_bus),
  .data2(outside_input),
  .op(op_mdr),
  .res(memory_data_register_wire),
);

always @(posedge clock) begin
  if( reset == 1'b0 ) begin
    memory_data_register <= 16'b0000_0000_0000_0000;		
  end 
  else if( phase_counter == 3'b100 ) begin
    memory_data_register <= memory_data_register_wire;
  end
  else begin
    memory_data_register <= memory_data_register;
  end
end

endmodule