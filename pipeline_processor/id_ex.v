module id_ex(
  input clock,
  input reset,
  input op_id_ex_write,
  input [15:0] program_counter_pre_id,
  input [1:0] op_alu_src_a_id,
  input [1:0] op_alu_src_b_id,
  input [3:0] op_alu_id,
  input op_data_for_output_update_id,
  input op_mem_write_id,
  input op_mem_read_id,
  input op_reg_write_id,
  input op_reg_write_address_id,
  input op_mdr_id,
  input op_res_id,
  input [2:0] rs_id, rd_id,
  input [15:0] ar_id,br_id,
  input [15:0] instruction_register_id,

  output reg [15:0] program_counter_pre_ex,
  output reg [1:0] op_alu_src_a_ex,
  output reg [1:0] op_alu_src_b_ex,
  output reg [3:0] op_alu_ex,
  output reg op_data_for_output_update_ex,
  output reg op_mem_write_ex,
  output reg op_mem_read_ex,
  output reg op_reg_write_ex,
  output reg op_reg_write_address_ex,
  output reg op_mdr_ex,
  output reg op_res_ex,
  output reg [2:0] rs_ex, rd_ex,
  output reg [15:0] ar_ex, br_ex,
  output reg [15:0] instruction_register_ex);

always @(posedge clock) begin
  if(reset == 1'b0 || op_id_ex_write == 1'b0) begin
    program_counter_pre_ex <= 16'b0000_0000_0000_0000;
    op_alu_src_a_ex <= 2'b00;
    op_alu_src_b_ex <= 2'b00;
    op_alu_ex <= 4'b0000;
    op_data_for_output_update_ex <= 1'b0;
    op_mem_write_ex <= 1'b0;
    op_mem_read_ex <= 1'b0;
    op_reg_write_ex <= 1'b0;
    op_reg_write_address_ex <= 1'b0;
    op_mdr_ex <= 1'b0;
    op_res_ex <= 1'b0;
    rs_ex <= 3'b000;
    rd_ex <= 3'b000;
    ar_ex <= 16'b0000_0000_0000_0000;
    br_ex <= 16'b0000_0000_0000_0000;
    instruction_register_ex <= 16'b0000_0000_0000_0000;
  end
  else if(op_id_ex_write == 1'b1) begin
    program_counter_pre_ex <= program_counter_pre_id;
    op_alu_src_a_ex <= op_alu_src_a_id;
    op_alu_src_b_ex <= op_alu_src_b_id;
    op_alu_ex <= op_alu_id;
    op_data_for_output_update_ex <= op_data_for_output_update_id;
    op_mem_write_ex <= op_mem_write_id;
    op_mem_read_ex <= op_mem_read_id;
    op_reg_write_ex <= op_reg_write_id;
    op_reg_write_address_ex <= op_reg_write_address_id;
    op_mdr_ex <= op_mdr_id;
    op_res_ex <= op_res_id;
    rs_ex <= rs_id;
    rd_ex <= rd_id;
    ar_ex <= ar_id;
    br_ex <= br_id;
    instruction_register_ex <= instruction_register_id;
  end
end

endmodule