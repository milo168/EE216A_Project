`timescale 1 ns/10 ps

module DotProduct_tb();
    reg clk;
    reg GlobalReset;
    wire[25:0] result;
    reg[18:0] A[0:9];
    reg[9:0] B[0:9];
    integer i;
    
    DotProduct DotProductTest(.clk(clk),
                            .GlobalReset(GlobalReset),
                            .A_0(A[0]), .A_1(A[1]), .A_2(A[2]), .A_3(A[3]), .A_4(A[4]),
                            .A_5(A[5]), .A_6(A[6]), .A_7(A[7]), .A_8(A[8]), .A_9(A[9]),
                            .B_0(B[0]), .B_1(B[1]), .B_2(B[2]), .B_3(B[3]), .B_4(B[4]),
                            .B_5(B[5]), .B_6(B[6]), .B_7(B[7]), .B_8(B[8]), .B_9(B[9]),
                            .value(result));
    
    parameter halfclock = 1;
    parameter fullclock = 2*halfclock;
    
    always #halfclock clk = ~clk;
    
    initial begin
       GlobalReset = 1'b1;
       clk = 1'b1;
       
       #halfclock;
       #fullclock GlobalReset = 1'b0; 
       
       for(i = 0; i < 10; i = i + 1)begin
          A[i] = 19'b010_0000_0000_0000_0000;
          B[i] = i;
       end
       
       for(i = 0; i < 32; i = i + 1)begin
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