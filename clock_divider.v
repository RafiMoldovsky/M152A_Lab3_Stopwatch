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

reg 2hz_clk_register; 
reg 1hz_clk_register;
reg blink_clk_register;
reg much_faster_clk_register;

reg [31:0] counter_2;
reg [31:0] counter_1;
reg [31:0] counter_blink;
reg [31:0] counter_much_faster;

always @(posedge clk)
    if(rst) begin
        2hz_clk_register=0;
        counter_2=32'b0;
    end
    else if(counter_2 == )
end 

endmodule 