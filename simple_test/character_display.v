module character_display (
	input [3:0] num,
	output [7:0] out);
	
	
	// 出力outの内容を決定する関数
	function [7:0] out_decider;
		input [3:0] a;
		begin
			case (a)
				0: out_decider = 8'b0111_1110 ;
				1: out_decider = 8'b0011_0000 ;
				2: out_decider = 8'b0110_1101 ;
				3: out_decider = 8'b0111_1001 ;
				
				4: out_decider = 8'b0011_0011 ;
				5: out_decider = 8'b0101_1011 ;
				6: out_decider = 8'b0101_1111 ;
				7: out_decider = 8'b0111_0010 ;
				
				8: out_decider = 8'b0111_1111 ;
				9: out_decider = 8'b0111_1011 ;
				10: out_decider = 8'b0111_0111 ;
				11: out_decider = 8'b0001_1111 ;
				
				12: out_decider = 8'b0100_1110 ;
				13: out_decider = 8'b0011_1101 ;
				14: out_decider = 8'b0100_1111 ;
				15: out_decider = 8'b0100_0111 ;
				
				default : out_decider = 8'b1000_0000 ;
			endcase
		end
	endfunction
	
	
	// 入力をout_deciderに渡す
	assign out = out_decider(num);
	


endmodule
