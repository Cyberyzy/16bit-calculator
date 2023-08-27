module control(	

	input clk,
	input [15:0] key_num, //键盘结果
	input [15:0] ans_num, //计算结果
//	input [15:0] disp_num,


	output reg islow,//是否传下八位数
	output reg isend,//运算是否结束
	output reg [7:0] data_a,
	output reg [7:0] data_b,
	output reg [2:0] sign, //sign大于0时才表示有计算符信号
	output reg store_flag
);

reg [15:0] data1;
reg [15:0] data2;
reg [15:0] regsign; //缓存计算符号
reg [4:0]  state;   //状态机
reg [32:0] cnt1;
reg [15:0] sb;

localparam IDLE         =4'b0_000;// 初始状态
localparam STORE_NUM1   =4'b0_001;// 储存第一个数字
localparam STORE_NUM2   =4'b0_010;// 储存第二个数字
localparam STORE_SIGN   =4'b0_011;// 储存符号位
localparam UP_LOW       =4'b0_101;//传下八位数
localparam UP_HIGH      =4'b0_110;//传上八位数
localparam ENDL         =4'b0_111;//运算结束，送出运算结束标志，接收模块不再更新数据
localparam STORE_RESULT =4'b1_000;//把运算结果存在data1中


//初始化
initial begin
	sign=0;
	islow=0;
	regsign=0;
	state=IDLE;
	cnt1=0;
	isend=1;
end


always @(posedge clk)begin
	//初始状态
	if (state==IDLE)begin
		if (key_num<10'd1000) begin
			state<=STORE_NUM1;
		end
		else if (key_num > 10'd999 && key_num < 10'd1014) state <= STORE_SIGN;
		else state<=IDLE;
	end 
	//跳转到状态1，储存第一个数字
	else if (state==STORE_NUM1)begin
		if(key_num<10'd1000)begin
			data1<=key_num;
		end
		else if (key_num > 10'd999 && key_num < 10'd1014)begin
			state <= STORE_SIGN;
		end 
		else state<=STORE_NUM1;
	end
	//跳转到状态2，储存符号
	else if (state==STORE_SIGN)begin
	   if (key_num > 10'd999 && key_num != 10'd1014) begin
	   		regsign<=key_num-10'd1008;
	   end
		if (key_num<10'd1000) state<=STORE_NUM2;
		else state<=STORE_SIGN;
	end
	//跳转到状态3，储存第二个数字
	else if (state==STORE_NUM2)begin
	if(key_num < 10'd1000)begin
		data2<=key_num;
		isend<=1;//运算结束
		end
		if (key_num>10'd999) state<=UP_LOW;
		else state<=STORE_NUM2;
	end
	//跳转到状态4，传下八位数
	else if (state==UP_LOW)begin
		isend<=0;//运算开始
		islow<=1;
		data_a<=data1[7:0];
		data_b<=data2[7:0];
		sign<=regsign;
		if (cnt1<=20'd500) begin
			cnt1<=cnt1+1;
			state<=UP_LOW;
		end
		else begin
			 state<=UP_HIGH;
			 cnt1<=0;
		end
	end
	//跳转到状态5，传上八位数
	else if (state==UP_HIGH)begin
		islow<=0;
		data_a=data1[15:8];
		data_b=data2[15:8];
		sign<=regsign[2:0];
		if (cnt1<=20'd500) begin
			cnt1<=cnt1+1;
			state<=UP_HIGH;
		end
		else begin
			 state<=ENDL;
			 cnt1<=0;
		end
	end
	//跳转到状态6，运算结束
	else if (state==ENDL)begin
		state<=STORE_RESULT;
//		if(key_num == 10'd1013)begin 
//				if(ans_num[15] == 1) begin
//					data1 <= 0;
//				end
//				else begin
//					data1 <= disp_num;
//				end
//			end
//			else begin 
//				data1 <= disp_num;
//			end
	end 
	//跳转到状态7，储存运算结果
	else if (state==STORE_RESULT)begin
		if (key_num==10'd1014) begin 
				state<=IDLE;
				isend<=1;
				data1 <= ans_num;
				end
		else if (key_num<10'd1014) begin
			state<=STORE_SIGN;
			data1 <= ans_num;
		end
	end
end
endmodule