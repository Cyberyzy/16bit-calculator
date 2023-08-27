//转换模块，处理输入的数据,若为负数，则转换为补码形式，同时将结果输出到数码管和七段数码管
module trans(
	input clk,
	input carry_flag,
	input [15:0]bin_data,
	input [2:0] opt,

	output reg seg_sign,
	output reg [15:0] disp_data,
	output reg [15:0] ans_data
);

reg [15:0] data1;
always @(posedge clk)begin
	data1 = bin_data;
	if(bin_data[15] == 1)begin
		disp_data = ~(data1 - 16'b1);
		seg_sign = 1;
	   ans_data = data1;
	end
	else begin
		disp_data = data1;
		seg_sign = 0;
		ans_data = data1;
	end
	if(opt == 3'b101) begin
		if(bin_data[8] == 1) disp_data = 1;
		else if(bin_data[8] == 0 && bin_data[0] == 1) disp_data = 1;
		else if (bin_data[0] == 0 && bin_data[8] == 0)disp_data = 0;
	end
end
endmodule