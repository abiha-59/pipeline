module Register_file(
    input logic clk,rst,reg_wrMW,
    input logic [4:0] raddr1,
    input logic [4:0] raddr2,
    input logic [4:0] waddr_MW,
    input logic [31:0] wdata,
    output logic[31:0] rdata1,
    output logic[31:0] rdata2
);

    logic [31:0] register_file[30:0];
    //Asynchronous Read 
    assign rdata1 = (|raddr1) ? register_file[raddr1] : '0;   // |raddr1 mean if any bit off addr1 is high then write the 
    assign rdata2 = (|raddr2) ? register_file[raddr2] : '0;   //value from register file present at that bit and assign to rdata1......
    //Synchronous Write
    always_ff @(negedge clk) begin               //write operation occurs synchronously with the falling edge of the clock signal.
        if (reg_wrMW&&(|waddr_MW)) begin         //if reg_wrMW is active high then write the data in register file at 'waddr' address
            register_file[waddr_MW] <=wdata;
        end
        else if (rst) begin
            for(int i=1;i<=32;i++) begin
                register_file[i] <=32'b0; // Reset all registers
            end
        end

    end
endmodule