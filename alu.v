module alu (

    dataA,
    dataB,
    cs,
    carry_in,
    result,
    zero,
    carry_flag

);

    input [7:0] dataA;//数字1
    input [7:0] dataB;//数字2
    input [2:0] cs;//运算符
    input carry_in;//进位标志

    output reg [7:0] result;//结果
    output reg zero;//零标志
    output reg carry_flag;//进位标志


    reg [8:0]	carry_temp;			//最高位为进位
    // 001:add;
    // 010:sub;
    // 011:and;
    // 100:or;
    // 101:compare;
    always @(*) begin
        case (cs)   
        //add   10'd1011
           3'b011 : begin
            result = dataA + dataB + carry_in;
            carry_temp = {1'b0,dataA} + {1'b0,dataB} + carry_in;
            carry_flag = carry_temp[8];
				zero = 0;
				if(result == 0)
				zero = 1;
           end
        //sub   10'd1012
           3'b100 : begin
            result = dataA - dataB-carry_in;
            carry_temp = {1'b0,dataA} - {1'b0,dataB} - carry_in;
            carry_flag = carry_temp[8];
				if(result==0)
					zero = 1;
				else zero=0;
           end
        //and     10'd1009
           3'b001 :begin result = dataA & dataB; carry_flag=1'b0; zero=0; end
        //or      10'd1010
           3'b010 :begin result = dataA | dataB; carry_flag=1'b0; zero=0; end
        //compare 10'd1013
           3'b101 : begin
            result = (dataA>dataB)?8'd1:8'd0;
				carry_flag=1'b0;
				zero =0;
           end
        endcase
    end
endmodule