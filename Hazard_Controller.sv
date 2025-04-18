module Hazard_Controller (
input  logic        clk,rst,reg_wr,
input  logic [1:0]  wb_sel,
input  logic [31:0] InstF,
output logic        reg_wrMW,
output logic [1:0]  wb_selMW,
output logic [2:0]  InstF_MW_funct3,
output logic [6:0]  InstF_MW_opcode
);

always_ff @ ( posedge clk ) begin 
    if ( rst ) begin
        InstF_MW_funct3 <= 3'b0;
        InstF_MW_opcode <= 7'b0;
        wb_selMW        <= 2'bx;
        reg_wrMW        <= 1'b0;  
    end


    else begin
        InstF_MW_funct3 <= InstF [14:12];
        InstF_MW_opcode <= InstF [6:0];
        wb_selMW        <= wb_sel;
        reg_wrMW        <= reg_wr;
    end
end


endmodule