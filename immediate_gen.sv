module immediate_gen(
    input logic [31:0] InstF,
    input logic [2:0]ImmSrcD,
    output logic [31:0] ImmExtD
);
    
    assign Imm = InstF[31:7];
    always_comb begin
        case(ImmSrcD) 
            // I Type
            3'b000:   ImmExtD = {{21{InstF[31]}}, InstF[30:20]};
            // S Typ
            3'b001:   ImmExtD = {{21{InstF[31]}}, InstF[30:25],InstF[11:7]};
            // B Typ
            3'b010:   ImmExtD = {{20{InstF[31]}}, InstF[7],InstF[30:25],InstF[11:8],1'b0};
            // J Typ
            3'b011:   ImmExtD = {{12{InstF[31]}}, InstF[19:12],InstF[20],InstF[30:21],1'b0};
            // U Typ
            3'b100:   ImmExtD = {    InstF[31],   InstF[30:12], {12{1'b0}}};
            default: 	ImmExtD = 32'dx; // undefined
        endcase
    end
endmodule

