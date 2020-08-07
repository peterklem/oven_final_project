module Timer (output reg [6:0] Z1 , input clk, output reg [6:0] Z2, output reg [6:0] Z3, output reg [6:0] Z4);
	parameter MAX_COUNT = 25000000;
		
	reg [28:0] count = 0;
		
		
	reg new_clk;
		
	always @ (posedge clk) begin
		if (count <= MAX_COUNT) begin
			count <= count + 1;
		end else begin 
			count <= 0;
			new_clk <= ~new_clk;
		end
	end 
	
	reg [3:0] number = 0;
	reg [2:0] number2 = 1;
	reg [3:0] number3 = 0;
	reg [2:0] number4 = 0;
	
	
	always @ (posedge new_clk) begin : countdown
		if (number == 0 && number2 == 0 && number3 == 0 && number4 == 0) begin
			number <= 0;
			number2 <= 0;
			number3 <= 0;
			number4 <= 0;
		end else begin
			if (number == 0) begin
				number <= 9;
				number2 <= number2 - 1;
				if (number2 == 0) begin
					number2 <= 5;
						number3 <= number3 - 1;
					if (number3 == 0) begin
						number3 <= 9;
						number4 <= number4 - 1;
						if (number4 == 0) begin
							number4 <= 5;
						end
					end else begin
						number3 <= number3 - 1;
					end
				end else begin
					number2 <= number2 - 1;
				end
			end else begin
				number <= number - 1;
			end
		end
		
		
			

		
	end
	
	always @ (*) begin
			case (number) 
				0: begin
					Z1 = 7'b1000000;
				end
				1: begin
					Z1 = 7'b1111001;
				end
				2: begin
					Z1 = 7'b0100100;
				end
				3: begin
					Z1 = 7'b0110000;
				end
				4: begin
					Z1 = 7'b0011001;
				end
				5: begin
					Z1 = 7'b0010010;
				end
				6: begin
					Z1 = 7'b0000010;
				end
				7: begin
					Z1 = 7'b1111000;
				end
				8: begin
					Z1 = 7'b0000000;
				end
				9: begin
					Z1 = 7'b0010000;
				end
			endcase
		end
		
		always @ (*) begin
			case (number2)
				0: begin
					Z2 = 7'b1000000;
				end
				1: begin
					Z2 = 7'b1111001;
				end
				2: begin
					Z2 = 7'b0100100;
				end
				3: begin
					Z2 = 7'b0110000;
				end
				4: begin
					Z2 = 7'b0011001;
				end
				5: begin
					Z2 = 7'b0010010;
				end
			endcase
		end
		
		always @ (*) begin
			case (number3) 
				0: begin
					Z3 = 7'b1000000;
				end
				1: begin
					Z3 = 7'b1111001;
				end
				2: begin
					Z3 = 7'b0100100;
				end
				3: begin
					Z3 = 7'b0110000;
				end
				4: begin
					Z3 = 7'b0011001;
				end
				5: begin
					Z3 = 7'b0010010;
				end
				6: begin
					Z3 = 7'b0000010;
				end
				7: begin
					Z3 = 7'b1111000;
				end
				8: begin
					Z3 = 7'b0000000;
				end
				9: begin
					Z3 = 7'b0010000;
				end
			endcase
		end
		
		always @ (*) begin
			case (number4)
				0: begin
					Z4 = 7'b1000000;
				end
				1: begin
					Z4 = 7'b1111001;
				end
				2: begin
					Z4 = 7'b0100100;
				end
				3: begin
					Z4 = 7'b0110000;
				end
				4: begin
					Z4 = 7'b0011001;
				end
				5: begin
					Z4 = 7'b0010010;
				end
			endcase
		end


endmodule
