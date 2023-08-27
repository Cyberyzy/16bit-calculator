`timescale 1 ns/ 1 ps
module alu1_tb();
//input
reg [7:0] dataA;
reg [7:0] dataB;
reg [2:0] cs;
reg carry_in;
wire [7:0] result;
wire zero;
wire carry_flag;
alu i2 (
.dataA(dataA),
.dataB(dataB),
.cs(cs),
.carry_in(carry_in),
.result(result),
.zero(zero),
.carry_flag(carry_flag)
);
initial                                                
begin
#20
carry_in=0;
cs=3'b011;
dataA=8'b11111110;
dataB=8'b00000011;
#20
cs=3'b011;
carry_in=1;
dataA=8'b00000000;
dataB=8'b00000000;
#20;
end              
endmodule

