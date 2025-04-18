module forward_mux1(
  input  logic [31:0] rdata1, wdata,
  input  logic For_A,
  output logic [31:0] SrcAE
);
always_comb begin
    case (For_A)
        1'b0 : SrcAE = wdata;
        1'b1 : SrcAE = rdata1;
    default  : SrcAE = rdata1;
    endcase
end

endmodule