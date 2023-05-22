module hazard_unit(
  input clock,
  input reset,
  input state,
  input [1:0] op1,
  input [2:0] op2,
  input op_mem_read_ex,
  input op_branch,
  input op_halt,
  input [2:0] rs_id,rd_id,
  input [2:0] rs_ex,

  output reg op_pc_write,
  output reg op_if_id_write,
  output reg op_id_ex_write,
  output reg op_if_id_flush);

reg stall;

always @(posedge clock) begin
  if(reset == 1'b0) begin
    stall <= 1'b0;
  end
  else if(op_halt == 1'b1) begin
    stall <= 1'b0;
  end
  else if(stall == 1'b1 && op_branch == 1'b1) begin
    stall <= 1'b0;
  end
  else if (stall == 1'b0 && op1 == 2'b10 && op2 != 3'b000) begin
    stall <= 1'b1;
  end
  else if(op_mem_read_ex == 1'b1 && (rs_ex == rs_id || rs_ex == rd_id)) begin
    stall <= 1'b1;
  end
  else begin
    stall <= 1'b0;
  end
end

always @* begin
  if(op_halt == 1'b1 || state == 1'b0) begin
    op_pc_write = 1'b0;
    op_if_id_write = 1'b0;
    op_id_ex_write = 1'b0;
    op_if_id_flush = 1'b0;
  end
  else if(stall == 1'b1 && op_branch == 1'b1) begin
    op_pc_write = 1'b1;
    op_if_id_write = 1'b1;
    op_id_ex_write = 1'b1;
    op_if_id_flush = 1'b1;
  end
  else if (stall == 1'b0 && op1 == 2'b10 && op2 != 3'b000) begin
    op_pc_write = 1'b0;
    op_if_id_write = 1'b0;
    op_id_ex_write = 1'b0;
    op_if_id_flush = 1'b0;
  end
  else if(op_mem_read_ex == 1'b1 && (rs_ex == rs_id || rs_ex == rd_id)) begin
    op_pc_write = 1'b0;
    op_if_id_write = 1'b0;
    op_id_ex_write = 1'b0;
    op_if_id_flush = 1'b0;
  end
  else begin
    op_pc_write = 1'b1;
    op_if_id_write = 1'b1;
    op_id_ex_write = 1'b1;
    op_if_id_flush = 1'b0;
  end
end



endmodule