`ifndef XCEL
    `include "defines.svh"
`endif

module slave_apb(intf_apb.slave apb3If);
    import pkg_apb::*;
	
	t_u_map mem;
	bit read, write;


	assign {read, write, apb3If.PREADY} = (apb3If.PSEL & apb3If.PENABLE) ? (apb3If.PWRITE ? 3'b011 : 3'b101) : 3'b000;
    assign apb3If.PSLVERR = (apb3If.PADDR >= (`ADDR_WIDTH-1)) & apb3If.PREADY;
    
	always_ff @(posedge apb3If.PCLK or negedge apb3If.PRESETn) begin : MEM
		if (!apb3If.PRESETn) mem.data <= 'd0;
		else casez({read, write})

			2'b?1: begin
				case (mem.data[apb3If.PADDR].bit_map)
					8'h0: mem.data[apb3If.PADDR].byte0  <= apb3If.PWDATA;
					8'h4: mem.data[apb3If.PADDR].byte1 <= apb3If.PWDATA;
					8'h8: mem.data[apb3If.PADDR].byte2 <= apb3If.PWDATA;
					default: $error("Error!!!");
				endcase
			end

			2'b1?: apb3If.PRDATA <= mem.data[apb3If.PADDR];

			default: apb3If.PRDATA <= 'd0;


		endcase
	end : MEM

endmodule
