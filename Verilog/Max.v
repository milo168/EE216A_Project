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

			genvar i;
			for(i=2; i<10; i=i+1) begin:ifgen
				if(Num[NUM_SIZE*i +: NUM_SIZE] > max) begin
					max = Num[NUM_SIZE*i +: NUM_SIZE];
					ind_o = 2;
				end
			end
		end
	end