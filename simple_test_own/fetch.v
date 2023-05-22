module fetch(
  input clock,
  input reset,
  input [2:0] phase_counter,
  input op_branch,  
  input op_halt,
  input [15:0] data_bus,
  input [15:0] data_for_res,
  output [15:0] program_counter_wire,
  output [15:0] program_counter_pre_wire,
  output [15:0] instruction_register_wire,
  output [15:0] clock_counter1,
  output [15:0] clock_counter2);

reg [15:0] program_counter;
reg [15:0] program_counter_pre;
reg [15:0] instruction_register;
reg [31:0] clock_counter;

assign program_counter_wire = program_counter;
assign program_counter_pre_wire = program_counter_pre;
assign instruction_register_wire = instruction_register;
assign clock_counter1 = clock_counter[31:16];
assign clock_counter2 = clock_counter[15:0];

always @(posedge clock) begin
  if( reset == 1'b0 ) begin
    instruction_register <= 16'b1100_0000_0000_0000;
    program_counter_pre <= 16'b0000_0000_0000_0000;
    program_counter <= 16'b0000_0000_0000_0000;			
  end 
  else if ( phase_counter == 3'b001 ) begin
    instruction_register <= data_bus;
    program_counter_pre <= program_counter + 16'b0000_0000_0000_0001;
  end 
  else if( phase_counter == 3'b101) begin
    if( op_branch == 1'b1) begin
      program_counter <= data_for_res;		
    end 
    else begin
      program_counter <= program_counter_pre;
    end
  end
  else begin
    program_counter_pre <= program_counter_pre;
    program_counter <= program_counter;
    instruction_register <= instruction_register;
  end
end

always @(posedge clock) begin
  if(reset == 1'b0) begin
    clock_counter <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;	
  end
  else if(op_halt == 1'b1) begin
    clock_counter <= clock_counter;
  end
  else begin
    clock_counter <= clock_counter + 1;
  end
end

endmodule