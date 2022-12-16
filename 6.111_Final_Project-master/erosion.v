`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kevin Zheng Class of 2012 
//           Dept of Electrical Engineering &  Computer Science
// 
// Create Date:    18:45:01 11/10/2010 
// Design Name: 
// Module Name:    erosion
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module erosion(
		input wire clock,
		input wire reset,
		input reg a8,
		input reg a7,
		input reg a6,
		input reg a5,
		input reg a4,
		input reg a3,
		input reg a2,
		input reg a1,
		input reg a0,
		input binarized_value,
		input reg [19:0] count,
		input reg [23:0] pixel_value,
		output reg pixel_eroded,
		output reg frame_end);

		reg [19:0] num_bits_per_frame; //345600


		always @ (posedge clock) begin

			//output if frame ended if we have counted total number of pixels in a frame

			if (count > 345600) frame_end <= 1;


			//pixel_eroded will be the first 3 elements of each line buffer to get a total of 
			//9 elements, we can logically 'and' these because the kernel is all 0's
			pixel_eroded <= (a8 & a7 & a6 & a5 & a4 & a3 & a2 
			& a1 & a0) ? 24'hFF0000 : pixel_value;//and 9 elements 			

		end
		
endmodule
