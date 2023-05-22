module fetch_p1(
  input clock,
  input reset,
  input op_branch,
  input op_pc_write,
  input op_cc_write,
  input [15:0] branch_address,
  output reg [15:0] program_counter,
  output [15:0] program_counter_pre,
  // output [15:0] clock_counter1,
  output [15:0] clock_counter2);

wire [15:0] program_counter_wire;
reg [31:0] clock_counter = 32'b0000_0000_0000_0000_0000_0000_0000_0000;

assign program_counter_pre = program_counter + 16'b0000_0000_0000_0001;
// assign clock_counter1 = clock_counter[31:16];
assign clock_counter2 = clock_counter[15:0];

mux2 #(.WIDTH(16)) address_for_write_mux(
  .data1(program_counter_pre),
  .data2(branch_address),
  .op(op_branch),
  .res(program_counter_wire));

always @(posedge clock) begin
  if(reset == 1'b0) begin
    program_counter <= 16'b0000_0000_0000_0000;
  end
  else if(op_pc_write == 1'b1) begin
    program_counter <= program_counter_wire;
  end
  else begin
    program_counter <= program_counter;
  end
end

always @(posedge clock) begin
  if(reset == 1'b0) begin
    clock_counter <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
  end
  else if(op_cc_write == 1'b0) begin
    clock_counter <= clock_counter;
  end
  else begin
    clock_counter <= clock_counter + 1;
  end 
end
endmodule