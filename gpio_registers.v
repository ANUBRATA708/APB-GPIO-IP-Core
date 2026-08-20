module gpio_registers(

    input           sys_clk,
    input           sys_rst,

    input           gpio_we,
    input   [3:0]   gpio_addr,

    input   [31:0]  gpio_dat_i,
    output  reg [31:0] gpio_dat_o,

    output          gpio_inta_o,

    input   [31:0]  aux_i,

    output  reg [31:0] out_pad_o,
    output  reg [31:0] oen_padoe_o,

    input   [31:0]  in_pad_i,

    input           gpio_eclk
);

reg [31:0] rgpio_out;
reg [31:0] rgpio_oe;

assign gpio_inta_o = 1'b0;

always @(posedge sys_clk or posedge sys_rst)
begin
    if(sys_rst)
    begin
        rgpio_out <= 32'h0;
        rgpio_oe  <= 32'h0;
    end
    else
    begin
        if(gpio_we == 1'b1)
        begin
            if(gpio_addr == 4'b0100)
                rgpio_out <= gpio_dat_i;

            else if(gpio_addr == 4'b1000)
                rgpio_oe <= gpio_dat_i;
        end
    end
end

always @(*)
begin
    if(gpio_addr == 4'b0000)
        gpio_dat_o = in_pad_i;

    else if(gpio_addr == 4'b0100)
        gpio_dat_o = rgpio_out;

    else if(gpio_addr == 4'b1000)
        gpio_dat_o = rgpio_oe;

    else
        gpio_dat_o = 32'h0;
end

always @(*)
begin
    out_pad_o   = rgpio_out;
    oen_padoe_o = rgpio_oe;
end

endmodule