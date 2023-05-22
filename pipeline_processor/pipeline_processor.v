module pipeline_processor(
  input clock,
  input reset,
  input exec,
  input [15:0] outside_input,
  output [15:0] data_for_output);


  wire op_if_id_write,op_id_ex_write;
  wire op_if_id_flush;

  wire op_branch_id;
  wire op_pc_write;
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
  wire [15:0] br_id,br_ex;
  wire [1:0] op_alu_src_a_id,op_alu_src_a_ex;
  wire [1:0] op_alu_src_b_id,op_alu_src_b_ex;
  wire [3:0] op_alu_id,op_alu_ex;
  wire op_data_for_output_update_id,op_data_for_output_update_ex,op_data_for_input_update_mem;
  wire op_mem_read_id, op_mem_read_ex;
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
    .branch_address(branch_address),
    .program_counter(program_counter_if),
    .program_counter_pre(program_counter_pre_if));

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
    .rs(rs_id),
    .rd(rd_id),
    .branch_address(branch_address));
  
  id_ex id_ex(
    .clock(clock),
    .reset(reset),
    .op_id_ex_write(op_id_ex_write),
    .program_counter_pre_id(program_counter_pre_id),
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
    .ar_ex_forward(ar_ex_forward),
    .r0_out(r0),
    .r1_out(r1));

  ex_mem ex_mem(
    .clock(clock),
    .reset(reset),
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
    .op_mem_write_mem(op_mem_write_mem),
    .op_reg_write_mem(op_reg_write_mem),
    .op_reg_write_address_mem(op_reg_write_address_mem),
    .op_mdr_mem(op_mdr_mem),
    .op_res_mem(op_res_mem),
    .rs_mem(rs_mem),
    .rd_mem(rd_mem),
    .ar_mem(ar_mem),
    .data_register_mem(data_register_mem));
  
  data_memory data_memory(
    .address(data_register_mem - 11'b100_0000_0000),
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