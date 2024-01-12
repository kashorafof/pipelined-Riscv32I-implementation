`timescale 1ns / 1ps
`include "../RTL/ALU.sv"
module ALU_tb;

// Inputs
reg [31:0] inputA;
reg [31:0] inputB;
reg [3:0] Op;

// Outputs
wire [31:0] Result;
wire Compare;

// Instantiate the ALU
ALU uut (
    .InA(inputA), 
    .InB(inputB), 
    .Op(Op), 
    .Result(Result),
    .Compare(Compare)
);

initial begin
    $dumpfile("vcd/ALU.vcd");
    $dumpvars(0, ALU_tb);
    
    // Initialize Inputs
    inputA = 0079468;
    inputB = 0;
    Op = 0;

    // Wait 100 ns for global reset to finish
    #10;
    
    // Add test
    inputA = 32'd15;
    inputB = 32'd10;
    Op = 4'b0000; // ADD operation
    #10; // Wait for operation to complete
    
    // Subtract test
    inputA = 32'd25;
    inputB = 32'd10;
    Op = 4'b0001; // SUB operation
    #10; // Wait for operation to complete

    // AND test
    inputA = 32'hA;
    inputB = 32'h3;
    Op = 4'b0010; // AND operation
    #10; // Wait for operation to complete

    // OR test
    inputA = 32'hA;
    inputB = 32'h5;
    Op = 4'b0011; // OR operation
    #10; // Wait for operation to complete

    // XOR test
    inputA = 32'hF;
    inputB = 32'hF;
    Op = 4'b0100; // XOR operation
    #10; // Wait for operation to complete

    // Set less than (signed) test
    inputA = -5;
    inputB = 10;
    Op = 4'b0101; // SLT operation
    #10; // Wait for operation to complete

    // Set less than (unsigned) test
    inputA = 32'd5;
    inputB = 32'd10;
    Op = 4'b0110; // SLTU operation
    #10; // Wait for operation to complete
    
    // Complete the tests
    $display("Test complete");
end

endmodule
