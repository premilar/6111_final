`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kevin Zheng Class of 2012 
//           Dept of Electrical Engineering &  Computer Science
// 
// Create Date:    18:45:01 11/10/2010 
// Design Name: 
// Module Name:    erosion
//////////////////////////////////////////////////////////////////////////////////
module erosion_shift(
		input wire clock,
		input wire reset,
		input reg binarized_value,
		input reg  [23:0] pixel_value,
		output reg [19:0] count_out,
		output reg [23:0] pixel_out,

		output reg  a8,
		output reg  a7,
		output reg  a6,
		output reg  a5,
		output reg  a4,
		output reg  a3,
		output reg  a2,
		output reg  a1,
		output reg  a0);
		
		reg buffer_one [699:0];
		reg buffer_two [699:0];
		reg pixel_buffer [702:0];
		reg buffer_three [2:0];
		reg [19:0] num_bits_per_frame; //345600
		reg [19:0] count;
		always @ (posedge clock) begin

			count_out <= count + 1;
			// new_pixel <= {h,s,v};
			buffer_one <= {binarized_value, buffer_one[699:1]};
			buffer_two <= {buffer_one[0], buffer_one[699:1]};
			buffer_three <= {buffer_two[0], buffer_one[2:1]};
			
			//shift pixel values in
			pixel_buffer <= {pixel_value,pixel_buffer[701:1]};
			pixel_out <= pixel_buffer[0];

			a8 <= buffer_one [639];
			a7 <= buffer_one [638];
			a6 <= buffer_one [637];
			a5 <= buffer_two [639];
			a4 <= buffer_two [638];
			a3 <= buffer_two [637];
			a2 <= buffer_three [2];
			a1 <= buffer_three [1];
			a0 <= buffer_three [0];
		end
endmodule
