`timescale 1 ns/10ps

module test_tb();
reg clk;
reg GlobalReset;
wire[25:0] result;
reg[14895:0] A;
reg[7839:0] B;
integer i;
wire[9:0] i_w;

test testGenerator(.clk(clk),.GlobalReset(GlobalReset),.Pixels(B),.Weights(A),.value(result));

parameter halfclock = 1;
parameter fullclock = 2*halfclock;

always #halfclock clk = ~clk;

assign i_w = i;

initial begin
	GlobalReset = 1'b1;
	clk = 1'b1;

	#halfclock;
	#fullclock GlobalReset = 1'b0;

	for(i = 0; i < 784; i = i+1) begin
		A[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
 		B[i*10 +: 10] = i%2;
	end

	for(i = 0; i < 810; i = i + 1)begin
		#fullclock;
	end

	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[25], result[24], result[23], result[22],
		result[21], result[20], result[19], result[18],
		result[17], result[16], result[15], result[14],
		result[13], result[12], result[11], result[10],
		result[9], result[8], result[7], result[6],
		result[5], result[4], result[3], result[2], result[1],
		result[0], result[25:18]);

	$stop;
end
endmodule
