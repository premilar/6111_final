`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jessica Quaye
// 
// Create Date:    21:21:17 11/18/2018 
// Design Name: 
// Module Name:    collision_detector 
//////////////////////////////////////////////////////////////////////////////////
module collision_detector(
    input clk,
    input[10:0] car1_leftx,car2_leftx, street_leftx,
    input[10:0] car1_rightx,car2_rightx, street_rightx,
    input[9:0] car1_topy, car2_topy, street_topy,
    input[9:0] car1_bottomy, car2_bottomy, street_bottomy,
    output reg direction,
    output reg is_collision,
    output reg[10:0] leftx_threshold, rightx_threshold,
    output reg[9:0] uppery_threshold, lowery_threshold);
    
    `include "params.v"
    
    //TO DO 
    always @ (posedge clk) begin    
    //determine the ranges of the car to tell you if this will be VERTICAL or HORIZONTAL collision
    //determine if its on the HORIZONTAL street
    if ((street_topy <= car2_topy) && (car2_bottomy <= street_bottomy)) direction <= HORIZONTAL;
    else if ((street_leftx <= car2_leftx) && (car2_rightx <= street_rightx)) direction <= VERTICAL;
    
    //determine if a collision has occured 
    if ((car1_leftx < car2_rightx) && (car1_rightx > car2_leftx) && (car1_topy < car2_topy) && (car1_bottomy > car2_topy)) 
      begin
      is_collision <= TRUE;
      end
      
   else if ((car2_leftx < car1_rightx) && (car2_rightx > car1_leftx) && (car2_topy < car1_topy) && (car2_bottomy > car1_topy)) 
      begin
      is_collision <= TRUE;
      end
      
   else is_collision <= FALSE;
   
   
   //determine thresholds or stopping points for ambulances
   //determine y thresholds
   if (car2_topy < car1_topy) uppery_threshold <= car2_topy;
   else uppery_threshold <= car1_topy;
   
   if (car2_bottomy > car1_bottomy) lowery_threshold <= car2_bottomy;
   else lowery_threshold <= car1_bottomy;
   
   //determine x thresholds
   if (car2_leftx < car1_leftx) leftx_threshold <= car2_leftx;
   else leftx_threshold <= car1_leftx;
   
   if (car2_rightx > car1_rightx) rightx_threshold <= car2_rightx;
   else rightx_threshold <= car1_rightx;
   
   end //end always

endmodule 


module calc_ambulance_params(input clk,
    input [10:0] leftx_threshold, rightx_threshold, street_leftx, street_rightx,
    input [9:0] uppery_threshold, lowery_threshold, street_topy, street_bottomy,
    input direction,
    input is_collision,
    output reg[1:0] ambulance_move_dir,
    output reg[10:0] ambulance_dest_x,
    output reg[9:0] ambulance_dest_y);
    
    `include "params.v"
        
    always @(posedge clk) begin
      if (direction == VERTICAL && is_collision == TRUE)
      begin
         if (lowery_threshold < street_topy) //ambulance move up to lower
         begin
            ambulance_move_dir <= MOVE_UP;
            ambulance_dest_y <= lowery_threshold;
         end
         
         else if (uppery_threshold > street_bottomy) //ambulance move down to upper
         begin
            ambulance_move_dir <= MOVE_DOWN;
            ambulance_dest_y <= uppery_threshold;
         end
      end
      
      if (direction == HORIZONTAL && is_collision == TRUE)
      begin
         if (leftx_threshold > street_rightx) //ambulance move left towards leftmost
         begin
            ambulance_move_dir <= MOVE_RIGHT;
            ambulance_dest_x <= leftx_threshold;
         end
         
         else if (rightx_threshold < street_leftx) // ambulance move right towards rightmost edge
         begin
            ambulance_move_dir <= MOVE_LEFT;
            ambulance_dest_x <= rightx_threshold;
         end
      end      
   
    end //end always
    

endmodule

module get_amb_xy(input clk,
                   input one_hz_enable,
                   input is_collision,
                   input [1:0] ambulance_move_dir,
                   input [10:0]  ambulance_dest_x,
                   input [9:0] ambulance_dest_y, 
                   output reg[10:0] ambulance_leftx,  ambulance_width,
                   output reg[9:0] ambulance_topy, ambulance_height);
                   
  `include "params.v"                
   reg amb_state = 0;

   always @(posedge clk)begin

         //determine if an ambulance is needed, ie, collision has occured
         if (is_collision == 1) begin
               begin               
                  case(ambulance_move_dir)      
                     MOVE_LEFT:
                     begin
                        ambulance_width <= 11'd100;
                        ambulance_height <= 10'd34;
                        ambulance_topy <= 10'd364;
                        if ((one_hz_enable == 1) && ((ambulance_leftx - CSPEED) > ambulance_dest_x) ) ambulance_leftx <= ambulance_leftx - CSPEED;
                     end
                     
                     MOVE_RIGHT:
                     begin
                        ambulance_width <= 11'd100;
                        ambulance_height <= 10'd34;
                        ambulance_topy <= 10'd364;
                        if ((one_hz_enable == 1) && ((ambulance_leftx + CSPEED) < ambulance_dest_x - ambulance_width) ) ambulance_leftx <= ambulance_leftx + CSPEED;
                     end
                     
                     MOVE_UP:
                     begin
                        ambulance_width <= 11'd34;
                        ambulance_height <= 10'd100;
                        ambulance_leftx <= 11'd520;
                        if ((one_hz_enable == 1) && ((ambulance_topy - CSPEED) > ambulance_dest_y) ) ambulance_topy <= ambulance_topy - CSPEED;
                     end
                     
                     MOVE_DOWN:
                     begin
                        ambulance_width <= 11'd34;
                        ambulance_height <= 10'd100;
                        ambulance_leftx <= 11'd425;
                        if ((one_hz_enable == 1) && ((ambulance_topy + CSPEED) < (ambulance_dest_y - ambulance_height)) ) ambulance_topy <= ambulance_topy + CSPEED;
                     end         
                  default:;
                  endcase
               end //end of move amb state   
         end //end if collision == 1
         
         else begin                  
                  case(ambulance_move_dir)      
                     MOVE_LEFT:
                     begin
                        ambulance_width <= 11'd100;
                        ambulance_height <= 10'd34;
                        ambulance_leftx <= 11'd1024 - ambulance_width;
                        ambulance_topy <= 10'd364;
                     end
                     
                     MOVE_RIGHT:
                     begin
                        ambulance_width <= 11'd100;
                        ambulance_height <= 10'd34;
                        ambulance_leftx <= 11'd0;
                        ambulance_topy <= 10'd364;
                     end
                     
                     MOVE_UP:
                     begin
                        ambulance_width <= 11'd34;
                        ambulance_height <= 10'd100;
                        ambulance_leftx <= 11'd520;
                        ambulance_topy <= 10'd768 - ambulance_height;   
                     end
                     
                     MOVE_DOWN:
                     begin
                        ambulance_width <= 11'd34;
                        ambulance_height <= 10'd100;
                        ambulance_leftx <= 11'd425;
                        ambulance_topy <= 11'd0;      
                     end         
                  default:;
                  endcase
         end
       end //end always
       

endmodule 

