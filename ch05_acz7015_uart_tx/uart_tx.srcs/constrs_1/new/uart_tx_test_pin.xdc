#set UnusedPin
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]

#system slock
set_property PACKAGE_PIN L5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

#reset active low, S0
set_property PACKAGE_PIN R4 [get_ports reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports reset_n]

#uart_tx
set_property PACKAGE_PIN V18 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]

#led
set_property PACKAGE_PIN AB14 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
