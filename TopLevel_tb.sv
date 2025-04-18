module TopLevel_tb;

  logic clk;
  logic rst;

  
  TopLevel toplevel (
    .clk(clk),
    .rst(rst)
  );

 
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

 
  initial begin
    rst = 1;
    #10;         
    rst = 0;
    #150;
    $stop;
  end

 
  initial begin
    #3;

    // Sample instructions:
    // ADD x1, x2, x3
    toplevel.InstMem.inst_memory[0] = 32'h003100B3;

    // SUB x4, x5, x6
    toplevel.InstMem.inst_memory[1] = 32'h40628233;

    toplevel.dmem.mem[1] = 32'hDEADBEEF;
  end

endmodule
