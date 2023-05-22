module display_for_16bit (
	input  clock, reset,

	// 出力候補データたち
	input [15:0] instruction_register,
	input [15:0] program_counter,
	input [15:0] data_register,
	input [15:0] mem_read_data,
	input [15:0] data_for_write_out,
	input [15:0] data_for_output,
	input [15:0] r0, r1,
	input [15:0] register0, register1, register2, register3, register4, register5, register6, register7,


	input [3:0] selector_in,

	output wire [7:0] l_out0, l_out1, l_out2, l_out3,
	output wire [7:0] r_out0, r_out1, r_out2, r_out3,
	output reg [7:0] selector_out);
	
	
	
	
//	各7セグメントLEDへの出力を格納するレジスタ
// a0が一の位、a1が十の位、a2が百の位、a4が千の位
	reg [3:0] a0, a1, a2, a3;
	reg [3:0] b0, b1, b2, b3;
	
	
//	各7セグメントLEDに対応する文字表示モジュール
// display0が一の位、display1が十の位、display2が百の位、display3が千の位
	character_display l_display0(.num(a0[3:0]), .out(l_out0));
	character_display l_display1(.num(a1[3:0]), .out(l_out1));
	character_display l_display2(.num(a2[3:0]), .out(l_out2));
	character_display l_display3(.num(a3[3:0]), .out(l_out3));

	character_display r_display0(.num(b0[3:0]), .out(r_out0));
	character_display r_display1(.num(b1[3:0]), .out(r_out1));
	character_display r_display2(.num(b2[3:0]), .out(r_out2));
	character_display r_display3(.num(b3[3:0]), .out(r_out3));

	
	
	always @( negedge clock or negedge reset ) begin
	
		// セレクタ出力の決定
		// selector_in == 0のときA, selector_in == 1 のときB・・・ってかんじです
		case (selector_in)
			0: selector_out <= 8'b1000_0000; 
			1: selector_out <= 8'b0100_0000; 
			2: selector_out <= 8'b0010_0000; 
			3: selector_out <= 8'b0001_0000; 

			4: selector_out <= 8'b0000_1000; 
			5: selector_out <= 8'b0000_0100; 
			6: selector_out <= 8'b0000_0010; 
			7: selector_out <= 8'b0000_0001; 
			default: selector_out <= 8'b0000_0000; 
		endcase
		
		
		// 出力データの決定
		case (selector_in)
			0: begin
					a0 <= instruction_register[3:0];
					a1 <= instruction_register[7:4];
					a2 <= instruction_register[11:8];
					a3 <= instruction_register[15:12];

					b0 <= program_counter[3:0];
					b1 <= program_counter[7:4];
					b2 <= program_counter[11:8];
					b3 <= program_counter[15:12];
				end

			1: begin
					a0 <= data_register[3:0];
					a1 <= data_register[7:4];
					a2 <= data_register[11:8];
					a3 <= data_register[15:12];

					b0 <= mem_read_data[3:0];
					b1 <= mem_read_data[7:4];
					b2 <= mem_read_data[11:8];
					b3 <= mem_read_data[15:12];
				end

			2: begin
					a0 <= r0[3:0];
					a1 <= r0[7:4];
					a2 <= r0[11:8];
					a3 <= r0[15:12];

					b0 <= r1[3:0];
					b1 <= r1[7:4];
					b2 <= r1[11:8];
					b3 <= r1[15:12];
				end

			3: begin
					a0 <= data_for_write_out[3:0];
					a1 <= data_for_write_out[7:4];
					a2 <= data_for_write_out[11:8];
					a3 <= data_for_write_out[15:12];

					b0 <= data_for_output[3:0];
					b1 <= data_for_output[7:4];
					b2 <= data_for_output[11:8];
					b3 <= data_for_output[15:12];
				end

      
			4: begin
					a0 <= register0[3:0];
					a1 <= register0[7:4];
					a2 <= register0[11:8];
					a3 <= register0[15:12];

					b0 <= register1[3:0];
					b1 <= register1[7:4];
					b2 <= register1[11:8];
					b3 <= register1[15:12];
				end
			5: begin
					a0 <= register2[3:0];
					a1 <= register2[7:4];
					a2 <= register2[11:8];
					a3 <= register2[15:12];

					b0 <= register3[3:0];
					b1 <= register3[7:4];
					b2 <= register3[11:8];
					b3 <= register3[15:12];
				end 

			6: begin
					a0 <= register4[3:0];
					a1 <= register4[7:4];
					a2 <= register4[11:8];
					a3 <= register4[15:12];

					b0 <= register5[3:0];
					b1 <= register5[7:4];
					b2 <= register5[11:8];
					b3 <= register5[15:12];
				end 

			7: begin
					a0 <= register6[3:0];
					a1 <= register6[7:4];
					a2 <= register6[11:8];
					a3 <= register6[15:12];

					b0 <= register7[3:0];
					b1 <= register7[7:4];
					b2 <= register7[11:8];
					b3 <= register7[15:12];
				end

			default: 	begin
									a0 <= 4'b1011;
									a1 <= 4'b1010;
									a2 <= 4'b1101;
									a3 <= 4'b0000;

									b0 <= 4'b1011;
									b1 <= 4'b1010;
									b2 <= 4'b1101;
									b3 <= 4'b0000;
								end
			
		endcase
		
		
	end


	

	
	endmodule