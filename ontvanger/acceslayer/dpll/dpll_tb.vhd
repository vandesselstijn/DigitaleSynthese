-------------------------------------------------------------------
-- Project  : testen volledige dpll voor ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date   : 20/05/2018
-- bestand  : dpll_tb.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dpll_tb is
end dpll_tb;

architecture structural of dpll_tb is 

-- Component beschrijven
component dpll is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        sdi_spread: in std_logic;
        extb: out std_logic;
        chip_sample: out std_logic;
        chip_sample1: out std_logic;
        chip_sample2: out std_logic
    );
end component;

--Transmittor component gecopieerd (wordt aangelegd om testwaarden te generen)
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

for uut : dpll use entity work.dpll(behav);
 
--Klok beschrijven
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk_s:  std_logic;
signal clk_16_s: std_logic;
signal clk_en_s:  std_logic;
signal rst_s:  std_logic;

-- Overige dpll signalen
signal chip_sample_s: std_logic;
signal chip_sample1_s: std_logic;
signal chip_sample2_s: std_logic;
signal extb_s: std_logic;

-- Transmitter signalen
signal up_s, down_s: std_logic := '0';
signal sel_s: std_logic_vector(1 downto 0) := "01"; --switch positie kiezen
signal sevenseg_s: std_logic_vector(6 downto 0);
signal sdo_spread_s: std_logic;

signal present_count, next_count: std_logic_vector(3 downto 0);

begin
    --tb mappen aan componenten
    transm: transmitter port map(
        clk => clk_16_s,
        rst => rst_s,
        clk_en => clk_en_s,
        up => up_s,
        down => down_s,
        sel => sel_s,
        sevenseg => sevenseg_s,
        sdo_spread => sdo_spread_s
    );

    uut: dpll port map(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,
        sdi_spread => sdo_spread_s,
        extb => extb_s,
        chip_sample => chip_sample_s,
        chip_sample1 => chip_sample1_s,
        chip_sample2 => chip_sample2_s
    );

    --Klok genereren
    clock : process
    begin 
        clk_s <= '0';
        wait for period/2;
        loop
            clk_s <= '0';
            wait for period/2;
            clk_s <= '1';
            wait for period/2;
            exit when end_of_sim;
        end loop;
        wait;
    end process clock;

    counter_syn: process(clk_s)
    begin
        if rising_edge(clk_s) then
            if rst_s = '1' then
                present_count <= "0000";
            else
                present_count <= next_count;
            end if;
        end if;
    end process counter_syn;

    --vertraagde clock genereren
    counter_comb: process(present_count)
    begin
        if(present_count = "0000") then
            clk_16_s <= '1';
        else
            clk_16_s <= '0';
        end if;

        next_count <= present_count + 1;
    end process counter_comb;

    --Optellen functie voor tb
    tb : process
    procedure count_up(constant wait_time : in time) is
    begin
        -- Counter +1 + wait long for transmittion
        up_s <= '1';
        wait for 4*period*16;
        up_s <= '0';
        wait for wait_time*16;
    end count_up;

    --Decrement funtie voor tb
    procedure count_down(constant wait_time : in time) is
    begin
        -- Counter +1 + wait long for transmittion
        down_s <= '1';
        wait for 4*period*16;
        down_s <= '0';
        wait for wait_time*16;
    end count_down;

    begin
        clk_en_s <= '1';        -- Klok aanzetten

        rst_s <= '1';           --restetten
        wait for 3*period*16;
        rst_s <= '0';

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