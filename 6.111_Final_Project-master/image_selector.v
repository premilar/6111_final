`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Premila Rowles
// 
// Create Date:    14:35:44 11/19/2018 
// Design Name: 
// Module Name:    image_selector 
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
module image_selector(
    input [23:0] pixel,
    input is_blue,
	 input is_green,
    output [23:0] vga_pixel,
    output binarized_pixel
    );
	
		//assign pixels to be the color detected in hsv space and determined by the bounds of hue and value
		assign vga_pixel = is_blue ? 24'h0000FF : is_green ? 24'h00FF00 : pixel;

endmodule
