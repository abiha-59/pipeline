module First_Register (
    input               clk ,rst,Flush,//Stall,
    input  logic [31:0] Addr,Inst,
    output logic [31:0] AddrF,InstF
);
    always_ff @( posedge clk ) begin 
     
        if(rst) begin
            AddrF <= 32'b0;
            InstF <= 32'b0;
        end

        else if (Flush) begin
            InstF <= 32'h00000013;
            AddrF <= AddrF;
        end
        else begin
            AddrF <= Addr;
            InstF <= Inst;
        end
    end
    
endmodule		