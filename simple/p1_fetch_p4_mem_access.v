module p1_fetch_p4_mem_access (

  input clock,
	input reset,
	input [15:0] outside_input,
	input [2:0] phase_counter,
	input op_branch,
	input op_mdr,
	input op_mem_write,
	input op_mem_src,
	input [15:0] data_register,
	input [15:0] data_for_mem_write,
	input [15:0] data_for_res,
	
	output [15:0] program_counter_wire,
	output [15:0] program_counter_pre_wire,
	output [15:0] instruction_register_wire,
	output [15:0] mem_read_data,
	output [15:0] mem_address_out,
	output [15:0] memory_data_register_wire);
	
	

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

	mux2 #(.WIDTH(16)) memory_data_register_mux(
		.data1(data_bus),
		.data2(outside_input),
		.op(op_mdr),
		.res(memory_data_register_wire),
	);
	
	// 主記憶アクセス
	main_memory memory (
		.data(data_for_mem_write), 
		.wren(op_mem_write), 
		.address(mem_address), 
		.clock(~clock), 
		.q(data_bus));


	always @(posedge clock) begin
		if( reset == 1'b0 ) begin
			instruction_register <= 16'b1100_0000_0000_0000;
			program_counter_pre <= 16'b0000_0000_0000_0000;
			program_counter <= 16'b0000_0000_0000_0000;		
			address_for_access <= 16'b0000_0000_0000_0000;	
			memory_data_register <= 16'b0000_0000_0000_0000;		
		end 
		else if (phase_counter == 3'b001) begin
			instruction_register <= data_bus;
			program_counter_pre <= program_counter + 16'b0000_0000_0000_0001;
		end 
		else if(phase_counter == 3'b100) begin
			memory_data_register <= memory_data_register_wire;
		end
		else if(phase_counter == 3'b101) begin
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