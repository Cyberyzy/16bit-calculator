module selDig(
    input               sys_clk,
    input               sys_rst_n,
    input               seg_en,             //数码管使能，0为关闭，1为打开
    input               seg_sign,           //数码管符号位（负号），0为不显示，1为显示； 
    input [3:0]		    data2,              //百位
    input [3:0]		    data1,	            //十位
    input [3:0]		    data0,              //个位
    input [3:0]         data3,              //千位


    output reg[3:0]     seg_cs,             //数码管的6位片选位，低电平有效
    output reg[7:0]     seg_led             //数码管的数据总线
);

localparam MAX_CNT = 13'd5000;              //数码管5M时钟下1ms所需的最大计数


reg             seg_clk;                    //数码管时钟，5Mhz
reg             flag_1ms;                   //1ms计数完成标志
reg[3:0]        clk_cnt;                    //时钟分频计数器；
reg[19:0]       seg_num;                    //6位数码管的24位BCD码计数器
reg[12:0]       cnt_1ms;                    //1ms的计数器
reg[2:0]        cnt_cs;                     //数码管选位（片选）计数器
reg[3:0]        seg_dip;                    //当前数码管显示的数据  
 

 //五分频，得到1Mhz的时钟，用于驱动数码管
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
       clk_cnt <= 4'd0;
       seg_clk <= 1'b1;
    end
    else begin
        if(clk_cnt < 4'd5/2 -1)begin
            clk_cnt <= clk_cnt + 1'b1;
            seg_clk <= seg_clk;
        end
        else begin
            seg_clk <= ~seg_clk;
            clk_cnt <= 4'd0;
        end
    end  
end

//将24位的2进制数转换位8421BCD码（使用4位二进制数表示1位十进制数）
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) 
        seg_num <= 0;
	else begin
            if(data3) begin     
				seg_num[15:0] <= {data3,data2,data1,data0};
				if(seg_sign)
					seg_num[15:12] <= 4'd11;          
				end
    else begin
            if(data2) begin     //如果百位有数据
				seg_num[11:0] <= {data2,data1,data0};
				if(seg_sign)
					seg_num[15:12] <= 4'd11;     //如果有负号，千位显示负号
				else
					seg_num[15:12] <= 4'd10;     //如果没有负号,千位不显示 
				end
			else begin
				if(data1) begin     //如果十位有数据
					seg_num[7:0] <= {data1,data0};
					seg_num[15:12] <= {3{4'd10}};    //十万位、万位和千位不显示
					if(seg_sign)
						seg_num[11:8] <= 4'd11;     //如果有负号，百位显示负号
					else
						seg_num[11:8] <= 4'd10;     //如果没有负号,百位不显示 
				end
				else begin //如果个位有数据
						seg_num[3:0] <= data0;
						seg_num[15:8] <= {4{4'd10}}; //十万位、万位、千位、百位不显示
						if(seg_sign)
							seg_num[7:4] <= 4'd11;     //如果有负号，十位显示负号
						else
							seg_num[7:4] <= 4'd10;     //如果没有负号,十位不显示 
				end
			end
		 end
		end
	end


//定义一个1ms的定时器
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        cnt_1ms <= 13'd0;
        flag_1ms <= 1'b0;
    end
    else begin
        if(cnt_1ms < MAX_CNT - 1)begin
            cnt_1ms <= cnt_1ms + 1'b1;
            flag_1ms <= 1'b0;
        end
        else begin
            flag_1ms <= 1'b1;
            cnt_1ms <= 13'd0;
        end
    end
end


//cnt_cs片选计数器，根据该计数器的值确定当前要片选显示哪个数码管
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        cnt_cs <= 3'd0;
    else if(flag_1ms) begin
        if(cnt_cs < 3'd4)
            cnt_cs <= cnt_cs + 1'b1;
        else
            cnt_cs <= 3'd0; 
    end
    else
        cnt_cs <= cnt_cs;
end


//根据片选计数器cnt_cs的值，轮流显示各个数码管
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        seg_cs <= 4'b1111;        //关闭数码管
        seg_dip <= 4'd10;           //不显示            
    end
    else begin
        if(seg_en) begin
            case(cnt_cs)
                3'd0:begin
                    seg_cs <= 4'b0111;    //数码管个位显示
                    seg_dip <= seg_num[3:0];
                end
                3'd1:begin
                    seg_cs <= 4'b1011;    //数码管十位显示
                    seg_dip <= seg_num[7:4];
                end
                3'd2:begin
                    seg_cs <= 4'b1101;    //数码管百位显示
                    seg_dip <= seg_num[11:8];
                end
                3'd3:begin
                    seg_cs <= 4'b1110;    //数码管千位显示
                    seg_dip <= seg_num[15:12];
                end
                default: begin
                    seg_cs <= 4'b1111;        //关闭数码管
                    seg_dip <= 4'd10;           //不显示            
                end     
            endcase
        end
        else begin
            seg_cs <= 6'b111111;        //关闭数码管
            seg_dip <= 4'd10;           //不显示            
        end
    end
end


//控制数码管显示数字
always @(posedge seg_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        seg_led <= 8'b11000000;     //显示0
    else begin
        case(seg_dip)
            4'd0: seg_led <= 8'b00000011;
			4'd1: seg_led <= 8'b10011111;
			4'd2: seg_led <= 8'b00100101;
			4'd3: seg_led <= 8'b00001101;
			4'd4: seg_led <= 8'b10011001;
			4'd5: seg_led <= 8'b01001001;
			4'd6: seg_led <= 8'b01000001;
			4'd7: seg_led <= 8'b00011111;
			4'd8: seg_led <= 8'b00000001;
			4'd9: seg_led <= 8'b00001001;
			4'd11: seg_led <= 8'b11111101;// 负号显示
			4'd10:  seg_led <= 8'b11111111;
			default: seg_led <= 8'b11111111;
        endcase
    end 
end	
 endmodule
