module p2_decode (

	// クロックとリセット
	input clock, 
	input reset,

	// 活性化の制御
	input [2:0] state,

	// 命令レジスタ(IR)の内容
	input [2:0] rs,
	input [2:0] rd,
	
	// 書き込みに関する制御線. regWrite == 1で書き込み
	input op_reg_write,
	input [15:0] data_for_write,
	input [2:0] address_for_write,
	
	// 出力レジスタ
	output reg [15:0] ar,
	output reg [15:0] br,
	
	output [15:0] r0_wire,r1_wire,r2_wire,r3_wire);
	
	
	// 内部変数
	// レジスタ0~7の定義
	reg [15:0] r0, r1, r2, r3, r4, r5, r6, r7;

	
		
		
	
	
	
	
	// clock　アサートで書き込み
	// clock ネゲートで読み出し
	// というイメージで作ってみたが、実際そううまく動いてくれるのか？
	// 順番に実行しているだけ
	always @(negedge clock) begin
		
		if( reset == 1'b0 ) begin
			r0 <= 16'b0000_0000_0000_0000;
			r1 <= 16'b0000_0000_0000_0000;
			r2 <= 16'b0000_0000_0000_0000;
			r3 <= 16'b0000_0000_0000_0000;
			r4 <= 16'b0000_0000_0000_0000;
			r5 <= 16'b0000_0000_0000_0000;
			r6 <= 16'b0000_0000_0000_0000;
			r7 <= 16'b0000_0000_0000_0000;	

			ar <= 16'b0000_0000_0000_0000;
			br <= 16'b0000_0000_0000_0000;
		end 
		else if(state == 3'b010) begin
			begin
				case (rs)
					3'b000: ar <= r0;
					3'b001: ar <= r1;
					3'b010: ar <= r2;
					3'b011: ar <= r3;
					
					3'b100: ar <= r4;
					3'b101: ar <= r5;
					3'b110: ar <= r6;
					3'b111: ar <= r7;
					
					default: ar <= 16'b0000_0000_0000_0000;
				endcase
			end
			
			begin
				case (rd)
					3'b000: br <= r0;
					3'b001: br <= r1;
					3'b010: br <= r2;
					3'b011: br <= r3;
					
					3'b100: br <= r4;
					3'b101: br <= r5;
					3'b110: br <= r6;
					3'b111: br <= r7;
					
					default: br <= 16'b0000_0000_0000_0000;
				endcase
			end
		end 
		else if(state == 3'b101) begin
			if(op_reg_write == 1'b1) begin
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
		else begin
				r0 <= r0;
				r1 <= r1;
				r2 <= r2;
				r3 <= r3;
				
				r4 <= r4;
				r5 <= r5;
				r6 <= r6;
				r7 <= r7;			
		end
	end

	assign r0_wire = r0;
	assign r1_wire = r1;
	assign r2_wire = r2;
	assign r3_wire = r3;
	
endmodule


			
		