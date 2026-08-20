module apb_gpio_top (

    // APB Interface
    input         PCLK,
    input         PRESET,

    input         PSEL,
    input         PENABLE,
    input         PWRITE,

    input  [3:0]  PADDR,
    input  [31:0] PWDATA,

    output [31:0] PRDATA,
    output        PREADY,
    output        IRQ,

    // Auxiliary Interface
    input  [31:0] aux_in,

    // GPIO Pads
    inout  [31:0] io_pad,

    // External Clock
    input         ext_clk_pad_i
);

    //==================================================
    // Internal Signals
    //==================================================

    wire         gpio_we;
    wire [3:0]   gpio_addr;

    wire [31:0]  gpio_dat_i;
    wire [31:0]  gpio_dat_o;

    wire         gpio_inta_o;

    wire [31:0]  aux_i;

    wire [31:0]  out_pad_o;
    wire [31:0]  oen_padoe_o;
    wire [31:0]  in_pad_i;

    wire         gpio_eclk;

    //==================================================
    // APB SLAVE INSTANCE
    //==================================================

    apb_slave u_apb_slave (

        .PCLK       (PCLK),
        .PRESET     (PRESET),

        .PSEL       (PSEL),
        .PENABLE    (PENABLE),
        .PWRITE     (PWRITE),

        .PADDR      (PADDR),
        .PWDATA     (PWDATA),

        .PRDATA     (PRDATA),
        .PREADY     (PREADY),

        .IRQ        (IRQ),

        .gpio_we    (gpio_we),
        .gpio_addr  (gpio_addr),

        .gpio_dat_i (gpio_dat_i),
        .gpio_dat_o (gpio_dat_o),

        .gpio_inta_o(gpio_inta_o)
    );

    //==================================================
    // GPIO REGISTER BLOCK
    //==================================================

    gpio_registers u_gpio_registers (

        .sys_clk      (PCLK),
        .sys_rst      (PRESET),

        .gpio_we      (gpio_we),
        .gpio_addr    (gpio_addr),

        .gpio_dat_i   (gpio_dat_i),
        .gpio_dat_o   (gpio_dat_o),

        .gpio_inta_o  (gpio_inta_o),

        .aux_i        (aux_i),

        .out_pad_o    (out_pad_o),
        .oen_padoe_o  (oen_padoe_o),

        .in_pad_i     (in_pad_i),

        .gpio_eclk    (gpio_eclk)
    );

    //==================================================
    // AUX INTERFACE
    //==================================================

    aux_interface u_aux_interface (

        .sys_clk (PCLK),
        .sys_rst (PRESET),

        .aux_in  (aux_in),
        .aux_i   (aux_i)
    );

    //==================================================
    // IO INTERFACE
    //==================================================

    io_interface u_io_interface (

        .out_pad_o     (out_pad_o),
        .oen_padoe_o   (oen_padoe_o),

        .in_pad_i      (in_pad_i),

        .io_pad        (io_pad),

        .ext_clk_pad_i (ext_clk_pad_i),

        .gpio_eclk     (gpio_eclk)
    );

endmodule