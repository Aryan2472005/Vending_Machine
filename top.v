`timescale 1ns / 1ps

// Sel = 00  Product A (Rs. 5/-)     Coin = 01 - Five
// Sel = 01  Product B (Rs. 10/-)    Coin = 10 - Ten
// Sel = 10  Product C (Rs. 20/-)

module top(
    input clk,
    input rst,
    input wire [1:0] sel,
    input wire [1:0] coin,
    input wire cancel,
    output reg PA, PB, PC,
    output reg change
    );

    
    parameter S0 = 3'b000;      // Shows 0
    parameter S1 = 3'b001;      // Shows 5
    parameter S2 = 3'b010;      // Shows 15
    parameter S3 = 3'b011;      // Shows 10
    parameter S4 = 3'b100;      // Shows 20
    
    reg [2:0] state, nstate;
    
    always @(posedge clk) begin
        if(rst) begin 
            state = 0;
            nstate = 0;
            change = 0;
            PA = 0; PB = 0; PC = 0;
        end
        else 
            state = nstate;
                        
        case(state)
            S0: begin
                if(coin == 2'b01)begin
                    nstate = S1;
                end
                else if(coin == 2'b10) begin
                    nstate = S3;
                end
            end
            
            S1: begin
                if(sel == 2'b00)begin
                    PA = 1; PB = 0; PC = 0;
                    nstate = S0;
                end
                else if(coin == 2'b10) begin
                    nstate = S2;
                end
                else if(coin == 2'b01) begin
                    nstate = S3;
                end
                else if(cancel == 1) begin
                    nstate = S0;
                    PA = 0; PB = 0; PC = 0;
                    change = 1'b1;
                end
            end
            
            S2: begin
                if(cancel == 1) begin
                    nstate = S0;
                    PA = 0; PB = 0; PC = 0;
                    change = 1'b1;
                end
                else if(coin == 2'b01) begin
                    nstate = S4; 
                end
            end
            
            S3: begin
                if(cancel == 1) begin
                    nstate = S0;
                    PA = 0; PB = 0; PC = 0;
                    change = 1'b1;
                end
                else if(sel == 2'b01) begin
                    PA = 0; PB = 1; PC = 0;
                    nstate = S0;
                end
                else if (sel == 2'b00) begin
                    PA = 1; PB = 0; PC = 0;
                    change = 1;
                    nstate = S0;
                end
                else if (coin == 2'b10) begin
                    nstate = S4;
                end
                else if(coin == 2'b01) begin
                    nstate = S2;
                end
            end
            
            S4: begin
                if(cancel == 1) begin
                    nstate = S0;
                    PA = 0; PB = 0; PC = 0;
                    change = 1'b1;
                end
                else if (sel == 2'b10) begin
                    PA = 0; PB = 0; PC = 1;
                end
            end
        endcase
    end
endmodule
