module execute_p3(
  
  input clock,
  input reset,
  input [1:0] op_forward_a,
  input [1:0] op_forward_b,
  input [1:0] op_forward_c,
  input [1:0] op_alu_src_a,
  input [1:0] op_alu_src_b,
  input [3:0] op_alu,
  input op_data_for_output_update,
  input [15:0] ar,
  input [15:0] br,
  input [15:0] program_counter_pre,
	input [15:0] instruction_register,
  input [15:0] outside_input,
  input [15:0] data_register_mem,
  input [15:0] data_for_res_wb,
  output reg [15:0] data_for_output,
  output [15:0] data_register_wire,
  output [3:0] cond,
  output [15:0] ar_ex_forward);
  
  wire [15:0] alu_src_a_middle;
  wire [15:0] alu_src_b_middle;
  wire [15:0] alu_src_a;
  wire [15:0] alu_src_b;

  // assign r0_out = ar_ex_forward;
  // assign r1_out = ar;



  mux4 #(.WIDTH(16)) ar_ex_mux(
    .data1(ar),
    .data2(data_register_mem),
    .data3(data_for_res_wb),
    .data4(16'b0000_0000_0000_0000),
    .op(op_forward_c),
    .res(ar_ex_forward));

  mux4 #(.WIDTH(16)) alu_src_middle_mux_a(
    .data1(br),
    .data2(outside_input),
    .data3(program_counter_pre),
    .data4(16'b0000_0000_0000_0000),
    .op(op_alu_src_a),
    .res(alu_src_a_middle));

  mux4 #(.WIDTH(16)) alu_src_mux_a(
    .data1(alu_src_a_middle),
    .data2(data_register_mem),
    .data3(data_for_res_wb),
    .data4(16'b0000_0000_0000_0000),
    .op(op_forward_a),
    .res(alu_src_a));
  
  mux4 #(.WIDTH(16)) alu_src_middle_mux_b(
    .data1({{8{instruction_register[7]}},instruction_register[7:0]}),
    .data2({12'b0000_0000_0000,instruction_register[3:0]}),
    .data3(ar),
    .data4(16'b0000_0000_0000_0000),
    .op(op_alu_src_b),
    .res(alu_src_b_middle));

  mux4 #(.WIDTH(16)) alu_src_mux_b(
    .data1(alu_src_b_middle),
    .data2(data_register_mem),
    .data3(data_for_res_wb),
    .data4(16'b0000_0000_0000_0000),
    .op(op_forward_b),
    .res(alu_src_b));

  alu a(
    .a(alu_src_a),
    .b(alu_src_b),
    .op(op_alu),
    .res(data_register_wire),
    .szcv(cond));

  always @(posedge clock) begin
    if(reset == 1'b0) begin
      data_for_output <= 16'b0000_0000_0000_0000;
    end
    else if(op_data_for_output_update == 1'b1) begin
      data_for_output <= ar;
    end
  end
  


  

endmodule