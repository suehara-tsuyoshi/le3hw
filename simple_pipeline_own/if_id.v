module if_id(
  input clock,
  input reset,
  input op_if_id_write,
  input op_if_id_flush,
  input [15:0] program_counter_pre_if,
  input [15:0] instruction_register_if,
  output reg [15:0] program_counter_pre_id,
  output reg [15:0] instruction_register_id);

always @(posedge clock) begin
  if(reset == 1'b0 || op_if_id_flush == 1'b1) begin
    program_counter_pre_id <= 16'b0000_0000_0000_0000;
    instruction_register_id <= 16'b1100_0000_1110_0000;
  end
  else if(op_if_id_write == 1'b1) begin
    program_counter_pre_id <= program_counter_pre_if;
    instruction_register_id <= instruction_register_if;
  end
  else begin
    program_counter_pre_id <= program_counter_pre_id;
    instruction_register_id <= instruction_register_id;
  end
end

endmodule