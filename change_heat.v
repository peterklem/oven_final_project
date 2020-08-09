module change_heat( input clk, // clk
                    input button1, //top button
                    input button2, //bottom buton
                    input toggle_oven, // S0, turns oven on and off 
                    input toggle_time_temp, // S1, switches between 
                    input toggle_set, //S2, switches between settings with either temperature or timer
                    output reg [6:0] hex3, //most significant digit
                    output reg [6:0] hex2, 
                    output reg [6:0] hex1, 
                    output reg [6:0] hex0, //least significant digit
                    output reg temp_reached, // 
                    output reg timer_reached);
	
	
	parameter MAX_COUNT = 50000000; // Every 2 seconds
	reg [30:0] count = 0;
	reg new_clk;
	
	parameter BUTTON_LIM = 10000000; // Every less than a second
	reg [30:0] button_count = 0;
	reg button_clk;
	
	
	reg heat_val; // 1 if increasing, 0 if decreasing
	
	reg [9:0] updated_temp = 60; // Actual temperature
	reg [9:0] goal_temp = 300; // User input temperature
	
	reg [3:0] hex2_num = 3;
	reg [3:0] hex1_num = 0;
	reg [3:0] hex0_num = 0;
	
	// Button timer
	always @ (posedge clk) begin
		if (button_count <= BUTTON_LIM) begin
			 button_count <= button_count + 1;
		end else begin 
			 button_count <= 0;
			 button_clk <= ~button_clk;
		end
	end
	
	// Count clock for hexadecimal displays
	always @ (posedge clk) begin
		if (count <= MAX_COUNT) begin
			 count <= count + 1;
		end else begin 
			 count <= 0;
			 new_clk <= ~new_clk;
		end
	end
	
	// User change temperature
	always @(posedge button_clk) begin
		if (toggle_set == 0) begin // toggle_set = 0 means we are setting temperature
			if (button1 == 0) begin // Increase 
				goal_temp = goal_temp + 5;
			end else if (button2 == 0) begin
				goal_temp = goal_temp - 5;
			end
		end
	end
	
	// Update hex displays
	always @(*) begin
		if (toggle_set == 0) begin // Setting temperature
			hex2_num = goal_temp / 100; 
			hex1_num = (goal_temp / 10) % 10;
			hex0_num = goal_temp % 10;
		end else begin
			hex2_num = updated_temp / 100; 
			hex1_num = (updated_temp / 10) % 10;
			hex0_num = updated_temp % 10;
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
	
	// Hex displays
	always @ (*) begin
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
