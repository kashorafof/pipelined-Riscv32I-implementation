`timescale 1ns / 1ps
`include "../RTL/Imm_extender.sv"
module Imm_tb;

// Inputs
reg [25:0] Imm_in;
reg [2:0] Format;

// Outputs
wire [31:0] Imm_out;

// Instantiate the Immediate extender
Immediate_extender uut (
    .Imm_in(Imm_in), 
    .Format(Format), 
    .Imm_out(Imm_out)
);

task check_results;
    input [31:0] expected;
    input [31:0] actual;
    input [31:0] Imm_in;
    input [2:0] Format;
    begin
        if (expected === actual) begin
            $display("Imm_in: %d, Format: %d, Expected: %d, Actual: %d, PASS", Imm_in, Format, expected, actual);
        end else begin
            $display("Imm_in: %d, Format: %d, Expected: %d, Actual: %d, FAIL", Imm_in, Format, expected, actual);
        end
    end

initial begin

    $dumpfile("./vcd/Imm_extender.vcd");
    $dumpvars(0, Imm_tb);

    // Initialize Inputs
    Imm_in = 0;
    Format = 0;

    // Wait 100 ns for global reset to finish
    #100;




end



endmodule