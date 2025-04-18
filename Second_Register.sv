module Second_Register (
    input  logic         clk,rst,    
    input  logic  [4:0]  waddr,
    input  logic  [31:0] AddrF,ALUResult,SrcBE,
  
    output logic  [4:0]  waddr_MW,
    output logic  [31:0] Addr_MW,ALUResult_MW,rdata2_MW
);

always_ff @( posedge clk ) begin

    if (rst) begin
        Addr_MW      <= 32'b0;
        ALUResult_MW <= 32'b0;
        rdata2_MW    <= 32'b0;
        waddr_MW     <= 5'b0;
    end 
    else begin
        Addr_MW      <= AddrF;
        ALUResult_MW <= ALUResult;
        rdata2_MW    <= SrcBE;
        waddr_MW     <= waddr;                        
    end
end
endmodule