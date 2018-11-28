module DotProductSt
#(parameter PIXEL_N = 10,
  parameter WEIGHT_SIZE = 19,
  parameter PIXEL_SIZE = 10,
  parameter FPM_DELAY = 6,
  parameter FPA_DELAY = 2,
  parameter PARALLEL = 1,
  parameter VAL_SIZE = 26)
(
   input clk,
   input GlobalReset,
   input [PIXEL_N*PIXEL_SIZE-1:0] Pixels,
   input [PIXEL_N*WEIGHT_SIZE-1:0] Weights,
   output [VAL_SIZE-1:0] value
);

   assign value = SOMETHING; // TODO

   // state bit declarations
   parameter MULT   = 3'b000;
   parameter MULT_W = 3'b010;
   parameter ADD    = 3'b011;
   parameter ADD_W  = 3'b011;
   parameter DONE   = 3'b100;

   reg[2:0] st_r    [0:PARALLEL-1];
   reg[3:0] m_w_cnt [0:PARALLEL-1]; // multiplier wait counter, 3 is a magic #
   reg[3:0] a_w_cnt [0:PARALLEL-1]; // adder wait counter, 3 is a magic #
   integer  pix_ind [0:PARALLEL-1]; // index of pixel to do
   
   reg[WEIGHT_SIZE-1:0] A        [0:PARALLEL-1];
   reg[PIXEL_SIZE-1:0]  B        [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    sum      [0:PARALLEL-1];
   reg[VAL_SIZE-1:0]    prevsum  [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPMAns   [0:PARALLEL-1];
   reg[2*VAL_SIZE-1:0]  addInput [0:PARALLEL-1];
   wire[VAL_SIZE-1:0]   FPAAns   [0:PARALLEL-1];
   
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
                                .Port2(addInput[i][2*VAL_SIZE-1:VAL_SIZE]),
                                .Port1(addInput[i][VAL_SIZE-1:0]),
                                .Output_syn(FPAAns[i]));
   end

   // NOTE: Might need to have GlobalReset be asserted for >2 clk cycles so prevsum is 0
   genvar k;
   for(k=0; k<PARALLEL; k=k+1) begin:prevsumgen
      always@(posedge clk, posedge GlobalReset) begin
         if(GlobalReset == 1'b1) begin
            prevsum[k] <= 0;
         else
            prevsum[k] <= sum;
         end
      end
   end

   genvar j;
   for(j=0; j<PARALLEL; j=j+1) begin:alwaysgen
      always@(posedge clk, posedge GlobalReset)begin
         if(GlobalReset == 1'b1) begin
            // inputs to multipliers
            A[j] <= 0;
            B[j] <= 0;
            // inputs to adders
            addInput[j][2*VAL_SIZE-1:VAL_SIZE] <= 0;
            addInput[j][VAL_SIZE-1:0]          <= 0;
            // delay counters
            m_w_cnt[j] <= 0;
            a_w_cnt[j] <= 0;
            // state
            st_r[j] <= MULT;
            pix_ind[j] <= j*PIXEL_N/PARALLEL;
            //$display("RESET AT: %g",$time);
         end
         else begin
            case(st_r[j])
               MULT: begin
                  A[j] <= Weights[pix_ind[j]*WEIGHT_SIZE +: WEIGHT_SIZE];
                  B[j] <= Pixels [pix_ind[j]*PIXEL_SIZE  +: PIXEL_SIZE];
                  st_r[j] <= MULT_W;
                  //$display("0 %g",$time);
               end
               MULT_W: begin
                  if(m_w_cnt < FPM_DELAY) begin
                     m_w_cnt <= m_w_cnt + 1;
                     st_r[j] <= MULT_W;
                  end
                  else
                     m_w_cnt <= 0;
                     st_r[j] <= ADD;
                  end
               end
               ADD: begin
                  addInput[j][2*VAL_SIZE-1:VAL_SIZE] <= prevsum;
                  addInput[j][2*VAL_SIZE-1:VAL_SIZE] <= FPMAns[j];
                  st_r[j] <= ADD_W;
               end
               ADD_W: begin
                  if(a_w_cnt < FPA_DELAY) begin
                     a_w_cnt <= a_w_cnt + 1;
                     st_r[j] <= MULT_A;
                  end
                  else
                     m_w_cnt <= 0;
                     if(pix_ind[j] < (j+1)*PIXEL_N/PARALLEL)
                        st_r[j] <= MULT;
                     else
                        st_r[j] <= DONE;
                     end
                  end
               end
               
               default: begin
                   A[j] <= A[j];
                   B[j] <= B[j];
                   //$display("def %g",$time);
               end
            endcase
         end
      end
   end


endmodule
