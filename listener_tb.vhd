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
entity listener_tb is
end listener_tb;


---------------------------------------------
-- Architecture
architecture listener_tb_arch of listener_tb is
    signal clk1_tb, clk2_tb, reset_tb, enable_tb, ack_tb, req_tb : STD_LOGIC;
    signal data_in, data_tb, data_out : STD_LOGIC_VECTOR (7 DOWNTO 0); 
begin
    i_talker_uut : entity work.talker
        port map (
            clk         => clk1_tb,
            reset       => reset_tb,
            enable      => enable_tb,
            ack_sync    => ack_tb,
            data_in     => data_in,
            req         => req_tb,
            data_out    => data_tb
        );

    i_listener_uut : entity work.listener
        port map (
            clk         => clk2_tb,
            reset       => reset_tb,
            enable      => enable_tb,
            ack         => ack_tb,
            data_in     => data_tb,
            req         => req_tb,
            data_out    => data_out
        );
    
    clock_100mhz_generation : process
    begin
        clk1_tb <= '0';
        wait for 5ns;
        clk1_tb <= '1';
        wait for 5ns;
    end process;
    
    clock_50mhz_generation : process
    begin
        clk2_tb <= '0';
        wait for 10ns;
        clk2_tb <= '1';
        wait for 10ns;
    end process;

    simulation : process
    begin
        enable_tb <= '0';
        reset_tb <= '1';
        data_in <= "00001111"; -- 0f
        wait for 6ns;
        
        enable_tb <= '0';
        reset_tb <= '0';
        data_in <= "00001111"; -- 0f
        wait for 10ns;
        
        enable_tb <= '1';
        reset_tb <= '0';
        data_in <= "10101010"; -- aa
        wait for 10ns;
        
        enable_tb <= '1';
        reset_tb <= '0';
        data_in <= "10101010"; -- aa
        wait for 10ns;
        
        enable_tb <= '1';
        reset_tb <= '0';
        data_in <= "11110000"; -- f0
        wait for 10ns;

        enable_tb <= '0';
        reset_tb <= '0';
        data_in <= "11110000"; -- f0
        wait for 10ns;
    end process;
end listener_tb_arch;
