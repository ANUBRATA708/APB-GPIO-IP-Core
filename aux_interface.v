module aux_interface(

    input sys_clk,
    input sys_rst,

    input [31:0] aux_in,
    output reg [31:0] aux_i
);

always @(posedge sys_clk)
begin
    if(sys_rst)
        aux_i <= 32'd0;
    else
        aux_i <= aux_in;
end

endmodule