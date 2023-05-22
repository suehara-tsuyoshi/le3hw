module p1_fetch_p4_mem_access (

	// クロック入力
  input clock,
	input reset,

	// 活性化の制御
	input [2:0] phase_counter,

	// branch命令がPCを書き換える必要がある場合に1
	input op_branch,

	// 書き込む場合に1
	input op_mem_write,

	// p1なら0，p4なら1
	input op_mem_src,

	// 分岐命令時の分岐先アドレス&ロードストア命令時のメモリアドレス
	input [15:0] data_register,

	// 書き込む値
	input [15:0] data_for_mem_write,

	// data_for_res
	input [15:0] data_for_res,
	
	output [15:0] program_counter_wire,
	output [15:0] program_counter_pre_wire,
	output [15:0] instruction_register_wire,
	// p1ではIRの値、p4ではMDRの値
	output [15:0] mem_read_data,
	output [15:0] mem_address_out);
	
	

  reg [15:0] program_counter;
	reg [15:0] program_counter_pre;
	reg [15:0] address_for_access;
	reg [15:0] instruction_register;
	reg [15:0] memory_data_register;

	wire [15:0] data_bus;
	wire [15:0] mem_address;

	assign program_counter_wire = program_counter;
	assign program_counter_pre_wire = program_counter_pre;
	assign instruction_register_wire = instruction_register;
	assign mem_address_out = mem_address;
	assign mem_read_data = data_bus;
	
	mux2 #(.WIDTH(16)) mem_address_mux(
		.data1(program_counter),
		.data2(data_register),
		.op(op_mem_src),
		.res(mem_address),
	);
	
	// 主記憶アクセス
	main_memory memory (
		.data(data_for_mem_write), 
		.wren(op_mem_write), 
		.address(mem_address), 
		.clock(clock), 
		.q(data_bus));


	always @(negedge clock) begin
		if( reset == 1'b0 ) begin
			instruction_register <= 16'b0000_0000_0000_0000;
			program_counter_pre <= 16'b0000_0000_0000_0000;
			program_counter <= 16'b0000_0000_0000_0000;		
			address_for_access <= 16'b0000_0000_0000_0000;			
		end 
		else if (phase_counter == 3'b000) begin
			instruction_register <= data_bus;
			program_counter_pre <= program_counter + 1;
		end 
		// p5ならpcを+1
		else if(phase_counter == 3'b100) begin
			// 条件分岐
			if( op_branch == 1'b1) begin
				program_counter <= data_for_res;		
			end 
			else begin
				program_counter <= program_counter_pre;
			end
		end
		else begin
			program_counter_pre <= program_counter_pre;
			program_counter <= program_counter;
			instruction_register <= instruction_register;
		end
	end
	
endmodule