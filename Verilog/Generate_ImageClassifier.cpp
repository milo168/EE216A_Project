#include <string>
#include <fstream>
#include <iostream>

using namespace std;
int main(int argc, char* argv[]){
	string code = "";
	string code_tb = "";
	int PIXEL_N = 785;
	int WEIGHT_SIZE = 19;
	int PIXEL_SIZE = 10;
	int NEURONS = 10;

	//ImageClassifier automated code goes here
	code += "module Image_Classifier\n";
	code += "#(parameter NEURONS = 10,\n  parameter PIXEL_N = 785,\n  parameter WEIGHT_SIZE = 19,\n  parameter PIXEL_SIZE = 10,\n  parameter FPM_DELAY = 6,\n";
  	code += "  parameter FPA_DELAY = 2,\n  parameter PARALLEL = 2,\n  parameter BUS_WIDTH = 1,\n  parameter VAL_SIZE = 26)";
	code += "\n(\ninput clk,\n";
	code += "input GlobalReset,\n";
	code += "input Input_Valid,\n";
	for(int i = 0; i < NEURONS; i++){
		for(int j = 0; j < PIXEL_N; j++){
			code += "input [WEIGHT_SIZE-1:0] Wgt_" + to_string(i) + "_" + to_string(j) + ",";
		}
	}
	code += "\n";
	for(int i = 0; i < PIXEL_N; i++){
		code += "input [PIXEL_SIZE-1:0] Pix_" + to_string(i) + ",";
	}
	code += "\noutput [3:0] Image_Number,\n";
	code += "output Output_Valid\n";
	code += ");\n";
	code += "\n";
	
	code += "reg[PIXEL_SIZE*PIXEL_N-1:0] PixelsStore;\n";
	code += "reg[WEIGHT_SIZE*PIXEL_N-1:0] WeightsStore[0:NEURONS-1];\n";
	code += "reg[31:0] switchCounter;\n";
	code += "reg ready;\n";
	code += "reg internalReset;\n";
	code += "wire[VAL_SIZE*NEURONS-1:0] value;\n";
	code += "\n";

	code += "assign Output_Valid = ready;\n";
	code += "\n";

	code += "genvar i;\n\
for(i=0; i<NEURONS; i=i+1) begin:dpgen\n\
    DotProductSt #(.PIXEL_N   (PIXEL_N),    .WEIGHT_SIZE(WEIGHT_SIZE),\n\
                   .PIXEL_SIZE(PIXEL_SIZE), .FPM_DELAY  (FPM_DELAY),\n\
                   .FPA_DELAY  (FPA_DELAY), .PARALLEL   (PARALLEL),\n\
                   .BUS_WIDTH  (BUS_WIDTH), .VAL_SIZE   (VAL_SIZE))\n\
                DP(.clk(clk),\n\
                   .GlobalReset(GlobalReset),\n\
                   .Pixels(PixelsStore[BUS_WIDTH*PARALLEL*PIXEL_SIZE-1:0]),\n\
                   .Weights(WeightsStore[i][BUS_WIDTH*PARALLEL*WEIGHT_SIZE-1:0]),\n\
                   .value(value[VAL_SIZE*i +: VAL_SIZE]));\n\
end\n\n";
/*
	for(int i = 0; i < NEURONS; i++){
		code += "DotProduct784 DP" + to_string(i) + "(.clk(clk),\n";
		code += "	.GlobalReset(internalReset),\n";
		for(int j = 0; j < PIXEL_N/28; j++){
			code += "	.Pixel" + to_string(j) + "(PixelsStore[" + to_string(j) + "]),\n";
		}
		for(int j = 0; j < PIXEL_N/28; j++){
			code += "	.Weight" + to_string(j) + "(WeightsStore" + to_string(i) + "[" + to_string(j) + "]),\n";
		}
		code += "	.WeightBias(WeightsStore" + to_string(i) + "[" + to_string(PIXEL_N) + "]),\n";
		code += "	.value(value[" + to_string((i+1)*26-1) + ":" + to_string(i*26) + "])\n";
		code += "	);\n";
	}*/
	/*
	code += "Max max(.GlobalReset(internalReset),\n";
	code += "	.Num(value),\n";
	code += "	.Index(Image_Number)\n";
	code += "	);\n";
	code +="\n";
	*/
	code += "always@(posedge clk)begin\n";
	code += "	if(GlobalReset == 1'b0)begin\n";
	code += "		switchCounter <= 0;\n";
	code += "		ready = 1'b0;\n";
	code += "		internalReset = 1'b0;\n		";
	/*for(int i = 0; i < PIXEL_N; i++){
		code += "PixelsStore[" + to_string(i) + "]<=0;";
	}*/
	code += "PixelsStore<=0;\n";
	code += "		";
	/*for(int i = 0; i < NEURONS; i++){
		for(int j = 0; j < PIXEL_N; j++){
			code += "WeightsStore[" + to_string(i) + "][" + to_string(j) + "]<=0;";
		}
	}*/
	for(int j = 0; j < NEURONS; j++){
		code += "WeightsStore[" + to_string(j) + "]<=0;";
	}

	code += "\n	end\n";
	code += "	else if(Input_Valid == 1'b1)begin\n";
	code += "		switchCounter <= 32'd0;\n";
	code += "		ready = 1'b0;\n";
	code += "		internalReset = 1'b0;\n		";
	for(int i = 0; i < PIXEL_N; i++){
		code += "PixelsStore[" + to_string(i) + "*PIXEL_SIZE+:PIXEL_SIZE]<=Pix_" + to_string(i) + ";";
	}
	code += "\n		";
	for(int i = 0; i < NEURONS; i++){
		for(int j = 0; j < PIXEL_N; j++){
			code += "WeightsStore[" + to_string(i) + "][" + to_string(j) + "*WEIGHT_SIZE+:WEIGHT_SIZE]<=Wgt_" + to_string(i) + "_" + to_string(j) + ";";
		}
	}
	code += "\n\tend\n";
	code += "\telse begin\n";
	code += "\tend\n";
	/*
	code += "	end else begin\n";
	code += "		internalReset = 1'b1;\n";
	code += "		switchCounter <= switchCounter + 32'd1;\n";
	for(int k = 0; k < PIXEL_N/28; k++){
		if(k == 0){
			code += "		if(switchCounter == 32'd0)begin\n";
		}else{
			code += "if(switchCounter == 32'd" + to_string(k*7-1) + ")begin\n";
		}
		for(int i = 0; i < PIXEL_N/28 && k != 0; i++){
			code += "			PixelsStore[" + to_string(i) + "] <= PixelsStore[" + to_string(k * PIXEL_N/28 + i) + "];\n";
		}
		for(int i = 0; i < NEURONS && k != 0; i++){
			for(int j = 0; j < PIXEL_N/28; j++){
				code += "			WeightsStore" + to_string(i) + "[" + to_string(j) + "] <= WeightsStore" + to_string(i) + "[" + to_string(k * PIXEL_N/28 + j) + "];\n";
			}
		}
		
		code += "		end else ";
	}*/
	
	code += "if(switchCounter == 32'd299) begin\n";
	code += "			ready = 1'b1;\n";
	for(int i = 0; i < NEURONS; i++){
		code += "			$display(\"%d %b.%b\", switchCounter, value[" + to_string(26*(NEURONS-i)-1) + ":" + to_string(26*(NEURONS-i)-8) + "],value[" + to_string(26*(NEURONS-i)-9) + ":" + to_string(26*(NEURONS-i)-26) + "]);\n";
	}
	code += "		end\n";
	code += "	end\n";
	code += "end\n";


	code += "endmodule\n";


	//TestBench automated code goes here
	code_tb += "`timescale 1 ns/10ps\n";
	code_tb += "\n";

	code_tb += "module Image_Classifier_tb();\n";
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
	writeFile1.open("Image_Classifier1.v");
	writeFile2.open("Image_Classifier_tb.v");
	writeFile1 << code;
	writeFile2 << code_tb;
	writeFile1.close();
	writeFile2.close();
	return 0;

}
