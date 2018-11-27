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

	//DotProduct automated code goes here
	code += "module test\n";
	code += "#(parameter PIXEL_N = " + to_string(PIXEL_N) + ",\n";
	code += "parameter WEIGHT_SIZE = " + to_string(WEIGHT_SIZE) + ",\n";
	code += "parameter PIXEL_SIZE = " + to_string(PIXEL_SIZE) + ")\n";
	code += "(\n";
	code += "input clk,\n";
	code += "input GlobalReset,\n";
	code += "input [PIXEL_N*PIXEL_SIZE-1:0] Pixels,\n";
	code += "input [PIXEL_N*WEIGHT_SIZE-1:0] Weights,\n";
	code += "output [25:0] value\n";
	code += ");\n";
	code += "\n";

	code += "wire[" + to_string(WEIGHT_SIZE-1) + ":0] A [0:" + to_string(PIXEL_N-1) + "];\n"; 
	code += "wire[" + to_string(PIXEL_SIZE-1) + ":0] B [0:" + to_string(PIXEL_N-1) + "];\n";
	code += "reg[" + to_string(WEIGHT_SIZE-1) + ":0] A1;\n";
	code += "reg[" + to_string(WEIGHT_SIZE-1) + ":0] A2;\n";
	code += "reg[" + to_string(PIXEL_SIZE-1) + ":0] B1;\n";
	code += "reg[" + to_string(PIXEL_SIZE-1) + ":0] B2;\n";
	code += "wire[25:0] FPMAns1;\n";
	code += "wire[25:0] FPMAns2;\n";
	code += "wire[25:0] FPAAns;\n";
	code += "reg[25:0] addAns [0:391];\n";
	code += "reg[25:0] addInput [0:1];\n";
	code += "reg[31:0] switchCounter = 32'd0;\n";
	code += "assign value = addAns[0];\n";
	code += "\n";

	for(int i = 0; i < PIXEL_N; i++){
		code += "assign A[" + to_string(i) + "] = " + "Weights[" + to_string(WEIGHT_SIZE*(i+1)-1) + ":" + to_string(WEIGHT_SIZE*i) + "];\n";
	}
	for(int i = 0; i < PIXEL_N; i++){
		code += "assign B[" + to_string(i) + "] = " + "Pixels[" + to_string(PIXEL_SIZE*(i+1)-1) + ":" + to_string(PIXEL_SIZE*i) + "];\n";
	}
	code += "\n";

	code += "FixedPointMultiplier FPM1(.clk(clk),.GlobalReset(GlobalReset),.WeightPort(A1),.PixelPort(B1),.Output_syn(FPMAns1));\n";
	code += "FixedPointMultiplier FPM2(.clk(clk),.GlobalReset(GlobalReset),.WeightPort(A2),.PixelPort(B2),.Output_syn(FPMAns2));\n";
	code += "FixedPointAdder FPA1(.clk(clk),.GlobalReset(GlobalReset),.Port2(addInput[1]),.Port1(addInput[0]),.Output_syn(FPAAns));\n";
	code += "\n";

	code += "always@(posedge clk)begin\n";
	code += "	if(GlobalReset == 1'b1)begin\n";
	code += "		A1 <= A[0];\n";
	code += "		A2 <= A[392];\n";
	code += "		B1 <= B[0];\n";
	code += "		B2 <= B[392];\n";
	code += "		addInput[0] <= 26'd0;\n";
	code += "		addInput[1] <= 26'd0;\n";
	code += "		switchCounter <= 32'd0;\n";
	for(int i = 0; i < PIXEL_N/2; i++){
		code += "		addAns[" + to_string(i) + "] <= 26'd0;\n";
	}
	code += "	end else begin\n";
	code += "		case(switchCounter)\n";
	for(int i = 0; i < PIXEL_N/2; i++){
		code += "			" + to_string(i) + ": begin\n";
		code += "				A1 <= A[" + to_string(i) + "];\n";
		code += "				A2 <= A[" + to_string(PIXEL_N/2+i) + "];\n";
		code += "				B1 <= B[" + to_string(i) + "];\n";
		code += "				B2 <= B[" + to_string(PIXEL_N/2+i) + "];\n";
		code += "			end\n";
	}
	code += "			default: begin\n";
	code += "				A1 <= A1;\n";
	code += "				A2 <= A2;\n";
	code += "				B1 <= B1;\n";
	code += "				B2 <= B2;\n";
	code += "			end\n";
	code += "		endcase\n";
	code += "\n";

	code += "		if(switchCounter >= 32'd7 && switchCounter <= 32'd398) begin\n";
	code += "			addInput[0] <= FPMAns1;\n";
	code += "			addInput[1] <= FPMAns2;\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd399 && switchCounter <= 32'd594) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd399) << 1'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd399) << 1'd1) + 32'd1];\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd595 && switchCounter <= 32'd692) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd595) << 1'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd595) << 1'd1) + 32'd1];\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd693 && switchCounter <= 32'd741) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd693) << 1'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd693) << 1'd1) + 32'd1];\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd742 && switchCounter <= 32'd765) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd742) << 1'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd742) << 1'd1) + 32'd1];\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd766 && switchCounter <= 32'd777) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd766) << 1'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd766) << 1'd1) + 32'd1];\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd778 && switchCounter <= 32'd783) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd778) << 1'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd778) << 1'd1) + 32'd1];\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd784 && switchCounter <= 32'd786) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd784) << 1'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd784) << 1'd1) + 32'd1];\n";
	code += "		end\n";
	code += "		if(switchCounter == 32'd787) begin\n";
	code += "			addInput[0] <= addAns[(switchCounter - 32'd787) << 1'd1];\n";
	code += " 			addInput[1] <= addAns[((switchCounter - 32'd787) << 1'd1) + 32'd1];\n";
	code += "		end\n";
	code += "		if(switchCounter == 32'd788) begin\n";
	code += "			addInput[0] <= addAns[2];\n";
	code += " 			addInput[1] <= addAns[48];\n";
	code += "		end\n";
	code += "		if(switchCounter == 32'd792) begin\n";
	code += "			addInput[0] <= addAns[0];\n";
	code += " 			addInput[1] <= addAns[1];\n";
	code += "		end\n";

	code += "		if(switchCounter >= 32'd10 && switchCounter <= 32'd401) begin\n";
	code += "			addAns[switchCounter - 32'd10] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd402 && switchCounter <= 32'd597) begin\n";
	code += "			addAns[switchCounter - 32'd402] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd598 && switchCounter <= 32'd695) begin\n";
	code += "			addAns[switchCounter - 32'd598] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd696 && switchCounter <= 32'd744) begin\n";
	code += "			addAns[switchCounter - 32'd696] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd745 && switchCounter <= 32'd768) begin\n";
	code += "			addAns[switchCounter - 32'd745] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd769 && switchCounter <= 32'd780) begin\n";
	code += "			addAns[switchCounter - 32'd769] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd781 && switchCounter <= 32'd786) begin\n";
	code += "			addAns[switchCounter - 32'd781] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter >= 32'd787 && switchCounter <= 32'd789) begin\n";
	code += "			addAns[switchCounter - 32'd787] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter == 32'd790) begin\n";
	code += "			addAns[switchCounter - 32'd790] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter == 32'd791) begin\n";
	code += "			addAns[1] <= FPAAns;\n";
	code += "		end\n";
	code += "		if(switchCounter == 32'd795) begin\n";
	code += "			addAns[0] <= FPAAns;\n";
	code += "		end\n";
	code += "		switchCounter <= switchCounter + 32'd1;\n";

	code += "	end\n";
	code += "end\n";
	
	code += "endmodule\n";


	//TestBench automated code goes here
	code_tb += "`timescale 1 ns/10ps\n";
	code_tb += "\n";

	code_tb += "module test_tb();\n";
	code_tb += "reg clk;\n";
	code_tb += "reg GlobalReset;\n";
	code_tb += "wire[25:0] result;\n";
	code_tb += "reg[14895:0] A;\n";
	code_tb += "reg[7839:0] B;\n";
	code_tb += "integer i;\n";
	code_tb += "wire[9:0] i_w;\n";
	code_tb += "\n";

	code_tb += "test testGenerator(.clk(clk),.GlobalReset(GlobalReset),.Pixels(B),.Weights(A),.value(result));\n";
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
	code_tb += "		A[i*19 +: 19] = 19'b010_0000_0000_0000_0000;\n";
	code_tb += " 		B[i*10 +: 10] = i%4;\n";
	code_tb += "	end\n";
	code_tb += "\n";

	code_tb += "	for(i = 0; i < 800; i = i + 1)begin\n";
	code_tb += "		#fullclock;\n";
	code_tb += "	end\n";
	code_tb += "\n";

	code_tb += "	$display(\"%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b\",\n";
	code_tb += "		result[25], result[24], result[23], result[22],\n";
        code_tb += "		result[21], result[20], result[19], result[18],\n";
        code_tb += "		result[17], result[16], result[15], result[14],\n";
        code_tb += "		result[13], result[12], result[11], result[10],\n";
        code_tb += "		result[9], result[8], result[7], result[6],\n";
        code_tb += "		result[5], result[4], result[3], result[2], result[1],\n";
        code_tb += "		result[0]);\n";
	code_tb += "\n";
	code_tb += "	$stop;\n";
	code_tb += "end\n";
	code_tb += "endmodule\n";

	ofstream writeFile1;
	ofstream writeFile2;
	writeFile1.open("test.v");
	writeFile2.open("test_tb.v");
	writeFile1 << code;
	writeFile2 << code_tb;
	writeFile1.close();
	writeFile2.close();
	return 0;

}
