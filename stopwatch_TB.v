`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:04:18 02/10/2022
// Design Name:   stopwatch
// Module Name:   C:/Users/Student/Xilinx/lab3_12pm/stopwatch_TB.v
// Project Name:  lab3_12pm
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: stopwatch
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module stopwatch_TB;

	// Inputs
	reg clk;
	reg btnd;

	// Outputs
	wire [7:0] seg;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	stopwatch uut (
		.clk(clk), 
		.btnd(btnd), 
		.seg(seg), 
		.an(an)
	);
	
	always @(*) begin
		clk = ~clk; #5;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		btnd = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		btnd = 1;
		
		#1000000000;
		
		btnd = 0;
        
		// Add stimulus here

	end
      
endmodule

