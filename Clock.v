module Clock (  output reg [6:0] hex0 , // hex0
                input clk, 
                output reg [6:0] hex1, //hex1
                output reg [6:0] hex2, //hex2
                output reg [6:0] hex3); //hex3


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
		reg [2:0] number2 = 0;
		reg [3:0] number3 = 0;
		reg [2:0] number4 = 0;
		
		always @ (posedge new_clk) begin
			if (number >= 9) begin
				number <= 0;
				number2 <= number2 + 1;
				if (number2 >= 5) begin
					number2 <= 0;
					number3 <= number3 +1;
					if (number3 >= 9) begin
						number3 <= 0;
						number4 <= number4 + 1;
						if (number4 >= 5) begin
							number4 <= 0;
						end
					end else begin
						number3 <= number3 + 1;
					end
				end else begin
					number2 <= number2 + 1;
				end
			end else begin
				number <= number + 1;
			end
		end
		
		always @ (*) begin
			case (number) 
				0: begin
					hex0 = 7'b1000000;
				end
				1: begin
					hex0 = 7'b1111001;
				end
				2: begin
					hex0 = 7'b0100100;
				end
				3: begin
					hex0 = 7'b0110000;
				end
				4: begin
					hex0 = 7'b0011001;
				end
				5: begin
					hex0 = 7'b0010010;
				end
				6: begin
					hex0 = 7'b0000010;
				end
				7: begin
					hex0 = 7'b1111000;
				end
				8: begin
					hex0 = 7'b0000000;
				end
				9: begin
					hex0 = 7'b0010000;
				end
			endcase
		end
		
		always @ (*) begin
			case (number2)
				0: begin
					hex1 = 7'b1000000;
				end
				1: begin
					hex1 = 7'b1111001;
				end
				2: begin
					hex1 = 7'b0100100;
				end
				3: begin
					hex1 = 7'b0110000;
				end
				4: begin
					hex1 = 7'b0011001;
				end
				5: begin
					hex1 = 7'b0010010;
				end
			endcase
		end
		
		always @ (*) begin
			case (number3) 
				0: begin
					hex2 = 7'b1000000;
				end
				1: begin
					hex2 = 7'b1111001;
				end
				2: begin
					hex2 = 7'b0100100;
				end
				3: begin
					hex2 = 7'b0110000;
				end
				4: begin
					hex2 = 7'b0011001;
				end
				5: begin
					hex2 = 7'b0010010;
				end
				6: begin
					hex2 = 7'b0000010;
				end
				7: begin
					hex2 = 7'b1111000;
				end
				8: begin
					hex2 = 7'b0000000;
				end
				9: begin
					hex2 = 7'b0010000;
				end
			endcase
		end
		
		always @ (*) begin
			case (number4)
				0: begin
					hex3 = 7'b1000000;
				end
				1: begin
					hex3 = 7'b1111001;
				end
				2: begin
					hex3 = 7'b0100100;
				end
				3: begin
					hex3 = 7'b0110000;
				end
				4: begin
					hex3 = 7'b0011001;
				end
				5: begin
					hex3 = 7'b0010010;
				end
			endcase
		end
		
					
	
endmodule
