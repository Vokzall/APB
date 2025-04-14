`ifndef XCEL
    `include "defines.svh"
`endif

interface intf_apb;

    logic [`DATA_WIDTH - 1:0] PADDR, PWDATA, PRDATA;
    logic PSLVERR, PCLK, PENABLE, PRESETn, PSEL, PWRITE, PREADY;

    modport slave(
        input PCLK, PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA,
        output PRDATA, PREADY, PSLVERR
    );
endinterface