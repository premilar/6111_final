`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jessica Quaye 
// Create Date:    13:07:07 11/05/2018 
// Design Name: 
// Module Name:    divider 
//////////////////////////////////////////////////////////////////////////////////

//assumes use of 65MHz clock, creates one second pulse each second
module clock_divider(
    input clk,
    output reg one_hz_enable );
	 
	 reg [25:0] counter = 26'b0;
	 
	 always @ (posedge clk) begin
		counter <= counter + 1;
		//generate 1hz signal
		if (counter == 26'd65_000_000 - 1) 
			begin 
				counter <= 0;
				one_hz_enable <= 1;
			end
		else one_hz_enable <= 0;		
	 end

endmodule

//creates 50% duty cycle 1mhz clock 
module led_divider(
    input clk,
    output reg one_mhz_enable
    );
	 
	 reg [5:0] counter = 6'b0;
	 
	 always @ (posedge clk) begin
		counter <= counter + 1;
		if (counter[5] == 1'b1) begin //send a clock when the 2**6 bit is 1
			one_mhz_enable <= 1;
		end
		
		else one_mhz_enable <= 0;
	 end


endmodule

