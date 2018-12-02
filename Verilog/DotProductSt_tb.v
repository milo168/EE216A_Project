`timescale 1 ns/10 ps

module DotProductSt_tb();

    parameter PIXEL_N = 10;
    parameter WEIGHT_SIZE = 19;
    parameter PIXEL_SIZE = 10;
    parameter FPM_DELAY = 6;
    parameter FPA_DELAY = 2;
    parameter PARALLEL = 1;
    parameter BUS_WIDTH = 1;
    parameter VAL_SIZE = 26;

    reg clk;
    reg GlobalReset;
    wire[VAL_SIZE-1:0] result;
    reg[BUS_WIDTH*PARALLEL*WEIGHT_SIZE-1:0] A;
    reg[BUS_WIDTH*PARALLEL*PIXEL_SIZE-1:0] B;
    reg[PIXEL_N*PIXEL_SIZE-1:0] Pixels;
    reg[PIXEL_N*WEIGHT_SIZE-1:0] Weights;
    integer i;
    integer j;
    integer k;

    DotProductSt #(
       .PIXEL_N(PIXEL_N),
       .WEIGHT_SIZE(WEIGHT_SIZE),
       .PIXEL_SIZE(PIXEL_SIZE),
       .FPM_DELAY  (FPM_DELAY),
       .FPA_DELAY  (FPA_DELAY),
       .PARALLEL   (PARALLEL),
       .BUS_WIDTH  (BUS_WIDTH),
       .VAL_SIZE   (VAL_SIZE))
    DotProductTest(.clk(clk),
        .GlobalReset(GlobalReset),
        .Pixels(B),
        .Weights(A),
        .value(result));
    
    parameter halfclock = 1;
    parameter fullclock = 2*halfclock;
    
    always #halfclock clk = ~clk;
    
    initial begin
        GlobalReset = 1'b1;
        clk = 1'b1;

        #halfclock;
        #fullclock GlobalReset = 1'b0;
        for(i = 0; i < PIXEL_N; i = i + 1) begin
            Pixels[i*PIXEL_SIZE +: PIXEL_SIZE] = i;
            Weights[i*WEIGHT_SIZE +: WEIGHT_SIZE] = 19'b010_0000_0000_0000_0000;
        end

        i = 0;
	while(i < PIXEL_N) begin
            for(j = 0; j < PARALLEL; j = j + 1) begin
                for(k = 0; k < BUS_WIDTH; k = k + 1) begin
                    if(i < PIXEL_N) begin
                        A[(j*WEIGHT_SIZE + k*WEIGHT_SIZE) +: WEIGHT_SIZE] = Weights[i*WEIGHT_SIZE +: WEIGHT_SIZE];
                        B[(j*PIXEL_SIZE + k*PIXEL_SIZE) +: PIXEL_SIZE] = Pixels[i*PIXEL_SIZE +: PIXEL_SIZE];
                        i = i + 1;
                    end
                    else begin
                        A[(j*WEIGHT_SIZE + k*WEIGHT_SIZE) +: WEIGHT_SIZE] = 0;
                        B[(j*PIXEL_SIZE + k*PIXEL_SIZE) +: PIXEL_SIZE] = 0;
                    end
                end
            end
            #(BUS_WIDTH*fullclock);
        end

        A = 0;
        B = 0;

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
