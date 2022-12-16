`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jessica Quaye
// 
// Create Date:    14:58:18 12/05/2018 
// Design Name: 
// Module Name:    video 
//////////////////////////////////////////////////////////////////////////////////
module video( input clk,
               input one_hz_enable,
               input[23:0] visualization_pixel,
               input [10:0] hcount,
               input [9:0] vcount,
               input read_control,
               output [23:0] video_pixel,
               output ram1_we_b,
               output[18:0] ram1_address,
               inout [35:0] ram1_data,
               output ram1_cen_b,
               output reg use_video_pixel
    );
        
   //WRITE TO ZBT 
   wire write_vram_we; 
   wire [18:0] write_vram_addr;
   wire [35:0] vram_read_data;
   wire [35:0] vram_write_data;
   wire [1:0] write_state;
   wire out_write_position;
   wire now_read;

   write_to_zbt writing_section(.clk(clk), .one_hz_enable(one_hz_enable), .visualization_pixel(visualization_pixel),
                           .write_state(write_state), .read_control(read_control),
                           .out_write_position(out_write_position),
                           .we(write_vram_we), .addr_wire(write_vram_addr), .write_data(vram_write_data), 
                           .hcount(hcount), .vcount(vcount), 
                           .now_read(now_read));
                           
   
   //READ FROM ZBT
   wire start_read;
   wire read_vram_we;
   wire [18:0]read_vram_addr;
   wire read_state;
   wire out_reading_state;
   
   read_from_zbt reading_section(.clk(clk), .pixel_out(video_pixel), .start_read(read_control), .one_hz_enable(one_hz_enable),
            .data_in(vram_read_data), .we(read_vram_we), .addr_out(read_vram_addr), .hcount(hcount), .vcount(vcount),
            .read_state(read_state) , .out_reading_state(out_reading_state), .right(right));
            

   //INTERFACE WITH STAFF ZBT MODULE
   reg[18:0] vram_addr; 
  reg zbt_vram_we;

  //use read_control and now_read signal to determine when to read from memory
   always @(posedge clk) begin      
      if (read_control == 1) begin
            //set everything to reading state 
            if (now_read == 1) begin
               vram_addr <= read_vram_addr;
               zbt_vram_we <= 0;
               use_video_pixel <= 1;
            end
      end
      
      else begin
         vram_addr <= write_vram_addr;
         zbt_vram_we <= 1;
         use_video_pixel <= 0;
      end
      
   end
      
   zbt_6111 zbt1(.clk(clk), .cen(1'b1), .we(zbt_vram_we), .addr(vram_addr), .write_data(vram_write_data), //REPLACE VRAM WRITE DATA
   .read_data(vram_read_data), .ram_we_b(ram1_we_b), .ram_address(ram1_address), .ram_data(ram1_data), .ram_cen_b(ram1_cen_b));

            
endmodule //end of video module

module write_to_zbt(input clk, input one_hz_enable, input[23:0] visualization_pixel, input read_control,
                     output reg we, output[18:0] addr_wire, output reg[35:0] write_data, output [1:0] write_state, 
                     output out_write_position,
                     output reg now_read,
                     input [10:0] hcount,
                     input [9:0] vcount);
         
      reg first = 0;
      reg [18:0] addr_counter;
      reg placeholder;
      
      `include "params.v"
      
      reg[1:0] state; 
      parameter IDLE = 2'd0;
      parameter WRITING = 2'd1;
      
      reg write_position = 0;
      parameter FIRST = 0;
      parameter SECOND = 1;
      
      reg [18:0] addr = {19{1'b1}};
      
      always @ (posedge clk) begin
//         //have a reg that assigns 1 when one_hz_enable == 1 and don't turn it off until idle has seen it
         if (one_hz_enable == 1) placeholder <= 1;
         case(state) 
            IDLE: 
            begin
               if (read_control == 1) now_read <= 1;
               
               else begin
                  if ((placeholder == 1) && (hcount == 0) && (vcount == 0)) begin
                     we <= 0;
                     placeholder <= 0;
                     state <= WRITING; //each second, record a frame till the buffer is full 
                     addr_counter <= 19'b0;
                     write_position <= FIRST;
                     now_read <= 0;
                  end
               end
            end
            
            WRITING:
            begin
               if (hcount[1:0] == 2'b00 && vcount[1:0] == 2'b00  && (hcount < 'd1024) && (vcount < 'd768)) begin
                  case(write_position)
                  FIRST:
                     begin
                        write_data[35:18] <= {visualization_pixel[23:18],visualization_pixel[15:10],visualization_pixel[7:2]} ; //write 18 pixels of data to the lhs
                        write_position <= SECOND;
                        we <= 1'b0;
                     end //end of first
                  SECOND:
                     begin
                        write_data[17:0] <= {visualization_pixel[23:18],visualization_pixel[15:10],visualization_pixel[7:2]} ;
                        write_position <= FIRST; //go to first because you need to have data =(first, second)
                        we <= 1'b1; //send a write enable because we have a full address

                        //at end of one frame, move to idle state and wait for
			//one second before coming to write another frame
                        if (addr_counter == (NUM_LINES_PER_FRAME - 1)) begin //keep track of address of multiple 24576 = 256 * 192  / (2  pixels per line)
                              addr_counter <= 0; 
                              state <= IDLE;
                        end

                        else addr_counter <= addr_counter + 1;

                        //wrap around address when you hit the end of 20 frames
                        if (addr == NUM_FRAMES_X_LINES) addr <= 0; //24576*20frames
                        else addr <= addr + 1; //increment address by 1                  
                           
                     end //end of SECOND                     
                     endcase
               end // if hcount and vcount are a multiple of 4
               

            end //end of WRITING state      
         endcase //end of state machine
      end //end always
      
      assign write_state = state;
      assign out_write_position = write_position;

      assign addr_wire = addr;

endmodule //write_to_zbt

module read_from_zbt(input clk, output reg[23:0] pixel_out, input start_read, input one_hz_enable,
                 input[35:0] data_in, output we, output reg[18:0] addr_out,
                 input [10:0] hcount,
                   input [9:0] vcount,
                 input right,
                 output read_state,
                 output out_reading_state);
                 
      `include "params.v"
                 
      assign we = 0; //indicate we are reading
       reg place_holder;
      
       reg state = 0;
      parameter INITIAL = 0;
      parameter READING = 1;
      
       reg[2:0] reading_state = 3'b0;
      parameter FIRST = 3'd0;
      parameter SECOND = 3'd1;
      
      reg [18:0] addr_counter;
     reg [5:0] frames_so_far = 6'b0;      
       reg [18:0] addr_held_for_align;
          
      always @ (posedge clk) begin
         if (one_hz_enable == 1) place_holder <= 1;
         
         case(state)
            INITIAL: begin
               addr_out <= 19'd0;
               pixel_out <= 24'hFF_FF_FF;
               if ((start_read == 1) && (hcount == 0) && (vcount == 0))begin
                  //wait for another cycle before moving to read because you need 2 cycles of delay and this applies 
                  state <= READING; 
               end
            end
            
            READING: begin
               case(reading_state)
                  FIRST: begin
   //                  read_data[35:18]is 18 bits so append 0s after each 6
                     pixel_out <= {{data_in[35:30], 2'b0} , {data_in[29:24], 2'b0}, {data_in[23:18], 2'b0}};
                     reading_state <= SECOND;
                  end
                  
                  SECOND: begin
   //                read_data[17:0]is 18 bits so append 0s after each 6 bits
                     pixel_out <= {{data_in[17:12], 2'b0} , {data_in[11:6], 2'b0}, {data_in[5:0], 2'b0}};

                     if ((hcount < FRAME_WIDTH) && (vcount < FRAME_HEIGHT)) begin //if within region && hcount is even
                              if (addr_counter == (NUM_LINES_PER_FRAME - 1)) begin
                                    if ((place_holder == 1)) begin
                                       place_holder <= 0;
                                       addr_out <= addr_out + 1;
                                       addr_counter <= 0;
                                       reading_state <= FIRST;                     						
                                    end
                              
                                    else begin
                                       addr_out <= addr_out - (NUM_LINES_PER_FRAME - 1);
                                       addr_counter <=0;
                                       reading_state <= FIRST;
                                    end
                              end
                                 
                              else begin //otherwise, it's business as usual. increment address by 1 and progress
                                 addr_counter <= addr_counter + 1;
                                 addr_out <= addr_out + 1; //increment address by 1
                                 reading_state <= FIRST;
                              end                        
                        
                     end //hcount == FRAME WIDTH
                     
                     else pixel_out <= 24'd0;
                     
                  end //end SECOND
                  
               endcase// endcase for reading state
               
               if (start_read == 0) state <= INITIAL;
            end //end READING
            
         endcase
      end //end always
      
      assign read_state = state;
      assign out_reading_state = reading_state;
      
endmodule //read_from_zbt


