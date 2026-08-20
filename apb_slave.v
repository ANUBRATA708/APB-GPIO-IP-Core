module apb_slave(

    input           PCLK,
    input           PRESET,

    input           PSEL,
    input           PENABLE,
    input           PWRITE,

    input   [3:0]   PADDR,
    input   [31:0]  PWDATA,

    output  reg [31:0] PRDATA,
    output          PREADY,
    output          IRQ,

    output  reg     gpio_we,
    output  [3:0]   gpio_addr,

    output  reg [31:0] gpio_dat_i,
    input   [31:0] gpio_dat_o,

    input           gpio_inta_o
);

assign PREADY = 1'b1;
assign IRQ    = gpio_inta_o;

/* IMPORTANT FIX */
assign gpio_addr = PADDR;

//----------------------------------
// WRITE CONTROL
//----------------------------------

always @(posedge PCLK or posedge PRESET)
begin
    if(PRESET)
    begin
        gpio_we    <= 1'b0;
        gpio_dat_i <= 32'h0;
    end
    else
    begin
        gpio_we <= 1'b0;

        if(PSEL && PENABLE && PWRITE)
        begin
            gpio_we    <= 1'b1;
            gpio_dat_i <= PWDATA;
        end
    end
end

//----------------------------------
// READ CONTROL
//----------------------------------

always @(*)
begin
    if(PSEL && PENABLE && !PWRITE)
        PRDATA = gpio_dat_o;
    else
        PRDATA = 32'h0;
end

endmodule