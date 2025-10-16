# Clock constraints
create_clock -name clk1 -period 10.0 [get_ports clk1]    ;# 100MHz
create_clock -name clk2 -period 5.0  [get_ports clk2]    ;# 200MHz

set_clock_groups -asynchronous -group {clk1} -group {clk2}

