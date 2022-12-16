 `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jessica Quaye 
// 
// Create Date:    22:21:57 12/05/2018 
// Design Name: 
// Module Name:    params 
//////////////////////////////////////////////////////////////////////////////////

//Street Dimensions 
	parameter STREET_LEFTX = 11'd420;
	parameter STREET_RIGHTX = 11'd600;
	parameter STREET_VERT_MID = 11'd512;
	parameter STREET_TOPY = 10'd344;
	parameter STREET_BOTTOMY = 10'd464;
	parameter STREET_HORIZ_MID = 10'd402;
	
//Car Directions
	parameter MOVE_LEFT = 2'b01;
	parameter MOVE_RIGHT = 2'b00;
	parameter MOVE_UP = 2'b10;
	parameter MOVE_DOWN = 2'b11;

//General Constants	
	parameter TRUE = 1;
	parameter FALSE = 0;
	parameter ON = 1;
	parameter OFF = 0;
	
//Line Directions
	parameter VERTICAL = 1'b1;
	parameter HORIZONTAL = 1'b0;
	
//Traffic Light Colors
	 parameter RED = 2'b00;
	 parameter YELLOW = 2'b01;
	 parameter GREEN = 2'b10;
	 
//Traffic Light FSM States
	parameter MAIN_RED_SIDE_GREEN = 3'b000;
	parameter MAIN_RED_SIDE_YELLOW = 3'b001;
	parameter MAIN_GREEN_SIDE_RED = 3'b010;
	parameter MAIN_YELLOW_SIDE_RED = 3'b011;
	
//Screen Limits
	parameter SCREEN_Y_LIMIT = 10'd768;
	parameter SCREEN_X_LIMIT = 11'd1024;
	
//LED Strip States
	parameter SEND_START_FRAME = 3'b000;
	parameter SEND_FRAME = 3'b001;
	parameter SEND_BLANK_FRAME = 3'b010;
	parameter SEND_END_FRAME = 3'b011;
	parameter READ_TRAFFIC_SIGNALS = 3'b100;
	
//	Ambulance Speed
parameter CSPEED = 4'd10;


//Video Parameters
		parameter NUMBER_OF_FRAMES = 6'd20;		
		parameter NUM_FRAMES_X_LINES = 19'd491520; //24576*20frames
		parameter NUM_LINES_PER_FRAME = 19'd24576;
		
		//small frame params
				
		parameter FRAME_WIDTH = 11'd256;
		parameter FRAME_HEIGHT = 10'd192;
