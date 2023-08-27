`timescale 1 ns/ 1 ps
module trans_tb();
//input
reg clk;
reg carry_flag;
reg [15:0] bin_data;
reg [2:0] opt_code;
wire [15:0]ans_data;
wire seg_sign;
wire [15:0]disp_data;

trans i2 (
.clk(clk),
.carry_flag(carry_flag),
.bin_data(bin_data),
.seg_sign(seg_sign),
.opt_code(opt_code),
.ans_data(ans_data),
.disp_data(disp_data)
);
initial                                                
begin
clk=0;
carry_flag = 0;
opt_code = 3'b101;
bin_data=16'b1111111111111111;
#20;
bin_data=16'b0000000000001111;
#20;
end              
always #2 clk= ~clk;
endmodule

