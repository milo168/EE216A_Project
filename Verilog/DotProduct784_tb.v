`timescale 1 ns/10ps

module DotProduct784_tb();
reg clk;
reg GlobalReset;
wire[25:0] result;
reg[18:0] A[0:27];
reg[9:0] B[0:27];
integer i;
wire[9:0] i_w;

DotProduct784 DP(.clk(clk),.GlobalReset(GlobalReset),.Pixel0(B[0]),.Pixel1(B[1]),.Pixel2(B[2]),.Pixel3(B[3]),.Pixel4(B[4]),.Pixel5(B[5]),.Pixel6(B[6]),.Pixel7(B[7]),.Pixel8(B[8]),.Pixel9(B[9]),.Pixel10(B[10]),.Pixel11(B[11]),.Pixel12(B[12]),.Pixel13(B[13]),.Pixel14(B[14]),.Pixel15(B[15]),.Pixel16(B[16]),.Pixel17(B[17]),.Pixel18(B[18]),.Pixel19(B[19]),.Pixel20(B[20]),.Pixel21(B[21]),.Pixel22(B[22]),.Pixel23(B[23]),.Pixel24(B[24]),.Pixel25(B[25]),.Pixel26(B[26]),.Pixel27(B[27]),.Weight0(A[0]),.Weight1(A[1]),.Weight2(A[2]),.Weight3(A[3]),.Weight4(A[4]),.Weight5(A[5]),.Weight6(A[6]),.Weight7(A[7]),.Weight8(A[8]),.Weight9(A[9]),.Weight10(A[10]),.Weight11(A[11]),.Weight12(A[12]),.Weight13(A[13]),.Weight14(A[14]),.Weight15(A[15]),.Weight16(A[16]),.Weight17(A[17]),.Weight18(A[18]),.Weight19(A[19]),.Weight20(A[20]),.Weight21(A[21]),.Weight22(A[22]),.Weight23(A[23]),.Weight24(A[24]),.Weight25(A[25]),.Weight26(A[26]),.Weight27(A[27]),.WeightBias(19'b010_0000_0000_0000_0000),.value(result));

parameter halfclock = 1;
parameter fullclock = 2*halfclock;

always #halfclock clk = ~clk;

assign i_w = i;

initial begin
	GlobalReset = 1'b0;
	clk = 1'b1;

	#halfclock;
	#fullclock GlobalReset = 1'b1;

	for(i = 0; i < 784; i = i+1) begin
		A[i%28] = 19'b000_1000_0000_0000_0000;
 		B[i%28] = (i%3+1);
		if(i%4 == 3) begin 
			#fullclock;
		end
	end

	for(i = 0; i < 260; i = i + 1)begin
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

	GlobalReset = 1'b0;
	#fullclock GlobalReset = 1'b1;

	for(i = 0; i < 784; i = i+1) begin
		if(i==0)begin
			A[i] = 19'b000_1010_0001_1001_0110;
			B[i] = 10'b00_0000_0001;
		end else begin
			A[i%28] = 19'b000_0000_0000_0000_0000;
 			B[i%28] = 0;
		end
		if(i%4 == 3) begin 
			#fullclock;
		end
	end

	for(i = 0; i < 260; i = i + 1)begin
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
