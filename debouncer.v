`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:38:33 02/08/2022 
// Design Name: 
// Module Name:    debouncer
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
module debouncer(
    input clk,
    input button,
    output button_output
);
reg [9:0] count=10'b1000000000; 
reg button_output_reg;
wire [3:0] count_sum;


always @(posedge clk)
    if(button==0)
    begin
        count<=[count[8:0],0];
        if(count_sum<=3) begin
            button_output<=0;
        end
    end
    else
    begin
        count<=[count[8:0],1'b1];
        if(count_sum>=7)
        begin
            count <= 0;
            count_sum<=0;
            button_output_reg<=1;
        end
        else if(count_sum<=3) begin
            button_output<=0;
        end
    end
end

    assign count_sum= count[9]+count[8]+count[7]+count[6]+count[5]+count[4]+count[3]+count[2]+count[1]+count[0];
    assign button_output=button_output_reg;

endmodule 