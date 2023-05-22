module control_unit(

  input clock,
  input reset,
  input exec,
  input [1:0] op1,
  input [2:0] op2,
  input [3:0] op3,
  input [2:0] opcond,
  input [3:0] cond,
  output state,
  output reg op_branch,
  output reg [1:0] op_alu_src_a,
  output reg [1:0] op_alu_src_b,
  output reg [3:0] op_alu,
  output reg op_data_for_output_update,
  output reg op_mem_read,
  output reg op_mem_write,
  output reg op_reg_write,
  output reg op_reg_write_address,
  output reg op_mdr,
  output reg op_res,
  output reg op_halt);

  reg [3:0] cond_register;
  
  chattering chattering(
    .clock(clock),
    .reset(reset),
    .exec(exec),
    .state(state));

  always @(posedge clock) begin
    if(reset == 1'b0) begin
      cond_register <= 4'b0000;
    end
    else begin
      cond_register <= cond;
    end
  end

  always @* begin
    
    if(op1 == 2'b11) begin
      // 演算命令
      if(op3[3] == 1'b0) begin
        // CMP命令(op_reg_writeは0)
        if(op3[2:0] == 3'b101) begin
          op_alu_src_a = 2'b00;
          op_alu_src_b = 2'b10;
          op_alu = op3;
          op_data_for_output_update = 1'b0;
          op_branch = 1'b0;
          op_reg_write = 1'b0;
          op_reg_write_address = 1'b0;
          op_mdr = 1'b0;
          op_res = 1'b0;
          op_mem_read = 1'b0;
          op_mem_write = 1'b0;
          op_halt = 1'b0;
        end 
        else begin
          op_alu_src_a = 2'b00;
          op_alu_src_b = 2'b10;
          op_alu = op3;
          op_data_for_output_update = 1'b0;
          op_branch = 1'b0;
          op_reg_write = 1'b1;
          op_reg_write_address = 1'b0;
          op_mdr = 1'b0;
          op_res = 1'b0;
          op_mem_read = 1'b0;
          op_mem_write = 1'b0;
          op_halt = 1'b0;
        end
        
      end
      // シフト命令
      else if(op3[3:2] == 2'b10) begin
        op_alu_src_a = 2'b00;
        op_alu_src_b = 2'b01;
        op_alu = op3;
        op_data_for_output_update = 1'b0;
        op_branch = 1'b0;
        op_reg_write = 1'b1;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 1'b0;;
        op_mem_read = 1'b0;
        op_mem_write = 1'b0;
        op_halt = 1'b0;
      end
      // in命令
      else if(op3 == 4'b1100) begin
        op_alu_src_a = 2'b01;
        op_alu_src_b = 2'b11;
        op_alu = 4'b0000;
        op_data_for_output_update = 1'b0;
        op_branch = 1'b0;
        op_reg_write = 1'b1;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b1;
        op_res = 1'b1;
        op_mem_read = 1'b0;
        op_mem_write = 1'b1;
        op_halt = 1'b0;
      end
      // out命令
      else if(op3 == 4'b1101) begin
        op_alu_src_a = 2'b00;
        op_alu_src_b = 2'b11;
        op_alu = 4'b0000;
        op_data_for_output_update = 1'b1;
        op_branch = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 1'b0;
        op_mem_read = 1'b0;
        op_mem_write = 1'b0;
        op_halt = 1'b0;
      end
      // hlt命令
      else if(op3 == 4'b1111) begin
        op_alu_src_a = 2'b00;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_data_for_output_update = 1'b0;
        op_branch = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 1'b0;
        op_mem_read = 1'b0;
        op_mem_write = 1'b0;
        op_halt = 1'b1;
      end
      else begin
        op_alu_src_a = 2'b00;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_data_for_output_update = 1'b0;
        op_branch = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 1'b0;
        op_mem_read = 1'b0;
        op_mem_write = 1'b0;
        op_halt = 1'b0;
      end
    end
    // ロード命令
    else if(op1 == 2'b00) begin
      op_alu_src_a = 2'b00;
      op_alu_src_b = 2'b00;
      op_alu = 4'b0000;
      op_data_for_output_update = 1'b0;
      op_branch = 1'b0;
      op_reg_write = 1'b1;
      op_reg_write_address = 1'b1;
      op_mdr = 1'b0;
      op_res = 1'b1;
      op_mem_read = 1'b1;
      op_mem_write = 1'b0;
      op_halt = 1'b0;
    end
    // ストア命令
    else if(op1 == 2'b01) begin
      op_alu_src_a = 2'b00;
      op_alu_src_b = 2'b00;
      op_alu = 4'b0000;
      op_data_for_output_update = 1'b0;
      op_branch = 1'b0;
      op_reg_write = 1'b0;
      op_reg_write_address = 1'b0;
      op_mdr = 1'b0;
      op_res = 1'b0;
      op_mem_read = 1'b0;
      op_mem_write = 1'b1;
      op_halt = 1'b0;
    end
    // 即値ロード命令
    else if(op1 == 2'b10 && op2 == 3'b000) begin
      op_alu_src_a = 2'b11;
      op_alu_src_b = 2'b00;
      op_alu = 4'b0000;
      op_data_for_output_update = 1'b0;
      op_branch = 1'b0;
      op_reg_write = 1'b1;
      op_reg_write_address = 1'b0;
      op_mdr = 1'b0;
      op_res = 1'b0;
      op_mem_read = 1'b0;
      op_mem_write = 1'b0;
      op_halt = 1'b0;
    end
    // 無条件分岐命令
    else if(op1 == 2'b10 && op2 == 3'b100) begin
      op_alu_src_a = 2'b10;
      op_alu_src_b = 2'b00;
      op_alu = 4'b0000;
      op_data_for_output_update = 1'b0;
      op_branch = 1'b1;
      op_reg_write = 1'b0;
      op_reg_write_address = 1'b0;
      op_mdr = 1'b0;
      op_res = 1'b0;
      op_mem_read = 1'b0;      
      op_mem_write = 1'b0;
      op_halt = 1'b0;
    end 
    // 条件分岐命令
    else if(op1 == 2'b10 && op2 == 3'b111) begin
      case(opcond)
      3'b000: 
      begin
        op_alu_src_a = 2'b10;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_data_for_output_update = 1'b0;
        op_branch = cond_register[2];
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 1'b0;
        op_mem_read = 1'b0;      
        op_mem_write = 1'b0;
        op_halt = 1'b0;
      end
      3'b001: 
      begin
        op_alu_src_a = 2'b10;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_data_for_output_update = 1'b0;
        op_branch = cond_register[3]^cond_register[0];
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 1'b0;
        op_mem_read = 1'b0;
        op_mem_write = 1'b0;
        op_halt = 1'b0;
      end
      3'b010: 
      begin
        op_alu_src_a = 2'b10;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_data_for_output_update = 1'b0;
        op_branch = cond_register[2] || (cond_register[3]^cond_register[0]);
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 1'b0;
        op_mem_read = 1'b0;
        op_mem_write = 1'b0;
        op_halt = 1'b0;
      end
      3'b011: 
      begin
        op_alu_src_a = 2'b10;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_data_for_output_update = 1'b0;
        op_branch = ~cond_register[2];
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 1'b0;
        op_mem_read = 1'b0;
        op_mem_write = 1'b0;
        op_halt = 1'b0;
      end
      default:
      begin
        op_alu_src_a = 2'b00;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_data_for_output_update = 1'b0;
        op_branch = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 1'b0;
        op_mem_read = 1'b0;
        op_mem_write = 1'b0;
        op_halt = 1'b0;
      end 
      endcase
    end
    else begin
      op_alu_src_a = 2'b00;
      op_alu_src_b = 2'b00;
      op_alu = 4'b0000;
      op_data_for_output_update = 1'b0;
      op_branch = 1'b0;
      op_reg_write = 1'b0;
      op_reg_write_address = 1'b0;
      op_mdr = 1'b0;
      op_res = 1'b0;
      op_mem_read = 1'b0;
      op_mem_write = 1'b0;
      op_halt = 1'b0;
    end
  end
endmodule

