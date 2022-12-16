`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Premila Rowles
// 
// Create Date:    18:16:21 12/01/2018 
// Design Name: 
// Module Name:    region
//////////////////////////////////////////////////////////////////////////////////
module region

   #(parameter UPPER_X = 353, 
    UPPER_Y = 272, 
    LOWER_X = 459, 
    LOWER_Y = 368)
    
    (input clk,
    input clock,
    input [17:0] vr_pixel,
    input [10:0] hcount,
    input [9:0] vcount,
    input display,
    output reg [23:0] x_avg_green,
    output reg [23:0] y_avg_green,
    output reg [23:0] x_avg_blue,
    output reg [23:0] y_avg_blue,
    output reg new_car,
    output reg [4:0] state,
    output reg end_frame,
    output reg start_frame

    );
   wire sign = 0;
   reg start = 0;

   reg [23:0] x_sum_g;
   reg [23:0] y_sum_g;

   reg [23:0] x_sum_b;
   reg [23:0] y_sum_b;


   reg [23:0] x_sum_green;
   reg [23:0] y_sum_green;
   reg [13:0] count_green;
   reg [23:0] x_sum_blue;
   reg [23:0] y_sum_blue;
   reg [13:0] count_blue;

   reg [13:0] count_avg_g;

   reg [13:0] count_avg_b;

   reg started_division;

   wire [11:0] x_quotient_g;
   wire [11:0] y_quotient_g;
   wire [10:0] remainder_x_g;
   wire [10:0] remainder_y_g;
   wire ready_x_g;
   wire ready_y_g;


   reg x_done_g;
   reg y_done_g;


   wire [11:0] x_quotient_b;
   wire [11:0] y_quotient_b;
   wire [10:0] remainder_x_b;
   wire [10:0] remainder_y_b;
   wire ready_x_b;
   wire ready_y_b;

   reg x_done_b;
   reg y_done_b;

   parameter RESET = 0;
   parameter LOAD_DATA = 1;
   parameter READY_X_READY_Y = 2;
   parameter BOTH_DONE = 3;
   parameter REGION_ONE_BLUE = 4;
   parameter REGION_TWO_GREEN = 5;
   parameter REGION_TWO_BLUE = 6;





    always @(posedge clk) // cross hairs generation
     begin
      
         if (hcount == 0 && vcount == 0) begin
               x_sum_green <= 0;
               y_sum_green <= 0;
               count_green <= 1;
               x_sum_blue <= 0;
               y_sum_blue <= 0;
               count_blue <= 1;

            end 


         // start accumulations based on bounds and based on color (vr_pixel[11:6] is green)
         if ((display) && (hcount > UPPER_X) && (hcount < LOWER_X) && (vcount > UPPER_Y) && 
                (vcount < LOWER_Y) && (vr_pixel[11:6] == 6'b11_1111)) begin //region one and green
//         
            x_sum_green <= x_sum_green + hcount;
            y_sum_green <= y_sum_green + vcount;
            count_green <= count_green + 1;   
            
         end
         //vr_pixel[5:0] is blue
         if ((display) && (hcount > UPPER_X) && (hcount < LOWER_X) && (vcount > UPPER_Y) && 
                (vcount < LOWER_Y) && (vr_pixel[5:0] == 6'b11_1111)) begin //region one and green

            x_sum_blue <= x_sum_blue + hcount;
            y_sum_blue <= y_sum_blue + vcount;
            count_blue <= count_blue + 1;
         end
   
        //state machine for dividing
      case(state)
         //reset state to set all values to 0 at start of frame
         RESET : begin
            if (hcount == 0 && vcount == 0) begin
               start <= 0;
               x_sum_g <= 0;
               y_sum_g <= 0;
               count_avg_g<= 0;
               x_sum_b <= 0;
               y_sum_b <= 0;
               count_avg_b <= 0;
               // once we reach the end of the frame, we have calculated all of our sums
               // and we can start dividing
            if (hcount == 750 && vcount == 550) begin
               state <= LOAD_DATA;
               started_division <= 1;
   
            end else started_division <= 0;
            end
            

         //load data- pass in sums and count to dividend and divisor and assert start for a clock cycle
         LOAD_DATA : begin
               if (started_division) begin

                  start <= 1;
                  
                  x_sum_g <= x_sum_green;
                  y_sum_g <= y_sum_green;
                  count_avg_g<= count_green;
                  
                  x_sum_b <= x_sum_blue;
                  y_sum_b <= y_sum_blue;
                  count_avg_b<= count_blue;
                  
                  started_division <= 0;
                  state <= READY_X_READY_Y;
               end else start <= 0;
            end

         // wait for divisions to end 
         // set averages to 0 if count is less than 300 (most likely due to noise)
         READY_X_READY_Y : begin
               start <= 0;
               if (ready_x_g) begin
                  if (count_green < 300) x_avg_green <= 0;
                  else begin
                     new_car <= 1;
                     x_avg_green <= x_quotient_g;
                  end
                  x_done_g <= 1;
               end
               if (ready_y_g) begin
                  if (count_green < 300) y_avg_green <= 0;
                  else begin
                     new_car <= 1;
                     y_avg_green <= y_quotient_g;
                  end
                  y_done_g <= 1;
               end
               if (ready_x_b) begin
                  if (count_blue < 300) x_avg_blue <= 0;
                  else begin
                     new_car <= 1;
                     x_avg_blue <= x_quotient_b;
                  end
                  x_done_b <= 1;
               end
               
               if (ready_y_b) begin   
                  if (count_blue < 300) y_avg_blue <= 0;
                  else begin
                     new_car <= 1;
                     y_avg_blue <= y_quotient_b;
                  
                  end
                  
                  y_done_b <= 1;
               end
               if (x_done_g && y_done_g && x_done_b && y_done_b) begin
                  state <= BOTH_DONE;
                  end_frame <= 1;
               end
            end

         // all averages calculated so we restart the FSM
         BOTH_DONE : begin
                  
                  state <= RESET;
                  started_division <= 1;
                  x_done_g <= 0;
                  y_done_g <= 0;
                  x_done_b <= 0;
                  y_done_b <= 0;
            
            end
            
            default : state <= RESET;
      endcase
   end
         
         //instantiate divider module for x and y sums for two different colors to happen in parallel
         divider divider_module(.clk(clk), .start(start), .sign(1'b0), .dividend(x_sum_g), .divider(count_avg_g),
         .quotient(x_quotient_g), .remainder(remainder_x_g), .ready(ready_x_g));
         
         divider divider_module2(.clk(clk), .start(start), .sign(1'b0), .dividend(y_sum_g), .divider(count_avg_g),
         .quotient(y_quotient_g), .remainder(remainder_y_g), .ready(ready_y_g));
   
         divider divider_module3(.clk(clk), .start(start), .sign(1'b0), .dividend(x_sum_b), .divider(count_avg_b),
         .quotient(x_quotient_b), .remainder(remainder_x_b), .ready(ready_x_b));
         
         divider divider_module4(.clk(clk), .start(start), .sign(1'b0), .dividend(y_sum_b), .divider(count_avg_b),
         .quotient(y_quotient_b), .remainder(remainder_y_b), .ready(ready_y_b));
   

         
    
endmodule


