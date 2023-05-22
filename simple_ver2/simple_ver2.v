module simple_ver2(
  // リセット&クロック
	input reset, clock,
	input [15:0] outside_input,

	// 外部出力用セレクタを決定するための数0~7（ロータリスイッチより入力予定）
	input [3:0] select_display,
	
	// cond, state出力用セレクタ
	output [3:0] selector_cond,
	output [3:0] selector_state,


	
	output [7:0] cond_register_out,
	output [7:0] phase_out,

	// 外部出力 by LED
	output clock_out, reset_out,

	// 外部出力用
	output wire [7:0] l_out0, l_out1, l_out2, l_out3,
	output wire [7:0] r_out0, r_out1, r_out2, r_out3,
	output  [7:0] selector_out);

	wire [2:0] phase;
  wire [15:0] instruction_register;
	wire [15:0] program_counter;
	wire [15:0] data_register;
	wire [3:0] cond_register;
	wire [15:0] mem_read_data_wire;
	wire [15:0] ar_out;
	wire [15:0] br_out;
	wire [15:0] data_for_write_out;

	assign selector_cond = 4'b0111;
	assign selector_state = 4'b1011;

  simple_core simple(
    // input
    .clock(clock),
    .reset(reset),
    .outside_input(outside_input),

    // output
    .phase(phase),
    .program_counter(program_counter),
    .instruction_register(instruction_register),
    .data_register(data_register),
    .cond_register(cond_register),
    .mem_read_data(mem_read_data_wire),
    
    
    // FPGAテスト用追加分output
    .clock_out(clock_out),
    .reset_out(reset_out),
    .ar_out(ar_out),
    .br_out(br_out),
    .data_for_res_out(data_for_res_out)
  );

  display_for_16bit display_for_16bit(
    .clock(clock), 
    .reset(reset),

    // 出力候補データたち
    .instruction_register(instruction_register),
    .program_counter(program_counter),
    .data_register(data_register),
    .mdr(mdr),
    .ar_out(ar_out),
    .br_out(br_out),
    .data_for_write_out(data_for_write_out),

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

  character_display clock_display(
    .num(cond_register), .out(cond_register_out)
  );

  character_display state_display(
    .num(phase), .out(phase_out)
  );


  
endmodule