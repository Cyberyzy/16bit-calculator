//二选一选择器
module mux1(

input flag,            //是否结束运算
input [15:0]result,    //运算结果
input [15:0]num,       //键盘输入
input clk,             //时钟 

output reg [15:0]disp  //显示结果

);

always @(posedge clk) begin
if(flag)begin
	if(num < 10'd1000)begin //如果键盘输入数字(非运算符)，接受键盘输入
		disp <= num;
	end
end
else begin//运算结束即输出运算结果
	disp <= result;
	end
end
endmodule