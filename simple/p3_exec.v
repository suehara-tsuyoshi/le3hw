module p3_exec(

  // クロック入力
  input clock,
  input reset,
  input [2:0] state,

  // ar,brの内容
  input [15:0] ar,
  input [15:0] br,

  // プログラムカウンタの内容
  input [15:0] program_counter,

  // 命令レジスタ(IR)の内容
	input [15:0] instruction_register,

  // 外部入力
  input [15:0] inp,

  // alu_src_aの制御線
  input [1:0] op_alu_src_a,

  // alu_src_bの制御線
  input [1:0] op_alu_src_b,

  // データレジスタに格納する値
  output [15:0] data_register,

  // 条件コードレジスタに格納する値
  output [3:0] cond);

  // aluへの入力
  wire [15:0] alu_src_a;
  wire [15:0] alu_src_b;
  wire [3:0] op_alu;
  
  // マルチプレクサで選択
  mux4_4bit op_alu_mux(
    .data1(4'b0000),
    .data2(4'b0000),
    .data3(4'b0000),
    .data4(instruction_register[7:4]),
    .op(instruction_register[15:14]),
    .res(op_alu));

  mux4_16bit alu_src_mux_a(
    .data1(br),
    .data2(16'b0000_0000_0000_0000),
    .data3(program_counter),
    .data4(br),
    .op(op_alu_src_a),
    .res(alu_src_a));

  mux4_16bit alu_src_mux_b(
    .data1({{8{instruction_register[7]}},instruction_register[7:0]}),
    .data2({12'b0000_0000_0000,instruction_register[3:0]}),
    .data3(inp),
    .data4(ar),
    .op(op_alu_src_b),
    .res(alu_src_b));

  // 演算
  alu a(
    .a(alu_src_a),
    .b(alu_src_b),
    .op(op_alu),
    .res(data_register),
    .szcv(cond));

endmodule