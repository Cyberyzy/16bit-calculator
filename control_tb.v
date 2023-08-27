`timescale 1ns/1ps
module control_tb;
	reg clk;
	reg [15:0]key_num;
	reg [15:0]ans_num;
	reg [15:0]disp_num;
	wire islow;
	wire isend;
	wire [7:0]data_a;
	wire [7:0]data_b;
	wire [2:0]sign;
	
	
	initial begin
		clk=0;
		key_num=16'd0;
		ans_num=16'd0;
		
		#100 key_num=16'd255;
				ans_num=16'd1111_1111_1111_1111;
				
		#200 key_num=16'd1011;
				ans_num=16'd1111_1111_1111_1111;
				
		#200 key_num=16'd1;
				ans_num=16'd1111_1111_1111_1111;
		
		#200 key_num=16'd1014;
				ans_num=16'd1111_1111_1111_1111;
		#500
		
		#100 key_num=16'd1;
			ans_num=16'd1111_1111_1111_1111;
				
		#200 key_num=16'd1011;
				ans_num=16'd1111_1111_1111_1111;
				
		#200 key_num=16'd2;
				ans_num=16'd1111_1111_1111_1111;
		
		#200 key_num=16'd1014;
				ans_num=16'd1111_1111_1111_1111;
		#200;
		$finish;
		
	end
	
	always #5 clk=~clk;
	
	control uut(
		.clk(clk),
		.key_num(key_num),
		.ans_num(ans_num),
		.islow(islow),
		.isend(isend),
		.data_a(data_a),
		.data_b(data_b),
		.sign(sign),
		.disp_num(disp_num)
	);

endmodule