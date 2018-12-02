`timescale 1 ns/10 ps

module DotProductSt_tb();
    reg clk;
    reg GlobalReset;
    wire[25:0] result;
    reg[189:0] A;
    reg[99:0] B;
    integer i;
    integer j;
    wire[9:0] i_w;

    parameter PARALLEL = 1;
    
    DotProductSt #(
             .PIXEL_N(10),
             .WEIGHT_SIZE(19),
             .PIXEL_SIZE(10),
             .FPM_DELAY  (6),
             .FPA_DELAY  (2),
             .PARALLEL   (PARALLEL),
             .VAL_SIZE   (26))
             DotProductTest(.clk(clk),
                            .GlobalReset(GlobalReset),
                            .Pixels(B),
                            .Weights(A),
                            .value(result));
    
    parameter halfclock = 1;
    parameter fullclock = 2*halfclock;
    
    always #halfclock clk = ~clk;

    assign i_w = i;
    
    initial begin
       GlobalReset = 1'b1;
       clk = 1'b1;
       
       #halfclock;
       #fullclock GlobalReset = 1'b0; 
       
       for(i = 0; i < 10; i = i + 1)begin
          for(j = 0; j < PARALLEL; j = j + 1) begin

             A[j*19 +: 19] = 19'b010_0000_0000_0000_0000;
             B[j*10 +: 10] = i;
          #fullclock;
       end
       
       for(i = 0; i < 100; i = i + 1)begin
          $display("%b%b%b%b%b%b%b%b.%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b %b %d",
                result[25], result[24], result[23], result[22], 
                result[21], result[20], result[19], result[18],
                result[17], result[16], result[15], result[14],
                result[13], result[12], result[11], result[10],
                result[9], result[8], result[7], result[6],
                result[5], result[4], result[3], result[2], result[1],
                result[0], B[i], i);
          #fullclock; 
       end
       
       $stop;
    end
    
endmodule
