module Timer (output reg [6:0] Z1 , input clk, output reg [6:0] Z2, output reg [6:0] Z3, output reg [6:0] Z4, input button1, input button2, input toggle_set);
	parameter max_count_timer = 25000000;
		
	reg [28:0] count = 0;
		
		
	reg new_clk;
	
	parameter BUTTON_LIM = 10000000; // Every less than a second
	reg [30:0] button_count = 0;
	reg button_clk;
	

		
		
	// Button timer
	always @ (posedge clk) begin
		if (button_count <= BUTTON_LIM) begin
			 button_count <= button_count + 1;
		end else begin 
			 button_count <= 0;
			 button_clk <= ~button_clk;
		end
	end



	
	always @ (posedge clk) begin
		if (count <= max_count_timer) begin
			count <= count + 1;
		end else begin 
			count <= 0;
			new_clk <= ~new_clk;
		end
	end 
	
	reg [5:0] set_sec = 0;
	reg [5:0] set_min = 0;
	reg [3:0] hex0;
	reg [2:0] hex1;
	reg [3:0] hex2;
	reg [2:0] hex3;
	
	reg[3:0] number;
	reg[2:0] number2;
	reg[3:0] number3;
	reg[2:0] number4;
	
	reg[3:0] num;
	reg[2:0] num2;
	reg[3:0] num3;
	reg[2:0] num4;
	
	
	//Setup
	always @(posedge button_clk) begin
		if(toggle_set == 0) begin // set Time
			if (button1 == 0) begin
				if (set_sec >= 55) begin
					set_sec = 0;
					set_min = set_min + 1;
					num3 = set_min % 10;
					num4 = set_min / 10;
				end else begin
					set_sec = set_sec + 5;
					num = set_sec % 10;
					num2 = set_sec / 10;
				end
			end else if (button2 == 0) begin
				if (set_sec == 0) begin
					set_min = set_min - 1;
					num3 = set_min % 10;
					num4 = set_min / 10;
					set_sec = 60;
				end else begin
					set_sec = set_sec - 5;
					num = set_sec % 10;
					num2 = set_sec / 10;
				end
			end
		end
	end
	
	//Countdown 
	always @ (posedge new_clk) begin
		if (toggle_set == 0) begin
			number = num;
			number2 = num2;
			number3 = num3;
			number4 = num4;
		end else if (toggle_set == 1) begin //Start timer
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
	end
	
	//Update hex display
	
	always @ (*) begin
		if (toggle_set == 0) begin
			hex0 = num;
			hex1= num2;
			hex2 = num3;
			hex3 = num4;
		end else begin
			hex0 = number;
			hex1 = number2;
			hex2 = number3;
			hex3 = number4;
		end
	end

	
	
	
	
	
	
	always @ (*) begin
			case (hex0) 
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
			case (hex1)
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
			case (hex2) 
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
			case (hex3)
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
