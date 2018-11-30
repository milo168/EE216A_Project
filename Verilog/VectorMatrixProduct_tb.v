`timescale 1 ns/10ps

module VectorMatrixProduct_tb();
reg clk;
reg GlobalReset;
wire[259:0] result;
reg[14895:0] Weights0;
reg[14895:0] Weights1;
reg[14895:0] Weights2;
reg[14895:0] Weights3;
reg[14895:0] Weights4;
reg[14895:0] Weights5;
reg[14895:0] Weights6;
reg[14895:0] Weights7;
reg[14895:0] Weights8;
reg[14895:0] Weights9;
reg[7839:0] Pixels;
integer i;
wire[9:0] i_w;

VectorMatrixProduct VMP(.clk(clk),.GlobalReset(GlobalReset),.Pixels(Pixels),.Weights0(Weights0),.Weights1(Weights1),.Weights2(Weights2),.Weights3(Weights3),.Weights4(Weights4),.Weights5(Weights5),.Weights6(Weights6),.Weights7(Weights7),.Weights8(Weights8),.Weights9(Weights9),.value(result));

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
		Weights0[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
		Weights1[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
		Weights2[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
		Weights3[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
		Weights4[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
		Weights5[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
		Weights6[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
		Weights7[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
		Weights8[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
		Weights9[i*19 +: 19] = 19'b000_1000_0000_0000_0000;
 		Pixels[i*10 +: 10] = i%2;
		if(i%28 == 27) begin 
			#fullclock;
		end
	end

	for(i = 0; i < 260; i = i + 1)begin
		#fullclock;
	end

	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[259],result[258],result[257],result[256],result[255],result[254],result[253],result[252],result[251],result[250],result[249],result[248],result[247],result[246],result[245],result[244],result[243],result[242],result[241],result[240],result[239],result[238],result[237],result[236],result[235],result[234],		result[259:252]);
	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[233],result[232],result[231],result[230],result[229],result[228],result[227],result[226],result[225],result[224],result[223],result[222],result[221],result[220],result[219],result[218],result[217],result[216],result[215],result[214],result[213],result[212],result[211],result[210],result[209],result[208],		result[233:226]);
	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[207],result[206],result[205],result[204],result[203],result[202],result[201],result[200],result[199],result[198],result[197],result[196],result[195],result[194],result[193],result[192],result[191],result[190],result[189],result[188],result[187],result[186],result[185],result[184],result[183],result[182],		result[207:200]);
	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[181],result[180],result[179],result[178],result[177],result[176],result[175],result[174],result[173],result[172],result[171],result[170],result[169],result[168],result[167],result[166],result[165],result[164],result[163],result[162],result[161],result[160],result[159],result[158],result[157],result[156],		result[181:174]);
	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[155],result[154],result[153],result[152],result[151],result[150],result[149],result[148],result[147],result[146],result[145],result[144],result[143],result[142],result[141],result[140],result[139],result[138],result[137],result[136],result[135],result[134],result[133],result[132],result[131],result[130],		result[155:148]);
	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[129],result[128],result[127],result[126],result[125],result[124],result[123],result[122],result[121],result[120],result[119],result[118],result[117],result[116],result[115],result[114],result[113],result[112],result[111],result[110],result[109],result[108],result[107],result[106],result[105],result[104],		result[129:122]);
	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[103],result[102],result[101],result[100],result[99],result[98],result[97],result[96],result[95],result[94],result[93],result[92],result[91],result[90],result[89],result[88],result[87],result[86],result[85],result[84],result[83],result[82],result[81],result[80],result[79],result[78],		result[103:96]);
	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[77],result[76],result[75],result[74],result[73],result[72],result[71],result[70],result[69],result[68],result[67],result[66],result[65],result[64],result[63],result[62],result[61],result[60],result[59],result[58],result[57],result[56],result[55],result[54],result[53],result[52],		result[77:70]);
	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[51],result[50],result[49],result[48],result[47],result[46],result[45],result[44],result[43],result[42],result[41],result[40],result[39],result[38],result[37],result[36],result[35],result[34],result[33],result[32],result[31],result[30],result[29],result[28],result[27],result[26],		result[51:44]);
	$display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d",
		result[25],result[24],result[23],result[22],result[21],result[20],result[19],result[18],result[17],result[16],result[15],result[14],result[13],result[12],result[11],result[10],result[9],result[8],result[7],result[6],result[5],result[4],result[3],result[2],result[1],result[0],		result[25:18]);

	$stop;
end
endmodule
