`timescale 1 ns/ 1 ps
module rom_tb();
//input
reg clk;
reg finala;
reg rst_n;
reg sl;
reg [7:0]result_data;
wire [15:0] bin_data;
wire seg_sign;

rom i2 (
.clk(clk),
.rst_n(rst_n),
.finala(finala),
.sl(sl),
.result_data(result_data),
.bin_data(bin_data),
.seg_sign(seg_sign)
);
initial                                                
begin
clk=0;
rst_n=0;
finala=0;
sl=1;
result_data = 8'b00000001;
#10;
sl=0;
result_data = 8'b00000001;
#20;
end              
always #2 clk= ~clk;
endmodule

