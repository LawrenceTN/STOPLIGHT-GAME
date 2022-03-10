`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/7/2020 12:22:07 PM
// Design Name: 
// Module Name: Segment Display
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