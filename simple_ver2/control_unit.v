module control_unit(

  input clock,
  input reset,

  input [1:0] op1,
  input [2:0] op2,
  input [3:0] op3,
  input [2:0] opcond,
  input [3:0] cond,


  output [2:0] phase,

  output reg op_mem_src,
  // p1
  output reg op_branch,
  // p3
  output reg [1:0] op_alu_src_a,
  output reg [1:0] op_alu_src_b,
  output reg [3:0] op_alu,
  // p4
  output reg op_mem_write,
  // p5
  output reg op_reg_write,
  output reg op_reg_write_address,
  output reg op_mdr,
  output reg [1:0] op_res);

  reg [3:0] cond_register;
  reg [2:0] phase_counter = 3'b100;

  assign phase = phase_counter;

  always @(posedge clock) begin
    if(reset == 1'b0) begin
      phase_counter <= 3'b100;
      cond_register <= 4'b0000;
      op_mem_src <= 1'b0;
      op_mem_write <= 1'b0;
    end
    else begin
      if(phase_counter == 3'b000) begin
        phase_counter <= phase_counter + 1;
        op_mem_src <= 1'b0;
        op_mem_write <= 1'b0;
      end
      else if(phase_counter == 3'b001) begin
        phase_counter <= phase_counter + 1;
        op_mem_src <= 1'b0;
        op_mem_write <= 1'b0;
      end
      else if(phase_counter == 3'b010) begin
        phase_counter <= phase_counter + 1;
        op_mem_src <= 1'b1;
        if(op1 == 2'b01) begin
          op_mem_write <= 1'b1;
        end
        else begin
          op_mem_write <= 1'b0;
        end
      end
      else if(phase_counter == 3'b011) begin
        phase_counter <= phase_counter + 1;
        op_mem_src <= 1'b0;
        op_mem_write <= 1'b0;
      end
      else if(phase_counter == 3'b100) begin
        if(op1 == 2'b11 && op3 == 4'b1111) begin
          phase_counter <= phase_counter;
          op_mem_src <= 1'b0;
          op_mem_write <= 1'b0;
        end
        else begin
          phase_counter <= 3'b000;
          op_mem_src <= 1'b0;
          op_mem_write <= 1'b0;
        end
      end
      else begin
        phase_counter <= 3'b000;
        op_mem_src <= 1'b0;
        op_mem_write <= 1'b0;
      end
    end
  end


  always @* begin
    if(op1 == 2'b11) begin
      // 演算命令
      if(op3[3] == 1'b0) begin
        op_alu_src_a = 2'b00;
        op_alu_src_b = 2'b10;
        op_alu = op3;
        op_branch = 1'b0;
        // op_mem_write = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 2'b00;
      end
      // シフト命令
      else if(op3[3:2] == 2'b10) begin
        op_alu_src_a = 2'b00;
        op_alu_src_b = 2'b01;
        op_alu = op3;
        op_branch = 1'b0;
        // op_mem_write = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 2'b00;
      end
      // in命令
      else if(op3 == 4'b1100) begin
        op_alu_src_a = 2'b01;
        op_alu_src_b = 2'b11;
        op_alu = 4'b0000;
        op_branch = 1'b0;
        // op_mem_write = 1'b0;
        op_reg_write = 1'b1;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b1;
        op_res = 2'b10;
      end
      // out命令
      else if(op3 == 4'b1101) begin
        op_alu_src_a = 2'b00;
        op_alu_src_b = 2'b11;
        op_alu = 4'b0000;
        op_branch = 1'b0;
        // op_mem_write = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 2'b00;
      end
      // hlt命令
      else if(op3 == 4'b1111) begin
        op_alu_src_a = 2'b00;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_branch = 1'b0;
        // op_mem_write = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 2'b00;
      end
      else begin
        op_alu_src_a = 2'bxx;
        op_alu_src_b = 2'bxx;
        op_alu = 4'bxxxx;
        op_branch = 1'bx;
        // op_mem_write = 1'bx;
        op_reg_write = 1'bx;
        op_reg_write_address = 1'bx;
        op_mdr = 1'bx;
        op_res = 2'bxx;
      end
    end
    // ロード命令
    else if(op1 == 2'b00) begin
      op_alu_src_a = 2'b00;
      op_alu_src_b = 2'b00;
      op_alu = 4'b0000;
      op_branch = 1'b0;
      // op_mem_write = 1'b0;
      op_reg_write = 1'b1;
      op_reg_write_address = 1'b1;
      op_mdr = 1'b0;
      op_res = 2'b01;
    end
    // ストア命令
    else if(op1 == 2'b01) begin
      op_alu_src_a = 2'b00;
      op_alu_src_b = 2'b00;
      op_alu = 4'b0000;
      op_branch = 1'b0;
      // op_mem_write = 1'b0;
      op_reg_write = 1'b0;
      op_reg_write_address = 1'b0;
      op_mdr = 1'b0;
      op_res = 2'b00;
    end
    // 即値ロード命令
    else if(op1 == 2'b10 && op2 == 3'b000) begin
      op_alu_src_a = 2'b11;
      op_alu_src_b = 2'b00;
      op_alu = 4'b0000;
      op_branch = 1'b0;
      // op_mem_write = 1'b0;
      op_reg_write = 1'b1;
      op_reg_write_address = 1'b0;
      op_mdr = 1'b0;
      op_res = 2'b00;
    end
    // 無条件分岐命令
    else if(op1 == 2'b10 && op2 == 3'b100) begin
      op_alu_src_a = 2'b10;
      op_alu_src_b = 2'b00;
      op_alu = 4'b0000;
      op_branch = 1'b1;
      // op_mem_write = 1'b0;
      op_reg_write = 1'b0;
      op_reg_write_address = 1'b0;
      op_mdr = 1'b0;
      op_res = 2'b00;
    end 
    // 条件分岐命令
    else if(op1 == 2'b10 && op2 == 3'b111) begin
      case(opcond)
      3'b100: 
      begin
        op_alu_src_a = 2'b10;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_branch = cond_register[2];
        // op_mem_write = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 2'b00;
      end
      3'b101: 
      begin
        op_alu_src_a = 2'b10;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_branch = cond_register[3]^cond_register[0];
        // op_mem_write = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 2'b00;
      end
      3'b110: 
      begin
        op_alu_src_a = 2'b10;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_branch = cond_register[2] || (cond_register[3]^cond_register[0]);
        // op_mem_write = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 2'b00;
      end
      3'b111: 
      begin
        op_alu_src_a = 2'b10;
        op_alu_src_b = 2'b00;
        op_alu = 4'b0000;
        op_branch = ~cond_register[2];
        // op_mem_write = 1'b0;
        op_reg_write = 1'b0;
        op_reg_write_address = 1'b0;
        op_mdr = 1'b0;
        op_res = 2'b00;
      end
      endcase
    end
    else begin
      op_alu_src_a = 2'bxx;
      op_alu_src_b = 2'bxx;
      op_alu = 4'bxxxx;
      op_branch = 1'bx;
      // op_mem_write = 1'bx;
      op_reg_write = 1'bx;
      op_reg_write_address = 1'bx;
      op_mdr = 1'bx;
      op_res = 2'bxx;
    end
  end
endmodule

