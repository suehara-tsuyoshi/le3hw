module ex_mem(
  input clock,
  input reset,
  input op_mem_write_ex,
  input op_mem_read_ex,
  input op_reg_write_ex,
  input op_reg_write_address_ex,
  input op_mdr_ex,
  input op_res_ex,
  input [2:0] rs_ex, 
  input [2:0] rd_ex,
  input [15:0] ar_ex,
  input [15:0] data_register_ex,
  output reg op_mem_write_mem,
  output reg op_reg_write_mem,
  output reg op_reg_write_address_mem,
  output reg op_mdr_mem,
  output reg op_res_mem,
  output reg [2:0] rs_mem,
  output reg [2:0] rd_mem,
  output reg [15:0] ar_mem,
  output reg [15:0] data_register_mem);

always @(posedge clock) begin
  if(reset == 1'b0) begin
    op_mem_write_mem <= 1'b0;
    op_reg_write_mem <= 1'b0;
    op_reg_write_address_mem <= 1'b0;
    op_mdr_mem <= 1'b0;
    op_res_mem <= 1'b0;
    rs_mem <= 3'b000;
    rd_mem <= 3'b000;
    ar_mem <= 16'b0000_0000_0000_0000;
    data_register_mem <= 16'b0000_0000_0000_0000;
  end
  else begin
    op_mem_write_mem <= op_mem_write_ex;
    op_reg_write_mem <= op_reg_write_ex;
    op_reg_write_address_mem <= op_reg_write_address_ex;
    op_mdr_mem <= op_mdr_ex;
    op_res_mem <= op_res_ex;
    rs_mem <= rs_ex;
    rd_mem <= rd_ex;
    ar_mem <= ar_ex;
    data_register_mem <= data_register_ex;
  end
end
endmodule