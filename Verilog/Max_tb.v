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
       
       for(i = 0; i < 10; i = i + 1)begin
          Nums[i*26 +: 26] = i;
       end
       $display("%d", result);
       #fullclock;
       $display("%d", result);

       $stop;
    end
    
endmodule
