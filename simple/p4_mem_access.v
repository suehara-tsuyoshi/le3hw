module p4_mem_access(
  // クロック信号
  input clock,
  input reset,
  
  // 状態
  input [2:0] state,

  // データレジスタの値
  input [15:0] data_register,

  // ar
  input [15:0] ar,

  // 外部入力
  input [15:0] outside_input,

  // MDRのセレクタへの制御線
  input op_mdr,

  // 主記憶から読み込むかどうか
  input op_mem_read,

  // 主記憶に書き込むかどうか
  input op_mem_write,

  // MDRに格納する値
  output [15:0] mdr,
  
  output wren_out,
  output [15:0] dfw_out,
  output [15:0] add_out);

  
  reg [15:0] data_for_write = 16'b0000_0000_0000_0000;
  reg wren = 1'b0;
  reg [15:0] address = 16'b0000_0000_0000_0000;
  wire [15:0] data_bus;

  always @(negedge clock) begin
    if(reset == 1'b0) begin
      data_for_write <= 16'b0000_0000_0000_0000;
      address <= 16'b0000_0000_0000_0000;
      wren <= 1'b0;
    end
    else if(state == 3'b100) begin
      if(op_mem_read == 1'b1) begin
        wren <= 1'b0;
        address <= data_register;
      end
      else if(op_mem_write == 1'b1) begin
        data_for_write <= ar;
        wren <= 1'b1;
        address <= data_register;
      end
      else begin
        data_for_write <= 16'b0000_0000_0000_0000;
        address <= address;
        wren <= 1'b0;
      end
    end
    else begin
      data_for_write <= data_for_write;
      address <= address;
      wren <= wren;
    end
  end

  // 主記憶に対する処理
	main_memory memory (
		.data(data_for_write), 
		.wren(wren), 
		.address(address), 
		.clock(clock), 
		.q(data_bus));

  mux2_16bit mdr_mux(
    .data1(outside_input),
    .data2(data_bus),
    .op(op_mdr),
    .res(mdr));
  
  assign wren_out = wren;
  assign dfw_out = data_for_write;
  assign add_out = address;

endmodule