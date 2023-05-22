module simple_test(
	input clock,
  input reset,
	input exec,
	input [15:0] outside_input,

	// 外部出力用セレクタを決定するための数0~7（ロータリスイッチより入力予定）
	input [3:0] select_display,
	
	// state出力用セレクタ,
	output [3:0] selector_state,

	// 外部出力 by LED
	output clock_out, reset_out,

	output wire [7:0] l_out0, l_out1, l_out2, l_out3,
	output wire [7:0] r_out0, r_out1, r_out2, r_out3,
	output  [7:0] selector_out,

	output [7:0] phase_out,
	output [15:0] instruction_register

  );

	//wire [15:0] instruction_register;
	wire [15:0] program_counter;
	wire [15:0] data_register;
	wire [15:0] mem_read_data;
	wire [15:0] data_for_res;
	wire [15:0] r0, r1;
	wire [15:0] data_for_output;
	wire [15:0] register0, register1, register2, register3, register4, register5, register6, register7;

	wire [2:0] phase;
	
	assign selector_state = 4'b0111;

	simple simple(
		//input
		.clock(clock),
		.reset(reset),
		.exec(exec),
		.outside_input(outside_input),

		//output
		.phase(phase),
		.program_counter(program_counter),
		.instruction_register(instruction_register),
		.data_register(data_register),
		.mem_read_data(mem_read_data),
		.data_for_write_out(data_for_res),
		.data_for_output(data_for_output),
		.r0(r0),
		.r1(r1),
		.clock_out(clock_out),
		.reset_out(reset_out),
		.register0(register0),
		.register1(register1),
		.register2(register2),
		.register3(register3),
		.register4(register4),
		.register5(register5),
		.register6(register6),
		.register7(register7), 
	);

	display_for_16bit display_for_16bit(
		.clock(clock), 
		.reset(reset),

		// 出力候補データたち
		.program_counter(program_counter),
		.instruction_register(instruction_register),
		.data_register(data_register),
		.mem_read_data(mem_read_data),
		.r0(r0),
		.r1(r1),
		.data_for_write_out(data_for_res),
		.data_for_output(data_for_output),
		.register0(register0),
		.register1(register1),
		.register2(register2),
		.register3(register3),
		.register4(register4),
		.register5(register5),
		.register6(register6),
		.register7(register7), 


		.selector_in(select_display),

		.l_out0(l_out0),
		.l_out1(l_out1), 
		.l_out2(l_out2), 
		.l_out3(l_out3),

		.r_out0(r_out0), 
		.r_out1(r_out1), 
		.r_out2(r_out2), 
		.r_out3(r_out3),

		.selector_out(selector_out)
	);

	character_display phase_display(
	.num(phase), .out(phase_out)
);
	
	


endmodule
