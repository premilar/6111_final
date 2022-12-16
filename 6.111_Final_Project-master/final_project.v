///////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- Template Toplevel Module
//
//
// Created: December 1, 2018
// Authors: Jessica Quaye and Premila Rowles
//

module final_project(beep, audio_reset_b, 
		       ac97_sdata_out, ac97_sdata_in, ac97_synch,
	       ac97_bit_clock,
	       
	       vga_out_red, vga_out_green, vga_out_blue, vga_out_sync_b,
	       vga_out_blank_b, vga_out_pixel_clock, vga_out_hsync,
	       vga_out_vsync,

	       tv_out_ycrcb, tv_out_reset_b, tv_out_clock, tv_out_i2c_clock,
	       tv_out_i2c_data, tv_out_pal_ntsc, tv_out_hsync_b,
	       tv_out_vsync_b, tv_out_blank_b, tv_out_subcar_reset,

	       tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1,
	       tv_in_line_clock2, tv_in_aef, tv_in_hff, tv_in_aff,
	       tv_in_i2c_clock, tv_in_i2c_data, tv_in_fifo_read,
	       tv_in_fifo_clock, tv_in_iso, tv_in_reset_b, tv_in_clock,

	       ram0_data, ram0_address, ram0_adv_ld, ram0_clk, ram0_cen_b,
	       ram0_ce_b, ram0_oe_b, ram0_we_b, ram0_bwe_b, 

	       ram1_data, ram1_address, ram1_adv_ld, ram1_clk, ram1_cen_b,
	       ram1_ce_b, ram1_oe_b, ram1_we_b, ram1_bwe_b,

	       clock_feedback_out, clock_feedback_in,

	       flash_data, flash_address, flash_ce_b, flash_oe_b, flash_we_b,
	       flash_reset_b, flash_sts, flash_byte_b,

	       rs232_txd, rs232_rxd, rs232_rts, rs232_cts,

	       mouse_clock, mouse_data, keyboard_clock, keyboard_data,

	       clock_27mhz, clock1, clock2,

	       disp_blank, disp_data_out, disp_clock, disp_rs, disp_ce_b,
	       disp_reset_b, disp_data_in,

	       button0, button1, button2, button3, button_enter, button_right,
	       button_left, button_down, button_up,

	       switch,

	       led,
	       
	       user1, user2, user3, user4,
	       
	       daughtercard,

	       systemace_data, systemace_address, systemace_ce_b,
	       systemace_we_b, systemace_oe_b, systemace_irq, systemace_mpbrdy,
	       
	       analyzer1_data, analyzer1_clock,
 	       analyzer2_data, analyzer2_clock,
 	       analyzer3_data, analyzer3_clock,
 	       analyzer4_data, analyzer4_clock);

   output beep, audio_reset_b, ac97_synch, ac97_sdata_out;
   input  ac97_bit_clock, ac97_sdata_in;
   
   output [7:0] vga_out_red, vga_out_green, vga_out_blue;
   output vga_out_sync_b, vga_out_blank_b, vga_out_pixel_clock,
	  vga_out_hsync, vga_out_vsync;

   output [9:0] tv_out_ycrcb;
   output tv_out_reset_b, tv_out_clock, tv_out_i2c_clock, tv_out_i2c_data,
	  tv_out_pal_ntsc, tv_out_hsync_b, tv_out_vsync_b, tv_out_blank_b,
	  tv_out_subcar_reset;
   
   input  [19:0] tv_in_ycrcb;
   input  tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, tv_in_aef,
	  tv_in_hff, tv_in_aff;
   output tv_in_i2c_clock, tv_in_fifo_read, tv_in_fifo_clock, tv_in_iso,
	  tv_in_reset_b, tv_in_clock;
   inout  tv_in_i2c_data;
        
   inout  [35:0] ram0_data;
   output [18:0] ram0_address;
   output ram0_adv_ld, ram0_clk, ram0_cen_b, ram0_ce_b, ram0_oe_b, ram0_we_b;
   output [3:0] ram0_bwe_b;
   
   inout  [35:0] ram1_data;
   output [18:0] ram1_address;
   output ram1_adv_ld, ram1_clk, ram1_cen_b, ram1_ce_b, ram1_oe_b, ram1_we_b;
   output [3:0] ram1_bwe_b;

   input  clock_feedback_in;
   output clock_feedback_out;
   
   inout  [15:0] flash_data;
   output [23:0] flash_address;
   output flash_ce_b, flash_oe_b, flash_we_b, flash_reset_b, flash_byte_b;
   input  flash_sts;
   
   output rs232_txd, rs232_rts;
   input  rs232_rxd, rs232_cts;

   input  mouse_clock, mouse_data, keyboard_clock, keyboard_data;

   input  clock_27mhz, clock1, clock2;

   output disp_blank, disp_clock, disp_rs, disp_ce_b, disp_reset_b;  
   input  disp_data_in;
   output  disp_data_out;
   
   input  button0, button1, button2, button3, button_enter, button_right,
	  button_left, button_down, button_up;
   input  [7:0] switch;
   output [7:0] led;

   inout [31:0] user1, user2, user3, user4;
   
   inout [43:0] daughtercard;

   inout  [15:0] systemace_data;
   output [6:0]  systemace_address;
   output systemace_ce_b, systemace_we_b, systemace_oe_b;
   input  systemace_irq, systemace_mpbrdy;

   output [15:0] analyzer1_data, analyzer2_data, analyzer3_data, 
		 analyzer4_data;
   output analyzer1_clock, analyzer2_clock, analyzer3_clock, analyzer4_clock;

   ////////////////////////////////////////////////////////////////////////////
   //
   // I/O Assignments
   //
   ////////////////////////////////////////////////////////////////////////////
   
   // Audio Input and Output
   assign beep= 1'b0;
//   assign audio_reset_b = 1'b0; //unused because sound module drives these outputs
//   assign ac97_synch = 1'b0;
//   assign ac97_sdata_out = 1'b0;
// ac97_sdata_in is an input

   // Video Output
   assign tv_out_ycrcb = 10'h0;
   assign tv_out_reset_b = 1'b0;
   assign tv_out_clock = 1'b0;
   assign tv_out_i2c_clock = 1'b0;
   assign tv_out_i2c_data = 1'b0;
   assign tv_out_pal_ntsc = 1'b0;
   assign tv_out_hsync_b = 1'b1;
   assign tv_out_vsync_b = 1'b1;
   assign tv_out_blank_b = 1'b1;
   assign tv_out_subcar_reset = 1'b0;
   
   // Video Input
   //assign tv_in_i2c_clock = 1'b0; //used by NTSC
   assign tv_in_fifo_read = 1'b1;
   assign tv_in_fifo_clock = 1'b0;
   assign tv_in_iso = 1'b1;
   //assign tv_in_reset_b = 1'b0; //used by NTSC
   assign tv_in_clock = clock_27mhz;//1'b0;
   //assign tv_in_i2c_data = 1'bZ; //used by NTSC
   // tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, 
   // tv_in_aef, tv_in_hff, and tv_in_aff are inputs
   
   // SRAMs
/* change lines below to enable ZBT RAM bank0 */
   assign ram0_data = 36'hZ;
   assign ram0_address = 19'h0;
   assign ram0_clk = 1'b0;
   assign ram0_we_b = 1'b1;
   assign ram0_cen_b = 1'b0;	// clock enable

/* enable RAM pins */

   assign ram0_ce_b = 1'b0;
   assign ram0_oe_b = 1'b0;
   assign ram0_adv_ld = 1'b0;
   assign ram0_bwe_b = 4'h0; 

/**********/
   //These values have to be set to 0 like ram0 since ram1 is used.
   assign ram1_adv_ld = 1'b0;   
   assign ram1_ce_b = 1'b0;
   assign ram1_oe_b = 1'b0;
   assign ram1_bwe_b = 4'h0;

   // clock_feedback_out will be assigned by ramclock
   // assign clock_feedback_out = 1'b0;  //2011-Nov-10
   // clock_feedback_in is an input
   
   // Flash ROM
   assign flash_data = 16'hZ;
   assign flash_address = 24'h0;
   assign flash_ce_b = 1'b1;
   assign flash_oe_b = 1'b1;
   assign flash_we_b = 1'b1;
   assign flash_reset_b = 1'b0;
   assign flash_byte_b = 1'b1;
   // flash_sts is an input

   // RS-232 Interface
   assign rs232_txd = 1'b1;
   assign rs232_rts = 1'b1;
   // rs232_rxd and rs232_cts are inputs


   // LED Displays
/* USED in hex display
   assign disp_blank = 1'b1;
   assign disp_clock = 1'b0;
   assign disp_rs = 1'b0;
   assign disp_ce_b = 1'b1;
   assign disp_reset_b = 1'b0;
   assign disp_data_out = 1'b0;
*/
   // disp_data_in is an input

   // Buttons, Switches, and Individual LEDs
   // assign led = 8'hFF;
   // button0, button1, button2, button3, button_enter, button_right,
   // button_left, button_down, button_up, and switches are inputs

   // User I/Os
//   assign user1 = 32'hZ; //used to drive LEDs
   assign user2 = 32'hZ;
//   assign user3 = 32'hZ; //used to drive LEDs
   assign user4 = 32'hZ;

   // Daughtercard Connectors
   assign daughtercard = 44'hZ;

   // SystemACE Microprocessor Port
   assign systemace_data = 16'hZ;
   assign systemace_address = 7'h0;
   assign systemace_ce_b = 1'b1;
   assign systemace_we_b = 1'b1;
   assign systemace_oe_b = 1'b1;
   // systemace_irq and systemace_mpbrdy are inputs

   // Logic Analyzer
   assign analyzer1_data = 16'h0;
   assign analyzer1_clock = 1'b1;
   assign analyzer2_data = 16'h0;
   assign analyzer2_clock = 1'b1;
   assign analyzer3_data = 16'h0;
   assign analyzer3_clock = 1'b1;
   assign analyzer4_data = 16'h0;
   assign analyzer4_clock = 1'b1;
			    
   ////////////////////////////////////////////////////////////////////////////
   // Demonstration of ZBT RAM as video memory

   // use FPGA's digital clock manager to produce a
   // 65MHz clock (actually 64.8MHz)
   wire clock_65mhz_unbuf,clock_65mhz;
   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_65mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 10
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 24
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
   BUFG vclk2(.O(clock_65mhz),.I(clock_65mhz_unbuf));

   wire locked;
   //assign clock_feedback_out = 0; // gph 2011-Nov-10
   
   ramclock rc(.ref_clock(clock_65mhz), .fpga_clock(clk),
					.ram0_clock(ram0_clk), 
					.ram1_clock(ram1_clk),  
					.clock_feedback_in(clock_feedback_in),
					.clock_feedback_out(clock_feedback_out), 
					.locked(locked));

   
   // power-on reset generation
   wire power_on_reset;    // remain high for first 16 clocks
   SRL16 reset_sr (.D(1'b0), .CLK(clk), .Q(power_on_reset),
		   .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
   defparam reset_sr.INIT = 16'hFFFF;

   // ENTER button is user reset
   wire reset,user_reset;
   debounce db1(power_on_reset, clk, ~button_enter, user_reset);
   assign reset = user_reset | power_on_reset;

   // display module used for debugging
   reg [63:0] dispdata;
	
   display_16hex hexdisp1(reset, clk, dispdata,
			  disp_blank, disp_clock, disp_rs, disp_ce_b,
			  disp_reset_b, disp_data_out);

   // generate basic XVGA video signals
   wire [10:0] hcount;
   wire [9:0]  vcount;
   wire hsync,vsync,blank;
   xvga xvga1(clk,hcount,vcount,hsync,vsync,blank);

   // wire up to ZBT ram
   wire [35:0] vram_write_data;
   wire [35:0] vram_read_data;
   wire [18:0] vram_addr;
   wire        vram_we;

   wire ram0_clk_not_used;
   zbt_6111 zbt0(clk, 1'b1, vram_we, vram_addr,
		   vram_write_data, vram_read_data,
		   ram0_clk_not_used,   //to get good timing, don't connect ram_clk to zbt_6111
		   ram0_we_b, ram0_address, ram0_data, ram0_cen_b);

   // generate pixel value from reading ZBT memory
   wire [17:0] 	vr_pixel; //change
   wire [18:0] 	vram_addr1;

   vram_display vd1(reset,clk,hcount,vcount,vr_pixel,
		    vram_addr1,vram_read_data);

   // ADV7185 NTSC decoder interface code
   // adv7185 initialization module
   adv7185init adv7185(.reset(reset), .clock_27mhz(clock_27mhz), 
		       .source(1'b0), .tv_in_reset_b(tv_in_reset_b), 
		       .tv_in_i2c_clock(tv_in_i2c_clock), 
		       .tv_in_i2c_data(tv_in_i2c_data));

   wire [29:0] ycrcb;	// video data (luminance, chrominance)
   wire [2:0] fvh;	// sync for field, vertical, horizontal
   wire       dv;	// data valid
   wire [23:0] rgb_out;//change
   wire [7:0] h,s,v;
   wire binarized_pixel;
   wire [23:0] vga_pixel;
   wire [23:0] pixel_out;
   wire is_red;
   wire is_blue;
   wire is_green;

   //convert NTSC raw analog output to digital
   ntsc_decode decode (.clk(tv_in_line_clock1), .reset(reset),
		       .tv_in_ycrcb(tv_in_ycrcb[19:10]), 
		       .ycrcb(ycrcb), .f(fvh[2]),
		       .v(fvh[1]), .h(fvh[0]), .data_valid(dv));
	
   //convert from YCrCb space (camera output) to RGB color space
   YCrCb2RGB ycrcb2rgb_module(.R(rgb_out[23:16]),.G(rgb_out[15:8]),
	                      .B(rgb_out[7:0]),.clk(tv_in_line_clock1),.rst(reset),
		              .Y(ycrcb[29:20]),.Cr(ycrcb[19:10]),.Cb(ycrcb[9:0]));
	

   //convert from rgb to hsv space for optimal color thresholding
   rgb2hsv rgb2hsv_module(.clock(tv_in_line_clock1),.reset(reset),
	                  .r(rgb_out[23:16]),.g(rgb_out[15:8]),.b(rgb_out[7:0]),
		          .h(h),.s(s),.v(v));
		
   //define upper and lower bounds for testing during chroma keying
	reg [7:0] h_upper_bound = 255;
	reg [7:0] h_lower_bound = 0;
	reg [7:0] s_upper_bound = 255;
	reg [7:0] s_lower_bound = 0;
	reg [7:0] v_upper_bound = 255;
	reg [7:0] v_lower_bound = 0;
	reg [10:0] counter = 0;
	wire [23:0] vga_pixel_output;

   //hsv_threshold determines if a given pixel is within the bounds of hue and value ranges
   hsv_threshold #(.H_LOWER_BOUND_BLUE(8'hAA), .H_UPPER_BOUND_BLUE(8'hAA),
		.S_UPPER_BOUND_BLUE(s_upper_bound),
		.S_LOWER_BOUND_BLUE(s_lower_bound),
		.V_UPPER_BOUND_BLUE(8'hFF), .V_LOWER_BOUND_BLUE(8'hA3), 
		.H_LOWER_BOUND_GREEN(8'h55), 
                .H_UPPER_BOUND_GREEN(8'h55),.S_UPPER_BOUND_GREEN(s_upper_bound),
		.S_LOWER_BOUND_GREEN(s_lower_bound),
		.V_UPPER_BOUND_GREEN(8'hFF), .V_LOWER_BOUND_GREEN(8'h77))		
   hsv_threshold_module(.rgb_pixel(rgb_out),.hsv_pixel({h,s,v}),
	                .pixel_out(pixel_out), .is_blue(is_blue),
		       	.is_green(is_green));

   //image selector outputs a color for each pixel depending on hsv_threshold output
   image_selector image_selector_module(.pixel(pixel_out),.is_blue(is_blue),
   	                                .is_green(is_green), .vga_pixel(vga_pixel),
					.binarized_pixel(binarized_pixel));

   //code to write NTSC data to video memory
   wire [18:0] ntsc_addr;
   wire [35:0] ntsc_data;
   wire        ntsc_we;

   //pass in 18 bit pixel to store in zbt memory
   ntsc_to_zbt n2z (clk, tv_in_line_clock1, fvh, dv, {vga_pixel[23:18],
	            vga_pixel[15:10], vga_pixel[7:2]},
		    ntsc_addr, ntsc_data, ntsc_we, switch[2]);

   //code to write pattern to ZBT memory
   reg [31:0] 	count;
   always @(posedge clk) count <= reset ? 0 : count + 1;

   wire [18:0] 	vram_addr2 = count[0+18:0];
   wire [35:0] 	vpat = ( switch[1] ? {4{count[3+3:3],4'b0}}
			 : {4{count[3+4:4],4'b0}} );

   //mux selecting read/write to memory based on which write-enable is chosen
   wire 	sw_ntsc = ~switch[3]; 
   wire 	my_we = sw_ntsc ? (hcount[0]==1'b1) : blank;
   wire [18:0] 	write_addr = sw_ntsc ? ntsc_addr : vram_addr2;
   wire [35:0] 	write_data = sw_ntsc ? ntsc_data : vpat;

   assign 	vram_addr = my_we ? write_addr : vram_addr1;
   assign 	vram_we = my_we;
   assign 	vram_write_data = write_data;



   wire[17:0] 	pixel; 
   reg 	b,hs,vs;
   wire sign = 0;
   reg start = 0;


  //define output wires for each instance of the region module
   wire [4:0] state_center;
   wire [4:0] state_one;
   wire [4:0] state_two;
   wire [4:0] state_three;
   wire [4:0] state_four;
   wire [4:0] state_five;
   wire [4:0] state_six;
   wire [4:0] state_seven;
   wire [4:0] state_eight;

   wire end_frame;
   wire start_frame;

   //Clock Divider Outputs
   wire one_hz_enable;
   wire one_mhz_enable;
   reg[1:0] disp_state = 0;


   reg[23:0] rgb;
   wire display;

   wire display_controller;
   assign display_controller = switch[4];
   wire [23:0] visualization_pixel;

   wire [23:0] video_pixel;
   wire use_video_pixel;
	 
  //assign read control to switches here
   wire read_control;
   assign read_control = switch[0];	  

   always @(posedge clk) begin
      b <= blank;
      hs <= hsync;
      vs <= vsync;
		
      if (display_controller == 1) begin
         if (display == 1) begin
            rgb[23:16] <= {pixel[17:12],2'b0};
	    rgb[15:8] <= {pixel[11:6],2'b0};
	    rgb[7:0] <= {pixel[5:0],2'b0};
         end
			
        else rgb <= 24'b0;
      end
		
      else begin
         if (use_video_pixel == 1) rgb <= video_pixel;
         else rgb <= visualization_pixel;
      end
   end
	
   wire [23:0] x_avg_green_center;
   wire [23:0] y_avg_green_center;
   wire [23:0] x_avg_blue_center;
   wire [23:0] y_avg_blue_center;

   wire [23:0] x_avg_green_one;
   wire [23:0] y_avg_green_one;
   wire [23:0] x_avg_blue_one;
   wire [23:0] y_avg_blue_one;

   wire [23:0] x_avg_green_two;
   wire [23:0] y_avg_green_two;
   wire [23:0] x_avg_blue_two;
   wire [23:0] y_avg_blue_two;

   wire [23:0] x_avg_green_three;
   wire [23:0] y_avg_green_three;
   wire [23:0] x_avg_blue_three;
   wire [23:0] y_avg_blue_three;

   wire [23:0] x_avg_green_four;
   wire [23:0] y_avg_green_four;
   wire [23:0] x_avg_blue_four;
   wire [23:0] y_avg_blue_four;

   wire [23:0] x_avg_green_five;
   wire [23:0] y_avg_green_five;
   wire [23:0] x_avg_blue_five;
   wire [23:0] y_avg_blue_five;

   wire [23:0] x_avg_green_six;
   wire [23:0] y_avg_green_six;
   wire [23:0] x_avg_blue_six;
   wire [23:0] y_avg_blue_six;

   wire [23:0] x_avg_green_seven;
   wire [23:0] y_avg_green_seven;
   wire [23:0] x_avg_blue_seven;
   wire [23:0] y_avg_blue_seven;

   wire [23:0] x_avg_green_eight;
   wire [23:0] y_avg_green_eight;
   wire [23:0] x_avg_blue_eight;
   wire [23:0] y_avg_blue_eight;

   //instance of region module for each region on the road
   region #(.UPPER_X(360), .UPPER_Y(300), .LOWER_X(445), .LOWER_Y(345))
      region_center_module(.clk(clk),.clock(clock_65mhz),.vr_pixel(vr_pixel),
	      		   .display(display),.hcount(hcount),.vcount(vcount),
			   .x_avg_green(x_avg_green_center),
			   .y_avg_green(y_avg_green_center),
			   .x_avg_blue(x_avg_blue_center),
			   .y_avg_blue(y_avg_blue_center),
			   .state(state_center));
				
   region #(.UPPER_X(360), .UPPER_Y(70), .LOWER_X(395), .LOWER_Y(285+35))
      region_one_module(.clk(clk),.clock(clock_65mhz),.vr_pixel(vr_pixel),
	                .display(display),.hcount(hcount),.vcount(vcount),
			.x_avg_green(x_avg_green_one),
			.y_avg_green(y_avg_green_one),
			.x_avg_blue(x_avg_blue_one),
			.y_avg_blue(y_avg_blue_one),
			.state(state_one));

   region #(.UPPER_X(420), .UPPER_Y(95), .LOWER_X(455), .LOWER_Y(265+35))
      region_two_module(.clk(clk),.clock(clock_65mhz),.vr_pixel(vr_pixel),
	                .display(display),.hcount(hcount),.vcount(vcount),
			.x_avg_green(x_avg_green_two),
			.y_avg_green(y_avg_green_two),
			.x_avg_blue(x_avg_blue_two),
			.y_avg_blue(y_avg_blue_two),
			.state(state_two));			
			
   region #(.UPPER_X(50), .UPPER_Y(275), .LOWER_X(330), .LOWER_Y(305))
      region_three_module(.clk(clk),.clock(clock_65mhz),.vr_pixel(vr_pixel),
	                  .display(display),.hcount(hcount),.vcount(vcount),
			  .x_avg_green(x_avg_green_three),
			  .y_avg_green(y_avg_green_three),
		          .x_avg_blue(x_avg_blue_three),
			  .y_avg_blue(y_avg_blue_three),
			  .state(state_three));			
				
				
   region #(.UPPER_X(40), .UPPER_Y(330), .LOWER_X(338), .LOWER_Y(360))
      region_four_module(.clk(clk),.clock(clock_65mhz),.vr_pixel(vr_pixel),
	                 .display(display),.hcount(hcount),.vcount(vcount),
			 .x_avg_green(x_avg_green_four),
			 .y_avg_green(y_avg_green_four),
			 .x_avg_blue(x_avg_blue_four),
			 .y_avg_blue(y_avg_blue_four),
			 .state(state_four));		
			
   region #(.UPPER_X(465), .UPPER_Y(275), .LOWER_X(740), .LOWER_Y(305))
      region_five_module(.clk(clk),.clock(clock_65mhz),.vr_pixel(vr_pixel),
	                 .display(display),.hcount(hcount),.vcount(vcount),
			 .x_avg_green(x_avg_green_five),
			 .y_avg_green(y_avg_green_five),
			 .x_avg_blue(x_avg_blue_five),
			 .y_avg_blue(y_avg_blue_five),
			 .state(state_five));		
			
			
   region #(.UPPER_X(465), .UPPER_Y(330), .LOWER_X(740), .LOWER_Y(360))
      region_six_module(.clk(clk),.clock(clock_65mhz),.vr_pixel(vr_pixel),
	                .display(display),.hcount(hcount),.vcount(vcount),
			.x_avg_green(x_avg_green_six),
			.y_avg_green(y_avg_green_six),
			.x_avg_blue(x_avg_blue_six)
			,.y_avg_blue(y_avg_blue_six),
			.state(state_six));		
			
  region #(.UPPER_X(360), .UPPER_Y(368-40), .LOWER_X(395), .LOWER_Y(550))
      region_seven_module(.clk(clk),.clock(clock_65mhz),.vr_pixel(vr_pixel),
	                  .display(display),.hcount(hcount),.vcount(vcount),
			  .x_avg_green(x_avg_green_seven),
			  .y_avg_green(y_avg_green_seven),
			  .x_avg_blue(x_avg_blue_seven),
			  .y_avg_blue(y_avg_blue_seven),
			  .state(state_seven));		
			
  region #(.UPPER_X(420), .UPPER_Y(368-40), .LOWER_X(455), .LOWER_Y(550))
      region_eight_module(.clk(clk),.clock(clock_65mhz),.vr_pixel(vr_pixel),
	                  .display(display),.hcount(hcount),.vcount(vcount),
			  .x_avg_green(x_avg_green_eight),
			  .y_avg_green(y_avg_green_eight),
			  .x_avg_blue(x_avg_blue_eight),
			  .y_avg_blue(y_avg_blue_eight),
			  .state(state_eight),
			  .new_car(new_car),
			  .end_frame(end_frame),.start_frame(start_frame));		
			

   //create crosshairs for center of mass for each car to debug averaging method
   assign pixel = ((hcount == x_avg_green_center || vcount == y_avg_green_center
					 	 || hcount == x_avg_green_one 
						 || vcount == y_avg_green_one 
						 || hcount == x_avg_green_two 
						 || vcount == y_avg_green_two 
						 || hcount == x_avg_green_three 
						 || vcount == y_avg_green_three
						 || hcount == x_avg_green_four 
						 || vcount == y_avg_green_four
						 || hcount == x_avg_green_five 
						 || vcount == y_avg_green_five 
						 || hcount == x_avg_green_six
						 || vcount == y_avg_green_six 
						 || hcount == x_avg_green_seven 
						 || vcount == y_avg_green_seven 
						 || hcount == x_avg_green_eight 
						 || vcount == y_avg_green_eight 
						 || hcount == x_avg_blue_one 
						 || vcount == y_avg_blue_one
					 	 || hcount == x_avg_blue_two 
						 || vcount == y_avg_blue_two
						 || count == x_avg_blue_three 
						 || vcount == y_avg_blue_three) 
						 ? 24'hFFFFFF : 0 ) | vr_pixel;
  //must include a check for display to ensure we don't have external noise 
  //when calculating center of mass
  assign display = ((hcount > 40 && hcount < 734) && (vcount > 64 && vcount < 565));



   // VGA Output.  In order to meet the setup and hold times of the
   // AD7125, we send it ~clk.

   assign vga_out_red = rgb[23:16];
   assign vga_out_green = rgb[15:8];
   assign vga_out_blue = rgb[7:0];
   assign vga_out_sync_b = 1'b1;    // not used
   assign vga_out_pixel_clock = ~clk;
   assign vga_out_blank_b = ~b;
   assign vga_out_hsync = hs;
   assign vga_out_vsync = vs;

  
////////////////////////////////////////////////////////////////////
// End of Image Processsing
// Beginning of Integration
/////////////////////////////////////////////////////////////////////

   //Traffic FSM Input
   wire[2:0] main_road_count;
   wire[2:0] side_road_count;
   wire ped_cross_main_road;
   wire ped_cross_side_road;
	 
   wire [1:0] car1_direction, car2_direction, car3_direction, car4_direction,
	      car5_direction, car6_direction, car7_direction, car8_direction, 
	      car9_direction, car10_direction, car11_direction,car12_direction,
	      car13_direction;

   //calculate number of cars on each road (using vertical and horizontal)
   assign main_road_count = (x_avg_green_one[10:0] > 0) + 
	                    (x_avg_green_two[10:0] > 0) +
	  		    (x_avg_blue_one[10:0] > 0) + 
			    (x_avg_blue_two[10:0] > 0) + 
			    (x_avg_green_seven[10:0] > 0) + 
			    (x_avg_green_eight[10:0] > 0);
   assign side_road_count = (x_avg_green_three[10:0] > 0) + 
	                    (x_avg_blue_three[10:0] > 0) +
	                    (x_avg_green_four[10:0] > 0) + 
			    (x_avg_blue_four[10:0] > 0) +  
			    (x_avg_green_five[10:0] > 0) + 
			    (x_avg_blue_five[10:0] > 0) + 
			    (x_avg_green_six[10:0] > 0);
	 
   //debouncing signals for buttons
   wire ped_cross_up, ped_cross_down, ped_cross_right, ped_cross_left;
   debounce upbtn(.reset(power_on_reset),.clock(clock_27mhz),.noisy(~button_up),.clean(ped_cross_up));
   debounce downbtn(.reset(power_on_reset),.clock(clock_27mhz),.noisy(~button_down),.clean(ped_cross_down));
   debounce rightbtn(.reset(power_on_reset),.clock(clock_27mhz),.noisy(~button_right),.clean(ped_cross_right));
   debounce leftbtn(.reset(power_on_reset),.clock(clock_27mhz),.noisy(~button_left),.clean(ped_cross_left));
	 
   //use buttons to simulate pedestrian signals
   assign ped_cross_main_road = ped_cross_right | ped_cross_left;
   assign ped_cross_side_road = ped_cross_up | ped_cross_down;
		 
   //Traffic FSM Outputs
   wire[1:0] main_out;
   wire[1:0] side_out;
   wire[2:0] out_state;

        
    //LED Outputs
   wire main_red;
   wire main_yellow;
   wire main_green;
   wire side_red;
   wire side_yellow;
   wire side_green;

    //Set hex display values
   always @(posedge clock_65mhz) begin
     dispdata <= {1'b0, out_state, 2'b0, main_out, 2'b0, side_out};
   end

   //LED strip Outputs
   //Main Road LED
   wire main_led_data;
   wire main_led_clock;
   wire main_enable_led_clock;
   assign main_led_clock = one_mhz_enable;
	 
   //Side Road LED
   wire side_led_data;
   wire side_led_clock;
   wire side_enable_led_clock;
   assign side_led_clock = one_mhz_enable;


   //Instantiate all modules	
   traffic_fsm traffic(.clk(clock_27mhz), .main_road_count(main_road_count), 
	               .side_road_count(side_road_count), 
	               .ped_cross_main_road(ped_cross_main_road), 
		       .ped_cross_side_road(ped_cross_side_road), 
		       .reset(reset), .one_hz_enable(one_hz_enable),
		       .main_out(main_out), .side_out(side_out), 
	               .out_state(out_state));
   
   clock_divider one_hz(.clk(clk), .one_hz_enable(one_hz_enable));
   led_divider one_mhz(.clk(clk), .one_mhz_enable(one_mhz_enable));
        
   led_controller led_out(.clk(clock_27mhz),.main_out(main_out),
	                  .side_out(side_out),
	                  .main_red(main_red),.main_yellow(main_yellow),
			  .main_green(main_green),
			  .side_red(side_red),.side_yellow(side_yellow),
			  .side_green(side_green));	
	
   led_strip main_led_strip(.clk(clk), .led_clock(main_led_clock),
	                    .red_signal(main_red),.yellow_signal(main_yellow), 
			    .green_signal(main_green),
	                    .main_led_data(main_led_data),
			    .main_enable_led_clock(main_enable_led_clock));
	 
   led_strip side_led_strip(.clk(clk), .side_led_clock(side_led_clock),
	                    .red_signal(side_red),.yellow_signal(side_yellow), 
			    .green_signal(side_green),
	                    .side_led_data(side_led_data),
			    .side_enable_led_clock(side_enable_led_clock));
	
   //send traffic signals to led strip
   //1 is data (yellow wire)
   //0 is clock (blue wire)
   assign user1[1:0] = {main_led_data,(main_led_clock && main_enable_led_clock)};
   assign user3[1:0] = {side_led_data, (side_led_clock && side_enable_led_clock)};
	
	 
   //Visualization signals
   //send signals to visualization module
   wire viz_hsync, viz_vsync, viz_blank;
	  
   //declare car inputs 
   wire [10:0] car1_leftx, car2_leftx, car3_leftx, car4_leftx, car5_leftx, 
	       car6_leftx,car7_leftx, car8_leftx, car9_leftx, car10_leftx; 
   wire [10:0] car11_leftx, car12_leftx, car13_leftx; 
   wire [9:0] car1_topy, car2_topy, car3_topy, car4_topy, car5_topy, car6_topy, 
	      car7_topy, car8_topy, car9_topy, car10_topy;
   wire [9:0] car11_topy, car12_topy, car13_topy;
   wire [10:0] car1_width, car2_width, car3_width, car4_width, car5_width, 
	       car6_width, car7_width,car8_width, car9_width, car10_width;
   wire [10:0] car11_width, car12_width, car13_width;
   wire [9:0] car1_height, car2_height, car3_height, car4_height, car5_height,
	      car6_height, car7_height, car8_height, car9_height, car10_height;
   wire[9:0] car11_height, car12_height, car13_height; 

   //REGIONS 1 To 3 FOR GREEN
   assign car1_leftx = (x_avg_green_one[10:0] > 0) ? (x_avg_green_one[10:0] + 80) : 0;
   assign car1_topy = (y_avg_green_one[9:0] > 0) ? (y_avg_green_one[9:0]) : 0;
	 
   assign car2_leftx = (x_avg_green_two[10:0] > 0) ? (x_avg_green_two[10:0] + 90) : 0;
   assign car2_topy = (y_avg_green_two[9:0] > 0) ? (y_avg_green_two[9:0]) : 0;
	 
   assign car3_leftx = (x_avg_green_three[10:0] > 0) ? (x_avg_green_three[10:0] + 30) : 0; //HORIZ
   assign car3_topy = (y_avg_green_three[9:0] > 0) ? (y_avg_green_three[9:0] + 60) : 0; //HORIZ
	 
   //REGIONS 1 TO 3 FOR BLUE
   assign car4_leftx = (x_avg_blue_one[10:0] > 0) ? (x_avg_blue_one[10:0] + 80) : 0; 
   assign car4_topy = (y_avg_blue_one[9:0] > 0 ) ? (y_avg_blue_one[9:0] ) : 0; 
	 
   assign car5_leftx = (x_avg_blue_two[10:0] > 0) ? (x_avg_blue_two[10:0] + 90) : 0; 
   assign car5_topy = (y_avg_blue_two[10:0] > 0) ? (y_avg_blue_two[10:0] ) : 0; 
	 
   assign car6_leftx = (x_avg_blue_three[10:0] > 0) ? (x_avg_blue_three[10:0] + 30) : 0; //HORIZ
   assign car6_topy = (y_avg_blue_three[9:0] > 0) ? (y_avg_blue_three[9:0] + 60) : 0; //HORIZ

   //REGIONS 4 TO 6 FOR GREEN
   assign car7_leftx = (x_avg_green_four[10:0] > 0) ? (x_avg_green_four[10:0] + 30) : 0; //HORIZ
   assign car7_topy = (y_avg_green_four[9:0] > 0) ? (y_avg_green_four[9:0] + 60) : 0; //HORIZ
	 
   assign car8_leftx = (x_avg_green_five[10:0] > 0) ? (x_avg_green_five[10:0] + 150) : 0; //HORIZ
   assign car8_topy = (y_avg_green_five[9:0] > 0) ? (y_avg_green_five[9:0] + 60) : 0; //HORIZ
	 
   assign car9_leftx = (x_avg_green_six[10:0] > 0) ? (x_avg_green_six[10:0] + 150) : 0; //HORIZ
   assign car9_topy = (y_avg_green_six[9:0] > 0) ? (y_avg_green_six[9:0] + 80) : 0; //HORIZ
	 
	 
   //REGIONS 7 AND 8 GREEN
   assign car10_leftx = (x_avg_green_seven[10:0] > 0) ? (x_avg_green_seven[10:0] + 100) : 0; 
   assign car10_topy = (y_avg_green_seven[9:0] > 0) ? (y_avg_green_seven[9:0] + 80) : 0; 
	 
   assign car11_leftx = (x_avg_green_eight[10:0] > 0) ? (x_avg_green_eight[10:0] + 100) : 0; 
   assign car11_topy = (y_avg_green_eight[9:0] > 0) ? (y_avg_green_eight[9:0] + 80) : 0; 
	 
  //REGIONS 4 TO 6 BLUE
   assign car12_leftx = (x_avg_blue_four[10:0] > 0) ? (x_avg_blue_four[10:0] + 0) : 0; //HORIZ
   assign car12_topy = (y_avg_blue_four[9:0] > 0) ? (y_avg_blue_four[9:0] + 60) : 0; //HORIZ
	 
   assign car13_leftx = (x_avg_blue_five[10:0] > 0) ? (x_avg_blue_five[10:0] + 150) : 0; //HORIZ
   assign car13_topy = (y_avg_blue_five[9:0] > 0) ? (y_avg_blue_five[9:0] + 60) : 0; //HORIZ
	 	 
   //calculate width, height and direction of car
   w_and_h_calc wcalc1(.clk(clk),.car_x(car1_leftx),.car_y(car1_topy),.car_height(car1_height),.car_width(car1_width),.car_direction(car1_direction));
   w_and_h_calc wcalc2(.clk(clk),.car_x(car2_leftx),.car_y(car2_topy),.car_height(car2_height),.car_width(car2_width),.car_direction(car2_direction));
   w_and_h_calc wcalc3(.clk(clk),.car_x(car3_leftx),.car_y(car3_topy),.car_height(car3_height),.car_width(car3_width),.car_direction(car3_direction));
   w_and_h_calc wcalc4(.clk(clk),.car_x(car4_leftx),.car_y(car4_topy),.car_height(car4_height),.car_width(car4_width),.car_direction(car4_direction));
   w_and_h_calc wcalc5(.clk(clk),.car_x(car5_leftx),.car_y(car5_topy),.car_height(car5_height),.car_width(car5_width),.car_direction(car5_direction));
   w_and_h_calc wcalc6(.clk(clk),.car_x(car6_leftx),.car_y(car6_topy),.car_height(car6_height),.car_width(car6_width),.car_direction(car6_direction));
   w_and_h_calc wcalc7(.clk(clk),.car_x(car7_leftx),.car_y(car7_topy),.car_height(car7_height),.car_width(car7_width),.car_direction(car7_direction));
   w_and_h_calc wcalc8(.clk(clk),.car_x(car8_leftx),.car_y(car8_topy),.car_height(car8_height),.car_width(car8_width),.car_direction(car8_direction));
   w_and_h_calc wcalc9(.clk(clk),.car_x(car9_leftx),.car_y(car9_topy),.car_height(car9_height),.car_width(car9_width),.car_direction(car9_direction));
   w_and_h_calc wcalc10(.clk(clk),.car_x(car10_leftx),.car_y(car10_topy),.car_height(car10_height),.car_width(car10_width),.car_direction(car10_direction));
   w_and_h_calc wcalc11(.clk(clk),.car_x(car11_leftx),.car_y(car11_topy),.car_height(car11_height),.car_width(car11_width),.car_direction(car11_direction));
   w_and_h_calc wcalc12(.clk(clk),.car_x(car12_leftx),.car_y(car12_topy),.car_height(car12_height),.car_width(car12_width),.car_direction(car12_direction));
   w_and_h_calc wcalc13(.clk(clk),.car_x(car13_leftx),.car_y(car13_topy),.car_height(car13_height),.car_width(car13_width),.car_direction(car13_direction));
   w_and_h_calc wcalc14(.clk(clk),.car_x(car14_leftx),.car_y(car14_topy),.car_height(car14_height),.car_width(car14_width),.car_direction(car14_direction));
	 

   //detect pairwise collision
   wire is_collision14;
   wire is_collision15;
   wire is_collision24;
   wire is_collision25;
   wire is_collision36;
   wire is_collision = is_collision14 || is_collision15 || is_collision24 || is_collision25 || is_collision36;
   wire [9:0] street_topy, street_bottomy;
   wire [10:0] street_leftx, street_rightx;
		
   wire [10:0] leftx_threshold14, rightx_threshold14;
   wire [9:0] uppery_threshold14, lowery_threshold14;
		
   wire [10:0] leftx_threshold15, rightx_threshold15;
   wire [9:0] uppery_threshold15, lowery_threshold15; 
		
   wire [10:0] leftx_threshold24, rightx_threshold24;
   wire [9:0] uppery_threshold24, lowery_threshold24;
		
   wire [10:0] leftx_threshold25, rightx_threshold25;
   wire [9:0] uppery_threshold25, lowery_threshold25;
		
   wire [10:0] leftx_threshold36, rightx_threshold36;
   wire [9:0] uppery_threshold36, lowery_threshold36;
		
   //calculate ambulance params
   wire [10:0] ambulance_dest_x, ambulance_leftx, ambulance_width;
   wire [9:0] ambulance_dest_y, ambulance_topy, ambulance_height;
   wire[1:0] ambulance_move_dir;
   wire direction14;
   wire direction15;
   wire direction24;
   wire direction25;
   wire direction36;
		
   assign street_leftx = 11'd420;
   assign street_rightx = 11'd600;
   assign street_topy = 10'd344;
   assign street_bottomy = 10'd464;
		
   //draw visualization
   visualization street_viz(.vclock(clk), .one_hz_enable(one_hz_enable),.hcount(hcount), .vcount(vcount), .hsync(hsync), .vsync(vsync), .blank(blank),
			    .car1_leftx(car1_leftx), .car1_topy(car1_topy),
			    .car2_leftx(car2_leftx), .car2_topy(car2_topy),
			    .car3_leftx(car3_leftx), .car3_topy(car3_topy),
			    .car4_leftx(car4_leftx), .car4_topy(car4_topy),
			    .car5_leftx(car5_leftx), .car5_topy(car5_topy),
			    .car6_leftx(car6_leftx), .car6_topy(car6_topy),
			    .car7_leftx(car7_leftx), .car7_topy(car7_topy),
			    .car8_leftx(car8_leftx), .car8_topy(car8_topy),
			    .car9_leftx(car9_leftx), .car9_topy(car9_topy),
			    .car10_leftx(car10_leftx), .car10_topy(car10_topy),
			    .car11_leftx(car11_leftx), .car11_topy(car11_topy),
			    .car12_leftx(car12_leftx), .car12_topy(car12_topy),
			    .car13_leftx(car13_leftx), .car13_topy(car13_topy),
			    .car1_direction(car1_direction), .car2_direction(car2_direction),
			    .car3_direction(car3_direction), .car4_direction(car4_direction),
			    .car5_direction(car5_direction), .car6_direction(car6_direction),	
			    .car7_direction(car7_direction), .car8_direction(car8_direction),	
			    .car9_direction(car9_direction), .car10_direction(car10_direction),
			    .car11_direction(car11_direction),	.car12_direction(car12_direction),
			    .car13_direction(car13_direction), 						
			    .car1_width(car1_width), .car2_width(car2_width),
			    .car3_width(car3_width), .car4_width(car4_width),
			    .car5_width(car5_width), .car6_width(car6_width),
			    .car7_width(car7_width), .car8_width(car8_width),
			    .car9_width(car9_width), .car10_width(car10_width),
			    .car11_width(car11_width), .car12_width(car12_width),
			    .car13_width(car13_width),
			    .car1_height(car1_height),.car2_height(car2_height),
			    .car3_height(car3_height),.car4_height(car4_height),
			    .car5_height(car5_height),.car6_height(car6_height),
			    .car7_height(car7_height),.car8_height(car8_height),
			    .car9_height(car9_height), .car10_height(car10_height),
			    .car11_height(car11_height), .car12_height(car12_height),
			    .car13_height(car13_height),
			    .is_collision(is_collision), 
			    .ambulance_leftx(ambulance_leftx),  .ambulance_width(ambulance_width),
			    .ambulance_topy(ambulance_topy), .ambulance_height(ambulance_height), .ambulance_direction(ambulance_move_dir),
			    .main_out(main_out), .side_out(side_out), .viz_hsync(viz_hsync),
			    .viz_vsync(viz_vsync), .viz_blank(viz_blank), .pixel(visualization_pixel));
		
   collision_detector coll_detect14( .clk(clk), .car1_leftx(car1_leftx),.car1_rightx(car1_leftx + car1_width),
	                             .car1_topy(car1_topy),.car1_bottomy(car1_topy + car1_height),
				     .car2_leftx(car4_leftx),.car2_rightx(car4_leftx + car4_width),
				     .car2_topy(car4_topy), .car2_bottomy(car4_topy + car4_height),
				     .street_topy(street_topy), .street_bottomy(street_bottomy), 
				     .street_leftx(street_leftx), .street_rightx(street_rightx),
				     .leftx_threshold(leftx_threshold14), .rightx_threshold(rightx_threshold14),
				     .uppery_threshold(uppery_threshold14), .lowery_threshold(lowery_threshold14),
				     .direction(direction14),.is_collision(is_collision14));
								 
   collision_detector coll_detect15( .clk(clk), .car1_leftx(car1_leftx),.car1_rightx(car1_leftx + car1_width),
	                             .car1_topy(car1_topy),.car1_bottomy(car1_topy + car1_height),
				     .car2_leftx(car5_leftx),.car2_rightx(car5_leftx + car5_width),
				     .car2_topy(car5_topy), .car2_bottomy(car5_topy + car5_height),
				     .street_topy(street_topy), .street_bottomy(street_bottomy), 
				     .street_leftx(street_leftx), .street_rightx(street_rightx),
				     .leftx_threshold(leftx_threshold15), .rightx_threshold(rightx_threshold15), 
				     .uppery_threshold(uppery_threshold15), .lowery_threshold(lowery_threshold15),
				     .direction(direction15),.is_collision(is_collision15));
								 
   collision_detector coll_detect24( .clk(clk), .car1_leftx(car2_leftx),.car1_rightx(car2_leftx + car2_width),
	   	                     .car1_topy(car2_topy),.car1_bottomy(car2_topy + car2_height),
				     .car2_leftx(car4_leftx),.car2_rightx(car4_leftx + car4_width),
				     .car2_topy(car4_topy), .car2_bottomy(car4_topy + car4_height),
				     .street_topy(street_topy), .street_bottomy(street_bottomy), 
				     .street_leftx(street_leftx), .street_rightx(street_rightx),
				     .leftx_threshold(leftx_threshold24), .rightx_threshold(rightx_threshold24), 
				     .uppery_threshold(uppery_threshold24), .lowery_threshold(lowery_threshold24),
				     .direction(direction24),.is_collision(is_collision24));
								 
   collision_detector coll_detect25( .clk(clk), .car1_leftx(car2_leftx),.car1_rightx(car2_leftx + car2_width),
	                             .car1_topy(car2_topy),.car1_bottomy(car2_topy + car2_height),
				     .car2_leftx(car5_leftx),.car2_rightx(car5_leftx + car5_width),
				     .car2_topy(car5_topy), .car2_bottomy(car5_topy + car5_height),
				     .street_topy(street_topy), .street_bottomy(street_bottomy), 
				     .street_leftx(street_leftx), .street_rightx(street_rightx),
				     .leftx_threshold(leftx_threshold25), .rightx_threshold(rightx_threshold25),
				     .uppery_threshold(uppery_threshold25), .lowery_threshold(lowery_threshold25),
				     .direction(direction25),.is_collision(is_collision25));

   collision_detector coll_detect36( .clk(clk), .car1_leftx(car3_leftx),.car1_rightx(car3_leftx + car3_width),
	                             .car1_topy(car3_topy),.car1_bottomy(car3_topy + car3_height),
				     .car2_leftx(car6_leftx),.car2_rightx(car6_leftx + car6_width),
				     .car2_topy(car6_topy), .car2_bottomy(car6_topy + car6_height),
				     .street_topy(street_topy), .street_bottomy(street_bottomy),
				     .street_leftx(street_leftx), .street_rightx(street_rightx),
				     .leftx_threshold(leftx_threshold36), .rightx_threshold(rightx_threshold36), 
				     .uppery_threshold(uppery_threshold36), .lowery_threshold(lowery_threshold36),
				     .direction(direction36),.is_collision(is_collision36));
	
   reg[10:0] leftx_threshold;
   reg[10:0] rightx_threshold;
   reg[9:0] uppery_threshold;
   reg[9:0] lowery_threshold;
   reg direction;
	
   always @ (posedge clk) begin
      if (is_collision == 1) begin
         if ((leftx_threshold14 > 0) && (rightx_threshold14 > 0)) begin
	    leftx_threshold <= leftx_threshold14;
	    rightx_threshold <= rightx_threshold14;
	    uppery_threshold <= uppery_threshold14;
	    lowery_threshold <= lowery_threshold14;
	    direction <= direction14;
    	 end
			
         if ((leftx_threshold15 > 0) && (rightx_threshold15 > 0))  begin
            leftx_threshold <= leftx_threshold15;
	    rightx_threshold <= rightx_threshold15;
	    uppery_threshold <= uppery_threshold15;
	    lowery_threshold <= lowery_threshold15;
	    direction <= direction15;
         end
			
	 if ((leftx_threshold24 > 0) && (rightx_threshold24 > 0)) begin
	    leftx_threshold <= leftx_threshold24;
	    rightx_threshold <= rightx_threshold24;
	    uppery_threshold <= uppery_threshold24;
	    lowery_threshold <= lowery_threshold24;
	    direction <= direction24;
         end
			
	 if ((leftx_threshold25 > 0) && (rightx_threshold25 > 0)) begin
            leftx_threshold <= leftx_threshold25;
	    rightx_threshold <= rightx_threshold25;
    	    uppery_threshold <= uppery_threshold25;
	    lowery_threshold <= lowery_threshold25;
	    direction <= direction25;
         end	
			
	 if ((leftx_threshold36 > 0) && (rightx_threshold36 > 0)) begin
	    leftx_threshold <= leftx_threshold36;
	    rightx_threshold <= rightx_threshold36;
	    uppery_threshold <= uppery_threshold36;
	    lowery_threshold <= lowery_threshold36;
	    direction <= direction36;
         end	
     end
   end
								
					
   //Calculate thresholds and other factors that will affect ambulance direction   
   calc_ambulance_params ambulance_calc(.clk(clk), .leftx_threshold(leftx_threshold), .rightx_threshold(rightx_threshold), .street_leftx(street_leftx), .street_rightx(street_rightx),
					.uppery_threshold(uppery_threshold), .lowery_threshold(lowery_threshold), .street_topy(street_topy), .street_bottomy(street_bottomy),
	 			        .direction(direction),
					.is_collision(is_collision),
					.ambulance_move_dir(ambulance_move_dir),
					.ambulance_dest_x(ambulance_dest_x),
					.ambulance_dest_y(ambulance_dest_y));

   //Use the ambulance parameters to determine where the ambulance should
   //start from and its destination limit								 
   get_amb_xy ambxny(.clk(clk), .one_hz_enable(one_hz_enable), .is_collision(is_collision),
		     .ambulance_move_dir(ambulance_move_dir), .ambulance_leftx(ambulance_leftx),  .ambulance_dest_x(ambulance_dest_x), .ambulance_width(ambulance_width),
		     .ambulance_topy(ambulance_topy), .ambulance_dest_y(ambulance_dest_y), .ambulance_height(ambulance_height));
						 
						 
   //Video playback
   //variables declared in RGB place 	  
   video video_stuff(.clk(clk), .one_hz_enable(one_hz_enable),
		     .visualization_pixel(visualization_pixel),
		     .hcount(hcount), .vcount(vcount),
		     .read_control(read_control),
	             .video_pixel(video_pixel),
		     .ram1_we_b(ram1_we_b), .ram1_address(ram1_address), .ram1_data(ram1_data), .ram1_cen_b(ram1_cen_b), .use_video_pixel(use_video_pixel));

    	     	 
   //Audio
   wire [7:0] from_ac97_data, to_ac97_data;
   wire ready;
   wire[4:0] volume = 5'd25;

   // AC97 driver
   audio a(clk, reset, volume, from_ac97_data, to_ac97_data, ready,
	       audio_reset_b, ac97_sdata_out, ac97_sdata_in,
	       ac97_synch, ac97_bit_clock);

   // record module
   recorder r(.clock(clk), .reset(reset), .ready(ready),
              .play_sound(is_collision), .from_ac97_data(from_ac97_data),
              .to_ac97_data(to_ac97_data));
				  
   assign led = ~{main_red, main_yellow, main_green, side_red, side_yellow, side_green, 1'b0, is_collision};


endmodule

///////////////////////////////////////////////////////////////////////////////
// xvga: Generate XVGA display signals (1024 x 768 @ 60Hz)

module xvga(vclock,hcount,vcount,hsync,vsync,blank);
   input vclock;
   output [10:0] hcount;
   output [9:0] vcount;
   output 	vsync;
   output 	hsync;
   output 	blank;

   reg 	  hsync,vsync,hblank,vblank,blank;
   reg [10:0] 	 hcount;    // pixel number on current line
   reg [9:0] vcount;	 // line number

   // horizontal: 1344 pixels total
   // display 1024 pixels per line
   wire      hsyncon,hsyncoff,hreset,hblankon;
   assign    hblankon = (hcount == 1023);    
   assign    hsyncon = (hcount == 1047);
   assign    hsyncoff = (hcount == 1183);
   assign    hreset = (hcount == 1343);

   // vertical: 806 lines total
   // display 768 lines
   wire      vsyncon,vsyncoff,vreset,vblankon;
   assign    vblankon = hreset & (vcount == 767);    
   assign    vsyncon = hreset & (vcount == 776);
   assign    vsyncoff = hreset & (vcount == 782);
   assign    vreset = hreset & (vcount == 805);

   // sync and blanking
   wire      next_hblank,next_vblank;
   assign next_hblank = hreset ? 0 : hblankon ? 1 : hblank;
   assign next_vblank = vreset ? 0 : vblankon ? 1 : vblank;
   always @(posedge vclock) begin
      hcount <= hreset ? 0 : hcount + 1;
      hblank <= next_hblank;
      hsync <= hsyncon ? 0 : hsyncoff ? 1 : hsync;  // active low

      vcount <= hreset ? (vreset ? 0 : vcount + 1) : vcount;
      vblank <= next_vblank;
      vsync <= vsyncon ? 0 : vsyncoff ? 1 : vsync;  // active low

      blank <= next_vblank | (next_hblank & ~hreset);
   end
endmodule

/////////////////////////////////////////////////////////////////////////////
// generate display pixels from reading the ZBT ram
// note that the ZBT ram has 2 cycles of read (and write) latency
//
// We take care of that by latching the data at an appropriate time.
//
// Note that the ZBT stores 36 bits per word; we use only 32 bits here,
// decoded into four bytes of pixel data.
//
// Bug due to memory management will be fixed. The bug happens because
// memory is called based on current hcount & vcount, which will actually
// shows up 2 cycle in the future. Not to mention that these incoming data
// are latched for 2 cycles before they are used. Also remember that the
// ntsc2zbt's addressing protocol has been fixed. 

// The original bug:
// -. At (hcount, vcount) = (100, 201) data at memory address(0,100,49) 
//    arrives at vram_read_data, latch it to vr_data_latched.
// -. At (hcount, vcount) = (100, 203) data at memory address(0,100,49) 
//    is latched to last_vr_data to be used for display.
// -. Remember that memory address(0,100,49) contains camera data
//    pixel(100,192) - pixel(100,195).
// -. At (hcount, vcount) = (100, 204) camera pixel data(100,192) is shown.
// -. At (hcount, vcount) = (100, 205) camera pixel data(100,193) is shown. 
// -. At (hcount, vcount) = (100, 206) camera pixel data(100,194) is shown.
// -. At (hcount, vcount) = (100, 207) camera pixel data(100,195) is shown.
//
// Unfortunately this means that at (hcount == 0) to (hcount == 11) data from
// the right side of the camera is shown instead (including possible sync signals). 

// To fix this, two corrections has been made:
// -. Fix addressing protocol in ntsc_to_zbt module.
// -. Forecast hcount & vcount 8 clock cycles ahead and use that
//    instead to call data from ZBT.


module vram_display(reset,clk,hcount,vcount,vr_pixel,
		    vram_addr,vram_read_data);

   input reset, clk;
   input [10:0] hcount;
   input [9:0] 	vcount;
   output [17:0] vr_pixel;//CHANGE
   output [18:0] vram_addr;
   input [35:0]  vram_read_data;

   //forecast hcount & vcount 8 clock cycles ahead to get data from ZBT
   wire [10:0] hcount_f = (hcount >= 1048) ? (hcount - 1048) : (hcount + 8);
   wire [9:0] vcount_f = (hcount >= 1048) ? ((vcount == 805) ? 0 : vcount + 1) : vcount;
      
   wire [18:0] 	 vram_addr = {vcount_f, hcount_f[9:1]}; //CHANGE

   wire  	 hc2 = hcount[0];//CHANGE
   reg [17:0] 	 vr_pixel; //CHANGE
   reg [35:0] 	 vr_data_latched;
   reg [35:0] 	 last_vr_data;

   always @(posedge clk)
     last_vr_data <= (hc2==1'b1) ? vr_data_latched : last_vr_data;//CHANGE

   always @(posedge clk)
     vr_data_latched <= (hc2==1'b0) ? vram_read_data : vr_data_latched;//CHANGE

   always @(*)		// each 36-bit word from RAM is decoded to 4 bytes
     case (hc2) //CHANGE
//       2'd3: vr_pixel = last_vr_data[17:0];   
//       2'd2: vr_pixel = last_vr_data[7+8:0+8];
       1'd1: vr_pixel = last_vr_data[17:0];
       1'd0: vr_pixel = last_vr_data[35:18];
     endcase

endmodule // vram_display


////////////////////////////////////////////////////////////////////////////
// ramclock module

///////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- ZBT RAM clock generation
//
//
// Created: April 27, 2004
// Author: Nathan Ickes
//
///////////////////////////////////////////////////////////////////////////////
//
// This module generates deskewed clocks for driving the ZBT SRAMs and FPGA 
// registers. A special feedback trace on the labkit PCB (which is length 
// matched to the RAM traces) is used to adjust the RAM clock phase so that 
// rising clock edges reach the RAMs at exactly the same time as rising clock 
// edges reach the registers in the FPGA.
//
// The RAM clock signals are driven by DDR output buffers, which further 
// ensures that the clock-to-pad delay is the same for the RAM clocks as it is 
// for any other registered RAM signal.
//
// When the FPGA is configured, the DCMs are enabled before the chip-level I/O
// drivers are released from tristate. It is therefore necessary to
// artificially hold the DCMs in reset for a few cycles after configuration. 
// This is done using a 16-bit shift register. When the DCMs have locked, the 
// <lock> output of this mnodule will go high. Until the DCMs are locked, the 
// ouput clock timings are not guaranteed, so any logic driven by the 
// <fpga_clock> should probably be held inreset until <locked> is high.
//
///////////////////////////////////////////////////////////////////////////////

module ramclock(ref_clock, fpga_clock, ram0_clock, ram1_clock, 
	        clock_feedback_in, clock_feedback_out, locked);
   
   input ref_clock;                 // Reference clock input
   output fpga_clock;               // Output clock to drive FPGA logic
   output ram0_clock, ram1_clock;   // Output clocks for each RAM chip
   input  clock_feedback_in;        // Output to feedback trace
   output clock_feedback_out;       // Input from feedback trace
   output locked;                   // Indicates that clock outputs are stable
   
   wire  ref_clk, fpga_clk, ram_clk, fb_clk, lock1, lock2, dcm_reset;

   ////////////////////////////////////////////////////////////////////////////
   
   //To force ISE to compile the ramclock, this line has to be removed.
   //IBUFG ref_buf (.O(ref_clk), .I(ref_clock));
	
	assign ref_clk = ref_clock;
   
   BUFG int_buf (.O(fpga_clock), .I(fpga_clk));

   DCM int_dcm (.CLKFB(fpga_clock),
		.CLKIN(ref_clk),
		.RST(dcm_reset),
		.CLK0(fpga_clk),
		.LOCKED(lock1));
   // synthesis attribute DLL_FREQUENCY_MODE of int_dcm is "LOW"
   // synthesis attribute DUTY_CYCLE_CORRECTION of int_dcm is "TRUE"
   // synthesis attribute STARTUP_WAIT of int_dcm is "FALSE"
   // synthesis attribute DFS_FREQUENCY_MODE of int_dcm is "LOW"
   // synthesis attribute CLK_FEEDBACK of int_dcm  is "1X"
   // synthesis attribute CLKOUT_PHASE_SHIFT of int_dcm is "NONE"
   // synthesis attribute PHASE_SHIFT of int_dcm is 0
   
   BUFG ext_buf (.O(ram_clock), .I(ram_clk));
   
   IBUFG fb_buf (.O(fb_clk), .I(clock_feedback_in));
   
   DCM ext_dcm (.CLKFB(fb_clk), 
		    .CLKIN(ref_clk), 
		    .RST(dcm_reset),
		    .CLK0(ram_clk),
		    .LOCKED(lock2));
   // synthesis attribute DLL_FREQUENCY_MODE of ext_dcm is "LOW"
   // synthesis attribute DUTY_CYCLE_CORRECTION of ext_dcm is "TRUE"
   // synthesis attribute STARTUP_WAIT of ext_dcm is "FALSE"
   // synthesis attribute DFS_FREQUENCY_MODE of ext_dcm is "LOW"
   // synthesis attribute CLK_FEEDBACK of ext_dcm  is "1X"
   // synthesis attribute CLKOUT_PHASE_SHIFT of ext_dcm is "NONE"
   // synthesis attribute PHASE_SHIFT of ext_dcm is 0

   SRL16 dcm_rst_sr (.D(1'b0), .CLK(ref_clk), .Q(dcm_reset),
		     .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
   // synthesis attribute init of dcm_rst_sr is "000F";
   

   OFDDRRSE ddr_reg0 (.Q(ram0_clock), .C0(ram_clock), .C1(~ram_clock),
		      .CE (1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));
   OFDDRRSE ddr_reg1 (.Q(ram1_clock), .C0(ram_clock), .C1(~ram_clock),
		      .CE (1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));
   OFDDRRSE ddr_reg2 (.Q(clock_feedback_out), .C0(ram_clock), .C1(~ram_clock),
		      .CE (1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));

   assign locked = lock1 && lock2;
   
endmodule

