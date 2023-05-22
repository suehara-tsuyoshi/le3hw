module p1_fetch (

	// クロック入力
  input clock,
	input reset,

	// 活性化の制御
	input [2:0] state,

	// branch命令がPCを書き換える必要がある場合に1（P5から送られてくるはず）
	input op_branch,

	// 分岐命令時の分岐先アドレス（P5から送られてくるはず）
	input [15:0] branch_address,

	// IRレジスタ
	output reg [15:0] instruction_register,
	output reg [15:0] program_counter);
	
	
	// 各種内部変数
	//reg [15:0] program_counter;
	reg [15:0] data_for_write = 16'b0000_0000_0000_0000;
	wire wren = 1'b0;
	wire [15:0] data_bus;
	
	
	// 主記憶から命令の読み込み
	main_memory memory (
		.data(data_for_write), 
		.wren(wren), 
		.address(program_counter), 
		.clock(clock), 
		.q(data_bus));
	
	always @(negedge clock) begin
		if (reset == 1'b0) begin
			program_counter <= 16'b0000_0000_0000_0000;
			instruction_register <= 16'b0000_0000_0000_0000;
		end 
		else if(state == 3'b001) begin
			// 分岐命令時
			if(op_branch == 1'b1) begin
			  
				instruction_register <= data_bus;
				// # 25
				program_counter <= branch_address;
				
			
			// 分岐しない（平常時）
			end else begin
				instruction_register <= data_bus;
				// # 25
				program_counter <= program_counter + 16'b0000_0000_0000_0001;
				
			end	
		end
		else begin
			program_counter <= program_counter;
			instruction_register <= instruction_register;
		end
	end
	
endmodule