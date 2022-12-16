`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jessica Quaye 
// 
// Create Date:    22:38:34 11/27/2018 
// Design Name: 
// Module Name:    led_strip 
//////////////////////////////////////////////////////////////////////////////////
module led_strip(
    input clk,
    input led_clock,
    input red_signal,
    input yellow_signal, 
    input green_signal,
    output reg main_led_data,
    output reg main_enable_led_clock
    );
   
   `include "params.v"

   //at each rising edge of the clock we have a new frame to send 
   //initialize frames of different colors with format 3 intro bits, 5 global bits, 8'bB, 8'bG, 8'bR 
   reg[31:0] red_frame =    32'b111_00011_0000_0000_0000_0000_1111_1111; //3 intro bits, 5 global bits, 8'bB, 8'bG, 8'bR 
   reg[31:0] green_frame =  32'b111_00011_0000_0000_1111_1111_0000_0000; //3 intro bits, 5 global bits, 8'bB, 8'bG, 8'bR 
   reg[31:0] yellow_frame = 32'b111_00011_0000_0000_1111_1111_1111_1111; //3 intro bits, 5 global bits, 8'bB, 8'bG, 8'bR 
   reg[31:0] blank_frame = 32'b111_00011_0000_0000_0000_0000_0000_0000; //3 intro bits, 5 global bits, 8'bB, 8'bG, 8'bR    
   
   //FSM parameters
   reg [2:0] state = 3'b000;
   
   //counters 
   reg [4:0] start_counter = 5'b0; //initialize counter to count 32 bits for start
   reg [1:0] frame_color; //determine which color frame we are sending according to RED = 0, YELLOW = 1, GREEN = 2
   reg [4:0] led_frame_counter = 5'd31; //initialize counter to count 32 bits for each frame
   reg [4:0] same_frame_counter = 5'd0; //need to send 27 frames of each color so used to send same frame till 27
   reg [7:0] blank_counter = 8'd0; //send blank bits
   
   //used to control whether (RED, YELLOW, GREEN) LEDs will be on or off
   reg [2:0] switch_control_values = 3'b0;    
   
   //store prev led clock 
   reg prev_led_clock;
   
   always @(posedge clk) begin
   prev_led_clock <= led_clock;
   
   if (prev_led_clock == 0 && led_clock == 1) begin //begin at rising edge of led_clock
      case(state)
         SEND_START_FRAME: //send 32'b0 to wire as start frame
         begin   
            main_led_data <= 1'b0;
            main_enable_led_clock <= 1;
            
            if (start_counter == 5'd31)
               begin
                  start_counter <= 5'b0;
                  frame_color <= 2'b0; //initialize all these parameters for following state
                  led_frame_counter <= 5'd31;
                  same_frame_counter <= 5'd0;
                  state <= SEND_FRAME; //move to next frame when the 31st bit is sent
               end
            
            else start_counter <= start_counter + 1;

         end
         
         SEND_FRAME:
         begin
            //choose which color to send
            if (frame_color == RED) //current focus is on RED section
               begin
                  if (switch_control_values[0] == 1)main_led_data <= red_frame[led_frame_counter]; //if signal for RED is on, turn on RED
                  else main_led_data <= blank_frame[led_frame_counter]; //else supply blank frames
               end
            else if (frame_color == YELLOW) //current focus is on YELLOW section
               begin
                  if (switch_control_values[1] == 1) main_led_data <= yellow_frame[led_frame_counter]; //if signal for YELLOW is on, turn on YELLOW
                  else main_led_data <= blank_frame[led_frame_counter]; //else supply blank frames
               end
            else if (frame_color == GREEN) //current focus is on GREEN section
               begin
                  if (switch_control_values[2] == 1)main_led_data <= green_frame[led_frame_counter]; //if signal for GREEN is on, turn on GREEN
                  else main_led_data <= blank_frame[led_frame_counter]; //else supply blank frames
               end 
            else state <= SEND_BLANK_FRAME;
                     
            if (led_frame_counter == 5'b0) //when you are done with one frame (one LED)
                  begin
                     led_frame_counter <= 5'd31;
                                 
                     if (same_frame_counter == 5'd6) //if all LEDs for one section are handled, move to another color's frame
                           begin
                              same_frame_counter <= 5'd0;
                              
                              if (frame_color == GREEN) state <= SEND_BLANK_FRAME; //after GREEN, just fill blank frames
                              else frame_color <= frame_color + 1;         	
                           end
                     
                     else same_frame_counter <= same_frame_counter + 1; //else stay in same frame and keep sending more
                  end
               
            else led_frame_counter <= led_frame_counter - 1; //otherwise continue iterating through the frame reg to index frame values
         end
         

         SEND_BLANK_FRAME: 
         begin
            main_led_data <= blank_frame[led_frame_counter];
            
         if (led_frame_counter == 5'b0)
               begin
               led_frame_counter <= 5'd31;
               
                  if (blank_counter == 8'd62) //after sending 2 full blank LEDs, send end frame
                  begin
                     state <= SEND_END_FRAME;
                     blank_counter <= 0;
                  end
                  
                  else blank_counter <= blank_counter + 1;
               end
            
         else led_frame_counter <= led_frame_counter - 1;
            
            
         end
         
         SEND_END_FRAME:
         begin
            start_counter <= start_counter + 1;
            main_led_data <= 1'b1;
            
            if (start_counter == 5'd31)
            begin
               main_enable_led_clock <= 0; //turn off main_enable_led_clock to avoid sending data after all frames have ended
               state <= READ_TRAFFIC_SIGNALS; //time to check switches
            end
         end
         
         READ_TRAFFIC_SIGNALS:
         begin
            switch_control_values <= {green_signal, yellow_signal, red_signal}; //invert what you expect because of how signals are sent - actually {r,y,g}
            state <= SEND_START_FRAME;
         end
         
      default: state <= SEND_START_FRAME;
      endcase
      
      end //end if one_mhz_enable   
   end // end always 

endmodule


