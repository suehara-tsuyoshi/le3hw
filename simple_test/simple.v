module simple(
  input clock,
  input reset,
  input exec,
  input [15:0] outside_input,
  output [2:0] phase,
  output [15:0] program_counter,
  output [15:0] instruction_register,
  output [15:0] data_register,
  output [15:0] mem_read_data,
  output [15:0] r0,
  output [15:0] r1,
  output [15:0] data_for_write_out,
  output [15:0] data_for_output,
  output clock_out, reset_out,
  output [15:0] register0, register1, register2, register3, register4, register5, register6, register7);

  assign data_for_write_out = data_for_res;
  assign phase = phase_counter;
  assign program_counter = program_counter_wire;
  assign instruction_register = instruction_register_wire;
  assign mem_read_data = data_bus;
  assign data_register = data_register_wire;
  assign clock_out = clock;
  assign reset_out = reset;

  wire [15:0] data_bus;
  wire [15:0] mem_address;
  wire [15:0] ar,br;

  wire [2:0] phase_counter;
  wire [15:0] instruction_register_wire;
  wire [15:0] program_counter_wire;
  wire [15:0] program_counter_pre_wire;
  wire [15:0] data_register_wire;
  wire [3:0] cond_wire;
  wire [15:0] memory_data_register_wire;
  wire [15:0] data_for_res;

  wire op_mem_src;
  wire op_branch;
  wire [1:0] op_alu_src_a;
  wire [1:0] op_alu_src_b;
  wire [3:0] op_alu;
  wire op_data_for_output_update;
  wire op_mem_write;
  wire op_mdr;
  wire op_reg_write;
  wire op_reg_write_address;
  wire op_res;

  mux2 #(.WIDTH(16)) mem_address_mux(
		.data1(program_counter_wire),
		.data2(data_register_wire),
		.op(op_mem_src),
		.res(mem_address));

  main_memory main_memory (
		.data(ar), 
		.wren(op_mem_write), 
		.address(mem_address), 
		.clock(~clock), 
		.q(data_bus));

  control_unit control_unit (
    .clock(clock),
    .reset(reset),
    .exec(exec),
    .op1(instruction_register_wire[15:14]),
    .op2(instruction_register_wire[13:11]),
    .op3(instruction_register_wire[7:4]),
    .opcond(instruction_register_wire[10:8]),
    .cond(cond_wire),
    .phase(phase_counter),
    .op_mem_src(op_mem_src),
    .op_branch(op_branch),
    .op_alu_src_a(op_alu_src_a),
    .op_alu_src_b(op_alu_src_b),
    .op_alu(op_alu),
    .op_data_for_output_update(op_data_for_output_update),
    .op_mem_write(op_mem_write),
    .op_mdr(op_mdr),
    .op_reg_write(op_reg_write),
    .op_reg_write_address(op_reg_write_address),
    .op_res(op_res));

  fetch fetch (
    .clock(clock),
    .reset(reset),
    .phase_counter(phase_counter),
    .op_branch(op_branch),
    .data_bus(data_bus),
    .data_for_res(data_for_res),
    .program_counter_wire(program_counter_wire),
    .program_counter_pre_wire(program_counter_pre_wire),
    .instruction_register_wire(instruction_register_wire),
    .clock_counter2(r1));

  reg_access reg_access (
    .clock(clock),
    .reset(reset),
    .phase_counter(phase_counter),
    .op_reg_write(op_reg_write),
    .op_reg_write_address(op_reg_write_address),
    .instruction_register_wire(instruction_register_wire),
    .data_for_write(data_for_res),
    .ar(ar),
    .br(br),
    .r0(register0),
    .r1(register1),
    .r2(register2),
    .r3(register3),
    .r4(register4),
    .r5(register5),
    .r6(register6),
    .r7(register7));
  
  execute execute (
    .clock(clock),
    .reset(reset),
    .phase_counter(phase_counter),
    .ar(ar),
    .br(br),
    .program_counter_pre(program_counter_pre_wire),
    .instruction_register(instruction_register_wire),
    .outside_input(outside_input),
    .op_alu_src_a(op_alu_src_a),
    .op_alu_src_b(op_alu_src_b),
    .op_alu(op_alu),
    .op_data_for_output_update(op_data_for_output_update),
    .data_for_output(r0),
    .data_register_wire(data_register_wire),
    .cond(cond_wire));

  mem_access mem_access (
    .clock(clock),
    .reset(reset),
    .phase_counter(phase_counter),
    .op_mdr(op_mdr),
    .data_bus(data_bus),
    .outside_input(outside_input),
    .memory_data_register_wire(memory_data_register_wire));
  
  write_back write_back (
    .data_register(data_register_wire),
    .memory_data_register(memory_data_register_wire),
    .op_res(op_res),
    .data_for_res(data_for_res));

endmodule