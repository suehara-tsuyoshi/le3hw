module simple(
  input clock,
  input reset,
  input [15:0] outside_input,
  output [15:0] instruciton_register,
  output [15:0] program_counter,
  output [15:0] data_register,
  output [3:0] cond_register,
  output [15:0] mdr,
  output [2:0] state_out,
  output [15:0] r0,
  output [15:0] r1,
  output [15:0] r2,
  output [15:0] r3,
  output [15:0] m0,
  output wren_out,
  output [15:0] dfw,
  output [15:0] add);

  wire [2:0] state;
  wire [15:0] instruction_wire;
  wire [15:0] program_counter_wire;

  // main_memory
  wire wren = 1'b0;
  wire [15:0] data = 16'b0000_0000_0000_0000;
  wire [15:0] address = 16'b0000_0000_0000_0000;
  

  // p1
  wire op_branch;
  wire [15:0] branch_address;

  // p2
  wire [2:0] rs;
  wire [2:0] rd;
  wire [15:0] ar;
  wire [15:0] br;

  // p3
  wire [15:0] data_wire;
  wire [3:0] cond_wire;
  wire [1:0] op_alu_src_a;
  wire [1:0] op_alu_src_b;

  // p4
  wire op_mdr;
  wire op_mem_read;
  wire op_mem_write;
  wire [15:0] mdr_wire;

  // p5
  wire [15:0] data_for_write_wire;
  wire [2:0] address_for_write_wire;
  wire op_mem_to_reg;
  wire op_reg_write;

  control_unit control(
    .clock(clock),
    .reset(reset),
    .instruction_wire(instruction_wire),
    .state(state),

    // p1
    .op_branch(op_branch),
    .branch_address(branch_address),
    
    // p2
    .rs(rs),
    .rd(rd),
    
    // p3
    .data_wire(data_wire),
    .cond_wire(cond_wire),
    .op_alu_src_a(op_alu_src_a),
    .op_alu_src_b(op_alu_src_b),
    
    // p4
    .mdr_wire(mdr_wire),
    .op_mdr(op_mdr),
    .op_mem_read(op_mem_read),
    .op_mem_write(op_mem_write),
    
    // p5
    .op_mem_to_reg(op_mem_to_reg),
    .op_reg_write(op_reg_write));
  

  p1_fetch fetch(
    .clock(clock),
    .reset(reset),
    .state(state),
    .op_branch(op_branch),
    .branch_address(branch_address),
    .instruction_register(instruction_wire),
    .program_counter(program_counter_wire));

  p2_decode decode(
    .clock(clock),
    .reset(reset),
    .state(state),
    .rs(rs),
    .rd(rd),
    .op_reg_write(op_reg_write),
    .data_for_write(data_for_write_wire),
    .address_for_write(address_for_write_wire),
    .ar(ar),
    .br(br),
    .r0_wire(r0),
    .r1_wire(r1),
    .r2_wire(r2),
    .r3_wire(r3));
  
  p3_exec exec(
    .clock(clock),
    .reset(reset),
    .state(state),
    .ar(ar),
    .br(br),
    .program_counter(program_counter_wire),
    .instruction_register(instruction_wire),
    .inp(outside_input),
    .op_alu_src_a(op_alu_src_a),
    .op_alu_src_b(op_alu_src_b),
    .data_register(data_wire),
    .cond(cond_wire));

  p4_mem_access mem_access(
    .clock(clock),
    .reset(reset),
    .state(state),
    .data_register(data_wire),
    .ar(ar),
    .outside_input(outside_input),
    .op_mdr(op_mdr),
    .op_mem_read(op_mem_read),
    .op_mem_write(op_mem_write),
    .mdr(mdr_wire),
    .wren_out(wren_out),
    .dfw_out(dfw),
    .add_out(add));
  
  p5_write_back write_back(
    .data_register(data_wire),
    .memory_data_register(mdr_wire),
    .op_mem_to_reg(op_mem_to_reg),
    .data_for_write(data_for_write_wire));

  main_memory memory(
    .data(data), 
		.wren(wren), 
		.address(address), 
		.clock(clock), 
		.q(m0));

  assign instruciton_register = instruction_wire;
  assign program_counter = program_counter_wire;
  assign data_register = data_wire;
  assign cond_register = cond_wire;
  assign mdr = mdr_wire;
  assign state_out = state;

  
endmodule