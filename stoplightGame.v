`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2020 10:13:37 AM
// Design Name: 
// Module Name: stoplightGame
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stoplightGame #(parameter SECOND = 100_000_000 - 1)

       (input [15:0] sw, // SWITCHES
        input clk, btnC, btnR, btnL,
        output [6:0] seg, // 7-DISPLAY SEGMENT
        output [3:0] an, // SEGMENT POSITION 4 USED
        output reg [15:0] led); // LEDs used 
        
    
    reg startFlag = 0; // Flag used for starting game
    reg playingFlag = 0; // User turns this on/off based on button

    reg [3:0] d0;
    reg [3:0] d3;

    reg [1:0] blink = 0;
    reg secondwin;
    
    // Used in case statement                     
    reg [3:0] state = idle; 

    // Cases for displaying the current pattern
    parameter idle = 4'b0000; 
    parameter pattern1 = 4'b0001;
    parameter pattern2 = 4'b0010;
    parameter pattern3 = 4'b0011;
    parameter victory = 4'b0100;
    parameter defeat = 4'b0101;
    parameter finish = 4'b0110;

    
    reg [26:0] counter; // Counts from 0 to 99,999,999 (SECOND)
    reg [26:0] counter1; // Counter used for pattern 1
    reg [26:0] counter2; // Counter used for pattern 2    
    reg [26:0] counter3; // Counter used for pattern 3    

    
    reg [4:0] x = 1; 
    reg [4:0] y = 0;

    
            
    SegmentDisplay SD (.clk(clk), .input0(d0), .input3(d3), .an(an), .seg(seg));               
                     
/***********************************************************************************************************/    
    always @(posedge clk) begin
    
        case (state) 
            ////////////////////////////////////////////////////////////////////////
            // Wait for game to start
            idle: begin
            
                 d3 <= 0; // Right most digit shows the step
                 d0 <= 0; // Left most digit shows the number to obtain

 
            if (btnC) begin        
            
                startFlag <= 1; 

                      end

            if (startFlag == 0) begin // If game has not started
               if (counter < SECOND/2) begin
                        // Turn on even LED
                        led[0] <= 1;
                        led[2] <= 1;
                        led[4] <= 1;
                        led[6] <= 1;
                        led[8] <= 1;
                        led[10] <= 1;
                        led[12] <= 1;
                        led[14] <= 1;
                        // Turn off odd LED
                        led[1] <= 0;
                        led[3] <= 0;
                        led[5] <= 0;
                        led[7] <= 0;
                        led[9] <= 0;
                        led[11] <= 0;
                        led[13] <= 0;
                        led[15] <= 0;                        
                                          end
                    else begin
                        // Turn off even LED
                        led[0] <= 0;
                        led[2] <= 0;
                        led[4] <= 0;
                        led[6] <= 0;
                        led[8] <= 0;
                        led[10] <= 0;
                        led[12] <= 0;
                        led[14] <= 0;
                        // Turn on odd LED
                        led[1] <= 1;
                        led[3] <= 1;
                        led[5] <= 1;
                        led[7] <= 1;
                        led[9] <= 1;
                        led[11] <= 1;
                        led[13] <= 1;
                        led[15] <= 1;
                         end
                                end 
                
                //if (startFlag == 1) begin
                else                  begin
                        state <= pattern1;
                                      end
                        
                if (counter < SECOND) begin
                        counter <= counter + 1;
                                          end
                else begin
                        counter <= 0;
                     end
           end // Ends idle case
/***********************************************************************************************************/
           
           ////////////////////////////////////////////////////////////////////////
           // Begin the game                 
        pattern1: begin 
                
                 d3 <= 8; // Left most digit shows the number to obtain
                 d0 <= 1; // Right most digit shows the step
                 
                 playingFlag <= 1; // Circulate lights 
       
             if (btnR) begin 
                playingFlag = ~playingFlag;
                if (y == 8) begin // If correct, go to next state
                    counter <= 0;
                    blink <= 0;
                    secondwin <= 0;
                    state <= victory;
                            end
                else begin        // If wrong, go to idle

                    counter <= 0;
                    blink <= 0;
                    state <= defeat;
                     end                   
                                       end

                  
                        led[0] <= 0;
                        led[2] <= 0;
                        led[4] <= 0;
                        led[6] <= 0;
                        led[8] <= 0;
                        led[10] <= 0;
                        led[12] <= 0;
                        led[14] <= 0;
                        
                        led[1] <= 0;
                        led[3] <= 0;
                        led[5] <= 0;
                        led[7] <= 0;
                        led[9] <= 0;
                        led[11] <= 0;
                        led[13] <= 0;
                        led[15] <= 0;
                
                                        
              
              if (playingFlag == 1) begin // If user is currently playing:                                                       
                   if (counter1 < SECOND/8) begin // LED switches on/off every 1/8th seconds
                        counter1 <= counter1 + 1;
                        led[y] <= 1; // y = 0, so Zero is turned on 
                        led[x] <= 0; // x = 1, so One is turned off
                                     
                                              end
                   else                         begin
                        counter1 <= 0;
                        led[y] <= 0;
                        led[x] <= 1;
                        x = x + 1; // Starts at 0
                        y = y + 1; // Starts at 1 (LEADING)
                                                         
                        if (x == 16) begin
                            x <= 0;
                                     end
                        if (y == 16) begin
                            y <=  0;
                                     end                        
    
                                                end // Ends light circulation
                                   end // Ends playingFlag                                                                                                                                                           
                               end // Ends pattern1 case

/***********************************************************************************************************/            
          pattern2: begin
          
            
                 d3 <= 8; // Right most digit shows the step
                 d0 <= 2; // Left most digit shows the number to obtain
                 playingFlag <= 1; // Circulate lights 
                  
              if (btnR) begin 
                    playingFlag = ~playingFlag;
                    if (y == 8) begin
                        counter <= 0;
                        blink <= 0;        
                        secondwin <= 1;            
                        state <= victory;
                                end
                    else begin
                        counter <= 0;
                        blink <= 0; 
                        state <= defeat;
                       end                   
                          end
                  
                        led[0] <= 0;
                        led[2] <= 0;
                        led[4] <= 0;
                        led[6] <= 0;
                        led[8] <= 0;
                        led[10] <= 0;
                        led[12] <= 0;
                        led[14] <= 0;
                        
                        led[1] <= 0;
                        led[3] <= 0;
                        led[5] <= 0;
                        led[7] <= 0;
                        led[9] <= 0;
                        led[11] <= 0;
                        led[13] <= 0;
                        led[15] <= 0;
                
              
              if (playingFlag == 1) begin // If user is currently playing:                                                       
                   if (counter2 < SECOND/16) begin // LED switches on/off every 1/6th seconds
                        counter2 <= counter2 + 1;
                        led[y] <= 1; // y = 0, so Zero is turned on 
                        led[x] <= 0; // x = 1, so One is turned off 
                                              end
                   else                         begin
                        counter2 <= 0;
                        led[y] <= 0;
                        led[x] <= 1;
                        x = x + 1; // Starts at 0
                        y = y + 1; // Starts at 1 (LEADING)                    
                        if (x == 16) begin
                            x <= 0;
                                     end
                        if (y == 16) begin
                            y <=  0;
                                     end                        
    
                                                end // Ends light circulation
                                   end // Ends playingFlag                                                                                                                                                           
                               end // Ends pattern2 case
                      
/***********************************************************************************************************/
         pattern3: begin 
              
                 d3 <= 8; // Right most digit shows the step
                 d0 <= 3; // Left most digit shows the number to obtain
                 playingFlag <= 1; // Circulate lights 
                  
          if (btnR) begin  
                playingFlag = ~playingFlag;
                if (y == 8) begin 
                    counter <= 0;
                    blink <= 0;
                    state <= finish;
                            end
              else begin 
                    counter <= 0;
                    blink <= 0;
                    state <= defeat;
                   end                   
                    end
                                       
                  
                        led[0] <= 0;
                        led[2] <= 0;
                        led[4] <= 0;
                        led[6] <= 0;
                        led[8] <= 0;
                        led[10] <= 0;
                        led[12] <= 0;
                        led[14] <= 0;
                        
                        led[1] <= 0;
                        led[3] <= 0;
                        led[5] <= 0;
                        led[7] <= 0;
                        led[9] <= 0;
                        led[11] <= 0;
                        led[13] <= 0;
                        led[15] <= 0;
                
              
              if (playingFlag == 1) begin // If user is currently playing:                                                       
                   if (counter3 < SECOND/24) begin // LED switches on/off every 1/6th seconds
                        counter3 <= counter3 + 1;
                        led[y] <= 1; // y = 0, so Zero is turned on 
                        led[x] <= 0; // x = 1, so One is turned off 
                        
                                              end
                   else                         begin
                        counter3 <= 0;
                        led[y] <= 0;
                        led[x] <= 1;
                        x = x + 1; // Starts at 0
                        y = y + 1; // Starts at 1 (LEADING)
                        if (x == 16) begin
                            x <= 0;
                                     end
                        if (y == 16) begin
                            y <=  0;
                                     end                        
    
                                                end // Ends light circulation
                                   end // Ends playingFlag                                                                                                                                                           
                               end // Ends pattern3 case
/***********************************************************************************************************/       
          victory: begin
                                    
                    
                    if (counter < SECOND/2) begin
                        // Turn on even LED
                        led[0] <= 1;
                        led[2] <= 1;
                        led[4] <= 1;
                        led[6] <= 1;
                        led[8] <= 1;
                        led[10] <= 1;
                        led[12] <= 1;
                        led[14] <= 1;
                        // Turn off odd LED
                        led[1] <= 1;
                        led[3] <= 1;
                        led[5] <= 1;
                        led[7] <= 1;
                        led[9] <= 1;
                        led[11] <= 1;
                        led[13] <= 1;
                        led[15] <= 1;
                                            
                                          end
                    else begin
                        // Turn off even LED
                        led[0] <= 0;
                        led[2] <= 0;
                        led[4] <= 0;
                        led[6] <= 0;
                        led[8] <= 0;
                        led[10] <= 0;
                        led[12] <= 0;
                        led[14] <= 0;
                        // Turn on odd LED
                        led[1] <= 0;
                        led[3] <= 0;
                        led[5] <= 0;
                        led[7] <= 0;
                        led[9] <= 0;
                        led[11] <= 0;
                        led[13] <= 0;
                        led[15] <= 0;
                         end
                         
                if (counter < SECOND) begin
                        counter <= counter + 1;
                                          end
                else begin
                        counter <= 0;
                        blink <= blink + 1; // Blink 3 times making it 3 
                        if (blink == 2) begin
                            if (secondwin == 1) begin                                
                                state <= pattern3;
                                                end
                          else begin
                                state <= pattern2;
                               end
                                        end
                     end
                                end // End victory      
/***********************************************************************************************************/
                               
      finish: begin

                  d0 <= 4;
                                                    
                  if (btnL) begin
                        startFlag <= 0;
                        state <= idle;
                            end
                            
                  if (counter < SECOND/4) begin
                        // Turn on even LED
                        led[0] <= 1;
                        led[2] <= 1;
                        led[4] <= 1;
                        led[6] <= 1;
                        led[8] <= 1;
                        led[10] <= 1;
                        led[12] <= 1;
                        led[14] <= 1;
                        // Turn off odd LED
                        led[1] <= 1;
                        led[3] <= 1;
                        led[5] <= 1;
                        led[7] <= 1;
                        led[9] <= 1;
                        led[11] <= 1;
                        led[13] <= 1;
                        led[15] <= 1;
                                            
                                          end
                    else begin
                        // Turn off even LED
                        led[0] <= 0;
                        led[2] <= 0;
                        led[4] <= 0;
                        led[6] <= 0;
                        led[8] <= 0;
                        led[10] <= 0;
                        led[12] <= 0;
                        led[14] <= 0;
                        // Turn on odd LED
                        led[1] <= 0;
                        led[3] <= 0;
                        led[5] <= 0;
                        led[7] <= 0;
                        led[9] <= 0;
                        led[11] <= 0;
                        led[13] <= 0;
                        led[15] <= 0;
                         end
                         
                if (counter < SECOND/2) begin
                        counter <= counter + 1;
                                          end
                else begin
                        counter <= 0;
                     end
                                 end // End finish case

/***********************************************************************************************************/                                         
      defeat: begin

                  
                    if (counter < SECOND/4) begin
                        // Turn on LED
                        led[y] <= 1;  
                                          end
                    else begin
                        // Turn off LED
                        led[y] <= 0;
                         end
                         
                if (counter < SECOND/2) begin
                        counter <= counter + 1;
                                          end
                else begin
                        counter <= 0;
                        blink <= blink + 1;  
                        if (blink == 3) begin
                            startFlag <= 0;
                            state <= idle;
                                        end
                     end
                            
                            end
                        endcase // Ends case statement    
   end  // Ends always posedge
endmodule
/***********************************************************************************************************/                   
           
    

module SegmentDisplay(
    input clk,
    input [3:0] input3, input0,
    output reg [3:0] an, 
    output reg [6:0] seg
    );
    
    
    
    reg [18:0] counter  = 0;
    parameter max = 10000; // Counter will switch current segment (an) 
    
    reg currentan = 0; // Currentan represents 2 segments: either d0 or d3
    
    reg [7:0] segoutput [1:0]; // Array of 2 elements of 8-bits to represent (0-9 LCD)
    
    wire [3:0] twodisplay [1:0]; // twodisplay is a 3-bit wire that will be set to input 0 and input 3
    
    // Current will be iterating through inputs 0-3
    assign twodisplay[0] = input0;
    assign twodisplay[1] = input3;
    
    // Parameters used for segment display
    parameter zero = 7'b1000000;
    parameter one = 7'b1111001;
    parameter two = 7'b0100100;
    parameter three = 7'b0110000;
    parameter four = 7'b0011001;
    parameter five = 7'b0010010;
    parameter six = 7'b0000010;
    parameter seven = 7'b1111000;
    parameter eight = 7'b0000000;
    parameter nine = 7'b0011000;
    parameter ten = 7'b0001000;
    parameter eleven = 7'b0000011;
    parameter twelve = 7'b1000110; 
    parameter thirteen = 7'b0100001; 
    parameter fourteen = 7'b0000110;
    parameter fifteen = 7'b0001110;

    // Increase the counter every posedge CLK
    always @(posedge clk) begin
        
        if (counter < max) begin // If counter is less than max, increment it
            counter <= counter + 1;
                           end 
        else               begin // If reaches max, then increment current and reset 0 
            currentan <= ~currentan; // Current switches between 1 and 0 every time counter reaches max
            counter <= 0;
                           end
    
    case (twodisplay[currentan]) 
        // Current will always be changing every counter reaches max   
        0: segoutput[currentan] <= zero;
        1: segoutput[currentan] <= one; 
        2: segoutput[currentan] <= two;
        3: segoutput[currentan] <= three;
        4: segoutput[currentan] <= four;
        5: segoutput[currentan] <= five;
        6: segoutput[currentan] <= six;
        7: segoutput[currentan] <= seven;
        8: segoutput[currentan] <= eight;
        9: segoutput[currentan] <= nine;
    endcase
        
    case(currentan) // Sets the segment to what the segoutput is (0-4) 
        0: begin
            an <= 4'b1110;
            seg <= segoutput[0];
           end 
        1: begin
            an <= 4'b0111;
            seg <= segoutput[1];
           end
    endcase
  end   
endmodule

