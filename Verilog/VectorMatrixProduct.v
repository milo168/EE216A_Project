module VectorMatrixProduct
#(parameter PIXEL_N = 10, // number of pixels (785)
  parameter WEIGHT_SIZE = 19, // bit-width of weights
  parameter PIXEL_SIZE = 10,  // bit-width of pixels
  parameter N = 10) // Number of neurons
(
   input clk,
   input GlobalReset,
   input [PIXEL_N*PIXEL_SIZE-1:0] Pixels,
   // Weights input must be as follows for this to work:
   // Weights[  WEIGHT_SIZE*PIXEL_N-1 : 0]                   = [Wgt_0_784, Wgt_0_783, ... Wgt_0_1, Wgt_0_0]
   // Weights[2*WEIGHT_SIZE*PIXEL_N-1 : WEIGHT_SIZE*PIXEL_N] = [Wgt_1_784, Wgt_1_783, ... Wgt_1_1, Wgt_1_0]
   input [PIXEL_N*WEIGHT_SIZE*N-1:0] Weights, // rows are length PIXEL_N, cols N
   output [26*N-1:0] value
);
   reg[25:0] vals [0:N-1];

   genvar i;
   for(i=0; i<N; i=i+1) begin:dpgen
      DotProduct DP(.clk(clk),
                    .GlobalReset(GlobalReset),
                    .Pixels     (Pixels),
                    .Weights    (Weights[(i+1)*PIXEL_SIZE*WEIGHT_SIZE-1:i*PIXEL_SIZE*WEIGHT_SIZE]),
                    .value      (vals[i])
                    );
   end

   genvar j;
   for(j=0; j<N; j=j+1) begin:valgen
      value[(j+1)*26-1:j*26] = vals[j];
   end

endmodule
