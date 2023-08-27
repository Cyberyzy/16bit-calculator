module recd(
binary,
key_press,
data
);

input [3:0] binary;//键盘输入
input key_press;//键盘按下标志


output reg [15:0] data;//显示结果


reg [3:0] key1=0;//寄存键盘输入_个位
reg [3:0] key2=0;//寄存键盘输入_十位
reg [3:0] key3=0;//寄存键盘输入_百位


always @(negedge key_press) begin
	if(binary < 4'b1010)begin
		key3 = key2;
		key2 = key1;
		key1 = binary;
		data = key3 * 100 + key2 * 10 + key1;
	end
	else begin 
		key1 = 0; 
		key2 = 0; 
		key3 = 0; 
		data = 10'd999 + binary;
	end
end
endmodule