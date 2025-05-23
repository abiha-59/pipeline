module LoadStore_Unit (
    input  logic [2:0]  InstF_MW_funct3,
    input  logic [6:0]  InstF_MW_opcode,
    input  logic [31:0] data_rd,      // From Data Mem in case of Load Instr 
	input  logic [31:0] rdata2_MW,        
    input  logic [31:0] ALUResult_MW,    
    output logic        cs,wr,valid, 
    output logic [3:0]  mask,
    output logic [31:0] addr,data_wr,  //addr >> ALUResult and data_wr >> rdata 2
	output logic [31:0] rdata          //Data to be load back to destination Register 
);

parameter Byte              = 3'b000; 
parameter HalfWord          = 3'b001;
parameter Word              = 3'b010;
parameter Byte_Unsigned     = 3'b100;
parameter HalfWord_Unsigned = 3'b101;
assign addr                 = ALUResult_MW;


always_comb begin
    //wr = 1;
	case (InstF_MW_opcode)
	7'b0000011: begin 
		wr = 1;
	    cs = 0;  //load
	end
	7'b0100011: begin 
		wr = 0; 
	    cs = 0;  //store
	end
	endcase
end

logic [7:0]  rdata_byte;
logic [15:0] rdata_hword;
logic [31:0] rdata_word;

    always_comb begin
        rdata_byte  = '0;
        rdata_hword = '0;
        rdata_word  = '0;
        case(InstF_MW_opcode) 
            7'b0000011: begin //Load
                case (InstF_MW_funct3)
                    Byte , Byte_Unsigned: case( addr[1:0] )
                            2'b00 : rdata_byte = data_rd [7:0];
                            2'b01 : rdata_byte = data_rd [15:8];     
                            2'b10 : rdata_byte = data_rd [23:16];
                            2'b11 : rdata_byte = data_rd [31:24]; 
                        endcase     
                    HalfWord , HalfWord_Unsigned: case( addr[1] )
                            1'b0 : rdata_hword = data_rd [15:0];       
                            1'b1 : rdata_hword = data_rd [31:16];
                        endcase
                    Word: rdata_word = data_rd; 
                endcase
            end
        endcase
        
    end

 always_comb
   begin 
        case (InstF_MW_funct3)
            Byte              : rdata = {{24{rdata_byte[7]}},   rdata_byte}; 
            Byte_Unsigned     : rdata = {24'b0,                 rdata_byte};
            HalfWord          : rdata = {{16{rdata_hword[15]}}, rdata_hword}; 
            HalfWord_Unsigned : rdata = {16'b0,                 rdata_hword};
            Word              : rdata = {                       rdata_word};
            default           : rdata = '0;        
        endcase 
  end
//prepare the data and mask for store
always_comb begin
    data_wr = '0;
    mask    = '0;
    case (InstF_MW_opcode)
       7'b0100011 : begin //store  
            case (InstF_MW_funct3)
            	Byte :  begin
            		case (addr[1:0])
                    2'b00 : begin
                        data_wr[7:0] = rdata2_MW[7:0];begin
                        mask         = 4'b0001;
                        end
                    end 
                    2'b01: begin
                        data_wr [15:8] = rdata2_MW[15:8];
                        mask           = 4'b0010;
                    end
                    2'b10: begin
                       data_wr[23:16]  = rdata2_MW [23:16];
                        mask           = 4'b0100;
                    end
                    2'b11:begin
                        data_wr[31:24] = rdata2_MW[31:24];
                        mask           = 4'b1000;
                    end
                    default: begin
                    end
                    endcase
            	end
                HalfWord: begin
                    case(addr[1]) 
                        1'b0 : begin data_wr [15:0]  = rdata2_MW[15:0];
                        mask                         = 4'b0011;
						end
                        1'b1 : begin data_wr [31:16] = rdata2_MW [31:16];
                        mask                         = 4'b1100;
						end
                    endcase
                end
				Word: begin 
					data_wr = rdata2_MW;
					mask 	= 4'b1111;
				end 		
            endcase
       end 
    endcase
end
endmodule
