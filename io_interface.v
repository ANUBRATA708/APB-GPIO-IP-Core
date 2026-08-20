module io_interface(

    input [31:0] out_pad_o,
    input [31:0] oen_padoe_o,

    output [31:0] in_pad_i,

    inout [31:0] io_pad,

    input ext_clk_pad_i,

    output gpio_eclk
);

assign gpio_eclk = ext_clk_pad_i;

genvar i;

generate
for(i=0;i<32;i=i+1)
begin : GPIO_TRI

assign io_pad[i] =
       oen_padoe_o[i] ?
       out_pad_o[i] :
       1'bz;

assign in_pad_i[i] = io_pad[i];

end
endgenerate

endmodule