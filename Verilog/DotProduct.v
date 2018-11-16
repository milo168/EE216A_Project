module DotProduct(
   input clk,
   input GlobalReset,
   input [18:0] Wgt_0_0,
   input [18:0] Wgt_0_1,
   input [18:0] Wgt_0_2,
   input [18:0] Wgt_0_3,
   input [18:0] Wgt_0_4,
   input [18:0] Wgt_0_5,
   input [18:0] Wgt_0_6,
   input [18:0] Wgt_0_7,
   input [18:0] Wgt_0_8,
   input [18:0] Wgt_0_9,
   input [9:0] Pix_0,
   input [9:0] Pix_1,
   input [9:0] Pix_2,
   input [9:0] Pix_3,
   input [9:0] Pix_4,
   input [9:0] Pix_5,
   input [9:0] Pix_6,
   input [9:0] Pix_7,
   input [9:0] Pix_8,
   input [9:0] Pix_9,
   output [26:0] value);
   
   reg[18:0] Wgt;
   reg[9:0] px;
   reg[25:0] FPMAns;
   reg[25:0] addInput1;
   reg[25:0] addInput2;
   reg[25:0] FPAAns;
   
   FixedPointMultiplier FPM1(.clk(clk),
                        .GlobalReset(GlobalReset),
                        .WeightPort(Wgt),
                        .PixelPort(px),
                        .Output_syn(FPMAns));
                        
   FixedPointAdder FPA1(.clk(clk),
                    .GlobalReset(GlobalReset),
                    .Port2(addInput2),
                    .Port1(addInput1),
                    .Output_syn(FPAAns));
   
   reg[3:0] multiplierCounter = 3'b000;
   reg adderCounter = 1'b0;
   
   always@(posedge clk)begin
       if(GlobalReset == 1'b1)begin
           Wgt <= 19'b0;
           px <= 10'b0;
           FPMAns <= 26'b0;
           addInput1 <= 26'b0;
           addInput2 <= 26'b0;
           FPAAns <= 26'b0;
       end
   end


endmodule