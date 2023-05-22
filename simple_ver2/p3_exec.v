module p3_exec(
  
  input clock,
  input reset,
  input [2:0] phase_counter,
  // ar,brの内容
  input [15:0] ar,
  input [15:0] br,

  // プログラムカウンタの内容
  input [15:0] program_counter_pre,

  // 命令レジスタ(IR)の内容
	input [15:0] instruction_register,

  // 外部入力
  input [15:0] inp,

  // alu_src_aの制御線
  input [1:0] op_alu_src_a,

  // alu_src_bの制御線
  input [1:0] op_alu_src_b,

  input [3:0] op_alu,

  // データレジスタに格納する値
  output reg [15:0] data_register,

  // 条件コードレジスタに格納する値
  output [3:0] cond);

  wire [15:0] data_register_wire;

  // aluへの入力
  wire [15:0] alu_src_a;
  wire [15:0] alu_src_b;
  
  // マルチプレクサで選択
  mux4 #(.WIDTH(16)) alu_src_mux_a(
    .data1(br),
    .data2(inp),
    .data3(program_counter_pre),
    .data4(16'b0000_0000_0000_0000),
    .op(op_alu_src_a),
    .res(alu_src_a));

  mux4 #(.WIDTH(16)) alu_src_mux_b(
    .data1({{8{instruction_register[7]}},instruction_register[7:0]}),
    .data2({12'b0000_0000_0000,instruction_register[3:0]}),
    .data3(ar),
    .data4(16'b0000_0000_0000_0000),
    .op(op_alu_src_b),
    .res(alu_src_b));

  // 演算
  alu a(
    .a(alu_src_a),
    .b(alu_src_b),
    .op(op_alu),
    .res(data_register_wire),
    .szcv(cond));

  always @(negedge clock) begin
    if(reset == 1'b0) begin
      data_register <= 16'b0000_0000_0000_0000;
    end
    else if(phase_counter == 3'b010) begin
      data_register <= data_register_wire;
    end
    else begin
      data_register <= data_register;
    end
  end


  

endmodule