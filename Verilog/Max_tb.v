`timescale 1 ns/10 ps

module Max_tb();
    reg clk;
    reg GlobalReset;
    wire[3:0] result;
    reg[259:0] Nums;
    integer i;
    
    Max MaxTest(.GlobalReset(GlobalReset),
                .Num(Nums),
                .Index(result));
    
    parameter halfclock = 1;
    parameter fullclock = 2*halfclock;
    
    always #halfclock clk = ~clk;
    
    initial begin
       GlobalReset = 1'b1;
       clk = 1'b1;
       
       #halfclock;
       #fullclock GlobalReset = 1'b0; 
       
       Nums[0*26 +: 26] = -10;
       Nums[1*26 +: 26] = -15;
       Nums[2*26 +: 26] = -2;
       Nums[3*26 +: 26] = -100;
       Nums[4*26 +: 26] = -30;
       Nums[5*26 +: 26] = -10000;
       Nums[6*26 +: 26] = -200;
       Nums[7*26 +: 26] = -301234;
       Nums[8*26 +: 26] = -1;
       Nums[9*26 +: 26] = -69;
       
       $display("%d", result);
       #fullclock;
       $display("%d", result);

       $stop;
    end
    
endmodule
