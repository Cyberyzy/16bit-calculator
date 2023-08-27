module BCD(
		input [15:0] binary,//输入二进制数
		output wire [3:0] b,//百位
		output wire [3:0] s,//十位
		output wire [3:0] g,//个位
		output wire [3:0] q//千位
		);
	
    reg [31:0] z;//寄存BCD 码

    always @ (*)
    begin
        z = 32'b0;                           //置 0
        z[15:0] = binary;                     //读入低 8 位
        repeat (16)                            //重复 8 次
        begin
            if(z[19:16]>4)                   //大于 4 就加 3
               z[19:16] = z[19:16] + 2'b11;
            if(z[23:20]>4)
               z[23:20] = z[23:20] + 2'b11;
				if(z[27:24]>4)
               z[27:24] = z[27:24] + 2'b11;
				if(z[31:28]>4)
               z[31:28] = z[31:28] + 2'b11;
            z[31:1] = z[30:0];               //左移一位
			end
		end

   assign b = z[27:24];                     //输出 BCD 码
   assign s = z[23:20];
   assign g = z[19:16];
   assign q = z[31:28];
endmodule
