`define CLOG2(x) \
   (x <= 2) ? 1 : \
   (x <= 4) ? 2 : \
   (x <= 8) ? 3 : \
   (x <= 16) ? 4 : \
   (x <= 32) ? 5 : \
   (x <= 64) ? 6 : \
   (x <= 128) ? 7 : \
   (x <= 256) ? 8 : \
   (x <= 512) ? 9 : \
   (x <= 1024) ? 10 : \
   -1

module DotProductSt
#(parameter PIXEL_N = 10,
  parameter WEIGHT_SIZE = 19,
  parameter PIXEL_SIZE = 10,
  parameter FPM_DELAY = 6,
  parameter FPA_DELAY = 2,
  parameter PARALLEL = 2, 
  parameter BUS_WIDTH = 1,
  parameter VAL_SIZE = 26)
(
   input clk,
   input GlobalReset,
   input [BUS_WIDTH*PARALLEL*PIXEL_SIZE-1:0] Pixels,
   input [BUS_WIDTH*PARALLEL*WEIGHT_SIZE-1:0] Weights,
   output [VAL_SIZE-1:0] value
);

   integer  pix_ind [0:PARALLEL-1]; // index of pixel to do
   
   reg[WEIGHT_SIZE-1:0] mulWeight [0:PARALLEL-1];
   reg[PIXEL_SIZE-1:0]  mulPixel  [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPMAns    [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    addInput1 [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    addInput2 [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    addInput3 [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPAAns1   [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPAAns2   [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPAAns3   [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    sum1      [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    sum2      [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    sum3      [0:PARALLEL-1];

   reg[1:0] cnt3;
   reg[`CLOG2(BUS_WIDTH):0] width_cnt;

   reg[VAL_SIZE-1:0]    sum_o;
   integer h;

   assign value = sum_o;

   // output the sum of the inputs
   always @* begin
      sum_o = 0;
      for(h=0; h<PARALLEL; h=h+1)
         sum_o = sum_o + sum1[h] + sum2[h] + sum3[h];
   end
   
   // generate PARALLEL number of FPM and FPAs
   genvar i;
   for(i=0; i<PARALLEL; i=i+1) begin:fpgen
      FixedPointMultiplier FPM1(.clk(clk),
                                .GlobalReset(GlobalReset),
                                .WeightPort(mulWeight[i]),
                                .PixelPort(mulPixel[i]),
                                .Output_syn(FPMAns[i]));
                          
      FixedPointAdder      FPA1(.clk(clk),
                                .GlobalReset(GlobalReset),
                                .Port2(addInput1[i]),
                                .Port1(sum1[i]),
                                .Output_syn(FPAAns1[i]));
      FixedPointAdder      FPA2(.clk(clk),
                                .GlobalReset(GlobalReset),
                                .Port2(addInput2[i]),
                                .Port1(sum2[i]),
                                .Output_syn(FPAAns2[i]));
      FixedPointAdder      FPA3(.clk(clk),
                                .GlobalReset(GlobalReset),
                                .Port2(addInput3[i]),
                                .Port1(sum3[i]),
                                .Output_syn(FPAAns3[i]));

   end

   genvar j;
   for(j=0; j<PARALLEL; j=j+1) begin:alwaysgen
      always@(posedge clk, posedge GlobalReset)begin
         if(GlobalReset == 1'b1) begin
            // inputs to multipliers
            mulWeight[j] <= 0;
            mulPixel[j] <= 0;
            // inputs to adders
            addInput1[j] <= 0;
            addInput2[j] <= 0;
            addInput3[j] <= 0;

            sum1[j] <= 0;
            sum2[j] <= 0;
            sum3[j] <= 0;
            cnt3 <= 0;
            width_cnt <= 0;
            //$display("RESET AT: %g",$time);
         end
         else begin
            mulWeight[j] <= Weights[(j*WEIGHT_SIZE*BUS_WIDTH + width_cnt*WEIGHT_SIZE) +: WEIGHT_SIZE];
            mulPixel[j] <= Pixels [(j*PIXEL_SIZE*BUS_WIDTH + width_cnt*PIXEL_SIZE) +: PIXEL_SIZE];
            case(cnt3)
               0: begin
                  addInput1[j] <= FPMAns[j];
               end

               1: begin
                  addInput2[j] <= FPMAns[j];
               end

               2: begin
                  addInput3[j] <= FPMAns[j];
               end

               default: begin

               end // default:
            endcase
            sum1[j] <= FPAAns1[j];
            sum2[j] <= FPAAns2[j];
            sum3[j] <= FPAAns3[j];

            // increment cnt3
            if(cnt3 == 2)
               cnt3 <= 0;
            else
               cnt3 <= cnt3 + 1;

            // increment width_cnt
            if(width_cnt == BUS_WIDTH-1)
               width_cnt <= 0;
            else
               width_cnt <= width_cnt + 1;
         end
      end
   end

endmodule
