module Max
#(parameter NUM_SIZE = 26)
(
	input GlobalReset,
	input [NUM_SIZE*10-1:0] Num,
	output [3:0] Index
);

	reg [NUM_SIZE-1:0] max;
	reg [3:0] ind_o;

	Index = ind_o;

	always @* begin
		if(GlobalReset == 1'b1) begin
			max = 0;
			ind_o = 0;
		end
		else begin
			if(Num[NUM_SIZE*0 +: NUM_SIZE] > Num[NUM_SIZE*1 +: NUM_SIZE]) begin
				max = Num[NUM_SIZE*0 +: NUM_SIZE];
				ind_o = 0;
			end
			else begin
				max = Num[NUM_SIZE*1 +: NUM_SIZE];
				ind_o = 1;
			end

			if(Num[NUM_SIZE*2 +: NUM_SIZE] > max) begin
				max = Num[NUM_SIZE*2 +: NUM_SIZE];
				ind_o = 2;
			end

			if(Num[NUM_SIZE*3 +: NUM_SIZE] > max) begin
				max = Num[NUM_SIZE*3 +: NUM_SIZE];
				ind_o = 3;
			end

			if(Num[NUM_SIZE*4 +: NUM_SIZE] > max) begin
				max = Num[NUM_SIZE*4 +: NUM_SIZE];
				ind_o = 4;
			end

			if(Num[NUM_SIZE*5 +: NUM_SIZE] > max) begin
				max = Num[NUM_SIZE*5 +: NUM_SIZE];
				ind_o = 5;
			end

			if(Num[NUM_SIZE*6 +: NUM_SIZE] > max) begin
				max = Num[NUM_SIZE*6 +: NUM_SIZE];
				ind_o = 6;
			end

			if(Num[NUM_SIZE*7 +: NUM_SIZE] > max) begin
				max = Num[NUM_SIZE*7 +: NUM_SIZE];
				ind_o = 7;
			end

			if(Num[NUM_SIZE*8 +: NUM_SIZE] > max) begin
				max = Num[NUM_SIZE*8 +: NUM_SIZE];
				ind_o = 8;
			end

			if(Num[NUM_SIZE*9 +: NUM_SIZE] > max) begin
				max = Num[NUM_SIZE*9 +: NUM_SIZE];
				ind_o = 9;
			end
		end
	end