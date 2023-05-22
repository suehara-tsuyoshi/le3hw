module stall_unit(
  // ストールするかどうかを判断するのを1phaseとして扱わないので、
  // クロックで同期せず、極力wireだけの回路を組みます
  // input clock,

  input reset,

  // stateは各フェーズのモジュールが挙動を調整してくれるはずと信じて、
  // ここでは導入しない
  // input state,

  // p3で実行中の命令に対するop_mem_read
  input op_mem_read23,  
  
  // p3で実行中の命令に対するデスティネーションレジスタアドレス
  input [2:0] rd23,
  // p1でフェッチされている命令に対するソースレジスタアドレス1
  input [2:0] rd12,
  // p1でフェッチされている命令に対するソースレジスタアドレス2
  input [2:0] rs12,

  // p2でデコード中の命令の分岐が成立する場合にアサート
  input op_branch23,

  // 制御ハザードによってストールするかどうかを決定するための信号線
  // output op_stall_ctrl,
  // データハザードによってストールするかどうかを決定するための信号線
  output op_stall_data);

  
  
  // function should_stall_ctrl;
  //   input op_branch23;

  //   if (reset == 1'b0) begin
  //     should_stall_ctrl = 1'b0;
  //   end
  //   else begin
  //     should_stall_ctrl = op_branch23;
  //   end
  // endfunction


  function should_stall_data;
    input op_mem_read23;
    input rd23;
    input rs12;
    input rd12;

    if (reset == 1'b0) begin
      should_stall_data = 1'b0;
    end
    else begin
      should_stall_data = (op_mem_read23 & ((rd23 == rs12 || rd23 == rd12)));
    end
    
  endfunction
  
  // assign op_stall_ctrl = should_stall_ctrl;
  assign op_stall_data = should_stall_data(op_mem_read23, rd23, rs12, rd12);
  





endmodule