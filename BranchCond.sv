module BranchCond(
    input logic[6:0] instr_opcode,
    input logic[2:0] funct3,
    input logic[31:0] SrcAE,
    input logic[31:0] SrcBE,
    output logic br_taken
);

localparam [2:0] BEQ  = 3'b000;
localparam [2:0] BNE  = 3'b001;
localparam [2:0] BLT  = 3'b100;
localparam [2:0] BGE  = 3'b101;
localparam [2:0] BLTU = 3'b110;
localparam [2:0] BGEU = 3'b111;

always_comb begin
    case(instr_opcode)  
        7'b1100011:begin
            case(funct3)
                BEQ  : br_taken = (SrcAE == SrcBE);
                BNE  : br_taken = (SrcAE != SrcBE);
                BLT  : br_taken = (SrcAE <  SrcBE);
                BGE  : br_taken = (SrcAE >= SrcBE);
                BLTU : br_taken = (SrcAE <  SrcBE);
                BGEU : br_taken = (SrcAE >= SrcBE);
                default : br_taken = 1'b0;
            endcase
        end
        7'b1101111 ,7'b1100111:begin //JAL //JALR
            br_taken=1'b1;
        end
        default : begin
            br_taken=1'b0;
        end

        
    endcase
end
endmodule