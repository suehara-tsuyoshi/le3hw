module processor(
  input clock,
  input reset,
  input exec,
  input [15:0] outside_input,
  output [15:0] program_counter,
  output [15:0] instruction_register,
  output [15:0] data_register,
  output [15:0] mem_read_data,
  output [15:0] r0,
  output [15:0] r1,
  output [15:0] data_for_write_out,
  output [15:0] data_for_output,
  output clock_out, reset_out,
  output [15:0] register0, register1, register2, register3, register4, register5, register6, register7,
  output [1:0] op_out);


  assign data_for_write_out = data_for_res;
  assign program_counter = program_counter_if;
  assign instruction_register = instruction_register_if;
  assign mem_read_data = memory_data;
  assign data_register = data_register_ex;
  assign clock_out = clock;
  assign reset_out = reset;
  assign op_out = {1'b0,op_cc_write};

  wire op_cc_write;
  wire op_if_id_write,op_id_ex_write,op_ex_mem_write,op_mem_wb_write;
  wire op_if_id_flush;

  wire op_branch_id,op_branch_ex,op_branch_mem,op_branch_wb;
  wire op_pc_write;
  wire [15:0] branch_address_wb;
  wire [15:0] program_counter_if;
  wire [15:0] program_counter_pre_if,program_counter_pre_id,program_counter_pre_ex;
  wire [15:0] instruction_register_if,instruction_register_id,instruction_register_ex;

  wire [3:0] cond_ex;
  wire op_reg_write_id,op_reg_write_ex,op_reg_write_mem,op_reg_write_wb;
  wire op_reg_write_address_id,op_reg_write_address_ex,op_reg_write_address_mem,op_reg_write_address_wb;
  wire [15:0] data_for_write_wb;
  wire [2:0] rs_id,rs_ex,rs_mem,rs_wb;
  wire [2:0] rd_id,rd_ex,rd_mem,rd_wb;
  wire [15:0] ar_id,ar_ex,ar_mem;
  wire [16:0] br_id,br_ex;
  wire [1:0] op_alu_src_a_id,op_alu_src_a_ex;
  wire [1:0] op_alu_src_b_id,op_alu_src_b_ex;
  wire [3:0] op_alu_id,op_alu_ex;
  wire op_data_for_output_update_id,op_data_for_output_update_ex,op_data_for_input_update_mem;
  wire op_mem_read_id,op_mem_read_ex,op_mem_read_mem;
  wire op_mem_write_id,op_mem_write_ex,op_mem_write_mem;
  wire op_mdr_id,op_mdr_ex,op_mdr_mem;
  wire op_res_id,op_res_ex,op_res_mem,op_res_wb;

  wire [15:0] data_register_ex,data_register_mem,data_register_wb;
  wire [1:0] op_forward_a,op_forward_b,op_forward_c;
  wire [15:0] ar_ex_forward;

  wire [15:0] memory_data;
  
  wire [15:0] memory_data_register_mem,memory_data_register_wb;

  wire [15:0] data_for_res;
  wire [15:0] branch_address;



 
  fetch_p1 fetch(
    .clock(clock),
    .reset(reset),
    .op_branch(op_branch_id),
    .op_pc_write(op_pc_write),
    .op_cc_write(op_cc_write),
    .branch_address(branch_address),
    .program_counter(program_counter_if),
    .program_counter_pre(program_counter_pre_if),
    .clock_counter1(r0),
    .clock_counter2(r1));

  instruction_memory instruction_memory(
    .address(program_counter_if),
    .clock(~clock),
    .q(instruction_register_if));

  if_id if_id(
    .clock(clock),
    .reset(reset),
    .op_if_id_write(op_if_id_write),
    .op_if_id_flush(op_if_id_flush),
    .program_counter_pre_if(program_counter_pre_if),
    .instruction_register_if(instruction_register_if),
    .program_counter_pre_id(program_counter_pre_id),
    .instruction_register_id(instruction_register_id));
  
  decode_p2 decode(
    .clock(clock), 
    .reset(reset),
    .exec(exec),
    .instruction_register_in(instruction_register_id),
    .cond(cond_ex),
    .op_reg_write_in(op_reg_write_wb),
    .op_reg_write_address_in(op_reg_write_address_wb),
    .op_mem_read_ex(op_mem_read_ex),
    .data_for_write_in(data_for_res),
    .rs_ex(rs_ex),
    .rs_in(rs_wb), 
    .rd_in(rd_wb),
    .program_counter_pre_in(program_counter_pre_id),
    .ar(ar_id),
    .br(br_id),
    .op_pc_write(op_pc_write),
    .op_if_id_write(op_if_id_write),
    .op_id_ex_write(op_id_ex_write),
    .op_if_id_flush(op_if_id_flush),
    .op_branch(op_branch_id),
    .op_alu_src_a(op_alu_src_a_id),
    .op_alu_src_b(op_alu_src_b_id),
    .op_alu(op_alu_id),
    .op_data_for_output_update(op_data_for_output_update_id),
    .op_mem_write(op_mem_write_id),
    .op_mem_read(op_mem_read_id),
    .op_reg_write(op_reg_write_id),
    .op_reg_write_address(op_reg_write_address_id),
    .op_mdr(op_mdr_id),
    .op_res(op_res_id),
    .op_cc_write(op_cc_write),
    .rs(rs_id),
    .rd(rd_id),
    .r0(register0),
    .r1(register1),
    .r2(register2),
    .r3(register3),
    .r4(register4),
    .r5(register5),
    .r6(register6),
    .r7(register7),
    .branch_address(branch_address));
  
  id_ex id_ex(
    .clock(clock),
    .reset(reset),
    .op_id_ex_write(op_id_ex_write),
    .program_counter_pre_id(program_counter_pre_id),
    .op_branch_id(op_branch_id),
    .op_alu_src_a_id(op_alu_src_a_id),
    .op_alu_src_b_id(op_alu_src_b_id),
    .op_alu_id(op_alu_id),
    .op_data_for_output_update_id(op_data_for_output_update_id),
    .op_mem_write_id(op_mem_write_id),
    .op_mem_read_id(op_mem_read_id),
    .op_reg_write_id(op_reg_write_id),
    .op_reg_write_address_id(op_reg_write_address_id),
    .op_mdr_id(op_mdr_id),
    .op_res_id(op_res_id),
    .rs_id(rs_id), 
    .rd_id(rd_id),
    .ar_id(ar_id),
    .br_id(br_id),
    .instruction_register_id(instruction_register_id),
    .program_counter_pre_ex(program_counter_pre_ex),
    .op_branch_ex(op_branch_ex),
    .op_alu_src_a_ex(op_alu_src_a_ex),
    .op_alu_src_b_ex(op_alu_src_b_ex),
    .op_alu_ex(op_alu_ex),
    .op_data_for_output_update_ex(op_data_for_output_update_ex),
    .op_mem_write_ex(op_mem_write_ex),
    .op_mem_read_ex(op_mem_read_ex),
    .op_reg_write_ex(op_reg_write_ex),
    .op_reg_write_address_ex(op_reg_write_address_ex),
    .op_mdr_ex(op_mdr_ex),
    .op_res_ex(op_res_ex),
    .rs_ex(rs_ex), 
    .rd_ex(rd_ex),
    .ar_ex(ar_ex),
    .br_ex(br_ex),
    .instruction_register_ex(instruction_register_ex));
  
  forwarding_unit forwarding_unit(
    .reset(reset),
    .op_alu_src_a(op_alu_src_a_ex),
    .op_alu_src_b(op_alu_src_b_ex),
    .op_mem_write_ex(op_mem_write_ex),
    .op_reg_write_mem(op_reg_write_mem),
    .op_reg_write_address_mem(op_reg_write_address_mem),
    .op_reg_write_wb(op_reg_write_wb),
    .op_reg_write_address_wb(op_reg_write_address_wb),
    .rs_ex(rs_ex),
    .rd_ex(rd_ex),
    .rs_mem(rs_mem),
    .rd_mem(rd_mem),
    .rs_wb(rs_wb),
    .rd_wb(rd_wb),
    .op_forward_a(op_forward_a),
    .op_forward_b(op_forward_b),
    .op_forward_c(op_forward_c));
  
  
  execute_p3 execute(
    .clock(clock),
    .reset(reset),
    .op_forward_a(op_forward_a),
    .op_forward_b(op_forward_b),
    .op_forward_c(op_forward_c),
    .op_alu_src_a(op_alu_src_a_ex),
    .op_alu_src_b(op_alu_src_b_ex),
    .op_alu(op_alu_ex),
    .op_data_for_output_update(op_data_for_output_update_ex),
    .ar(ar_ex),
    .br(br_ex),
    .program_counter_pre(program_counter_pre_ex),
    .instruction_register(instruction_register_ex),
    .outside_input(outside_input),
    .data_register_mem(data_register_mem),
    .data_for_res_wb(data_for_res),
    .data_for_output(data_for_output),
    .data_register_wire(data_register_ex),
    .cond(cond_ex),
    .ar_ex_forward(ar_ex_forward));

  ex_mem ex_mem(
    .clock(clock),
    .reset(reset),
    .op_ex_mem_write(op_ex_mem_write),
    .op_branch_ex(op_branch_ex),
    .op_mem_write_ex(op_mem_write_ex),
    .op_mem_read_ex(op_mem_read_ex),
    .op_reg_write_ex(op_reg_write_ex),
    .op_reg_write_address_ex(op_reg_write_address_ex),
    .op_mdr_ex(op_mdr_ex),
    .op_res_ex(op_res_ex),
    .rs_ex(rs_ex), 
    .rd_ex(rd_ex),
    .ar_ex(ar_ex_forward),
    .data_register_ex(data_register_ex),
    .op_branch_mem(op_branch_mem),
    .op_mem_write_mem(op_mem_write_mem),
    .op_mem_read_mem(op_mem_read_mem),
    .op_reg_write_mem(op_reg_write_mem),
    .op_reg_write_address_mem(op_reg_write_address_mem),
    .op_mdr_mem(op_mdr_mem),
    .op_res_mem(op_res_mem),
    .rs_mem(rs_mem),
    .rd_mem(rd_mem),
    .ar_mem(ar_mem),
    .data_register_mem(data_register_mem));
  
  data_memory data_memory(
    .address(data_register_mem),
    .clock(~clock),
    .data(ar_mem),
    .wren(op_mem_write_mem),
    .q(memory_data));
  
  mem_access_p4 mem_access(
    .op_mdr(op_mdr_mem),
    .memory_data(memory_data),
    .outside_input(outside_input),
    .memory_data_register_wire(memory_data_register_mem));
  
  mem_wb mem_wb(
    .clock(clock),
    .reset(reset),
    .op_mem_wb_write(op_mem_wb_write),
    .op_reg_write_mem(op_reg_write_mem),
    .op_reg_write_address_mem(op_reg_write_address_mem),
    .op_res_mem(op_res_mem),
    .rs_mem(rs_mem), 
    .rd_mem(rd_mem),
    .data_register_mem(data_register_mem),
    .memory_data_register_mem(memory_data_register_mem),
    .op_reg_write_wb(op_reg_write_wb),
    .op_reg_write_address_wb(op_reg_write_address_wb),
    .op_res_wb(op_res_wb),
    .rs_wb(rs_wb), 
    .rd_wb(rd_wb),
    .data_register_wb(data_register_wb),
    .memory_data_register_wb(memory_data_register_wb));
  
  write_back_p5 write_back(
    .data_register(data_register_wb),
    .memory_data_register(memory_data_register_wb),
    .op_res(op_res_wb),
    .data_for_res(data_for_res));


endmodule