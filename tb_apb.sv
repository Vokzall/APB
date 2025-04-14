
module tb_apb();


intf_apb apb();
slave_apb inst(.apb3If(apb));

initial begin
    apb.PCLK = 0;
    apb.PRESETn = 0;

    apb.PADDR = 0;
    apb.PSEL = 0;
    apb.PENABLE = 0;
    apb.PWDATA = 0;
    apb.PWRITE = 0;
end

always begin
    #5 apb.PCLK = ~apb.PCLK;
end

integer tran_begin;
integer tran_end;

task write_data;
    input logic [31:0] addr;
    input logic [31:0] data;

    @(posedge apb.PCLK);
    apb.PSEL = 1;
    @(posedge apb.PCLK);
    tran_begin = $realtime;
    apb.PENABLE = 1;
    apb.PWRITE = 1;
    apb.PADDR = addr;
    apb.PWDATA = data;

    @(posedge apb.PCLK);
    tran_end = $realtime;
    apb.PSEL = 0;
    apb.PENABLE = 0;
    apb.PWRITE = 0;

    $fwrite(outF, "WRITE | begin_time=%d | end_time=%d | addr=%h | size=%d\n", tran_begin, tran_end, addr, $size(data));
endtask 

task read_data;
    input logic [31:0] addr;
    
    @(posedge apb.PCLK);
    apb.PSEL = 1;
    @(posedge apb.PCLK);
    tran_begin = $realtime;
    apb.PENABLE = 1;
    apb.PWRITE = 0;
    apb.PADDR = addr;

    @(posedge apb.PCLK);
    tran_end = $realtime;
    apb.PSEL = 0;
    apb.PENABLE = 0;

    $fwrite(outF, "READ  | begin_time=%d | end_time=%d | addr=%h | size=%d\n", tran_begin, tran_end, addr, $size(apb.PRDATA));
endtask

integer outF;
integer i;
integer ARRAY_SIZE = 101;

initial begin
    outF = $fopen("log.txt");

    @(posedge apb.PCLK);
    @(posedge apb.PCLK);
    apb.PRESETn = 1;
    
    @(posedge apb.PCLK);
    write_data(32'h00, 32'h1111_1111);
    @(posedge apb.PCLK);
    write_data(32'h04, 32'h2222_2222);
    @(posedge apb.PCLK);
    write_data(32'h08, 32'h3333_3333);
    @(posedge apb.PCLK);
    write_data(32'h0C, 32'h4444_4444);
    @(posedge apb.PCLK);

    for (i=0; i < ARRAY_SIZE; i= i+1) begin
        write_data(32'h10 + 32'h04 * i, 32'h5*i);
        @(posedge apb.PCLK);
    end
    
    @(posedge apb.PCLK);
    read_data(32'h00);
    @(posedge apb.PCLK);
    read_data(32'h04);
    @(posedge apb.PCLK);
    read_data(32'h08);
    @(posedge apb.PCLK);
    read_data(32'h0C);
    @(posedge apb.PCLK);

    for (i=0; i < ARRAY_SIZE; i= i+1) begin
        read_data(32'h10 + 32'h04 * i);
        @(posedge apb.PCLK);
    end
    
    @(posedge apb.PCLK);
    @(posedge apb.PCLK);
    @(posedge apb.PCLK);

    $fclose(outF);
    $finish;
end

endmodule


//xrun -sv amba_slave.sv amba_tb.sv -top amba_tb -access +rwc -gui
