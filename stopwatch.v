`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:38:33 02/08/2022 
// Design Name: 
// Module Name:    stopwatch 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module stopwatch(
    input clk,
	 input btnd,
	 output [7:0] seg,
	 output [3:0] an
    );
wire clk_slow;	 
wire twohz_clk;
wire onehz_clk;
wire blink_clk;
wire much_faster_clk;

wire rst;
debouncer RstDebouncer(.clk(much_faster_clk), .button(btnd), .button_output(rst));

reg [12:0] sec_counter;
wire [6:0] minutes;
wire [5:0] seconds;

assign minutes = sec_counter/60;
assign seconds = sec_counter%60;

always @(posedge onehz_clk) begin
	if (rst == 1)
		sec_counter <= 0;
	else if (sec_counter == 3599)
		sec_counter <= 0;
	else
		sec_counter <= sec_counter+1;
end

clock_divider ClockDivider(.clk(clk), .rst(0),
.twohz_clk(twohz_clk), .onehz_clk(onehz_clk), .blink_clk(blink_clk),
.much_faster_clk(much_faster_clk));
	 
fourdig_7seg FourDigSevenSeg(.clk(much_faster_clk), .minutes(minutes), .seconds(seconds), .seg(seg), .an(an));


endmodule

module slow_clock (input clk, output clk_slow);

reg [30:0] ctr;
assign clk_slow = ctr[24];

always @(posedge clk)
	ctr <= ctr+1;

endmodule


module fourdig_7seg(
	input clk,
	input [6:0] minutes,
	input [6:0] seconds,
	output [7:0] seg,
	output reg [3:0] an);

reg [1:0] ctr;
reg [3:0] dig;

to_7seg To_7Seg(.dig(dig), .seg(seg));
	
always @(posedge clk) begin
ctr <= ctr+1;
if (ctr == 0) begin
	dig <= seconds % 10;
	an <= 4'b1110;
end else if (ctr == 1) begin
	an <= 4'b1101;
	dig <= seconds / 10;
end else if (ctr == 2) begin
	dig <= minutes % 10;
	an <= 4'b1011;
end else begin
	an <= 4'b0111;
	dig <= minutes / 10;
end
	
	
end

endmodule

module to_7seg(input [3:0] dig, output reg [7:0] seg);
always @(*) begin
if (dig == 0)
	seg = 8'b11000000;
else if (dig == 1)
	seg = 8'b11111001; // BC
	else if (dig == 2) 
	seg = 8'b10100100; // ABDEG
	else if (dig == 3)
	seg = 8'b10110000; // ABCDG
	else if (dig == 4)
	seg = 8'b10011001; // BCFG
	else if (dig == 5)
	seg = 8'b10010010; // ACDFG
	else if (dig == 6)
	seg = 8'b10000010; // ACDEFG
	else if (dig == 7)
	seg = 8'b11111000; // ABC
	else if (dig == 8)
	seg = 8'b10000000; // ABCDEFG
	else if (dig == 9)
	seg = 8'b10010000; // ABCDFG
	// 
end
	
endmodule


