`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jessica Quaye
// 
// Create Date:    13:32:18 11/05/2018 
// Design Name: 
// Module Name:    led_controller 
//////////////////////////////////////////////////////////////////////////////////

//default convention for color output. RED = 0, YELLOW = 1, GREEN = 2
module led_controller(
    input clk,
    input [1:0] main_out,
    input [1:0]side_out,
    output reg main_red,
    output reg main_yellow,
    output reg main_green,
    output reg side_red,
    output reg side_yellow,
    output reg side_green);
    
    `include "params.v"  
    always @(posedge clk)
    begin
   	case(main_out) //determine outputs for main traffic lights
   		RED: 
   		begin
   			main_red <= ON;
   			main_yellow <= OFF;
   			main_green <= OFF;
   		end
   		
   		YELLOW:
   		begin
   			main_red <= OFF;
   			main_yellow <= ON;
   			main_green <= OFF;
   		end
   		
   		GREEN:
   		begin
   			main_red <= OFF;
   			main_yellow <= OFF;
   			main_green <= ON;
   		end			
   	default:;
   	endcase
   	
   	case(side_out) //determine outputs for side traffic lights
   		RED: 
   		begin
   			side_red <= ON;
   			side_yellow <= OFF;
   			side_green <= OFF;
   		end
   		
   		YELLOW:
   		begin
   			side_red <= OFF;
   			side_yellow <= ON;
   			side_green <= OFF;
   		end
   		
   		GREEN:
   		begin
   			side_red <= OFF;
   			side_yellow <= OFF;
   			side_green <= ON;
   		end			
   	default:;
   	endcase   	
    end //end always
endmodule
