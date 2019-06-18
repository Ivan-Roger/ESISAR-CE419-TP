---------------------------------------------
-- Authors:
--   Ga�tan CHOMLAFEL
--   Ivan ROGER
-- TP - Sujet Examen 2017/2018
-- Date: 20/05/2019
---------------------------------------------
-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

---------------------------------------------
-- Entity
entity top is
    port (
        clk          : in STD_LOGIC;
        enable       : in STD_LOGIC;
        reset        : in STD_LOGIC;
        data         : in STD_LOGIC_VECTOR (7 downto 0);
        req_out      : out STD_LOGIC;
        ack_out      : out STD_LOGIC;
        clk2_out     : out STD_LOGIC;
        disp_an      : out STD_LOGIC_VECTOR (3 downto 0);
        disp_dp      : out STD_LOGIC;
        disp_seg     : out STD_LOGIC_VECTOR (6 downto 0);
        disp_led     : out STD_LOGIC_VECTOR (7 downto 0)
    );
end top;

---------------------------------------------
-- Architecture
architecture top_arch of top is

    component hex2led is
        port (
            HEX : in std_logic_vector(3 downto 0);
            LED : out std_logic_vector(6 downto 0)
        );
    end component;
    
    component led_control is
        port (
            CLK : in std_logic;
            DISP0 : in std_logic_vector(6 downto 0);
            DISP1 : in std_logic_vector(6 downto 0);
            DISP2 : in std_logic_vector(6 downto 0);
            DISP3 : in std_logic_vector(6 downto 0);
            AN : out std_logic_vector(3 downto 0);
            DP : out std_logic;
            SEVEN_SEG : out std_logic_vector(6 downto 0)
        );
    end component;
    
    signal DISP0, DISP1 : std_logic_vector (6 downto 0);
    signal req, ack     : std_logic;
    signal data_bus     : std_logic_vector (7 downto 0);
    signal data_out     : std_logic_vector (7 downto 0);
    
--    signal data_in      : std_logic_vector (7 downto 0);
--    type Tab is array (15 DOWNTO 0) of std_logic_vector (7 DOWNTO 0);
--    signal data         : Tab := (
--        "00000000",
--        "00000001",
--        "00000010",
--        "00000100",
--        "00001000",
--        "00010000",
--        "00100000",
--        "01000000",
--        "10000000",
--        "01000000",
--        "00100000",
--        "00010000",
--        "00001000",
--        "00000100",
--        "00000010",
--        "00000001"
--    ); -- 2D array
--    signal i            : integer range 0 to 15 := 0;
    
    signal clk2         : std_logic;
    signal clk2_count   : integer range 0 to 25000000;
begin

    -- Generate slower clock
    process(clk)
    begin
        if (clk'event and clk = '1') then
            clk2 <= clk2;
            clk2_count <= clk2_count + 1;
            if (clk2_count >= 25000000) then
                clk2_count <= 0;
                clk2 <= not clk2;
            end if;
        end if;
    end process;
    
    -- Select data to send
--    process(clk2)
--    begin
--        if (clk2'event and clk2='1') then
--            if (enable='1' and ack='1') then
--                i <= i + 1;
--            end if;
--            data_in <= data(i);
--        end if;
--    end process;

    -- Talker entity (quick clock)
    i_talker : entity work.talker
        generic map (
            C_NB_BIT    => 8
        )
        port map (
            clk         => clk,
            reset       => reset,
            enable      => enable,
            ack_sync    => ack,
            data_in     => data,
            req         => req,
            data_out    => data_bus
        );
        
    -- Listener entity (slow clock)
    i_listener : entity work.listener
        generic map (
            C_NB_BIT    => 8
        )
        port map (
            clk         => clk2,
            reset       => reset,
            enable      => enable,
            ack         => ack,
            data_in     => data_bus,
            req         => req,
            data_out    => data_out
        );    
    
    -- Status LEDs
    clk2_out <= clk2;
    req_out <= req;
    ack_out <= ack;
    
    -- 7-Seg display
    disp_led <= data_out;
    
    HEX2LED_1 : hex2led port map (
        HEX => data_out(3 downto 0),
        LED => DISP0);
    
    HEX2LED_2 : hex2led port map (
        HEX => data_out(7 downto 4),
        LED => DISP1);
    
    LEDCONTROL_1 : led_control port map (
        CLK => clk,
        DISP0 => DISP0,
        DISP1 => DISP1,
        DISP2 => (others => '1'),
        DISP3 => (others => '1'),
        AN => disp_an,
        SEVEN_SEG => disp_seg,
        dp => disp_dp);

end top_arch;