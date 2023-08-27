`timescale 1 ns/ 1 ps
module recd_tb();
//input
reg [3:0] binary;
reg key_press;
wire [15:0]data;

recd i2 (
.key_press(key_press),
.binary(binary),
.data(data)
);
initial                                                
begin
key_press =0;
#10
key_press =1;
binary=4'b0010;
#20
key_press=0;
#30
key_press=1;
binary=4'b0001;
#20
key_press=0;
#20;
key_press=1;
binary=4'b1010;
#20
key_press=0;
#20;
end              

endmodule

