module flag(
	// 判断是否进位或者借位
	input [2:0]sign,
	input islow,
	input carry_in,
	output reg carry_out,
	output reg led2
);

reg regcarry;//用来缓存
initial begin
	regcarry=0;
	carry_out=0;

end

always @(*)begin
	if (islow==1 && sign==3) begin //加法有进位
		regcarry=carry_in;
		carry_out=0;
	end
	else if (islow==1 && sign==4) begin //减法有借位
		regcarry=carry_in;
		carry_out=0;
	end
	else if (islow==0 && sign==3) begin
		carry_out=regcarry;
	end
	else if (islow==0 && sign==4) begin
		carry_out=regcarry;
	end
	
	if (carry_out==1 && islow==0) begin
		if (sign==3) led2=1;
		else if (sign==4) led2=0;
		else led2=0;
	end
	else if (carry_out==0 && islow==0) begin
		if (sign==3) led2=0;
		else if (sign==4) led2=1;
		else led2=0;
	end
end
endmodule