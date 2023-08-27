module flag(

	input [2:0]sign,//运算符
	input islow,//是否传下八位数
	input carry_in,//进位标志


	output reg carry_out,//进位标志
	output reg led2//进位灯
);

reg regcarry;//寄存进位标志

// 初始化
initial begin
	regcarry = 0;
	carry_out = 0;
end

always @(*)begin
	if (islow == 1 && sign == 3'b011) begin //加法有进位
		regcarry = carry_in;
		carry_out = 0;
	end
	else if (islow == 1 && sign == 3'b100) begin //减法有借位
		regcarry = carry_in;
		carry_out = 0;
	end
	else if (islow == 0 && sign == 3'b011) begin//加法且尚未运算结束
		carry_out=regcarry;
	end
	else if (islow == 0 && sign == 3'b100) begin//减法且尚未运算结束
		carry_out = regcarry;
	end
	if (carry_out == 1 && islow == 0) begin //进位灯
		if (sign == 3'b011) begin
			led2 = 1;			
		end
		else if (sign == 3'b100) begin
			led2 = 0;
		end
		else begin
			led2 = 0;
		end
	end
	else if (carry_out == 0 && islow == 0) begin//借位灯
		if (sign == 3'b011) begin
			led2 = 0;
		end
		else if (sign == 3'b100) begin
			led2 = 1;
		end
		else begin
			led2 = 0;			
		end

	end
end
endmodule