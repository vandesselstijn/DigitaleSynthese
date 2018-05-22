library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity transmitter_tb is
end transmitter_tb;

architecture structural of transmitter_tb is 

-- Component here
component transmitter is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        up: in std_logic;
        down: in std_logic;
        sel: in std_logic_vector(1 downto 0);
        sevenseg: out std_logic_vector(6 downto 0);
        sdo_spread: out std_logic
    );
end component;

for uut : transmitter use entity work.transmitter(structural);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk_t:  std_logic;
signal clk_en_t:  std_logic;
signal rst_t:  std_logic;

-- Signals here

signal up_t, down_t: std_logic := '0';
signal sel_t: std_logic_vector(1 downto 0) := "00";
signal sevenseg_t: std_logic_vector(6 downto 0);
signal sdo_spread_t: std_logic;


begin
    uut: transmitter port map(
        clk => clk_t,
        rst => rst_t,
        clk_en => clk_en_t,

        -- Map signals
        up => up_t,
        down => down_t,
        sel => sel_t,

        sevenseg => sevenseg_t,
        sdo_spread => sdo_spread_t
    );


    --Klok genererne
    clock : process
    begin 
        clk_t <= '0';
        wait for period/2;
        loop
            clk_t <= '0';
            wait for period/2;
            clk_t <= '1';
            wait for period/2;
            exit when end_of_sim;
        end loop;
        wait;
    end process clock;

    tb : process
    procedure count_up(constant wait_time : in time) is --Optellen
    begin
        up_t <= '1';
        wait for 4*period;
        up_t <= '0';
        wait for wait_time;
    end count_up;

    procedure count_down(constant wait_time : in time) is --Aftrekken
    begin
        down_t <= '1';
        wait for 4*period;
        down_t <= '0';
        wait for wait_time;
    end count_down;

    begin

        --Klok aanzetten
        clk_en_t <= '1';
        
        -- Reset
        rst_t <= '1';
        wait for 3*period;
        rst_t <= '0';

        --5 keer ingeklokte data wachten (31keer pn en 11 shiften)
        count_up(31*11*5*period);
        count_up(31*11*5*period);
        count_down(31*11*5*period);
        count_down(31*11*5*period);
        count_down(31*11*5*period);
        
        end_of_sim <= true;
        wait;
    end process;
end;