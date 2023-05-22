module decode_p2 (
	input clock, 
	input reset,
  input exec,
  input [3:0] cond,
	input op_reg_write_in,
  input op_reg_write_address_in,
  input op_mem_read_ex,
	input [15:0] data_for_write_in,
  input [15:0] instruction_register_in,
  input [2:0] rs_ex,
  input [2:0] rs_in, rd_in,
  input [15:0] program_counter_pre_in,
	output [15:0] ar,
	output [15:0] br,
  output op_pc_write,
  output op_if_id_write,
  output op_id_ex_write,
  output op_if_id_flush,
  output op_branch,
  output [1:0] op_alu_src_a,
  output [1:0] op_alu_src_b,
  output [3:0] op_alu,
  output op_data_for_output_update,
  output op_mem_write,
  output op_mem_read,
  output op_reg_write,
  output op_reg_write_address,
  output op_mdr,
  output op_res,
  output op_cc_write,
  output [2:0] rs, rd,
  output [15:0] branch_address,
  output [15:0] r0,r1,r2,r3,r4,r5,r6,r7);

  wire state;
	wire [2:0] address_for_write;
	wire [3:0] cond_wire;
  wire op_branch_wire;
  wire [1:0] op_alu_src_a_wire;
  wire [1:0] op_alu_src_b_wire;
  wire [3:0] op_alu_wire;
  wire op_data_for_output_update_wire;
  wire op_mem_write_wire;
  wire op_reg_write_wire;
  wire op_reg_write_address_wire;
  wire op_mem_read_wire;
  wire op_mdr_wire;
  wire op_res_wire;
  wire op_halt_wire;
	
  assign branch_address = {{8{instruction_register_in[7]}},instruction_register_in[7:0]} + program_counter_pre_in;
  assign rs = instruction_register_in[13:11];
  assign rd = instruction_register_in[10:8];

	mux2 #(.WIDTH(3)) address_for_write_mux(
		.data1(rd_in),
		.data2(rs_in),
		.op(op_reg_write_address_in),
		.res(address_for_write));


  control_unit control_unit (
    .clock(clock),
    .reset(reset),
    .exec(exec),
    .op1(instruction_register_in[15:14]),
    .op2(instruction_register_in[13:11]),
    .op3(instruction_register_in[7:4]),
    .opcond(instruction_register_in[10:8]),
    .cond(cond),
    .state(state),
    .op_branch(op_branch),
    .op_alu_src_a(op_alu_src_a),
    .op_alu_src_b(op_alu_src_b),
    .op_alu(op_alu),
    .op_data_for_output_update(op_data_for_output_update),
    .op_mem_read(op_mem_read),
    .op_mem_write(op_mem_write),
    .op_reg_write(op_reg_write),
    .op_reg_write_address(op_reg_write_address),
    .op_mdr(op_mdr),
    .op_res(op_res),
    .op_halt(op_halt_wire));
  
  hazard_unit hazard_unit(
    .clock(clock),
    .reset(reset),
    .state(state),
    .op1(instruction_register_in[15:14]),
    .op2(instruction_register_in[13:11]),
    .op_mem_read_ex(op_mem_read_ex),
    .op_branch(op_branch),
    .op_halt(op_halt_wire),
    .rs_id(rs),
    .rd_id(rd),
    .rs_ex(rs_ex),
    .op_pc_write(op_pc_write),
    .op_if_id_write(op_if_id_write),
    .op_id_ex_write(op_id_ex_write),
    .op_if_id_flush(op_if_id_flush),
    .op_cc_write(op_cc_write));

  register_file register_file(
    .clock(~clock),
    .reset(reset),
    .op_reg_write(op_reg_write_in),
    .rs(instruction_register_in[13:11]),
    .rd(instruction_register_in[10:8]),
    .address_for_write(address_for_write),
    .data_for_write(data_for_write_in),
    .ar(ar),
    .br(br),
    .register0(r0),
    .register1(r1),
    .register2(r2),
    .register3(r3),
    .register4(r4),
    .register5(r5),
    .register6(r6),
    .register7(r7));

endmodule


			
		