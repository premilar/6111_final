`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jessica Quaye
// 
// Create Date:    19:17:09 11/12/2018 
// Design Name: 
// Module Name:    visualization 
//////////////////////////////////////////////////////////////////////////////////


//draws vertical line on the screen
module vertical_line
	#(parameter COLOR = 24'hFF_FF_FF)
	 (input [10:0] x,hcount,
    input [9:0] y,vcount,
	 input [9:0] y_length,
	 input [9:0] thickness,
    output reg [23:0] pixel);
	 
	 always @ * begin
		 if ( (hcount >= x && hcount <= (x+thickness)) && (vcount >= y && vcount <= (y + y_length + thickness)) ) pixel = COLOR; //we are at the same x but same or greater y
		 else pixel = 0;
	 end //end always
endmodule

//draws dotted vertical line on screen
module vertical_dotted
	#(parameter WIDTH = 3,         
               COLOR = 24'hFF_FF_FF)
	(input [10:0] x,hcount,
    input [9:0] y,vcount,
    output reg [23:0] pixel);

	 always @ * begin
		if ((hcount >= x && hcount < (x+WIDTH)) && 
		   (vcount >= 0 && vcount <= 64 |
			 vcount >= 128 && vcount <= 192 |
			 vcount >= 256 && vcount <= 320 |
			 vcount >= 512 && vcount <= 576 |
			 vcount >= 640 && vcount <= 704 )) pixel = COLOR;
		else pixel = 0;			 
	 end //end always 
	 
endmodule

//draws horizontal line on screen
module horizontal_line
	#(parameter COLOR = 24'hFF_FF_FF) 
	 (input [10:0] x,hcount,
    input [9:0] y,vcount,
	 input [10:0] x_length,
	 input [10:0] thickness,
    output reg [23:0] pixel);
	 
	 always @ * begin
		 if ((vcount >= y && vcount <= (y + thickness)) && (hcount >= x && hcount <= (x + x_length + thickness))) pixel = COLOR; //we are at the same x but same or greater y
		 else pixel = 0;
	 end //end always
endmodule 

//draws dotted horizontal line on screen
module horizontal_dotted
	#(parameter HEIGHT = 10,        
               COLOR = 24'hFF_FF_FF)
	(input [10:0] x,hcount,
    input [9:0] y,vcount,
    output reg [23:0] pixel);

	 always @ * begin
		if ((vcount >= y && vcount < (y+HEIGHT)) && 
		   (hcount >= 0 && hcount <= 128 |
			 hcount >= 256 && hcount <= 384 |
			 hcount >= 620 && hcount <= 748 |
			 hcount >= 876 && hcount <= 1004 )) pixel = COLOR;
		else pixel = 0;			 
	 end //end always 
	 
endmodule

//draws traffic light given color that should be turned on
module draw_traffic_light
	(input clk,
	 input [10:0] x,hcount,
    input [9:0] y,vcount,
	 input [1:0] signal,
	 input orientation,
    output reg [23:0] traffic_pixel);
	 
	 `include "params.v"
	 
	 reg [15:0] image_addr; //num of bits for 8*6000 ROM
	 wire [7:0] image_bits, red_mapped, green_mapped, blue_mapped;
	
	//vertical w = 68, h = 180
	
	wire[10:0] WIDTH = (orientation == VERTICAL) ?  11'd68 : 11'd180 ;
	wire[9:0]HEIGHT = (orientation == VERTICAL) ?  10'd180 : 10'd68;

	always @ (posedge clk) begin
		case(orientation) 
			VERTICAL: begin
				image_addr <= (hcount-x + 3) + (vcount-y) * WIDTH;
				end
			HORIZONTAL: begin //rotate 90deg
				image_addr <= (HEIGHT - (vcount-y)) +  (WIDTH- (hcount - x))* HEIGHT;
				end
		endcase
	 end
	 
	 traffic_image_rom  traffic_rom(.clka(clk), .addra(image_addr), .douta(image_bits));
	 
   // use color map to create 8bits R, 8bits G, 8 bits B;
   traffic_red_coe traffic_rcm (.clka(clk), .addra(image_bits), .douta(red_mapped));
   traffic_green_coe traffic_gcm (.clka(clk), .addra(image_bits), .douta(green_mapped));
   traffic_blue_coe traffic_bcm (.clka(clk), .addra(image_bits), .douta(blue_mapped));
	
	always @(posedge clk) begin
	
     if ((hcount >= x && hcount < (x+WIDTH)) &&
          (vcount >= y && vcount < (y+HEIGHT)))
				 begin
				 if (signal == RED) begin
					//yellow off and green off 
					if ((red_mapped > 8'd200) && (green_mapped > 8'd100)) traffic_pixel <= {8'd170, 8'd170, 8'd170}; //yellow off
					else if (green_mapped > 8'd150) traffic_pixel <= {8'd170, 8'd170, 8'd170}; //green off 
					else traffic_pixel <= {red_mapped, green_mapped, blue_mapped};
				 end
				 
				 if (signal == YELLOW) begin
					//red off and green off
					if ((red_mapped > 8'd200) && (green_mapped < 8'd90)) traffic_pixel <= {8'd170, 8'd170, 8'd170}; //red off 
					else if (green_mapped > 8'd150 && (red_mapped < 8'd90)) traffic_pixel <= {8'd170, 8'd170, 8'd170}; //green off
					else traffic_pixel <= {red_mapped, green_mapped, blue_mapped};
				 end
				 
				 if (signal == GREEN) begin
					//red off, yellow off
					if ((red_mapped > 8'd200) && (green_mapped < 8'd100)) traffic_pixel <= {8'd170, 8'd170, 8'd170}; // red off
					else if ((red_mapped > 8'd200) && (green_mapped > 8'd100)) traffic_pixel <= {8'd170, 8'd170, 8'd170}; //yellow off
					else traffic_pixel <= {red_mapped, green_mapped, blue_mapped};
				 end
			end
     else traffic_pixel <= 0;
	end
	 

endmodule

//draws street on screen
module draw_street
( input clk,
  input[10:0]hcount, 
  input[9:0] vcount,
  output [23:0] street_pixel);
  
  `include "params.v"
  
	 //DRAW MAIN ROAD
  	 //generate left line
		wire [23:0] left_line_pixel;
		vertical_line #(.COLOR(24'hFF_FF_FF))
		  left_line(.x(11'd424),.y(10'd0),.hcount(hcount),.vcount(vcount), .y_length(SCREEN_Y_LIMIT), .thickness(11'd0),//x = (1024/2) - width/2, y = (768/2) - height/2
					 .pixel(left_line_pixel));
					 
	//generate right line
		wire [23:0] right_line_pixel;
		vertical_line #(.COLOR(24'hFF_FF_FF))
		  right_line(.x(11'd600),.y(10'd0),.hcount(hcount),.vcount(vcount), .y_length(SCREEN_Y_LIMIT), .thickness(11'd0),//x = (1024/2) - width/2, y = (768/2) - height/2
					 .pixel(right_line_pixel));
					 
	//generate mid dotted vertical line
	wire [23:0] vert_mid_dot_pixel;
	vertical_dotted #(.WIDTH(4), .COLOR(24'hFF_FF_FF))
		mid_dot(.x(11'd512),.y(10'd0),.hcount(hcount),.vcount(vcount), //x = (right-left/2) - width/2
					 .pixel(vert_mid_dot_pixel));
					 
	//DRAW SIDE ROAD				 
	//generate top line 
	wire [23:0] top_line_pixel;
	horizontal_line #(.COLOR(24'hFF_FF_FF))
		 top_line(.x(11'd0),.y(10'd344),.hcount(hcount),.vcount(vcount), .x_length(SCREEN_X_LIMIT), .thickness(11'd0),//y = (right-left/2) - width/2
					 .pixel(top_line_pixel));
					 
	//generate bottom line
	wire [23:0] bottom_line_pixel;
	horizontal_line #(.COLOR(24'hFF_FF_FF))
		 bottom_line(.x(11'd0),.y(10'd464),.hcount(hcount),.vcount(vcount), .x_length(SCREEN_X_LIMIT), .thickness(11'd0),//y = (right-left/2) - width/2
					 .pixel(bottom_line_pixel));
	
	//generate mid dotted horizontal line
	wire [23:0] horiz_mid_dot_pixel;
	horizontal_dotted #(.HEIGHT(4),.COLOR(24'hFF_FF_FF))
		 horiz_mid_dot(.x(11'd0),.y(10'd402),.hcount(hcount),.vcount(vcount), //y = (top-bottom/2) - height/2
					 .pixel(horiz_mid_dot_pixel));
					 
	assign street_pixel = left_line_pixel | vert_mid_dot_pixel | right_line_pixel | top_line_pixel | bottom_line_pixel | horiz_mid_dot_pixel;
endmodule

//draws a car given its color
module draw_car
	#(parameter COLOR = 24'hFF_00_00)
   (input clk,
	 input [10:0] x,hcount, width, 
    input [9:0] y,vcount, height,
	 input [1:0] car_direction,
	 input is_ambulance,
    output reg [23:0] pixel);
	 
	(* ram_style =  "registers" *) reg [15:0] image_addr, amb_addr; //num of bits for 8*6000 ROM
	wire [7:0] image_bits, red_mapped, green_mapped, blue_mapped;
	wire [7:0] amb_bits, amb_red_mapped, amb_green_mapped, amb_blue_mapped;
	
	`include "params.v"
	
	always @ (posedge clk) begin
		case(car_direction) 
			MOVE_RIGHT: begin
				amb_addr <= (hcount-x + 3) + (vcount-y) * width;
				image_addr <= (hcount-x + 3) + (vcount-y) * width;
				end
			MOVE_LEFT: begin
				amb_addr <= (width-(hcount-x) - 4) +  (vcount-y) * width;
				image_addr <= (width-(hcount-x) - 4) +  (vcount-y) * width;
				end
			MOVE_UP: begin
				amb_addr <= (height - (vcount-y)) +  (width- (hcount - x))* height;
				image_addr <= (height - (vcount-y)) +  (width- (hcount - x))* height;
				end
			MOVE_DOWN: begin
				amb_addr <= (vcount-y) +  (hcount - x)* height;
				image_addr <= (vcount-y) +  (hcount - x)* height;
				end
		endcase
	 end
	 
	 smaller_car  car_rom(.clka(clk), .addra(image_addr), .douta(image_bits)); //CHANGE
	 amb_image_rom  amb_rom(.clka(clk), .addra(amb_addr),   .douta(amb_bits));
	 
   // use color map to create 8bits R, 8bits G, 8 bits B;
   smaller_car_red_coe car_rcm (.clka(clk), .addra(image_bits), .douta(red_mapped)); //CHANGE
   smaller_car_green_coe car_gcm (.clka(clk), .addra(image_bits), .douta(green_mapped)); //CHANGE
   smaller_car_blue_coe car_bcm (.clka(clk), .addra(image_bits), .douta(blue_mapped)); //CHANGE
	
	//use color map to create 8bits R, 8bits G, 8 bits B;
	amb_red_coe amb_rcm(.clka(clk), .addra(amb_bits), .douta(amb_red_mapped));
	amb_green_coe amb_gcm (.clka(clk), .addra(amb_bits), .douta(amb_green_mapped));
   amb_blue_coe amb_bcm (.clka(clk), .addra(amb_bits), .douta(amb_blue_mapped));
	
	always @(posedge clk) begin
     if ((hcount >= x && hcount < (x+width)) &&
          (vcount >= y && vcount < (y+height)))
			 begin
				if (is_ambulance == TRUE) pixel <= {amb_red_mapped, amb_green_mapped, amb_blue_mapped};
				else begin
					if ((x > 0) && (y >0))begin
						
						if ((red_mapped > 'd60) && (green_mapped < 'd50) && (blue_mapped < 50)) pixel <= COLOR;
						else pixel <= {red_mapped, green_mapped, blue_mapped};
					end
					else pixel <= 0;
				end
			 end	 
     else pixel <= 0;
	end
		
endmodule

module visualization(
    input vclock,
	 input one_hz_enable,
    input[10:0] hcount,
    input[9:0] vcount,
    input hsync, vsync, blank,
    input [1:0] main_out,
    input [1:0] side_out,
    input [1:0] car1_direction,car2_direction, car3_direction, car4_direction, car5_direction, 
	 	     car6_direction, car7_direction, car8_direction, car9_direction, car10_direction,
    input[1:0] car11_direction, car12_direction, car13_direction, 
    input [1:0] ambulance_direction,
    input [10:0] car1_leftx,car2_leftx, car3_leftx,car4_leftx, car5_leftx, car6_leftx, car7_leftx, car8_leftx, car9_leftx, car10_leftx,
    input [10:0] car11_leftx, car12_leftx, car13_leftx,
    input [10:0] car1_width, car2_width, car3_width, car4_width, car5_width, car6_width, car7_width, car8_width, car9_width, car10_width,
    input [10:0] car11_width, car12_width, car13_width, 
    input [9:0] car1_topy, car2_topy, car3_topy, car4_topy, car5_topy, car6_topy, car7_topy, car8_topy, car9_topy, car10_topy,
    input [9:0] car11_topy, car12_topy, car13_topy, 
    input [9:0] car1_height,car2_height, car3_height, car4_height, car5_height,car6_height, car7_height, car8_height, car9_height, car10_height,
    input [9:0] car11_height,car12_height, car13_height, 
    input is_collision,
    input[10:0] ambulance_leftx, ambulance_width,
    input[9:0] ambulance_topy, ambulance_height,
    output viz_hsync,
    output viz_vsync,
    output viz_blank,
    output[23:0] pixel
    );	
	 
    assign viz_hsync = hsync;
    assign viz_vsync = vsync;
    assign viz_blank = blank;
	 
    `include "params.v"
	
       //draw street
	wire [23:0] street_pixel;
	draw_street street1(.clk(vclock),.hcount(hcount),.vcount(vcount),
					 .street_pixel(street_pixel));
	
	//draw main traffic light
	wire [23:0] traffic1_pixel;
	draw_traffic_light traffic1(.clk(vclock),.x(320),.y(0),.hcount(hcount),.vcount(vcount), .signal(main_out), .orientation(VERTICAL),
					 .traffic_pixel(traffic1_pixel));
	
	//draw side traffic light
	wire [23:0] traffic2_pixel;
	draw_traffic_light traffic2(.clk(vclock),.x(624),.y(468),.hcount(hcount),.vcount(vcount), .signal(side_out), .orientation(HORIZONTAL),
					 .traffic_pixel(traffic2_pixel));
					 

	//draw car - GREEN
	wire[23:0] car1_pixel;
	draw_car #(.COLOR(24'h00_FF_00))
	car1(.clk(vclock), .x(car1_leftx), .y(car1_topy), .hcount(hcount), .vcount(vcount), .height(car1_height), .width(car1_width), .pixel(car1_pixel), .car_direction(car1_direction), .is_ambulance(FALSE));
	
	//draw car - GREEN
	wire[23:0] car2_pixel;
	draw_car #(.COLOR(24'h00_FF_00))
	car2(.clk(vclock), .x(car2_leftx), .y(car2_topy), .hcount(hcount), .vcount(vcount), .height(car2_height), .width(car2_width), .pixel(car2_pixel), .car_direction(car2_direction), .is_ambulance(FALSE));

	
	//draw car - GREEN
	wire[23:0] car3_pixel;
	draw_car #(.COLOR(24'h00_FF_00))
	car3(.clk(vclock), .x(car3_leftx), .y(car3_topy), .hcount(hcount), .vcount(vcount), .height(car3_height), .width(car3_width), .pixel(car3_pixel), .car_direction(car3_direction), .is_ambulance(FALSE));
	
	//draw car - BLUE
	wire[23:0] car4_pixel;
	draw_car #(.COLOR(24'h00_00_FF))
	 car4(.clk(vclock), .x(car4_leftx), .y(car4_topy), .hcount(hcount), .vcount(vcount), .height(car4_height), .width(car4_width), .pixel(car4_pixel), .car_direction(car4_direction), .is_ambulance(FALSE));
	
	//draw car - BLUE
	wire[23:0] car5_pixel;
	draw_car #(.COLOR(24'h00_00_FF))
	 car5(.clk(vclock), .x(car5_leftx), .y(car5_topy), .hcount(hcount), .vcount(vcount), .height(car5_height), .width(car5_width), .pixel(car5_pixel), .car_direction(car5_direction), .is_ambulance(FALSE));

	//draw car - BLUE
	wire[23:0] car6_pixel;
	draw_car #(.COLOR(24'h00_00_FF))
	car6(.clk(vclock), .x(car6_leftx), .y(car6_topy), .hcount(hcount), .vcount(vcount), .height(car6_height), .width(car6_width), .pixel(car6_pixel), .car_direction(car6_direction), .is_ambulance(FALSE));

	//draw car - GREEN
	wire[23:0] car7_pixel;
	draw_car #(.COLOR(24'h00_FF_00))
	car7(.clk(vclock), .x(car7_leftx), .y(car7_topy), .hcount(hcount), .vcount(vcount), .height(car7_height), .width(car7_width), .pixel(car7_pixel), .car_direction(car7_direction), .is_ambulance(FALSE));

	//draw car - GREEN
	wire[23:0] car8_pixel;
	draw_car #(.COLOR(24'h00_FF_00))
	car8(.clk(vclock), .x(car8_leftx), .y(car8_topy), .hcount(hcount), .vcount(vcount), .height(car8_height), .width(car8_width), .pixel(car8_pixel), .car_direction(car8_direction), .is_ambulance(FALSE));

	//draw car - GREEN
	wire[23:0] car9_pixel;
	draw_car #(.COLOR(24'h00_FF_00))
	car9(.clk(vclock), .x(car9_leftx), .y(car9_topy), .hcount(hcount), .vcount(vcount), .height(car9_height), .width(car9_width), .pixel(car9_pixel), .car_direction(car9_direction), .is_ambulance(FALSE));

	//draw car - GREEN
	wire[23:0] car10_pixel;
	draw_car #(.COLOR(24'h00_FF_00))
	car10(.clk(vclock), .x(car10_leftx), .y(car10_topy), .hcount(hcount), .vcount(vcount), .height(car10_height), .width(car10_width), .pixel(car10_pixel), .car_direction(car10_direction), .is_ambulance(FALSE));

	//draw car - GREEN
	wire[23:0] car11_pixel;
	draw_car #(.COLOR(24'h00_FF_00))
	car11(.clk(vclock), .x(car11_leftx), .y(car11_topy), .hcount(hcount), .vcount(vcount), .height(car11_height), .width(car11_width), .pixel(car11_pixel), .car_direction(car11_direction), .is_ambulance(FALSE));

	//draw car - BLUE
	wire[23:0] car12_pixel;
	draw_car #(.COLOR(24'h00_00_FF))
	car12(.clk(vclock), .x(car12_leftx), .y(car12_topy), .hcount(hcount), .vcount(vcount), .height(car12_height), .width(car12_width), .pixel(car12_pixel), .car_direction(car12_direction), .is_ambulance(FALSE));

	
	//draw car - BLUE
	wire[23:0] car13_pixel;
	draw_car #(.COLOR(24'h00_00_FF))
	car13(.clk(vclock), .x(car13_leftx), .y(car13_topy), .hcount(hcount), .vcount(vcount), .height(car13_height), .width(car13_width), .pixel(car13_pixel), .car_direction(car13_direction), .is_ambulance(FALSE));
		
	//draw ambulance
	wire [23:0] ambulance_pixel;
	draw_car ambulance(.clk(vclock), .x(ambulance_leftx), .y(ambulance_topy), .hcount(hcount), .vcount(vcount), .height(ambulance_height), .width(ambulance_width), .pixel(ambulance_pixel), .car_direction(ambulance_direction), .is_ambulance(TRUE));

	reg [23:0] dom_pixel;

	always @ * begin		
	    if (is_collision == 1) dom_pixel = street_pixel | car1_pixel | car2_pixel | car3_pixel | car4_pixel |
		                               car5_pixel| car6_pixel| car7_pixel| car8_pixel| car9_pixel | car10_pixel |
					       car11_pixel | car12_pixel | car13_pixel | ambulance_pixel;
	    else dom_pixel = street_pixel | car1_pixel | car2_pixel | car3_pixel | car4_pixel | car5_pixel | 
		            car6_pixel | car7_pixel| car8_pixel | car9_pixel | car10_pixel | car11_pixel | 
			    car12_pixel | car13_pixel;
	end //end always 
						 
	assign pixel =  dom_pixel| traffic1_pixel | traffic2_pixel;
endmodule


//module to determine the height, width and direction of a car
module w_and_h_calc(
	 input clk,
	 input [10:0] car_x,
	 input [9:0] car_y,
	 output reg[9:0] car_height,
	 output reg[10:0] car_width,
	 output reg[1:0] car_direction);

	`include "params.v"
	 	 
	always @ (posedge clk) begin
		
		//determine if orientation is vertical or horizontal
		if (car_x < STREET_LEFTX || car_x > STREET_RIGHTX) //should be horizontal
			begin
				car_height <= 11'd39; //CHANGE
				car_width <= 10'd80; //CHANGE
				
					//given horizontal orientation, check if moving left or moving right
					if (STREET_TOPY < car_y && car_y < STREET_HORIZ_MID) car_direction <= MOVE_LEFT;
					else car_direction <= MOVE_RIGHT;
			end
		
		//else vertical orientation
		else begin
				car_height <= 11'd80; //CHANGE
				car_width <= 10'd39; //CHANGE
				
					//given vertical orientation, check if moving up or moving down
					if (STREET_LEFTX < car_x && car_x < STREET_VERT_MID) car_direction <= MOVE_DOWN;
					else car_direction <= MOVE_UP;
		end
	end //end always

endmodule





////////////////////////////////
////UNUSED CODE: previously used blobs and ORed pixels before transitioning to
//COE files
//////////

//module draw_car
//   #(parameter COLOR = 24'h22_8B_22)  
//   (input clk,
//	 input [10:0] x,hcount, width, 
//    input [9:0] y,vcount, height,
//    output [23:0] pixel);
//	 
//	 wire [23:0] rectangle_pixel;
//	 
//	 //draw car rectangle
//	 draw_filled_rectangle #(.COLOR(COLOR))
//				car_skeleton(.x(x), .y(y), .hcount(hcount), .vcount(vcount), .height(height), .width(width), .pixel(rectangle_pixel));
//				
//	 //draw four wheels all of radius 10
//	 //draw top left wheel 
//	 wire [23:0] top_left_wheel_pixel;
//	 draw_round_puck #(.RADIUS(10), .COLOR(24'hFF_FF_FF))
//		top_left_wheel(.clk(clk), .hcount(hcount), .vcount(vcount), .x(x -10), .y(y - 5), .pixel(top_left_wheel_pixel));
//		
//	//draw top right wheel
//	 wire [23:0] top_right_wheel_pixel; 
//	 draw_round_puck #(.RADIUS(10), .COLOR(24'hFF_FF_FF))
//		top_right_wheel(.clk(clk), .hcount(hcount), .vcount(vcount), .x(x+width-15), .y(y-5), .pixel(top_right_wheel_pixel));
//		
//	//draw bottom left wheel
//	 wire [23:0] bottom_left_wheel_pixel; 
//	 draw_round_puck #(.RADIUS(10), .COLOR(24'hFF_FF_FF))
//		bottom_left_wheel(.clk(clk), .hcount(hcount), .vcount(vcount), .x(x-10), .y(y+height-10), .pixel(bottom_left_wheel_pixel));
//	 
//	 //draw bottom right wheel
//	 wire [23:0] bottom_right_wheel_pixel; 
//	 draw_round_puck #(.RADIUS(10), .COLOR(24'hFF_FF_FF))
//		bottom_right_wheel(.clk(clk), .hcount(hcount), .vcount(vcount), .x(x+width-15), .y(y + height-10), .pixel(bottom_right_wheel_pixel));
//		
//	 assign pixel = rectangle_pixel | top_left_wheel_pixel | top_right_wheel_pixel | bottom_left_wheel_pixel | bottom_right_wheel_pixel;
//endmodule

//module used to create a circle of given radius on the screen by coloring pixels with given color
//module draw_round_puck
//#(parameter RADIUS = 10'd30,
//				 COLOR = 24'hFF_00_00)
//( input clk,
//  input[10:0]x, hcount, 
//  input[9:0] y, vcount,
//  output reg[23:0] pixel);
//  
//  reg[100:0] radiussquared;
//  reg[10:0] deltax;
//  reg[9:0] deltay;
//  reg[120:0] deltaxsquared;
//  reg[80:0] deltaysquared;
//
//    always @(posedge clk) 
//    // compute x-xcenter and y-ycenter
//    begin
//    radiussquared <= RADIUS*RADIUS;
//    
//     // RADIUS is a paramater
//    deltax <= (hcount > (x+RADIUS)) ? (hcount-(x+RADIUS)) : ((x+RADIUS)-hcount);
//    deltay <= (vcount > (y+RADIUS)) ? (vcount-(y+RADIUS)) : ((y+RADIUS)-vcount);
//    
//     deltaxsquared <= deltax * deltax;
//     deltaysquared <= deltay * deltay;
//    
//        // check if distance is less than radius squared
//    if(deltaxsquared + deltaysquared <= radiussquared) pixel <= COLOR;
//    else pixel <= 0;
//    end //end always block
//endmodule


//module used to overwrite pixels of a larger circle. 
//module draw_inner_circle
//#(parameter RADIUS = 10,
//				 COLOR = 24'h00_00_00)
//( input clk,
//  input[10:0] x,hcount, 
//  input[9:0] y,vcount,
//  input activate_inner,
//  input [23:0] outer_pixel,
//  output [23:0] pixel);
//
//  reg[100:0] radiussquared;
//  reg[10:0] deltax;
//  reg[9:0] deltay;
//  reg[120:0] deltaxsquared;
//  reg[80:0] deltaysquared;
//  
//  //alpha blending initialization 
//	wire[2:0] m = 3'b010;
//	wire[2:0] n = 3'b100;
//   
//	//inner register 
//	reg[23:0] internal_pixel;
//
//    always @(posedge clk) 
//    // compute x-xcenter and y-ycenter
//    begin
//    radiussquared <= RADIUS*RADIUS;
//        
//    // RADIUS is a paramater
//    deltax <= (hcount > (x+RADIUS)) ? (hcount-(x+RADIUS)) : ((x+RADIUS)-hcount);
//    deltay <= (vcount > (y+RADIUS)) ? (vcount-(y+RADIUS)) : ((y+RADIUS)-vcount);
//    
//     deltaxsquared <= deltax * deltax;
//     deltaysquared <= deltay * deltay;
//    	 
//    // check if distance is less than radius squared
//    if(deltaxsquared + deltaysquared <= radiussquared && activate_inner == 1) 
//			 begin
//				internal_pixel[23:16] <= (outer_pixel[23:16] * m  >> n) + (COLOR[23:16] * (2**n - m) >>n);
//				internal_pixel[15:8] <= (outer_pixel[15:8] * m  >> n) + (COLOR[15:8] * (2**n - m) >> n);
//				internal_pixel[7:0] <= (outer_pixel[7:0] * m  >> n) + (COLOR[7:0] * (2**n - m) >> n);
//			 end
//	 else internal_pixel <= outer_pixel; //otherwise, maintain outer pixel color 
//    end //end always block
//	
//	assign pixel = internal_pixel;
//
//endmodule

//module draw_traffic_light
//	#(parameter THICKNESS = 5, 
//					 HORIZONTAL_LENGTH = 90,
//					 VERTICAL_LENGTH = 180,
//					 STICK_LENGTH = 120,
//					 LIGHT_RADIUS = 20,
//					 COLOR = 24'h22_8B_22)
//	(input clk,
//	 input [10:0] x,hcount,
//    input [9:0] y,vcount,
//	 input [1:0] signal,
//    output [23:0] traffic_pixel);
// 
//	 //draw main box
//	 wire [23:0] main_box_pixel;
//	 draw_empty_rectangle main_box(.x(x),.y(y),.hcount(hcount),.vcount(vcount), .thickness(THICKNESS), .vertical_length(VERTICAL_LENGTH), .horizontal_length(HORIZONTAL_LENGTH), .pixel(main_box_pixel));
//	 
//	 //draw support stick
//	 wire [23:0] support_stick_pixel; //x = x + (horiz_len/2 - thickness/2)
//		vertical_line #(.COLOR(COLOR))
//		  support_stick(.x(x + 42),.y(y+VERTICAL_LENGTH),.hcount(hcount),.vcount(vcount), .y_length(STICK_LENGTH), .thickness(THICKNESS), .pixel(support_stick_pixel));
//		 
//	 //determine coordinates for circles
//	 wire[10:0] circle_x = x + 20;
//    wire[9:0] red_y = y + 9'd20;
//	 wire[9:0] yellow_y = red_y + 9'd50;
//	 wire[9:0] green_y = yellow_y + 9'd50;
//	 
//	 //declare switches to control lights. if light should be off, activate the inner circle
//	 reg activate_inner_r;
//	 reg activate_inner_y;
//	 reg activate_inner_g;
//	 
//	 //constants
//	 wire[1:0] red = 2'b00;
//	 wire[1:0] yellow = 2'b01;
//	 wire[1:0] green = 2'b10;
//	 wire on = 1;
//	 wire off = 0;
//	 
//	 always @ * begin
//		if (signal != red) activate_inner_r = on;
//		else activate_inner_r = off;
//		
//		if (signal != yellow) activate_inner_y = on;
//		else activate_inner_y = off;
//		
//		if (signal != green) activate_inner_g = on;
//		else activate_inner_g = off;
//	 end
//	 
//	 //DRAW PUCKS FOR TRAFFIC LIGHTS 
//	 
//	 //DRAW RED PUCK
//	 wire [23:0] red_puck_pixel;
//	 draw_round_puck #(.RADIUS(LIGHT_RADIUS), .COLOR(24'hFF_00_00))
//		red_puck(.clk(clk), .hcount(hcount), .vcount(vcount), .x(circle_x), .y(red_y), .pixel(red_puck_pixel));
//		
//	 //IF RED LIGHT IS OFF, DRAW A DARK INNER CIRCLE
//	 wire [23:0] red_inner_pixel;
//      draw_inner_circle #(.RADIUS(15))
//        r_black (.clk(clk), .hcount(hcount), .vcount(vcount), .x(circle_x + 5), .y(red_y + 5), .activate_inner(activate_inner_r), .outer_pixel(red_puck_pixel), .pixel(red_inner_pixel));
//	
//	 //DRAW YELLOW PUCK
//	 wire [23:0] yellow_puck_pixel;
//	 draw_round_puck #(.RADIUS(LIGHT_RADIUS), .COLOR(24'hFF_FF_00))
//		yellow_puck(.clk(clk), .hcount(hcount), .vcount(vcount), .x(circle_x), .y(yellow_y), .pixel(yellow_puck_pixel));
//		
//	//IF YELLOW LIGHT IS OFF, DRAW A DARK INNER CIRCLE
//	 wire [23:0] yellow_inner_pixel;
//      draw_inner_circle #(.RADIUS(15))
//       y_black (.clk(clk), .hcount(hcount), .vcount(vcount), .x(circle_x + 5), .y(yellow_y + 5), .activate_inner(activate_inner_y), .outer_pixel(yellow_puck_pixel), .pixel(yellow_inner_pixel));
//	 
//	 //DRAW GREEN PUCK
//	 wire [23:0] green_puck_pixel;
//	 draw_round_puck #(.RADIUS(LIGHT_RADIUS) , .COLOR(24'h00_FF_00))
//		green_puck(.clk(clk), .hcount(hcount), .vcount(vcount), .x(circle_x), .y(green_y),.pixel(green_puck_pixel));
//	
//	//IF GREEN LIGHT IS OFF, DRAW A DARK INNER CIRCLE
//	 wire [23:0] green_inner_pixel;
//      draw_inner_circle #(.RADIUS(15))
//       g_black (.clk(clk), .hcount(hcount), .vcount(vcount), .x(circle_x + 5), .y(green_y + 5), .activate_inner(activate_inner_g), .outer_pixel(green_puck_pixel), .pixel(green_inner_pixel));
//	 
//	assign traffic_pixel = main_box_pixel | support_stick_pixel | red_inner_pixel | yellow_inner_pixel | green_inner_pixel;
//endmodule

//module draw_empty_rectangle
//   #(parameter COLOR = 24'h22_8B_22)  
//   (input [10:0] x,hcount,
//    input [9:0] y,vcount,
//	 input [10:0] thickness,
//	 input [7:0] vertical_length, horizontal_length,
//    output [23:0] pixel);
//
//	//DRAW VERTICAL BARS
//	//draw left bar
//	wire [23:0] vert_left_pixel;
//		vertical_line #(.COLOR(COLOR))
//		  vert_left(.x(x),.y(y),.hcount(hcount),.vcount(vcount), .y_length(vertical_length), .thickness(thickness), .pixel(vert_left_pixel));
//	
//	//draw right bar
//	wire [23:0] vert_right_pixel;
//		vertical_line #(.COLOR(COLOR))
//		  vert_right(.x(x + horizontal_length),.y(y),.hcount(hcount),.vcount(vcount), .y_length(vertical_length), .thickness(thickness), .pixel(vert_right_pixel));  
//		  
//   //DRAW HORIZONTAL BARS
//	//draw top bar 
//	wire [23:0] horiz_top_pixel;
//		horizontal_line #(.COLOR(COLOR))
//			horiz_top(.x(x),.y(y),.hcount(hcount),.vcount(vcount), .x_length(horizontal_length), .thickness(thickness), .pixel(horiz_top_pixel));  
//		
//	//draw bottom bar
//   wire [23:0] horiz_bottom_pixel;
//		horizontal_line #(.COLOR(COLOR))
//			horiz_bottom(.x(x),.y(y + vertical_length),.hcount(hcount),.vcount(vcount), .x_length(horizontal_length), .thickness(thickness), .pixel(horiz_bottom_pixel));  
//		  
//   assign pixel = vert_left_pixel | vert_right_pixel | horiz_top_pixel | horiz_bottom_pixel;
//
//endmodule

//module draw_filled_rectangle
//   #(parameter COLOR = 24'hFF_45_00)  
//   (input [10:0] x,hcount, width,
//    input [9:0] y,vcount, height,
//    output reg [23:0] pixel);
//	 
//	 always @ * begin
//		if ( (hcount >= x && hcount < (x+width)) && (vcount >= y && vcount < (y+height))) pixel = COLOR;
//		else pixel = 0;
//	 end
//endmodule
