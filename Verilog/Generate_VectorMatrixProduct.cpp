#include <string>
#include <fstream>
#include <iostream>

using namespace std;
int main(int argc, char* argv[]){
	string code = "";
	string code_tb = "";
	int PIXEL_N = 784;
	int WEIGHT_SIZE = 19;
	int PIXEL_SIZE = 10;
	int NEURONS = 10;

	//VectorMatrixProduct automated code goes here
	code += "module VectorMatrixProduct\n";
	code += "#(parameter PIXEL_N = " + to_string(PIXEL_N) + ",\n";
	code += "parameter WEIGHT_SIZE = " + to_string(WEIGHT_SIZE) + ",\n";
	code += "parameter PIXEL_SIZE = " + to_string(PIXEL_SIZE) + ")\n";
	code += "(\n";
	code += "input clk,\n";
	code += "input GlobalReset,\n";
	code += "input [PIXEL_N*PIXEL_SIZE-1:0] Pixels,\n";
	for(int i = 0; i < NEURONS; i++){
		code += "input [PIXEL_N*WEIGHT_SIZE-1:0] Weights" + to_string(i) + ",\n";
	}
	code += "output [" + to_string(26*NEURONS-1) + ":0] value\n";
	code += ");\n";
	code += "\n";

	code += "reg[9:0] PixelsStore[0:27];\n";
	for(int i = 0; i < NEURONS; i++){
		code += "reg[18:0] WeightsStore" + to_string(i) + "[0:27];\n";
	}
	code += "reg[31:0] switchCounter;\n";
	code += "wire[25:0] vals [0:" + to_string(NEURONS-1) + "];\n";
	code += "\n";

	for(int i = 0; i < NEURONS; i++){
		code += "assign value[" + to_string((i+1)*26-1) + ":" + to_string(i*26) + "] = vals[" + to_string(i) + "];\n";
	}

	for(int i = 0; i < NEURONS; i++){
		code += "DotProduct784 DP" + to_string(i) + "(.clk(clk),\n";
		code += "	.GlobalReset(GlobalReset),\n";
		for(int j = 0; j < PIXEL_N/28; j++){
			code += "	.Pixel" + to_string(j) + "(PixelsStore[" + to_string(j) + "]),\n";
		}
		for(int j = 0; j < PIXEL_N/28; j++){
			code += "	.Weight" + to_string(j) + "(WeightsStore" + to_string(i) + "[" + to_string(j) + "]),\n";
		}
		code += "	.value(vals[" + to_string(i) + "])\n";
		code += "	);\n";
	}
	code +="\n";

	code += "always@(posedge clk)begin\n";
	code += "	if(GlobalReset == 1'b1)begin\n";
	code += "		switchCounter <= 32'd0;\n";
	for(int i = 0; i < PIXEL_N/28; i++){
		code += "		PixelsStore[" + to_string(i) + "] <= 10'd0;\n";
	}
	for(int i = 0; i < NEURONS; i++){
		for(int j = 0; j < PIXEL_N/28; j++){
			code += "		WeightsStore" + to_string(i) + "[" + to_string(j) + "] <= 19'd0;\n";
		}
	}
	code += "	end else begin\n";
	for(int k = 0; k < PIXEL_N/28; k++){
		if(k == 0){
			code += "		if(switchCounter == 32'd" + to_string(k) + ")begin\n";
		}else{
			code += "if(switchCounter == 32'd" + to_string(k) + ")begin\n";
		}
		for(int i = 0; i < PIXEL_N/28; i++){
			code += "			PixelsStore[" + to_string(i) + "] <= Pixels[(32'd" + to_string(k*PIXEL_N/28+i) + "+32'd1)*32'd10-1:32'd" + to_string(k*PIXEL_N/28+i) + "*32'd10];\n";
		}
		for(int i = 0; i < NEURONS; i++){
			for(int j = 0; j < PIXEL_N/28; j++){
				code += "			WeightsStore" + to_string(i) + "[" + to_string(j) + "] <= Weights" + to_string(i) + "[(32'd" + to_string(k*PIXEL_N/28+i) + "+32'd1)*32'd19-1:32'd" + to_string(k*PIXEL_N/28+i) + "*32'd19];\n";
			}
		}
		if(k != PIXEL_N/28-1){
			code += "		end else ";
		}else{
			code += "		end\n";
		}
	}

	code += "		switchCounter <= switchCounter + 32'd1;\n";
	code += "	end\n";
	code += "end\n";
	code += "\n";
	
	code += "endmodule\n";


	//TestBench automated code goes here
	code_tb += "`timescale 1 ns/10ps\n";
	code_tb += "\n";

	code_tb += "module VectorMatrixProduct_tb();\n";
	code_tb += "reg clk;\n";
	code_tb += "reg GlobalReset;\n";
	code_tb += "wire[259:0] result;\n";
	for(int i = 0; i < NEURONS; i++){
		code_tb += "reg[14895:0] Weights" + to_string(i) + ";\n";
	}
	code_tb += "reg[7839:0] Pixels;\n";
	code_tb += "integer i;\n";
	code_tb += "wire[9:0] i_w;\n";
	code_tb += "\n";

	code_tb += "VectorMatrixProduct VMP(.clk(clk),.GlobalReset(GlobalReset),.Pixels(Pixels),";
	for(int i = 0; i < NEURONS; i++){
		code_tb += ".Weights" + to_string(i) + "(Weights" + to_string(i) + "),";
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
	code_tb += "	GlobalReset = 1'b1;\n";
	code_tb += "	clk = 1'b1;\n";
	code_tb += "\n";

	code_tb += "	#halfclock;\n";
	code_tb += "	#fullclock GlobalReset = 1'b0;\n";
	code_tb += "\n";
	
	code_tb += "	for(i = 0; i < 784; i = i+1) begin\n";
	for(int i = 0; i < NEURONS; i++){
		code_tb += "		Weights" + to_string(i) + "[i*19 +: 19] = 19'b000_1000_0000_0000_0000;\n";
	}
	code_tb += " 		Pixels[i*10 +: 10] = i%2;\n";
	code_tb += "		if(i%28 == 27) begin \n";
	code_tb += "			#fullclock;\n";
	code_tb += "		end\n;";
	code_tb += "	end\n";
	code_tb += "\n";

	code_tb += "	for(i = 0; i < 260; i = i + 1)begin\n";
	code_tb += "		#fullclock;\n";
	code_tb += "	end\n";
	code_tb += "\n";

	for(int i = NEURONS; i > 0; i--){
		/*code_tb += "	$display(\"%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d\",\n";
		code_tb += "		result[25], result[24], result[23], result[22],\n";
		code_tb += "		result[21], result[20], result[19], result[18],\n";
		code_tb += "		result[17], result[16], result[15], result[14],\n";
		code_tb += "		result[13], result[12], result[11], result[10],\n";
		code_tb += "		result[9], result[8], result[7], result[6],\n";
		code_tb += "		result[5], result[4], result[3], result[2], result[1],\n";
		code_tb += "		result[0], result[25:18]);\n";*/

		code_tb += "	$display(\"%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %d\",\n";
		for(int j = 0; j < 26; j++){
			if(j == 0){
				code_tb += "		";
			}
			code_tb += "result[" + to_string(26*i-1-j) + "],";
		}
		code_tb += "		result[" + to_string(26*i-1) + ":" + to_string(26*i-8) + "]);\n";
	}
	code_tb += "\n";
	code_tb += "	$stop;\n";
	code_tb += "end\n";
	code_tb += "endmodule\n";

	ofstream writeFile1;
	ofstream writeFile2;
	writeFile1.open("VectorMatrixProduct.v");
	writeFile2.open("VectorMatrixProduct_tb.v");
	writeFile1 << code;
	writeFile2 << code_tb;
	writeFile1.close();
	writeFile2.close();
	return 0;

}