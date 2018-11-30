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
       GlobalReset = 1'b0;
       clk = 1'b1;
       
       #halfclock;
       #fullclock GlobalReset = 1'b1; 
       
       /*Nums[0*26 +: 26] = -10;
       Nums[1*26 +: 26] = -15;
       Nums[2*26 +: 26] = -2;
       Nums[3*26 +: 26] = -100;
       Nums[4*26 +: 26] = -30;
       Nums[5*26 +: 26] = -10000;
       Nums[6*26 +: 26] = 200;
       Nums[7*26 +: 26] = -301234;
       Nums[8*26 +: 26] = -10000;
       Nums[9*26 +: 26] = -69;*/
       
       Nums[259:234]   = 26'b00000000001110010010000000;
       Nums[233:208]   = 26'b00000000000110000110001010;
       Nums[207:182]   = 26'b00000000001001001101000010;
       Nums[181:156]   = 26'b00000000000111000000011010;
       Nums[155:130]   = 26'b11111111111110100111111011;
       Nums[129:104]   = 26'b00000000001110100000111000;
       Nums[103:78]    = 26'b11111111110100100100111001;
       Nums[77:52]     = 26'b00000000001010100101110010;
       Nums[51:26]     = 26'b00000000000111111011110110;
       Nums[25:0]      = 26'b00000000000111110100111011;
       
       $display("%d outer", result);
       #fullclock;
       $display("%d outer2", result);

       $stop;
    end
    
endmodule
