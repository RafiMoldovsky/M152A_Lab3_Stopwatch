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
	 input btnr,
	 input [7:0] sw,
	 
	 output [7:0] seg,
	 output [3:0] an
    );
wire clk_slow;	 
wire twohz_clk;
wire onehz_clk;
wire blink_clk;
wire much_faster_clk;

wire rst;
debouncer RstDebouncer(.clk_sys(clk), .button(btnd), .button_output(rst));

wire pause;
debouncer PauseDebouncer(.clk_sys(clk), .button(btnr), .button_output(pause));

reg pause_reg;
always @(posedge pause) begin
	pause_reg <= ~pause_reg;
end

reg [12:0] sec_counter;
wire [6:0] minutes;
wire [5:0] seconds;
reg [5:0] seconds_for_adj;

reg [7:0] sw_deb;
always @(posedge much_faster_clk) begin
	sw_deb <= sw;
end
	


assign minutes = sec_counter/60;
assign seconds = sec_counter%60;

/*
reg pending_rst;
always @(posedge much_faster_clk)
	if (rst == 1)
		pending_rst <= 1;
		*/
		
reg onehz_div;
reg [3:0] blink_which;

always @(posedge twohz_clk or posedge rst) begin
if (rst) begin
	sec_counter <= 0;
	onehz_div <= 0;
	blink_which <= 0;
end
else if (!pause_reg && !sw_deb[0]) begin // normal operation
		sec_counter <= (sec_counter+(onehz_div))%3600;
		onehz_div <= ~onehz_div;
		blink_which <= 0;
end
else if (!pause_reg && sw_deb[0]) // adjustment mode
begin
	if(sw[1]==0) begin
		//change minutes and blink
		blink_which <= 4'b1100;
		sec_counter<=sec_counter+60;
		end
	if(sw[1]==1)begin
		blink_which <= 4'b0011;
		if (seconds == 59)
			sec_counter <= sec_counter - 59;
		else
			sec_counter <= sec_counter + 1;
	end
end
end


clock_divider ClockDivider(.clk(clk), .rst(0),
.twohz_clk(twohz_clk), .onehz_clk(onehz_clk), .blink_clk(blink_clk),
.much_faster_clk(much_faster_clk));
	 
fourdig_7seg FourDigSevenSeg(.clk(much_faster_clk), .blink_clk(blink_clk), .blink_which(blink_which),
.minutes(minutes), .seconds(seconds), .seg(seg), .an(an));


endmodule

module slow_clock (input clk, output clk_slow);

reg [30:0] ctr;
assign clk_slow = ctr[24];

always @(posedge clk)
	ctr <= ctr+1;

endmodule


module fourdig_7seg(
	input clk,
	input blink_clk,
	input [3:0] blink_which, // 0000 for nothing, 1100 for min, 0011 for sec
	input [6:0] minutes,
	input [6:0] seconds,
	output [7:0] seg,
	output [3:0] an);

reg [1:0] ctr;
reg [3:0] dig;
reg [3:0] an_fast;

assign an = an_fast | (blink_which * blink_clk);

to_7seg To_7Seg(.dig(dig), .seg(seg));
	
always @(posedge clk) begin
ctr <= ctr+1;
if (ctr == 0) begin
	dig <= seconds % 10;
	an_fast <= 4'b1110;
end else if (ctr == 1) begin
	an_fast <= 4'b1101;
	dig <= seconds / 10;
end else if (ctr == 2) begin
	dig <= minutes % 10;
	an_fast <= 4'b1011;
end else begin
	an_fast <= 4'b0111;
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
