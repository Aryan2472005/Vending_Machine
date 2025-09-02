`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2025 17:12:52
// Design Name: 
// Module Name: tb
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
// Sel = 00 â€" Product A (Rs. 5/-)     Coin = 01 - Five
// Sel = 01 â€" Product B (Rs. 10/-)    Coin = 10 - Ten
// Sel = 10 â€" Product C (Rs. 20/-)      01 + 10 - 15 == 11          11+01 - 100

module tb();

    reg clk;
    reg rst;
    reg [1:0] sel;
    reg [1:0] coin;
    reg cancel;
    wire PA, PB, PC, change;

    // Instantiate DUT (Device Under Test)
    top uut (
        .clk(clk),
        .rst(rst),
        .sel(sel),
        .coin(coin),
        .cancel(cancel),
        .PA(PA),
        .PB(PB),
        .PC(PC),
        .change(change)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        sel = 2'b00;
        coin = 2'b00;
        cancel = 0;

        // Apply reset
        #10;
        rst = 0;

        // Insert 5 coin and buy Product A (Rs. 5)
        #10 coin = 2'b01; sel = 2'b00;
        #20 coin = 2'b00; sel = 2'b00;  // Reset inputs

        // Insert 10 coin and buy Product B (Rs. 10)
        #20 coin = 2'b10; sel = 2'b01;
        #20 coin = 2'b00; sel = 2'b00;

        // Insert 20 coin and buy Product C (Rs. 20)
        #20 coin = 2'b10; 
        #20 coin = 2'b10; sel = 2'b10;
        #20 coin = 2'b00; sel = 2'b00;

        // Insert 10, but cancel
        #20 coin = 2'b10; cancel = 1;
        #20 coin = 2'b00; cancel = 0;

        // Insert 5 + 10 = 15, then buy A (expect change back)
        #20 coin = 2'b01;
        #20 coin = 2'b10; sel = 2'b00;
        #20 coin = 2'b00; sel = 2'b00;

        // Finish simulation
        #50 $finish;
    end

endmodule

