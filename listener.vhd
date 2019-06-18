---------------------------------------------
-- Authors:
--   Gaëtan CHOMLAFEL
--   Ivan ROGER
-- TP - Sujet Examen 2017/2018
-- Date: 20/05/2019
---------------------------------------------
-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---------------------------------------------
-- Entity
entity listener is
	generic (
		C_NB_BIT : integer
	);
    port (
        clk, reset, enable, req : in STD_LOGIC;
        data_in                 : in STD_LOGIC_VECTOR (C_NB_BIT-1 downto 0);
        data_out                : inout STD_LOGIC_VECTOR (C_NB_BIT-1 downto 0);
        ack                     : out STD_LOGIC
    );
end listener;

---------------------------------------------
-- Architecture
architecture listener_arch of listener is
    type StateType is (S_ready, S_receive);
    signal currentState, nextState : StateType;
    signal data_tmp : STD_LOGIC_VECTOR (C_NB_BIT-1 downto 0);
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                currentState <= S_ready;
                data_out <= (others => '0');
            else
                currentState <= nextState;
                data_out <= data_tmp;
            end if;
        end if;
    end process;

    process (currentState, req, enable, data_in, data_out)
    begin
        case currentState is
            when S_ready =>
                ack <= '0';
                data_tmp <= data_out;
                if (req = '1' and enable = '1') then
                    nextState <= S_receive;
					data_tmp <= data_in;
                else
                    nextState <= S_ready;
                end if;
            when S_receive =>
                ack <= '1';
                if (req = '0') then
                    nextState <= S_ready;
                else
                    nextState <= S_receive;
                end if;
                data_tmp <= data_out;
        end case;
    end process;
end listener_arch;
