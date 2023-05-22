module register_file(
  input clock,
  input reset,
  input op_reg_write,
  input [2:0] rs,rd,
  input [2:0] address_for_write,
  input [15:0] data_for_write,
  output [15:0] ar,
  output [15:0] br,
  output [15:0] register0, register1, register2, register3, register4, register5, register6, register7);

reg [15:0] r0,r1,r2,r3,r4,r5,r6,r7;

assign register0 = r0;
assign register1 = r1;
assign register2 = r2;
assign register3 = r3;
assign register4 = r4;
assign register5 = r5;
assign register6 = r6;
assign register7 = r7;

mux8 #(.WIDTH(16)) ar_mux(
    .data1(r0),
    .data2(r1),
    .data3(r2),
    .data4(r3),
    .data5(r4),
    .data6(r5),
    .data7(r6),
    .data8(r7),
    .op(rs),
    .res(ar));

mux8 #(.WIDTH(16)) br_mux(
    .data1(r0),
    .data2(r1),
    .data3(r2),
    .data4(r3),
    .data5(r4),
    .data6(r5),
    .data7(r6),
    .data8(r7),
    .op(rd),
    .res(br));

// レジスタ読み書き部分
// クロック前半で書き込み、後半で読み出しを行う

always @(posedge clock) begin
  if(reset == 1'b0) begin
    r0 <= 16'b0000_0000_0000_0000;
    r1 <= 16'b0000_0000_0000_0000;
    r2 <= 16'b0000_0000_0000_0000;
    r3 <= 16'b0000_0000_0000_0000;
    r4 <= 16'b0000_0000_0000_0000;
    r5 <= 16'b0000_0000_0000_0000;
    r6 <= 16'b0000_0000_0000_0000;
    r7 <= 16'b0000_0000_0000_0000;	
  end 
  else if(op_reg_write == 1'b1) begin
    case (address_for_write)
        3'b000: r0 <= data_for_write;
        3'b001: r1 <= data_for_write;
        3'b010: r2 <= data_for_write;
        3'b011: r3 <= data_for_write;						
        3'b100: r4 <= data_for_write;
        3'b101: r5 <= data_for_write;
        3'b110: r6 <= data_for_write;
        3'b111: r7 <= data_for_write;
        default: begin
                r0 <= r0;
                r1 <= r1;
                r2 <= r2;
                r3 <= r3;								
                r4 <= r4;
                r5 <= r5;
                r6 <= r6;
                r7 <= r7;	
              end
      endcase
  end
end

endmodule