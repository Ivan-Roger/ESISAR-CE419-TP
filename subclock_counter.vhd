---------------------------------------------
-- Authors:
--   Gaëtan CHOMLAFEL
--   Ivan ROGER
-- TP - Sujet Examen 2017/2018
-- Date: 18/06/2019
---------------------------------------------
-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---------------------------------------------
-- Entity
entity subclock_counter is
	generic (
		COUNT : integer
	);
    port (
        clk  : in STD_LOGIC;
        clk2 : inout STD_LOGIC
    );
end subclock_counter;

---------------------------------------------
-- Architecture
architecture subclock_counter_arch of subclock_counter is
    signal clk2_count   : integer range 1 to COUNT;
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            clk2 <= clk2;
            clk2_count <= clk2_count + 1;
            if (clk2_count >= COUNT) then
                clk2_count <= 1;
                clk2 <= not clk2;
            end if;
        end if;
    end process;

end subclock_counter_arch;
