module DotProductSt
#(parameter PIXEL_N = 10,
  parameter WEIGHT_SIZE = 19,
  parameter PIXEL_SIZE = 10,
  parameter FPM_DELAY = 6,
  parameter FPA_DELAY = 2,
  parameter PARALLEL = 2, 
  parameter VAL_SIZE = 26)
(
   input clk,
   input GlobalReset,
   input [PIXEL_N*PIXEL_SIZE-1:0] Pixels,
   input [PIXEL_N*WEIGHT_SIZE-1:0] Weights,
   output [VAL_SIZE-1:0] value
);

   integer  pix_ind [0:PARALLEL-1]; // index of pixel to do
   
   reg[WEIGHT_SIZE-1:0] A        [0:PARALLEL-1];
   reg[PIXEL_SIZE-1:0]  B        [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPMAns   [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    addInput1 [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    addInput2 [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    addInput3 [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPAAns1  [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPAAns2  [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPAAns3  [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    sum1     [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    sum2     [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    sum3     [0:PARALLEL-1];

   integer cnt3;


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
                                .WeightPort(A[i]),
                                .PixelPort(B[i]),
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
            A[j] <= 0;
            B[j] <= 0;
            // inputs to adders
            addInput1[j] <= 0;
            addInput2[j] <= 0;
            addInput3[j] <= 0;

            sum1[j] <= 0;
            sum2[j] <= 0;
            sum3[j] <= 0;
            pix_ind[j] <= j*PIXEL_N/PARALLEL;
            cnt3 <= 0;
            //$display("RESET AT: %g",$time);
         end
         else begin
            if(pix_ind[j] >= (j+1)*PIXEL_N/PARALLEL) begin // FINISH
               A[j] <= 0;
               B[j] <= 0;
            end
            else begin
               A[j] <= Weights[pix_ind[j]*WEIGHT_SIZE +: WEIGHT_SIZE];
               B[j] <= Pixels [pix_ind[j]*PIXEL_SIZE  +: PIXEL_SIZE];
               pix_ind[j] = pix_ind[j] + 1;
            end
            case(cnt3)
               0: begin
                  addInput1[j] <= FPMAns[j];
               end // 0:

               1: begin
                  addInput2[j] <= FPMAns[j];
               end // 1:

               2: begin
                  addInput3[j] <= FPMAns[j];
               end // 2:

               default: begin

               end // default:
            endcase // pix_ind[j] % 3
            sum1[j] <= FPAAns1[j];
            sum2[j] <= FPAAns2[j];
            sum3[j] <= FPAAns3[j];
            if(cnt3 == 2)
               cnt3 <= 0;
            else
               cnt3 <= cnt3 + 1;
         end
      end
   end


endmodule
