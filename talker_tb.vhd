---------------------------------------------
-- Authors:
--   Gaëtan CHOMLAFEL
--   Ivan ROGER
-- TP - Sujet Examen 2017/2018
-- Date: 28/05/2019
---------------------------------------------
-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---------------------------------------------
-- Entity
entity talker_tb is
end talker_tb;

---------------------------------------------
-- Architecture
architecture talker_tb_arch of talker_tb is
    signal clk_tb, enable_tb, reset_tb, ack_tb  : STD_LOGIC;
    signal data_tb                     : STD_LOGIC_VECTOR (7 downto 0);
    signal req_out                  : STD_LOGIC;
    signal data_out                 : STD_LOGIC_VECTOR (7 downto 0);
begin
    i_uut : entity work.talker
        port map (
            clk         => clk_tb,
            reset       => reset_tb,
            enable      => enable_tb,
            ack_sync    => ack_tb,
            data_in     => data_tb,
            req         => req_out,
            data_out    => data_out
        );

    clock_100mhz_generation : process
    begin
        clk_tb <= '0';
        wait for 5ns;
        clk_tb <= '1';
        wait for 5ns;
    end process;

    simulation : process
    begin
        enable_tb <= '0';
        reset_tb <= '1';
        ack_tb <= '0';
        data_tb <= "00001111"; -- 0f
        wait for 6ns;
        
        enable_tb <= '0';
        reset_tb <= '0';
        ack_tb <= '0';
        data_tb <= "00001111"; -- 0f
        wait for 10ns;
        
        enable_tb <= '1';
        reset_tb <= '0';
        ack_tb <= '0';
        data_tb <= "10101010"; -- aa
        wait for 10ns;
        
        enable_tb <= '1';
        reset_tb <= '0';
        ack_tb <= '1';
        data_tb <= "10101010"; -- aa
        wait for 10ns;
        
        enable_tb <= '1';
        reset_tb <= '0';
        ack_tb <= '0';
        data_tb <= "11110000"; -- f0
        wait for 10ns;
    end process;

end talker_tb_arch;
