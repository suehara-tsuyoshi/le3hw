module countup(
  input clock,
  input clock2,
  input reset,
  output reg [7:0] seg,
  output reg [3:0] sel);

  reg [15:0] led;
  reg [7:0] num;



  always @(posedge clock or negedge reset) begin
    if(reset == 1'b0) begin
      led[15:0] <= 16'b0000000000000000;
    end
    else if (led[3:0] == 4'b1001) begin
      led[3:0] <= 4'b0000;
      if(led[7:4] == 4'b1001) begin
        led[7:4] <= 4'b0000;
        if(led[11:8] == 4'b1001) begin
          led[11:8] <= 4'b0000;
          if(led[15:12] == 4'b1001) begin
            led[15:12] <= 4'b0000;
          end
          else begin
            led[15:12] <= led[15:12] + 1;
          end
        end 
        else begin
          led[11:8] <= led[11:8] + 1;
        end
      end 
      else begin
        led[7:4] <= led[7:4] + 1;
      end
    end
    else begin
      led[3:0] <= led[3:0] + 1;
    end
  end

  function [7:0] decode;
  input [3:0] a;
  begin
    case (a)
    4'b0000: decode = 8'b11111100;
    4'b0001: decode = 8'b01100000;
    4'b0010: decode = 8'b11011010;
    4'b0011: decode = 8'b11110010;
    4'b0100: decode = 8'b01100110;
    4'b0101: decode = 8'b10110110;
    4'b0110: decode = 8'b10111110;
    4'b0111: decode = 8'b11100000;
    4'b1000: decode = 8'b11111110;
    4'b1001: decode = 8'b11110110;
    default: decode = 8'b00000000;
    endcase
  end
  endfunction

  always @(posedge clock2 or negedge reset) begin
    if(reset == 1'b0) begin
      num <= 8'b00000000;
      seg <= decode(led[3:0]);
      sel <= 4'b0000;
    end
    else if(num == 8'b00100000) begin
      seg <= decode(led[3:0]);
      sel <= 4'b1110;
      num <= num + 1;
    end
    else if(num == 8'b01000000) begin
      seg <= decode(led[7:4]);
      sel <= 4'b1101;
      num <= num + 1;
    end
    else if(num == 8'b01100000) begin
      seg <= decode(led[11:8]);
      sel <= 4'b1011;
      num <= num + 1;
    end
    else if(num == 8'b10000000) begin
      seg <= decode(led[15:12]);
      sel <= 4'b0111;
      num = 8'b00000000;
    end
    else begin
      num <= num + 1;
    end
  end
endmodule

