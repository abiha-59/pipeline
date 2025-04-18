module Instruction_Memory(
    input logic [31:0] Addr,
    output logic [31:0] Inst
);
logic [31:0] inst_memory[1023:0]; //Assuming 1024 32bit instructions
initial begin
    $readmemh("instruction.txt",inst_memory);
end
assign Inst = inst_memory[Addr[31:2]]; //word addressable
endmodule