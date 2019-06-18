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
use IEEE.NUMERIC_STD.ALL;

---------------------------------------------
-- Entity
entity talker_n is
	generic (
		C_NB_BIT : integer;
		C_NB_MSG : integer
	);
    port (
        clk, reset, start, ack       : in STD_LOGIC;
        data_in                      : in STD_LOGIC_VECTOR (C_NB_BIT-1 downto 0);
        req                          : out STD_LOGIC;
        ready                        : out STD_LOGIC;
        index                        : inout STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
        data_out                     : inout STD_LOGIC_VECTOR (C_NB_BIT-1 downto 0)
    );
end talker_n;

---------------------------------------------
-- Architecture
architecture talker_n_arch of talker_n is
    type StateType is (S_ready, S_transmit, S_ack);
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
    
    process (currentState, ack, start, data_in, data_out)
    begin
        nextState <= currentState;
        ready <= '0';
        req <= '0';
        index <= index;
        data_tmp <= data_out;
        case currentState is
            when S_ready =>
                ready <= '1';
                if (ack = '0' and start = '1') then
                    nextState <= S_transmit;
                    data_tmp <= data_in;
                end if;
            when S_transmit =>
                req <= '1';
                if (ack = '1') then
                    nextState <= S_ack;
                end if;
            when S_ack =>
                index <= std_logic_vector(unsigned(index)+1);
                if (ack = '0') then
                    -- If we reached the last message to send, end transmission
                    if (unsigned(index) < C_NB_MSG-1) then
                        nextState <= S_transmit;
                    else
                        nextState <= S_ready;
                    end if;
                end if;
        end case;
    end process;
end talker_n_arch;
