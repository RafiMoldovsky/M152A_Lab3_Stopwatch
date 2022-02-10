`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:38:33 02/08/2022 
// Design Name: 
// Module Name:    clock_divider 
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
module clock_divider(
    input wire clk,
    input wire rst,
    output wire 2hz_clk,
    output wire 1hz_clk,
    output wire blink_clk,
    output wire much_faster_clk
);

//100 MHz = 10^8 Hz master clock 
//want a 2hz, 1hz, >1hz, and a 50-700hz - as outputs 

reg 2hz_clk_register; 
reg 1hz_clk_register;
reg blink_clk_register;
reg much_faster_clk_register;

reg [31:0] counter_2;
reg [31:0] counter_1;
reg [31:0] counter_blink;
reg [31:0] counter_much_faster;

localparam 2hz_divisor = 25000000;
localparam 1hz_divisor=50000000;
//for blink, will use a 4hz clk
localparam blink_divisor = 6250000;
//for much faster, will use 500 hz;
localparam faster_divisor=100000;

always @(posedge clk)
begin
    if(rst) begin
        2hz_clk_register<=0;
        counter_2<=32'b0;
    end
    else if(counter_2 == 2hz_divisor-1) begin
        2hz_clk_register<= ~2hz_clk_register;
        counter_2<=32'b0;
    end 
    else
        counter_2=counter_2+32'b1;
    end 
end 

always @(posedge clk)
begin
    if(rst) begin
        1hz_clk_register<=0;
        counter_1<=32'b0;
    end
    else if(counter_1 == 1hz_divisor-1) begin
        1hz_clk_register<= ~1hz_clk_register;
        counter_1<=32'b0;
    end 
    else
        counter_1=counter_1+32'b1;
    end 
end 

always @(posedge clk)
begin
    if(rst) begin
        blink_clk_register<=0;
        counter_blink<=32'b0;
    end
    else if(counter_blink == blink_divisor-1) begin
        blink_clk_register<= ~blink_clk_register;
        counter_blink<=32'b0;
    end 
    else
        counter_blink=counter_blink+32'b1;
    end 
end 

always @(posedge clk)
begin
    if(rst) begin
        much_faster_clk_register<=0;
        counter_much_faster<=32'b0;
    end
    else if(counter_much_faster == faster_divisor-1) begin
        much_faster_clk_register<= ~much_faster_clk_register;
        counter_much_faster<=32'b0;
    end 
    else
        counter_much_faster=counter_much_faster+32'b1;
    end 
end 

assign 2hz_clk=2hz_clk_register;
assign 1hz_clk=1hz_clk_register;
assign blink_clk=blink_clk_register;
assign much_faster_clk=much_faster_clk_register;

endmodule 