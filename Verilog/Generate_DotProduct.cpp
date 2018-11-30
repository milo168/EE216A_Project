#include <string>
#include <fstream>
#include <iostream>

using namespace std;
int main(int argc, char* argv[]){
	string code = "";
	string code_tb = "";
	int PIXEL_N = 28;
	int WEIGHT_SIZE = 19;
	int PIXEL_SIZE = 10;

	//DotProduct automated code goes here
	code += "module DotProduct784\n";
	code += "#(parameter PIXEL_N = " + to_string(PIXEL_N) + ",\n";
	code += "parameter WEIGHT_SIZE = " + to_string(WEIGHT_SIZE) + ",\n";
	code += "parameter PIXEL_SIZE = " + to_string(PIXEL_SIZE) + ")\n";
	code += "(\n";
	code += "input clk,\n";
	code += "input GlobalReset,\n";
	for(int i = 0; i < PIXEL_N; i++){
		code += "input [" + to_string(PIXEL_SIZE-1) + ":0] Pixel" + to_string(i) + ",\n";
	}
	for(int i = 0; i < PIXEL_N; i++){
		code += "input [" + to_string(WEIGHT_SIZE-1) + ":0] Weight" + to_string(i) + ",\n";
	}
	code += "output [25:0] value\n";
	code += ");\n";
	code += "\n";

	code += "wire[" + to_string(WEIGHT_SIZE-1) + ":0] A [0:" + to_string(PIXEL_N-1) + "];\n"; 
	code += "wire[" + to_string(PIXEL_SIZE-1) + ":0] B [0:" + to_string(PIXEL_N-1) + "];\n";
	code += "reg[" + to_string(WEIGHT_SIZE-1) + ":0] A1;\n";
	code += "reg[" + to_string(WEIGHT_SIZE-1) + ":0] A2;\n";
	code += "reg[" + to_string(WEIGHT_SIZE-1) + ":0] A3;\n";
	code += "reg[" + to_string(WEIGHT_SIZE-1) + ":0] A4;\n";
	code += "reg[" + to_string(PIXEL_SIZE-1) + ":0] B1;\n";
	code += "reg[" + to_string(PIXEL_SIZE-1) + ":0] B2;\n";
	code += "reg[" + to_string(PIXEL_SIZE-1) + ":0] B3;\n";
	code += "reg[" + to_string(PIXEL_SIZE-1) + ":0] B4;\n";
	code += "wire[25:0] FPMAns1;\n";
	code += "wire[25:0] FPMAns2;\n";
	code += "wire[25:0] FPMAns3;\n";
	code += "wire[25:0] FPMAns4;\n";
	code += "wire[25:0] FPAAns1;\n";
	code += "wire[25:0] FPAAns2;\n";
	code += "wire[25:0] FPAAns3;\n";
	code += "reg[25:0] addAns [0:195];\n";
	code += "reg[25:0] addInput [0:5];\n";
	code += "reg[31:0] switchCounter;\n";
	code += "assign value = addAns[0];\n";
	code += "\n";

	for(int i = 0; i < PIXEL_N; i++){
		code += "assign A[" + to_string(i) + "] = " + "Weight" + to_string(i) + ";\n";
	}
	for(int i = 0; i < PIXEL_N; i++){
		code += "assign B[" + to_string(i) + "] = " + "Pixel" + to_string(i) + ";\n";
	}
	code += "\n";

	code += "FixedPointMultiplier FPM1(.clk(clk),.GlobalReset(~GlobalReset),.WeightPort(A1),.PixelPort(B1),.Output_syn(FPMAns1));\n";
	code += "FixedPointMultiplier FPM2(.clk(clk),.GlobalReset(~GlobalReset),.WeightPort(A2),.PixelPort(B2),.Output_syn(FPMAns2));\n";
	code += "FixedPointMultiplier FPM3(.clk(clk),.GlobalReset(~GlobalReset),.WeightPort(A3),.PixelPort(B3),.Output_syn(FPMAns3));\n";
	code += "FixedPointMultiplier FPM4(.clk(clk),.GlobalReset(~GlobalReset),.WeightPort(A4),.PixelPort(B4),.Output_syn(FPMAns4));\n";
	code += "FixedPointAdder FPA1(.clk(clk),.GlobalReset(~GlobalReset),.Port2(addInput[1]),.Port1(addInput[0]),.Output_syn(FPAAns1));\n";
	code += "FixedPointAdder FPA2(.clk(clk),.GlobalReset(~GlobalReset),.Port2(addInput[3]),.Port1(addInput[2]),.Output_syn(FPAAns2));\n";
	code += "FixedPointAdder FPA3(.clk(clk),.GlobalReset(~GlobalReset),.Port2(addInput[5]),.Port1(addInput[4]),.Output_syn(FPAAns3));\n";
	code += "\n";

	code += "always@(posedge clk)begin\n";
	code += "	if(GlobalReset == 1'b0)begin\n";
	code += "		A1 <= A[0];\n";
	code += "		A2 <= A[14];\n";
	code += "		B1 <= B[0];\n";
	code += "		B2 <= B[14];\n";
	code += "		addInput[0] <= 26'd0;\n";
	code += "		addInput[1] <= 26'd0;\n";
	code += "		addInput[2] <= 26'd0;\n";
	code += "		addInput[3] <= 26'd0;\n";
	code += "		addInput[4] <= 26'd0;\n";
	code += "		addInput[5] <= 26'd0;\n";
	code += "		switchCounter <= 32'd0;\n";
	for(int i = 0; i < PIXEL_N/4*28; i++){
		code += "		addAns[" + to_string(i) + "] <= 26'd0;\n";
	}
	code += "	end else begin\n";
	code += "		if(switchCounter <= 32'd195)begin \n";
	code += "			A1 <= A[(32'd4*switchCounter)%32'd28];\n";
	code += "			A2 <= A[32'd1 + ((32'd4*switchCounter)%32'd28)];\n";
	code += "			A3 <= A[32'd2 + ((32'd4*switchCounter)%32'd28)];\n";
	code += "			A4 <= A[32'd3 + ((32'd4*switchCounter)%32'd28)];\n";
	code += "			B1 <= B[(32'd4*switchCounter)%32'd28];\n";
	code += "			B2 <= B[32'd1 + ((32'd4*switchCounter)%32'd28)];\n";
	code += "			B3 <= B[32'd2 + ((32'd4*switchCounter)%32'd28)];\n";
	code += "			B4 <= B[32'd3 + ((32'd4*switchCounter)%32'd28)];\n";
	code += "		end else begin\n";
	code += "			A1 <= A1;\n";
	code += "			A2 <= A2;\n";
	code += "			A3 <= A3;\n";
	code += "			A4 <= A4;\n";
	code += "			B1 <= B1;\n";
	code += "			B2 <= B2;\n";
	code += "			B3 <= B3;\n";
	code += "			B4 <= B4;\n";
	code += "		end\n";
	code += "\n";

	code += "		if(switchCounter >= 32'd7 && switchCounter <= 32'd202) begin\n";
	code += "			addInput[0] <= FPMAns1;\n";
	code += "			addInput[1] <= FPMAns2;\n";
	code += "			addInput[2] <= FPMAns3;\n";
	code += "			addInput[3] <= FPMAns4;\n";
	code += "		end else\n";
	code += "		if(switchCounter >= 32'd203 && switchCounter <= 32'd251) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd203) << 2'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd203) << 2'd1) + 32'd1];\n";
	code += "			addInput[2] <= addAns[((switchCounter - 32'd203) << 2'd1) + 32'd2];\n";
	code += " 			addInput[3] <= addAns[((switchCounter - 32'd203) << 2'd1) + 32'd3];\n";
	code += "		end else\n";
	code += "		if(switchCounter >= 32'd252 && switchCounter <= 32'd263) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd252) << 2'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd252) << 2'd1) + 32'd1];\n";
	code += "			addInput[2] <= addAns[((switchCounter - 32'd252) << 2'd1) + 32'd2];\n";
	code += " 			addInput[3] <= addAns[((switchCounter - 32'd252) << 2'd1) + 32'd3];\n";
	code += "		end else\n";
	code += "		if(switchCounter >= 32'd267 && switchCounter <= 32'd269) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd267) << 2'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd267) << 2'd1) + 32'd1];\n";
	code += "			addInput[2] <= addAns[((switchCounter - 32'd267) << 2'd1) + 32'd2];\n";
	code += " 			addInput[3] <= addAns[((switchCounter - 32'd267) << 2'd1) + 32'd3];\n";
	code += "		end else\n";
	code += "		if(switchCounter == 32'd276) begin\n";
	code += "			addInput[0] <= addAns[0];\n";
	code += " 			addInput[1] <= addAns[1];\n";
	code += "			addInput[2] <= addAns[2];\n";
	code += " 			addInput[3] <= addAns[48];\n";
	code += "		end \n";

	code += "		if(switchCounter >= 32'd10 && switchCounter <= 32'd205) begin\n";
	code += "			addInput[4] <= FPAAns1;\n";
	code += " 			addInput[5] <= FPAAns2;\n";
	code += "		end else\n";
	code += "		if(switchCounter >= 32'd206 && switchCounter <= 32'd254) begin\n";
	code += "			addInput[4] <= FPAAns1;\n";
	code += " 			addInput[5] <= FPAAns2;\n";
	code += "		end else\n";
	code += "		if(switchCounter >= 32'd255 && switchCounter <= 32'd266) begin\n";
	code += "			addInput[4] <= FPAAns1;\n";
	code += " 			addInput[5] <= FPAAns2;\n";
	code += "		end else\n";
	code += "		if(switchCounter >= 32'd270 && switchCounter <= 32'd272) begin\n";
	code += "			addInput[4] <= FPAAns1;\n";
	code += " 			addInput[5] <= FPAAns2;\n";
	code += "		end else\n";
	code += "		if(switchCounter == 32'd279) begin\n";
	code += "			addInput[4] <= FPAAns1;\n";
	code += " 			addInput[5] <= FPAAns2;\n";
	code += "		end \n";


	code += "		if(switchCounter >= 32'd14 && switchCounter <= 32'd208) begin\n";
	code += "			addAns[switchCounter - 32'd14] <= FPAAns3;\n";
	//code += "			$display(\"%d %b.%b\", switchCounter, FPAAns3[25:18],FPAAns3[17:0]);\n";
	code += "		end else\n";
	code += "		if(switchCounter >= 32'd209 && switchCounter <= 32'd257) begin\n";
	code += "			addAns[switchCounter - 32'd209] <= FPAAns3;\n";
	//code += "			$display(\"%d %b.%b\", switchCounter, FPAAns3[25:18],FPAAns3[17:0]);\n";
	code += "		end else\n";
	code += "		if(switchCounter >= 32'd258 && switchCounter <= 32'd269) begin\n";
	code += "			addAns[switchCounter - 32'd258] <= FPAAns3;\n";
	//code += "			$display(\"%d %b.%b\", switchCounter, FPAAns3[25:18],FPAAns3[17:0]);\n";
	code += "		end else\n";
	code += "		if(switchCounter >= 32'd273 && switchCounter <= 32'd275) begin\n";
	code += "			addAns[switchCounter - 32'd273] <= FPAAns3;\n";
	//code += "			$display(\"%d %b.%b\", switchCounter, FPAAns3[25:18],FPAAns3[17:0]);\n";
	code += "		end else\n";
	code += "		if(switchCounter == 32'd282) begin\n";
	code += "			addAns[0] <= FPAAns3;\n";
	//code += "			$display(\"%d %b.%b\", switchCounter, FPAAns3[25:18],FPAAns3[17:0]);\n";
	code += "		end\n";

	code += "		switchCounter <= switchCounter + 32'd1;\n";
	code += "	end\n";
	code += "end\n";
	
	code += "endmodule\n";


	//TestBench automated code goes here
	code_tb += "`timescale 1 ns/10ps\n";
	code_tb += "\n";

	code_tb += "module DotProduct784_tb();\n";
	code_tb += "reg clk;\n";
	code_tb += "reg GlobalReset;\n";
	code_tb += "wire[25:0] result;\n";
	code_tb += "reg[18:0] A[0:" + to_string(PIXEL_N-1) +"];\n";
	code_tb += "reg[9:0] B[0:" + to_string(PIXEL_N-1) +"];\n";
	code_tb += "integer i;\n";
	code_tb += "wire[9:0] i_w;\n";
	code_tb += "\n";

	code_tb += "DotProduct784 DP(.clk(clk),.GlobalReset(GlobalReset),";
	for(int i = 0; i < PIXEL_N; i++){
		code_tb += ".Pixel" + to_string(i) + "(B[" + to_string(i) + "]),";
	}
	for(int i = 0; i < PIXEL_N; i++){
		code_tb += ".Weight" + to_string(i) + "(A[" + to_string(i) + "]),";
	}
	code_tb += ".value(result));\n";
	code_tb += "\n";

	code_tb += "parameter halfclock = 1;\n";
	code_tb += "parameter fullclock = 2*halfclock;\n";
	code_tb += "\n";

	code_tb += "always #halfclock clk = ~clk;\n";
	code_tb += "\n";
	
	code_tb += "assign i_w = i;\n";
	code_tb += "\n";
	
	code_tb += "initial begin\n";
	code_tb += "	GlobalReset = 1'b0;\n";
	code_tb += "	clk = 1'b1;\n";
	code_tb += "\n";

	code_tb += "	#halfclock;\n";
	code_tb += "	#fullclock GlobalReset = 1'b1;\n";
	code_tb += "\n";
	
	code_tb += "	for(i = 0; i < 784; i = i+1) begin\n";
	code_tb += "		A[i%28] = 19'b000_1000_0000_0000_0000;\n";
	code_tb += " 		B[i%28] = i%2;\n";
	code_tb += "		if(i%28 == 27) begin \n";
	code_tb += "			#fullclock;\n";
	code_tb += "		end\n;";
	code_tb += "	end\n";
	code_tb += "\n";

	code_tb += "	for(i = 0; i < 260; i = i + 1)begin\n";
	code_tb += "		#fullclock;\n";
	code_tb += "	end\n";
	code_tb += "\n";

	code_tb += "	$display(\"%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d\",\n";
	code_tb += "		result[25], result[24], result[23], result[22],\n";
        code_tb += "		result[21], result[20], result[19], result[18],\n";
        code_tb += "		result[17], result[16], result[15], result[14],\n";
        code_tb += "		result[13], result[12], result[11], result[10],\n";
        code_tb += "		result[9], result[8], result[7], result[6],\n";
        code_tb += "		result[5], result[4], result[3], result[2], result[1],\n";
        code_tb += "		result[0], result[25:18]);\n";
	code_tb += "\n";
	code_tb += "	$stop;\n";
	code_tb += "end\n";
	code_tb += "endmodule\n";

	ofstream writeFile1;
	ofstream writeFile2;
	writeFile1.open("DotProduct784.v");
	writeFile2.open("DotProduct784_tb.v");
	writeFile1 << code;
	writeFile2 << code_tb;
	writeFile1.close();
	writeFile2.close();
	return 0;

}
