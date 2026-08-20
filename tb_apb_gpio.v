`timescale 1ns/1ps

module tb_apb_gpio;

//-------------------------------------------------
// APB Signals
//-------------------------------------------------
reg         PCLK;
reg         PRESET;

reg         PSEL;
reg         PENABLE;
reg         PWRITE;

reg  [3:0]  PADDR;
reg  [31:0] PWDATA;

wire [31:0] PRDATA;
wire        PREADY;
wire        IRQ;

//-------------------------------------------------
// GPIO
//-------------------------------------------------
reg  [31:0] aux_in;
wire [31:0] io_pad;
reg         ext_clk_pad_i;

//-------------------------------------------------
// DUT
//-------------------------------------------------
apb_gpio_top DUT (

    .PCLK(PCLK),
    .PRESET(PRESET),

    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),

    .PADDR(PADDR),
    .PWDATA(PWDATA),

    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .IRQ(IRQ),

    .aux_in(aux_in),

    .io_pad(io_pad),

    .ext_clk_pad_i(ext_clk_pad_i)
);

//-------------------------------------------------
// CLOCK
//-------------------------------------------------
initial
begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
end

//-------------------------------------------------
// TEST
//-------------------------------------------------
initial
begin

    PRESET        = 1;
    PSEL          = 0;
    PENABLE       = 0;
    PWRITE        = 0;
    PADDR         = 0;
    PWDATA        = 0;
    aux_in        = 0;
    ext_clk_pad_i = 0;

    //-------------------------------------------------
    // RESET
    //-------------------------------------------------
    $display("====================================");
    $display("TESTCASE 1 : RESET CHECK");
    $display("====================================");

    #20;
    PRESET = 0;

    #10;

    if(DUT.u_gpio_registers.rgpio_out == 32'h0 &&
       DUT.u_gpio_registers.rgpio_oe  == 32'h0)
        $display("PASS : Registers reset successfully");
    else
        $display("FAIL : Reset failed");

    //-------------------------------------------------
    // WRITE RGPIO_OUT
    //-------------------------------------------------
    $display("====================================");
    $display("TESTCASE 2 : APB WRITE RGPIO_OUT");
    $display("====================================");

    @(posedge PCLK);
    PSEL   = 1;
    PWRITE = 1;
    PADDR  = 4'h4;
    PWDATA = 32'hAAAAAAAA;

    @(posedge PCLK);
    PENABLE = 1;

    @(posedge PCLK);

    @(posedge PCLK);

    PSEL    = 0;
    PENABLE = 0;

    #10;

    if(DUT.u_gpio_registers.rgpio_out == 32'hAAAAAAAA)
        $display("PASS : RGPIO_OUT written correctly");
    else
        $display("FAIL : RGPIO_OUT write failed (%h)",
                 DUT.u_gpio_registers.rgpio_out);

    //-------------------------------------------------
    // WRITE RGPIO_OE
    //-------------------------------------------------
    $display("====================================");
    $display("TESTCASE 3 : APB WRITE RGPIO_OE");
    $display("====================================");

    @(posedge PCLK);
    PSEL   = 1;
    PWRITE = 1;
    PADDR  = 4'h8;
    PWDATA = 32'hFFFFFFFF;

    @(posedge PCLK);
    PENABLE = 1;

    @(posedge PCLK);

    @(posedge PCLK);

    PSEL    = 0;
    PENABLE = 0;

    #10;

    if(DUT.u_gpio_registers.rgpio_oe == 32'hFFFFFFFF)
        $display("PASS : RGPIO_OE written correctly");
    else
        $display("FAIL : RGPIO_OE write failed (%h)",
                 DUT.u_gpio_registers.rgpio_oe);

    //-------------------------------------------------
    // GPIO OUTPUT CHECK
    //-------------------------------------------------
    $display("====================================");
    $display("TESTCASE 4 : GPIO OUTPUT CHECK");
    $display("====================================");

    #20;

    if(io_pad == 32'hAAAAAAAA)
        $display("PASS : GPIO output reflected on io_pad");
    else
        $display("FAIL : GPIO output mismatch (%h)", io_pad);

    //-------------------------------------------------
    // APB READ
    //-------------------------------------------------
    $display("====================================");
    $display("TESTCASE 5 : APB READ RGPIO_OUT");
    $display("====================================");

    @(posedge PCLK);
    PSEL   = 1;
    PWRITE = 0;
    PADDR  = 4'h4;

    @(posedge PCLK);
    PENABLE = 1;

    #2;

    if(PRDATA == 32'hAAAAAAAA)
        $display("PASS : APB Read successful, PRDATA = %h", PRDATA);
    else
        $display("FAIL : APB Read failed, PRDATA = %h", PRDATA);

    @(posedge PCLK);

    PSEL    = 0;
    PENABLE = 0;
	 //-------------------------------------------------
    // TESTCASE 6 : AUXILIARY INPUT CHECK
    //-------------------------------------------------

    $display("====================================");
    $display("TESTCASE 6 : AUXILIARY INPUT CHECK");
    $display("====================================");
  
    aux_in = 32'h12345678;

    @(posedge PCLK);
    #1;

    if(DUT.u_aux_interface.aux_i == 32'h12345678)
        $display("PASS : Auxiliary input transferred correctly");
    else
        $display("FAIL : Auxiliary input transfer failed");

    //-------------------------------------------------
    // DONE
    //-------------------------------------------------
    $display("====================================");
    $display("ALL TESTCASES COMPLETED");
    $display("====================================");

    #20;
    $stop;

end

endmodule