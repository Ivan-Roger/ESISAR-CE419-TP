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
entity talker is
	generic (
		C_NB_BIT : integer
	);
    port (
        ack_sync, clk, reset, enable : in STD_LOGIC;
        data_in                      : in STD_LOGIC_VECTOR (C_NB_BIT-1 downto 0);
        req                          : out STD_LOGIC;
        data_out                     : inout STD_LOGIC_VECTOR (C_NB_BIT-1 downto 0)
    );
end talker;

---------------------------------------------
-- Architecture
architecture talker_arch of talker is
    type StateType is (S_ready, S_transmit, S_finish);
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
    
    process (currentState, ack_sync, enable, data_in, data_out)
    begin
        case currentState is
            when S_ready =>
                req <= '0';
                data_tmp <= data_out;
                if (ack_sync = '0' and enable = '1') then
                    nextState <= S_transmit;
                    data_tmp <= data_in;
                else
                    nextState <= S_ready;
                end if;
            when S_transmit =>
                req <= '1';
                data_tmp <= data_out;
                if (ack_sync = '1') then
                    nextState <= S_finish;
                else
                    nextState <= S_transmit;
                end if;
            when S_finish =>
                req <= '0';
                data_tmp <= data_out;
                if (ack_sync = '0') then
                    nextState <= S_ready;
                else
                    nextState <= S_finish;
                end if;
        end case;
    end process;
end talker_arch;
