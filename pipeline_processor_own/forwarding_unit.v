module forwarding_unit(
  
  input reset,

  input [1:0] op_alu_src_a,
  input [1:0] op_alu_src_b,

  input op_mem_write_ex,

  input op_reg_write_mem,
  input op_reg_write_address_mem,

  input op_reg_write_wb,
  input op_reg_write_address_wb,

  input [2:0] rs_ex,rd_ex,
  input [2:0] rs_mem,rd_mem,
  input [2:0] rs_wb,rd_wb,

  output [1:0] op_forward_a,
  output [1:0] op_forward_b,
  output [1:0] op_forward_c);

  wire [2:0] rt_mem,rt_wb;

  mux2 #(.WIDTH(3)) rt_mem_mux(
    .data1(rd_mem),
    .data2(rs_mem),
    .op(op_reg_write_address_mem),
    .res(rt_mem));

  mux2 #(.WIDTH(3)) rt_wb_mux(
    .data1(rd_wb),
    .data2(rs_wb),
    .op(op_reg_write_address_wb),
    .res(rt_wb));

  
  function [1:0] should_forward_a;
    input res;
    begin  
      if (op_alu_src_a != 2'b00) begin
        should_forward_a = 2'b00;
      end
      else if(op_reg_write_mem == 1'b1 && rd_ex == rt_mem) begin
        should_forward_a = 2'b01;
      end
      else if(op_reg_write_wb == 1'b1 && rd_ex == rt_wb) begin
        should_forward_a = 2'b10;
      end
      else begin
        should_forward_a = 2'b00;
      end
    end
  endfunction

  function [1:0] should_forward_b;
    input res;
    begin    
      if (op_alu_src_b != 2'b10) begin
        should_forward_b = 2'b00;
      end
      else if(op_reg_write_mem == 1'b1 && rs_ex == rt_mem) begin
        should_forward_b = 2'b01;
      end
      else if(op_reg_write_wb == 1'b1 && rs_ex == rt_wb) begin
        should_forward_b = 2'b10;
      end
      else begin
        should_forward_b = 2'b00;
      end
    end
    
  endfunction


  function [1:0] should_forward_c;
    input res;
    begin
      if (op_mem_write_ex == 1'b0) begin
        should_forward_c = 2'b00;
      end
      else if(op_reg_write_mem == 1'b1 && rs_ex == rt_mem) begin
        should_forward_c = 2'b01;
      end
      else if(op_reg_write_wb == 1'b1 && rs_ex == rt_wb) begin
        should_forward_c = 2'b10;
      end
      else begin
        should_forward_c = 2'b00;
      end
    end
    
  endfunction

  
  assign op_forward_a = should_forward_a(reset);
  assign op_forward_b = should_forward_b(reset);
  assign op_forward_c = should_forward_c(reset);
  





endmodule