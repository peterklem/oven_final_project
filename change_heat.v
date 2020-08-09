module change_heat(	input clk, 
							input button1, //top
							input button2, //bottom
							input toggle_oven, //SW0, switches between clock and timer/heat
							input toggle_time_temp, //SW1, when oven is on it switches between time and temp
							input toggle_set, //SW2, changes setting vs viewing variables
							output reg [6:0] hex3, //most significant
							output reg [6:0] hex2, 
							output reg [6:0] hex1, 
							output reg [6:0] hex0, 
							output reg temp_reached, // temperature LED
							output timer_reached); // timer LED
	
	
	// REGISTERS AND PARAMETERS FOR THE OVEN HEAT PART
	// ==============================================================
	parameter MAX_COUNT_HEAT = 50000000; // Every 2 seconds
	reg [30:0] count = 0;
	reg new_clk;
	
	parameter BUTTON_LIM = 10000000; // Every less than a second
	reg [30:0] button_count = 0;
	reg button_clk;
	
	
	reg heat_val; // 1 if increasing, 0 if decreasing
	
	reg [9:0] updated_temp = 60; // Actual temperature
	reg [9:0] goal_temp = 300; // User input temperature
	
	reg [3:0] hex3_num = 0;
	reg [3:0] hex2_num = 3;
	reg [3:0] hex1_num = 0;
	reg [3:0] hex0_num = 0;
	
	// ==============================================================
	
	// REGISTERS FOR OVEN TIMER
	// ==============================================================
	parameter max_count_timer = 25000000;
	reg [28:0] count_timer = 0;
	reg timer_clk;
	
	reg[3:0] number;
	reg[2:0] number2;
	reg[3:0] number3;
	reg[2:0] number4;
	
	reg[3:0] num;
	reg[2:0] num2;
	reg[3:0] num3;
	reg[2:0] num4;
	
	reg [5:0] set_sec = 0;
	reg [5:0] set_min = 0;

	// ==============================================================
	

	
	// Button timer, heat clock, and timer/countup clock 
	always @ (posedge clk) begin
		// button
		if (button_count <= BUTTON_LIM) begin
			 button_count <= button_count + 1;
		end else begin 
			 button_count <= 0;
			 button_clk <= ~button_clk;
		end
		// heat
		if (count <= MAX_COUNT_HEAT) begin
			 count <= count + 1;
		end else begin 
			 count <= 0;
			 new_clk <= ~new_clk;
		end
		
		//timer/countup clock
		if (count_timer <= max_count_timer) begin
			count_timer <= count_timer + 1;
		end else begin 
			count_timer <= 0;
			timer_clk <= ~timer_clk;
		end
	end
	
	
	// User change temperature
	always @(posedge button_clk) begin
		if (toggle_time_temp == 0) begin // Looking at timer
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
		end else begin // looking at temperature
			if (toggle_set == 0) begin // toggle_set = 0 means we are setting temperature
				if (button1 == 0) begin // Increase 
					goal_temp = goal_temp + 5;
				end else if (button2 == 0) begin
					goal_temp = goal_temp - 5;
				end
			end
		end
		
	end
	
	// Update hex displays
	always @(*) begin
		if (toggle_time_temp == 1) begin 
			// Show temperature vals
			if (toggle_set == 0) begin // Setting temperature
				hex2_num = goal_temp / 100; 
				hex1_num = (goal_temp / 10) % 10;
				hex0_num = goal_temp % 10;
			end else begin
				hex2_num = updated_temp / 100; 
				hex1_num = (updated_temp / 10) % 10;
				hex0_num = updated_temp % 10;
			end
		end else begin
			// Timer values calculated from registers
			if (toggle_set == 0) begin
				hex0_num = num;
				hex1_num = num2;
				hex2_num = num3;
				hex3_num = num4;
			end else begin
				hex0_num = number;
				hex1_num = number2;
				hex2_num = number3;
				hex3_num = number4;
			end
		end
		// Display light for when oven is done preheating
		if (updated_temp > goal_temp - 2 && updated_temp < goal_temp + 2) begin
			temp_reached = 1; // Light on
		end else begin
			temp_reached = 0; // Light off
		end
	end
	
	// Toggle heat val
	always @(*) begin
		if (updated_temp < goal_temp) begin
			heat_val <= 1;
		end else begin
			heat_val <= 0;
		end
	end
	
	// Temp control
	always @(posedge new_clk) begin
			// Do nothing
		if (heat_val == 1) begin
			updated_temp <= updated_temp + 4;
		end else begin
			updated_temp <= updated_temp - 1;
		end
	end
	
	//Countdown 
	always @ (posedge timer_clk) begin
		if (toggle_set == 0) begin
			number = num;
			number2 = num2;
			number3 = num3;
			number4 = num4;
		end else if (toggle_set == 1) begin //Start timer
			if (number == 0 && number2 == 0 && number3 == 0 && number4 == 0) begin
					timer_reached <= 0;
					number <= 0;
					number2 <= 0;
					number3 <= 0;
					number4 <= 0;
			end else begin
				timer_reached <= 1;
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
	
	
	// Hex displays
	always @ (*) begin
		case (hex3_num) 
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
		
		case (hex2_num) 
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
		
		case (hex1_num) 
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
			 6: begin
				  hex1 = 7'b0000010;
			 end
			 7: begin
				  hex1 = 7'b1111000;
			 end
			 8: begin
				  hex1 = 7'b0000000;
			 end
			 9: begin
				  hex1 = 7'b0010000;
			 end
		endcase
		
		case (hex0_num) 
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



endmodule
