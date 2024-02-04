module Reg_file_test;
  reg clk;
  reg rst;
  reg [31:0] Write_data;
  reg RegWriteE;
  reg [4:0] Rd;
  reg [4:0] Rs1;
  reg [4:0] Rs2;
  wire [31:0] Read_reg1;
  wire [31:0] Read_reg2;

  // Instantiate the Reg_file module
  Reg_file uut (
      .clk_i(clk),
      .rst_i(rst),
      .Write_data_i(Write_data),
      .RegWriteE_i(RegWriteE),
      .Rd_i(Rd),
      .Rs1_i(Rs1),
      .Rs2_i(Rs2),
      .Read_reg1_o(Read_reg1),
      .Read_reg2_o(Read_reg2)
  );

  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    Write_data = 0;
    RegWriteE = 0;
    Rd = 0;
    Rs1 = 0;
    Rs2 = 0;

    // Apply reset
    #10 rst = 0;

    // Write to register 1
    #10 Write_data = 32'hDEADBEEF;
    RegWriteE = 1;
    Rs1 <= 1;
    Rd  <= 1;

    $display("Register %d: %h, %h", Read_reg1, Read_reg2);
    // wait till the positive edge of the clock

    #1 $display("Register %d: %h, %h", Read_reg1, Read_reg2);
    #10 $display("Register %d: %h, %h", Read_reg1, Read_reg2);

    #10 RegWriteE = 1;
    Rd = 0;

    // Stop writing
    #10 RegWriteE = 0;

    // Read from register 1
    #10 Rs1 = 1;

    // Check the read data
    #10
      if (Read_reg1 !== 32'hDEADBEEF)
        $display("Test failed: Read_reg1 = %h, expected %h", Read_reg1, 32'hDEADBEEF);

    // Finish the test
    #10 $finish;
  end

  // Generate clock
  always #5 clk = ~clk;

endmodule
