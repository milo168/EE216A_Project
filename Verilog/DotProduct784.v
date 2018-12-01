module DotProduct784
#(parameter PIXEL_N = 28,
parameter WEIGHT_SIZE = 19,
parameter PIXEL_SIZE = 10)
(
input clk,
input GlobalReset,
input [9:0] Pixel0,
input [9:0] Pixel1,
input [9:0] Pixel2,
input [9:0] Pixel3,
input [9:0] Pixel4,
input [9:0] Pixel5,
input [9:0] Pixel6,
input [9:0] Pixel7,
input [9:0] Pixel8,
input [9:0] Pixel9,
input [9:0] Pixel10,
input [9:0] Pixel11,
input [9:0] Pixel12,
input [9:0] Pixel13,
input [9:0] Pixel14,
input [9:0] Pixel15,
input [9:0] Pixel16,
input [9:0] Pixel17,
input [9:0] Pixel18,
input [9:0] Pixel19,
input [9:0] Pixel20,
input [9:0] Pixel21,
input [9:0] Pixel22,
input [9:0] Pixel23,
input [9:0] Pixel24,
input [9:0] Pixel25,
input [9:0] Pixel26,
input [9:0] Pixel27,
input [18:0] Weight0,
input [18:0] Weight1,
input [18:0] Weight2,
input [18:0] Weight3,
input [18:0] Weight4,
input [18:0] Weight5,
input [18:0] Weight6,
input [18:0] Weight7,
input [18:0] Weight8,
input [18:0] Weight9,
input [18:0] Weight10,
input [18:0] Weight11,
input [18:0] Weight12,
input [18:0] Weight13,
input [18:0] Weight14,
input [18:0] Weight15,
input [18:0] Weight16,
input [18:0] Weight17,
input [18:0] Weight18,
input [18:0] Weight19,
input [18:0] Weight20,
input [18:0] Weight21,
input [18:0] Weight22,
input [18:0] Weight23,
input [18:0] Weight24,
input [18:0] Weight25,
input [18:0] Weight26,
input [18:0] Weight27,
input [18:0] WeightBias,
output [25:0] value
);

wire[18:0] A [0:27];
wire[9:0] B [0:27];
reg[18:0] A1;
reg[18:0] A2;
reg[18:0] A3;
reg[18:0] A4;
reg[9:0] B1;
reg[9:0] B2;
reg[9:0] B3;
reg[9:0] B4;
reg[25:0] biasWeight;
wire[25:0] FPMAns1;
wire[25:0] FPMAns2;
wire[25:0] FPMAns3;
wire[25:0] FPMAns4;
wire[25:0] FPAAns1;
wire[25:0] FPAAns2;
wire[25:0] FPAAns3;
reg[25:0] addAns [0:195];
reg[25:0] addInput [0:3];
reg[31:0] switchCounter;
assign value = addAns[0];

assign A[0] = Weight0;
assign A[1] = Weight1;
assign A[2] = Weight2;
assign A[3] = Weight3;
assign A[4] = Weight4;
assign A[5] = Weight5;
assign A[6] = Weight6;
assign A[7] = Weight7;
assign A[8] = Weight8;
assign A[9] = Weight9;
assign A[10] = Weight10;
assign A[11] = Weight11;
assign A[12] = Weight12;
assign A[13] = Weight13;
assign A[14] = Weight14;
assign A[15] = Weight15;
assign A[16] = Weight16;
assign A[17] = Weight17;
assign A[18] = Weight18;
assign A[19] = Weight19;
assign A[20] = Weight20;
assign A[21] = Weight21;
assign A[22] = Weight22;
assign A[23] = Weight23;
assign A[24] = Weight24;
assign A[25] = Weight25;
assign A[26] = Weight26;
assign A[27] = Weight27;
assign B[0] = Pixel0;
assign B[1] = Pixel1;
assign B[2] = Pixel2;
assign B[3] = Pixel3;
assign B[4] = Pixel4;
assign B[5] = Pixel5;
assign B[6] = Pixel6;
assign B[7] = Pixel7;
assign B[8] = Pixel8;
assign B[9] = Pixel9;
assign B[10] = Pixel10;
assign B[11] = Pixel11;
assign B[12] = Pixel12;
assign B[13] = Pixel13;
assign B[14] = Pixel14;
assign B[15] = Pixel15;
assign B[16] = Pixel16;
assign B[17] = Pixel17;
assign B[18] = Pixel18;
assign B[19] = Pixel19;
assign B[20] = Pixel20;
assign B[21] = Pixel21;
assign B[22] = Pixel22;
assign B[23] = Pixel23;
assign B[24] = Pixel24;
assign B[25] = Pixel25;
assign B[26] = Pixel26;
assign B[27] = Pixel27;

FixedPointMultiplier FPM1(.clk(clk),.GlobalReset(~GlobalReset),.WeightPort(A1),.PixelPort(B1),.Output_syn(FPMAns1));
FixedPointMultiplier FPM2(.clk(clk),.GlobalReset(~GlobalReset),.WeightPort(A2),.PixelPort(B2),.Output_syn(FPMAns2));
FixedPointMultiplier FPM3(.clk(clk),.GlobalReset(~GlobalReset),.WeightPort(A3),.PixelPort(B3),.Output_syn(FPMAns3));
FixedPointMultiplier FPM4(.clk(clk),.GlobalReset(~GlobalReset),.WeightPort(A4),.PixelPort(B4),.Output_syn(FPMAns4));
FixedPointAdder FPA1(.clk(clk),.GlobalReset(~GlobalReset),.Port2(addInput[1]),.Port1(addInput[0]),.Output_syn(FPAAns1));
FixedPointAdder FPA2(.clk(clk),.GlobalReset(~GlobalReset),.Port2(addInput[3]),.Port1(addInput[2]),.Output_syn(FPAAns2));
FixedPointAdder FPA3(.clk(clk),.GlobalReset(~GlobalReset),.Port2(FPAAns2),.Port1(FPAAns1),.Output_syn(FPAAns3));

always@(posedge clk)begin
	if(GlobalReset == 1'b0)begin
		A1 <= A[0];
		A2 <= A[1];
		A3 <= A[2];
		A4 <= A[3];
		B1 <= B[0];
		B2 <= B[1];
		B2 <= B[2];
		B2 <= B[3];
		biasWeight <= {{(7){WeightBias[18]}},WeightBias};
		addInput[0] <= 26'd0;
		addInput[1] <= 26'd0;
		addInput[2] <= 26'd0;
		addInput[3] <= 26'd0;
		switchCounter <= 32'd0;
		addAns[0] <= 26'd0;
		addAns[1] <= 26'd0;
		addAns[2] <= 26'd0;
		addAns[3] <= 26'd0;
		addAns[4] <= 26'd0;
		addAns[5] <= 26'd0;
		addAns[6] <= 26'd0;
		addAns[7] <= 26'd0;
		addAns[8] <= 26'd0;
		addAns[9] <= 26'd0;
		addAns[10] <= 26'd0;
		addAns[11] <= 26'd0;
		addAns[12] <= 26'd0;
		addAns[13] <= 26'd0;
		addAns[14] <= 26'd0;
		addAns[15] <= 26'd0;
		addAns[16] <= 26'd0;
		addAns[17] <= 26'd0;
		addAns[18] <= 26'd0;
		addAns[19] <= 26'd0;
		addAns[20] <= 26'd0;
		addAns[21] <= 26'd0;
		addAns[22] <= 26'd0;
		addAns[23] <= 26'd0;
		addAns[24] <= 26'd0;
		addAns[25] <= 26'd0;
		addAns[26] <= 26'd0;
		addAns[27] <= 26'd0;
		addAns[28] <= 26'd0;
		addAns[29] <= 26'd0;
		addAns[30] <= 26'd0;
		addAns[31] <= 26'd0;
		addAns[32] <= 26'd0;
		addAns[33] <= 26'd0;
		addAns[34] <= 26'd0;
		addAns[35] <= 26'd0;
		addAns[36] <= 26'd0;
		addAns[37] <= 26'd0;
		addAns[38] <= 26'd0;
		addAns[39] <= 26'd0;
		addAns[40] <= 26'd0;
		addAns[41] <= 26'd0;
		addAns[42] <= 26'd0;
		addAns[43] <= 26'd0;
		addAns[44] <= 26'd0;
		addAns[45] <= 26'd0;
		addAns[46] <= 26'd0;
		addAns[47] <= 26'd0;
		addAns[48] <= 26'd0;
		addAns[49] <= 26'd0;
		addAns[50] <= 26'd0;
		addAns[51] <= 26'd0;
		addAns[52] <= 26'd0;
		addAns[53] <= 26'd0;
		addAns[54] <= 26'd0;
		addAns[55] <= 26'd0;
		addAns[56] <= 26'd0;
		addAns[57] <= 26'd0;
		addAns[58] <= 26'd0;
		addAns[59] <= 26'd0;
		addAns[60] <= 26'd0;
		addAns[61] <= 26'd0;
		addAns[62] <= 26'd0;
		addAns[63] <= 26'd0;
		addAns[64] <= 26'd0;
		addAns[65] <= 26'd0;
		addAns[66] <= 26'd0;
		addAns[67] <= 26'd0;
		addAns[68] <= 26'd0;
		addAns[69] <= 26'd0;
		addAns[70] <= 26'd0;
		addAns[71] <= 26'd0;
		addAns[72] <= 26'd0;
		addAns[73] <= 26'd0;
		addAns[74] <= 26'd0;
		addAns[75] <= 26'd0;
		addAns[76] <= 26'd0;
		addAns[77] <= 26'd0;
		addAns[78] <= 26'd0;
		addAns[79] <= 26'd0;
		addAns[80] <= 26'd0;
		addAns[81] <= 26'd0;
		addAns[82] <= 26'd0;
		addAns[83] <= 26'd0;
		addAns[84] <= 26'd0;
		addAns[85] <= 26'd0;
		addAns[86] <= 26'd0;
		addAns[87] <= 26'd0;
		addAns[88] <= 26'd0;
		addAns[89] <= 26'd0;
		addAns[90] <= 26'd0;
		addAns[91] <= 26'd0;
		addAns[92] <= 26'd0;
		addAns[93] <= 26'd0;
		addAns[94] <= 26'd0;
		addAns[95] <= 26'd0;
		addAns[96] <= 26'd0;
		addAns[97] <= 26'd0;
		addAns[98] <= 26'd0;
		addAns[99] <= 26'd0;
		addAns[100] <= 26'd0;
		addAns[101] <= 26'd0;
		addAns[102] <= 26'd0;
		addAns[103] <= 26'd0;
		addAns[104] <= 26'd0;
		addAns[105] <= 26'd0;
		addAns[106] <= 26'd0;
		addAns[107] <= 26'd0;
		addAns[108] <= 26'd0;
		addAns[109] <= 26'd0;
		addAns[110] <= 26'd0;
		addAns[111] <= 26'd0;
		addAns[112] <= 26'd0;
		addAns[113] <= 26'd0;
		addAns[114] <= 26'd0;
		addAns[115] <= 26'd0;
		addAns[116] <= 26'd0;
		addAns[117] <= 26'd0;
		addAns[118] <= 26'd0;
		addAns[119] <= 26'd0;
		addAns[120] <= 26'd0;
		addAns[121] <= 26'd0;
		addAns[122] <= 26'd0;
		addAns[123] <= 26'd0;
		addAns[124] <= 26'd0;
		addAns[125] <= 26'd0;
		addAns[126] <= 26'd0;
		addAns[127] <= 26'd0;
		addAns[128] <= 26'd0;
		addAns[129] <= 26'd0;
		addAns[130] <= 26'd0;
		addAns[131] <= 26'd0;
		addAns[132] <= 26'd0;
		addAns[133] <= 26'd0;
		addAns[134] <= 26'd0;
		addAns[135] <= 26'd0;
		addAns[136] <= 26'd0;
		addAns[137] <= 26'd0;
		addAns[138] <= 26'd0;
		addAns[139] <= 26'd0;
		addAns[140] <= 26'd0;
		addAns[141] <= 26'd0;
		addAns[142] <= 26'd0;
		addAns[143] <= 26'd0;
		addAns[144] <= 26'd0;
		addAns[145] <= 26'd0;
		addAns[146] <= 26'd0;
		addAns[147] <= 26'd0;
		addAns[148] <= 26'd0;
		addAns[149] <= 26'd0;
		addAns[150] <= 26'd0;
		addAns[151] <= 26'd0;
		addAns[152] <= 26'd0;
		addAns[153] <= 26'd0;
		addAns[154] <= 26'd0;
		addAns[155] <= 26'd0;
		addAns[156] <= 26'd0;
		addAns[157] <= 26'd0;
		addAns[158] <= 26'd0;
		addAns[159] <= 26'd0;
		addAns[160] <= 26'd0;
		addAns[161] <= 26'd0;
		addAns[162] <= 26'd0;
		addAns[163] <= 26'd0;
		addAns[164] <= 26'd0;
		addAns[165] <= 26'd0;
		addAns[166] <= 26'd0;
		addAns[167] <= 26'd0;
		addAns[168] <= 26'd0;
		addAns[169] <= 26'd0;
		addAns[170] <= 26'd0;
		addAns[171] <= 26'd0;
		addAns[172] <= 26'd0;
		addAns[173] <= 26'd0;
		addAns[174] <= 26'd0;
		addAns[175] <= 26'd0;
		addAns[176] <= 26'd0;
		addAns[177] <= 26'd0;
		addAns[178] <= 26'd0;
		addAns[179] <= 26'd0;
		addAns[180] <= 26'd0;
		addAns[181] <= 26'd0;
		addAns[182] <= 26'd0;
		addAns[183] <= 26'd0;
		addAns[184] <= 26'd0;
		addAns[185] <= 26'd0;
		addAns[186] <= 26'd0;
		addAns[187] <= 26'd0;
		addAns[188] <= 26'd0;
		addAns[189] <= 26'd0;
		addAns[190] <= 26'd0;
		addAns[191] <= 26'd0;
		addAns[192] <= 26'd0;
		addAns[193] <= 26'd0;
		addAns[194] <= 26'd0;
		addAns[195] <= 26'd0;
	end else begin
		if(switchCounter <= 32'd195)begin 
			A1 <= A[(32'd4*switchCounter)%32'd28];
			A2 <= A[32'd1 + ((32'd4*switchCounter)%32'd28)];
			A3 <= A[32'd2 + ((32'd4*switchCounter)%32'd28)];
			A4 <= A[32'd3 + ((32'd4*switchCounter)%32'd28)];
			B1 <= B[(32'd4*switchCounter)%32'd28];
			B2 <= B[32'd1 + ((32'd4*switchCounter)%32'd28)];
			B3 <= B[32'd2 + ((32'd4*switchCounter)%32'd28)];
			B4 <= B[32'd3 + ((32'd4*switchCounter)%32'd28)];
		end else begin
			A1 <= A1;
			A2 <= A2;
			A3 <= A3;
			A4 <= A4;
			B1 <= B1;
			B2 <= B2;
			B3 <= B3;
			B4 <= B4;
		end

		if(switchCounter >= 32'd7 && switchCounter <= 32'd202) begin
			addInput[0] <= FPMAns1;
			addInput[1] <= FPMAns2;
			addInput[2] <= FPMAns3;
			addInput[3] <= FPMAns4;
		end else
		if(switchCounter >= 32'd208 && switchCounter <= 32'd256) begin
			addInput[0] <= addAns[(switchCounter - 32'd208) << 2'd2];
 			addInput[1] <= addAns[((switchCounter - 32'd208) << 2'd2) + 32'd1];
			addInput[2] <= addAns[((switchCounter - 32'd208) << 2'd2) + 32'd2];
 			addInput[3] <= addAns[((switchCounter - 32'd208) << 2'd2) + 32'd3];
		end else
		if(switchCounter >= 32'd262 && switchCounter <= 32'd273) begin
			addInput[0] <= addAns[(switchCounter - 32'd262) << 2'd2];
 			addInput[1] <= addAns[((switchCounter - 32'd262) << 2'd2) + 32'd1];
			addInput[2] <= addAns[((switchCounter - 32'd262) << 2'd2) + 32'd2];
 			addInput[3] <= addAns[((switchCounter - 32'd262) << 2'd2) + 32'd3];
		end else
		if(switchCounter >= 32'd279 && switchCounter <= 32'd281) begin
			addInput[0] <= addAns[(switchCounter - 32'd279) << 2'd2];
 			addInput[1] <= addAns[((switchCounter - 32'd279) << 2'd2) + 32'd1];
			addInput[2] <= addAns[((switchCounter - 32'd279) << 2'd2) + 32'd2];
 			addInput[3] <= addAns[((switchCounter - 32'd279) << 2'd2) + 32'd3];
		end else
		if(switchCounter == 32'd287) begin
			addInput[0] <= addAns[0];
 			addInput[1] <= addAns[1];
			addInput[2] <= addAns[2];
 			addInput[3] <= addAns[48];
		end else
		if(switchCounter == 32'd293) begin
			addInput[0] <= addAns[0];
 			addInput[1] <= biasWeight;
			addInput[2] <= 26'd0;
 			addInput[3] <= 26'd0;
		end 
		if(switchCounter >= 32'd12 && switchCounter <= 32'd207) begin
			addAns[switchCounter - 32'd12] <= FPAAns3;
		end else
		if(switchCounter >= 32'd213 && switchCounter <= 32'd261) begin
			addAns[switchCounter - 32'd213] <= FPAAns3;
		end else
		if(switchCounter >= 32'd267 && switchCounter <= 32'd278) begin
			addAns[switchCounter - 32'd267] <= FPAAns3;
		end else
		if(switchCounter >= 32'd284 && switchCounter <= 32'd286) begin
			addAns[switchCounter - 32'd284] <= FPAAns3;
		end else
		if(switchCounter == 32'd292) begin
			addAns[0] <= FPAAns3;
		end else
		if(switchCounter == 32'd298) begin
			addAns[0] <= FPAAns3;
		end
		switchCounter <= switchCounter + 32'd1;
	end
end
endmodule
