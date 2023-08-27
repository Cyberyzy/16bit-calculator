//寄存计算结果
module rom(

input clk, //时钟
input finala,//是否结束运算
input sl,//是否传下八位数
input [7:0] result_data,//计算结果


output reg [15:0] bin_data,//显示结果
output reg [15:0] ans_data
); 


reg [7:0]data_low;//寄存下八位数
reg [7:0]data_high;//寄存上八位数


always @(posedge clk) begin
	if(finala==0)begin
		if (sl == 1) begin                //若尚未结束运算且需要传下八位数
			data_low <= result_data[7:0];
		end
		else if (sl == 0)begin      		//若尚未结束运算且需要传上八位数
			data_high <= result_data[7:0];
		end
		bin_data <= {data_high,data_low}; //将寄存器中的数据传给显示模块
	end
end
always @(posedge clk) begin
		if(bin_data[15] == 1)begin
			ans_data = ~(bin_data - 16'b1);
		end
		else begin
			ans_data = bin_data;
		end
end
endmodule