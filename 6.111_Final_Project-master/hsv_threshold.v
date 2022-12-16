`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Premila Rowles 
// 
// Create Date:    14:34:10 11/19/2018 
// Design Name: 
// Module Name:    hsv_threshold 
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module hsv_threshold
	#(parameter H_UPPER_BOUND = 24'hFFFFFF,
	H_LOWER_BOUND = 24'hFFFFFF, 
	S_UPPER_BOUND = 24'hFFFFFF,
	S_LOWER_BOUND = 24'hFFFFFF, 
	V_UPPER_BOUND = 24'hFFFFFF,
	V_LOWER_BOUND = 24'hFFFFFF, 
	CAR_UPPER_BOUND = 24'hFFA500, 
	CAR_LOWER_BOUND = 24'hFFA500)

	(input [23:0] rgb_pixel,
    input [23:0] hsv_pixel,
    output [23:0] pixel_out,
    output is_blue,
	 output is_green
    );
	 wire h_satisfied;
	 wire s_satisfied;
	 wire v_satisfied;
	
		
	 //pixels are assigned a color depending on upper and lower bounds of hue and value parameters
	assign is_blue = ((hsv_pixel[23:16] >= H_LOWER_BOUND_BLUE) && (hsv_pixel[23:16] <= H_UPPER_BOUND_BLUE)) && 
	((hsv_pixel[15:8] >= S_LOWER_BOUND_BLUE) && (hsv_pixel[15:8] <= S_UPPER_BOUND_BLUE)) &&
	                ((hsv_pixel[7:0] >= V_LOWER_BOUND_BLUE) && (hsv_pixel[7:0] <= V_UPPER_BOUND_BLUE));
						 
	assign is_green = ((hsv_pixel[23:16] >= H_LOWER_BOUND_GREEN) && (hsv_pixel[23:16] <= H_UPPER_BOUND_GREEN)) && 
	((hsv_pixel[15:8] >= S_LOWER_BOUND_GREEN) && (hsv_pixel[15:8] <= S_UPPER_BOUND_GREEN)) &&
	                ((hsv_pixel[7:0] >= V_LOWER_BOUND_GREEN) && (hsv_pixel[7:0] <= V_UPPER_BOUND_GREEN));
	//keep passing rgb pixel along so we can assign a pixel to either its rgb output or its hsv output
	assign pixel_out = rgb_pixel;
		
		

endmodule
