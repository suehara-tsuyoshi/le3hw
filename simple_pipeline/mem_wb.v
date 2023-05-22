module mem_wb(
  input clock,
  input reset,
  input op_mem_wb_write,
  input op_reg_write_mem,
  input op_reg_write_address_mem,
  input op_res_mem,
  input [2:0] rs_mem, rd_mem,
  input [15:0] data_register_mem,
  input [15:0] memory_data_register_mem,
  output reg op_reg_write_wb,
  output reg op_reg_write_address_wb,
  output reg op_res_wb,
  output reg [2:0] rs_wb, rd_wb,
  output reg [15:0] data_register_wb,
  output reg [15:0] memory_data_register_wb);

always @(posedge clock) begin
  if(reset == 1'b0) begin
    op_reg_write_wb <= 1'b0;
    op_reg_write_address_wb <= 1'b0;
    op_res_wb <= 1'b0;
    rs_wb <= 3'b000;
    rd_wb <= 3'b000;
    data_register_wb <= 16'b0000_0000_0000_0000;
    memory_data_register_wb <= 16'b0000_0000_0000_0000;
  end
  else begin
    op_reg_write_wb <= op_reg_write_mem;
    op_reg_write_address_wb <= op_reg_write_address_mem;
    op_res_wb <= op_res_mem;
    rs_wb <= rs_mem;
    rd_wb <= rd_mem;
    data_register_wb <= data_register_mem;
    memory_data_register_wb <= memory_data_register_mem;
  end
end

endmodule