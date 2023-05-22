module control_unit(
  
  // クロック入力
  input clock,
  input reset,

  // 命令レジスタに格納する値
  input [15:0] instruction_wire,

  // 活性化させるフェーズ
  output reg [2:0] state,

  // p1

  // 条件分岐するか
  output op_branch,
  // 条件分岐するアドレス
  output [15:0] branch_address,
  
  // p2

  // ソースレジスタ・デスティネーションレジスタ
  output [2:0] rs,
  output [2:0] rd,
  
  // p3

  // データレジスタに格納する値
  input [15:0] data_wire,
  // データレジスタの値に対応する条件コード
  input [3:0] cond_wire,

  // alu_src
  output [1:0] op_alu_src_a,
  output [1:0] op_alu_src_b,
  
  // p4

  // メモリデータレジスタに格納する値
  input [15:0] mdr_wire,

  // 各種制御線
  output op_mdr,
  output op_mem_read,
  output op_mem_write,
  
  // p5

  // 書き込みアドレス
  output [2:0] address_for_write,

  // 書き込みに関する制御線
  output op_mem_to_reg,
  output op_reg_write);

  // 各種レジスタ
  reg [15:0] instruction_register;
  reg [2:0] phase_counter;

  reg [15:0] data_register;
  reg [3:0] cond_register;

  reg [15:0] memory_data_register;

  // p1

  function set_op_branch;
    input [15:0] ir;
    begin
      if(ir[15:14] == 2'b10) begin
        if(ir[13:11] == 3'b000 && cond_register[2] == 1'b1) begin
          set_op_branch = 1'b1;
        end
        else if(ir[13:11] == 3'b001 && (cond_register[3]^cond_register[0])) begin
          set_op_branch = 1'b1;
        end
        else if(ir[13:11] == 3'b010 && (cond_register[2] || (cond_register[3]^cond_register[0]))) begin
          set_op_branch = 1'b1;
        end
        else if(ir[13:11] == 3'b011 && cond_register[2] == 1'b0) begin
          set_op_branch = 1'b1;
        end
        else begin
          set_op_branch = 1'b0;
        end
      end
      else begin
        set_op_branch = 1'b0;
      end
    end
    
  endfunction

  assign op_branch = set_op_branch(instruction_register);
  assign branch_address = data_register;

  // p2
  assign rs = instruction_register[13:11];
  assign rd = instruction_register[10:8];

  // p3
  function [1:0] set_op_alu_src_a;
    input [15:0] ir;
    if(ir[15:14]==2'b10) begin
      if(ir[13:11]==3'b000) begin
        set_op_alu_src_a = 2'b01;
      end
      else begin
        set_op_alu_src_a = ir[15:14];
      end
    end
    else begin
      set_op_alu_src_a = ir[15:14];
    end
  endfunction

  function [1:0] set_op_alu_src_b;
    input [15:0] ir;
    if(ir[15:14]==2'b11) begin
      if(ir[7:4]==4'b1000 || ir[7:4]==4'b1001 || ir[7:4]==4'b1010 || ir[7:4]==4'b1011) begin
        set_op_alu_src_b = 2'b01;
      end
      else if(ir[7:4]==4'b1100) begin
        set_op_alu_src_b = 2'b10;
      end
      else begin
        set_op_alu_src_b = 2'b11;
      end
    end
    else begin
      set_op_alu_src_b = 2'b00;
    end
  endfunction

  assign op_alu_src_a = set_op_alu_src_a(instruction_register);
  assign op_alu_src_b = set_op_alu_src_b(instruction_register);

  // p4
  mux4_1bit op_mdr_mux(
    .data1(1'b1),
    .data2(1'b0),
    .data3(1'b0),
    .data4(1'b0),
    .op(instruction_register[15:14]),
    .res(op_mdr));

  mux4_1bit op_mem_read_mux(
    .data1(1'b1),
    .data2(1'b0),
    .data3(1'b0),
    .data4(1'b0),
    .op(instruction_register[15:14]),
    .res(op_mem_read));

  mux4_1bit op_mem_write_mux(
    .data1(1'b0),
    .data2(1'b1),
    .data3(1'b0),
    .data4(1'b0),
    .op(instruction_register[15:14]),
    .res(op_mem_write));    

  // p5
  
  function set_op_mem_to_reg;
  input [15:0] ir;
  begin
    if(ir[15:14] == 2'b00 || {ir[15:14],ir[7:4]} == 6'b111100) begin
      set_op_mem_to_reg = 1'b1;
    end 
    else begin
      set_op_mem_to_reg = 1'b0;
    end
  end
  endfunction

  function set_op_reg_write;
  input [15:0] ir;
  begin
    if(ir[15:14] == 2'b00 || {ir[15:14],ir[7:4]} == 6'b111100 || ir[15:11] == 5'b10000) begin
      set_op_reg_write = 1'b1;
    end 
    else begin
      set_op_reg_write = 1'b0;
    end
  end
  endfunction

  mux2_3bit address_for_write_mux(
    .data1(instruction_register[13:11]),
    .data2(instruction_register[10:8]),
    .op(instruction_register[15]|instruction_register[14]),
    .res(address_for_write));
  
  assign op_mem_to_reg = set_op_mem_to_reg(instruction_register);
  assign op_reg_write = set_op_reg_write(instruction_register);


  always @(posedge clock) begin
    instruction_register <= instruction_wire;
    data_register <= data_wire;
    cond_register <= cond_wire;
    memory_data_register <= mdr_wire;

    if(reset == 1'b0) begin
      instruction_register <= 16'b0000_0000_0000_0000;
      state <= 3'b000;
      phase_counter <= 3'b000;
      data_register <= 16'b0000_0000_0000_0000;
      cond_register <= 4'b0000;
    end
    else begin
      if(phase_counter == 3'b000) begin
        state <= 3'b001;
        phase_counter <= phase_counter + 1;
      end
      else if(phase_counter == 3'b001) begin
        state <= 3'b010;
        phase_counter <= phase_counter + 1;
      end
      else if(phase_counter == 3'b010) begin
        state <= 3'b011;
        phase_counter <= phase_counter + 1;
      end
      else if(phase_counter == 3'b011) begin
        state <= 3'b100;
        phase_counter <= phase_counter + 1;
      end
      else if(phase_counter == 3'b100) begin
        state <= 3'b101;
        phase_counter <= 3'b000;
      end
      else begin
        instruction_register <= 16'b0000_0000_0000_0000;
        state <= 3'b000;
        phase_counter <= 3'b000;
      end
    end
  end

endmodule

