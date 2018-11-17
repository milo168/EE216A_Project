module DotProduct(
   input clk,
   input GlobalReset,
   input [18:0] A_0,
   input [18:0] A_1,
   input [18:0] A_2,
   input [18:0] A_3,
   input [18:0] A_4,
   input [18:0] A_5,
   input [18:0] A_6,
   input [18:0] A_7,
   input [18:0] A_8,
   input [18:0] A_9,
   input [9:0] B_0,
   input [9:0] B_1,
   input [9:0] B_2,
   input [9:0] B_3,
   input [9:0] B_4,
   input [9:0] B_5,
   input [9:0] B_6,
   input [9:0] B_7,
   input [9:0] B_8,
   input [9:0] B_9,
   output [25:0] value);
   
   reg[18:0] A;
   reg[9:0] B;
   reg[25:0] intermediateAdds[0:4];
   wire[25:0] FPMAns;
   reg[25:0] addInput [0:1];
   wire[25:0] FPAAns;
   assign value = intermediateAdds[4];
   
   FixedPointMultiplier FPM1(.clk(clk),
                        .GlobalReset(GlobalReset),
                        .WeightPort(A),
                        .PixelPort(B),
                        .Output_syn(FPMAns));
                        
   FixedPointAdder FPA1(.clk(clk),
                    .GlobalReset(GlobalReset),
                    .Port2(addInput[1]),
                    .Port1(addInput[0]),
                    .Output_syn(FPAAns));
   
   reg[4:0] switchCounter = 5'b0000;
   
   always@(posedge clk)begin
       if(GlobalReset == 1'b1)begin
           A <= A_0;
           B <= B_0;
           addInput[0] <= 26'b0;
           addInput[1] <= 26'b0;
           switchCounter <= 5'b00000;
           intermediateAdds[0] = 26'b0;
           intermediateAdds[1] = 26'b0;
           intermediateAdds[2] = 26'b0;
           intermediateAdds[3] = 26'b0;
           intermediateAdds[4] = 26'b0;
           //$display("RESET AT: %g",$time);
       end else begin
           case(switchCounter)
               0: begin
                   A <= A_0;
                   B <= B_0;
                   //$display("0 %g",$time);
               end
               1: begin
                   A <= A_1;
                   B <= B_1; 
                   //$display("1 %g",$time);
               end
               2: begin
                   A <= A_2;
                   B <= B_2; 
                   //$display("2 %g",$time);
               end
               3: begin
                   A <= A_3;
                   B <= B_3; 
                  //$display("3 %g",$time);
               end
               4: begin
                   A <= A_4;
                   B <= B_4; 
                   //$display("4 %g",$time);
               end
               5: begin
                   A <= A_5;
                   B <= B_5; 
                   //$display("5 %g",$time);
               end
               6: begin
                   A <= A_6;
                   B <= B_6; 
                   //$display("6 %g",$time);
               end
               7: begin
                   A <= A_7;
                   B <= B_7; 
                   //$display("7 %g",$time);
               end
               8: begin
                   A <= A_8;
                   B <= B_8; 
                   //$display("8 %g",$time);
               end
               9: begin
                   A <= A_9;
                   B <= B_9; 
                   //$display("9 %g",$time);
               end
               default: begin
                   A <= A;
                   B <= B;
                   //$display("def %g",$time);
               end
           endcase
           
           
           //Put the result from multiplier to adder
           if(switchCounter <= 5'd16 && switchCounter >= 5'd7 && switchCounter % 2'd2 == 1'd0)begin
              addInput[0] <= FPMAns; 
           end else if(switchCounter <= 5'd16 && switchCounter >= 5'd7 && switchCounter % 2'd2 == 1'd1)begin
              addInput[1] <= FPMAns; 
           end
           
           //Funky adder hiearchy
           if(switchCounter == 5'd18)begin
              addInput[0] <= intermediateAdds[0];
              addInput[1] <= intermediateAdds[1];
           end else if(switchCounter == 5'd20)begin
              addInput[0] <= intermediateAdds[2];
              addInput[1] <= intermediateAdds[3]; 
           end else if(switchCounter == 5'd22)begin
               addInput[0] <= intermediateAdds[0];
               addInput[1] <= intermediateAdds[4];
           end else if(switchCounter == 5'd26)begin
               addInput[0] <= intermediateAdds[1]; 
               addInput[1] <= intermediateAdds[2];
           end else if(switchCounter == 5'd29)begin
               switchCounter <= 5'd0;
           end
           
           //Store the results from the adds
           if(switchCounter >= 5'd11 && (switchCounter - 5'd11) % 2'd2 == 1'd0)begin
               intermediateAdds[(switchCounter - 5'd11) % 5'd10 >> 1'd1] <= FPAAns;
           end
           
           
           switchCounter <= switchCounter + 1;
           
       end
   end


endmodule