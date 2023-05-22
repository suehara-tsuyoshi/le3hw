module simple_core(
  input clock,
  input reset,
  input outside_input,
  output [2:0] phase,
  output [15:0] program_counter,
  output [15:0] instruction_register,
  output [15:0] data_register,
  output [3:0] cond_register,
  output [15:0] mem_read_data,
  
  // FPGAテスト用追加分
  output clock_out, reset_out,
  output [15:0] ar_out, br_out,
  output [15:0] data_for_res_out);

  assign phase = phase_counter;
  assign instruction_register = instruction_register_wire;
  assign mem_read_data = mem_read_data_wire;
  assign data_register = data_register_wire;
  assign cond_register = cond_wire;

  // テスト用
  assign clock_out = clock;
  assign reset_out = reset;
  assign ar_out = ar;
  assign br_out = br;
  assign data_for_res_out = data_for_res_wire;

  wire [2:0] phase_counter;
  wire [15:0] instruction_register_wire;
  wire [15:0] program_counter_pre_wire;
  wire [15:0] data_register_wire;
  wire [3:0] cond_wire;
  wire [15:0] mem_read_data_wire;

  wire op_mem_src;
  // p1
  wire op_branch;
  // p2
  wire [15:0] ar,br;
  // p3
  wire [1:0] op_alu_src_a;
  wire [1:0] op_alu_src_b;
  wire [3:0] op_alu;
  // p4
  wire op_mem_write;
  // p5
  wire op_mdr;
  wire op_reg_write;
  wire op_reg_write_address;
  wire op_res;
  wire [15:0] data_for_res_wire;

  control_unit control(
    .clock(clock),
    .reset(reset),
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
    .op_mem_write(op_mem_write),
    .op_mdr(op_mdr),
    .op_reg_write(op_reg_write),
    .op_reg_write_address(op_reg_write_address),
    .op_res(op_res));
  

  p1_fetch_p4_mem_access fetch_mem_access(
    .clock(clock),
    .reset(reset),
    .phase_counter(phase_counter),
    .op_mem_src(op_mem_src),
    .op_branch(op_branch),
    .op_mem_write(op_mem_write),
    .data_register(data_register_wire),
    .data_for_mem_write(ar),
    .data_for_res(data_for_res_wire),
    .program_counter_wire(program_counter),
    .program_counter_pre_wire(program_counter_pre_wire),
    .instruction_register_wire(instruction_register_wire),
    .mem_read_data(mem_read_data_wire),
    .mem_address_out(mem_address));


  p2_decode decode(
    .clock(clock),
    .reset(reset),
    .phase_counter(phase_counter),
    .instruction_register_wire(instruction_register_wire),
    .op_reg_write(op_reg_write),
    .op_reg_write_address(op_reg_write_address),
    .data_for_write(data_for_res_wire),
    .ar(ar),
    .br(br));
  
  p3_exec exec(
    .clock(clock),
    .reset(reset),
    .phase_counter(phase_counter),
    .ar(ar),
    .br(br),
    .program_counter_pre(program_counter_pre_wire),
    .instruction_register(instruction_register_wire),
    .inp(outside_input),
    .op_alu_src_a(op_alu_src_a),
    .op_alu_src_b(op_alu_src_b),
    .op_alu(op_alu),
    .data_register(data_register_wire),
    .cond(cond_wire));
  
  p5_write_back write_back(
    .data_register(data_register_wire),
    .mem_read_data(mem_read_data_wire),
    .outside_input(outside_input),
    .op_res(op_res),
    .data_for_res(data_for_res_wire));


endmodule