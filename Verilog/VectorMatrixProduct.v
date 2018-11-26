module VectorMatrixProduct
#(parameter PIXEL_N = 10,
  parameter WEIGHT_SIZE = 19,
  parameter PIXEL_SIZE = 10,
  parameter N = 10)
(
   input clk,
   input GlobalReset,
   input [PIXEL_N*PIXEL_SIZE-1:0] Pixels,
   input [PIXEL_N*WEIGHT_SIZE*N-1:0] Weights, // rows are length PIXEL_N, cols N
   output [25:0] value
);
   reg[25:0] vals [0:N-1];

   genvar i;
   for(i=0; i<N; i=i+1) begin:dpgen
      DotProduct DP(.clk(clk),
                    .GlobalReset(GlobalReset),
                    .Pixels     (Pixels),
                    .Weights    (Weights[(i+1)*PIXEL_SIZE*WEIGHT_SIZE-1:(i+1)*PIXEL_SIZE*WEIGHT_SIZE]),
                    .value      (vals[i])
                    );
   end


endmodule