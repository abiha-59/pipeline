module TopLevel (
    input logic clk,
    input logic rst
);

    logic        PCsrc,reg_wr,sel_A,sel_B,cs,wr,br_taken,reg_wrMW,For_A,For_B,Flush;//
    logic [1:0]  wb_sel,wb_selMW;
    logic [2:0]  ImmSrcD,funct3,InstF_MW_funct3;
    logic [3:0]  mask;
    logic [4:0]  raddr1,raddr2,waddr,alu_op,waddr_MW;
    logic [6:0]  instr_opcode,InstF_MW_opcode;
    logic [31:0] Addr,PC,Inst,PCF,wdata,rdata1,SrcAE,rdata2,SrcBE,ImmExtD,SrcA,SrcB,ALUResult,rdata,data_rd,addr,data_wr,AddrPlus4,AddrF,InstF,Addr_MW,ALUResult_MW,rdata2_MW;

    PCPlus4 PCplus4 (
        .Addr(Addr),
        .PCF(PCF)
    );

Mux_PC MuxPC(
    .PCF(PCF),
    .ALUResult(ALUResult),
    .PCsrc(PCsrc),
    .PC(PC)
);

program_counter ProgCounter (
    .clk(clk),
    .rst(rst),
    //.Stall(Stall),
    .PC(PC),
    .Addr(Addr)
);

Instruction_Memory InstMem(
    .Addr(Addr),
    .Inst(Inst)
);

First_Register firs_register (
    .clk(clk),
    .rst(rst),
    .Flush(Flush),
    .Addr(Addr),
    .Inst(Inst),
    .AddrF(AddrF),
    .InstF(InstF)
);

Instruction_Fetch Fetch(
    .InstF(InstF),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .waddr(waddr)
);

Register_file RegsiterFile(
    .clk(clk),
    .rst(rst),
    .reg_wrMW(reg_wrMW),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .waddr_MW(waddr_MW),
    .wdata(wdata),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

immediate_gen Immediate(
    .InstF(InstF),
    .ImmSrcD(ImmSrcD),
    .ImmExtD(ImmExtD)
);

forward_mux1 ForwardMux1(
    .rdata1(rdata1),
    .wdata(wdata),
    .For_A(For_A),
    .SrcAE(SrcAE)
);
    
forward_mux2 ForwardMux2(
    .rdata2(rdata2),
    .wdata(wdata),
    .For_B(For_B),
    .SrcBE(SrcBE)
);

mux_selA MuxselA(
    .sel_A(sel_A),
    .SrcAE(SrcAE),
    .AddrF(AddrF),
    .SrcA(SrcA)
);

mux_selB MuxselB(
    .sel_B(sel_B),
    .ImmExtD(ImmExtD),
    .SrcBE(SrcBE),
    .SrcB(SrcB)
);


ALU Alu(
    .alu_op(alu_op),
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUResult(ALUResult)
);

Second_Register second_register(
    .clk(clk),
    .rst(rst),
    .waddr(waddr),
    .AddrF(AddrF),
    .ALUResult(ALUResult),
    .SrcBE(SrcBE),
    .waddr_MW(waddr_MW),
    .Addr_MW(Addr_MW),
    .ALUResult_MW(ALUResult_MW),
    .rdata2_MW(rdata2_MW)
);


LoadStore_Unit loadstore(
    .InstF_MW_funct3(InstF_MW_funct3),
    .InstF_MW_opcode(InstF_MW_opcode),
    .data_rd(data_rd),
    .rdata2_MW(rdata2_MW),
    .ALUResult_MW(ALUResult_MW),
    .cs(cs),
    .wr(wr),
    .mask(mask),
    .addr(addr),
    .data_wr(data_wr),
    .rdata(rdata)
);

Data_Memory Dmem(
    .clk(clk),
    .rst(rst),
    .cs(cs),
    .wr(wr),
    .mask(mask),.addr(addr),
    .data_wr(data_wr),
    .data_rd(data_rd)
);


MuxResult Muxresult(
    .wb_selMW(wb_selMW),
    .ALUResult_MW(ALUResult_MW),
    .rdata(rdata),
    .AddrPlus4(AddrPlus4),
    .wdata(wdata)
);

BranchCond Branchcond(
    .funct3(funct3),
    .instr_opcode(instr_opcode),
    .SrcAE(SrcAE),
    .SrcBE(SrcBE),
    .br_taken(br_taken)
);

AddrPlus4 addrplus4(
    .Addr_MW(Addr_MW),
    .AddrPlus4(AddrPlus4)
);



Hazard_Unit hazardunit (
    .reg_wrMW(reg_wrMW),
    .PCsrc(PCsrc),
    .wb_selMW(wb_selMW),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .waddr_MW(waddr_MW),
    .For_A(For_A),
    .For_B(For_B),
    .Flush(Flush)
);

Hazard_Controller hazardcontroller(
    .clk(clk),
    .rst(rst),
    .reg_wr(reg_wr),
    .wb_sel(wb_sel),
    .InstF(InstF),
    .reg_wrMW(reg_wrMW),
    .wb_selMW(wb_selMW),
    .InstF_MW_funct3(InstF_MW_funct3),
    .InstF_MW_opcode(InstF_MW_opcode)
);

controller Controller(
    .br_taken(br_taken),
    .InstF(InstF),
    .PCsrc(PCsrc),
    .reg_wr(reg_wr),
    .sel_A(sel_A),
    .sel_B(sel_B),
    .wb_sel(wb_sel),
    .ImmSrcD(ImmSrcD),
    .funct3(funct3),
    .alu_op(alu_op),
    .instr_opcode(instr_opcode)
);


endmodule