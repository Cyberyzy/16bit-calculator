`timescale 1 ns/ 1 ps
module bcd_tb();
//input
				 reg [15:0] binary;
//output
		       wire [3:0] g;
				 wire [3:0] s;
				 wire [3:0] b;
				 wire [3:0] q;
                         
BCD i2 (
.binary(binary),
.g(g),
.s(s),
.b(b),
.q(q)
);
initial                                                
begin    	
#20 
binary = 16'b0000_0001_0000_0001;//1+16+128=135
#200
binary = 16'b0000000000001111;//1+16+128=135
#200;
end                                                                                      
endmodule

