-------------------------------------------------------------------
-- Project  : tb matchedfilter voor ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date   : 20/05/2018
-- bestand  : matchedfilter_tb.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity matchedFilter_tb is
end matchedFilter_tb;

architecture structural of matchedFilter_tb is 

-- Component beschrijvne
component matchedFilter is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        sel: in std_logic_vector(1 downto 0);
        chip_sample: in std_logic;
        sdi_spread: in std_logic;
        seq_det: out std_logic
    );
end component;

-- Compontent Dpll
component dpll is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        sdi_spread: in std_logic;
        chip_sample: out std_logic;
        chip_sample1: out std_logic;
        chip_sample2: out std_logic
    );
end component;

-- Compontent transmitter
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

for uut : matchedFilter use entity work.matchedFilter(behav);
 
--Klok beschrijven
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk_s:  std_logic;
signal clk_16_s: std_logic;
signal clk_en_s:  std_logic;
signal rst_s:  std_logic;

--Ander tb signalen 
signal chip_sample_s: std_logic;
signal chip_sample1_s: std_logic;
signal chip_sample2_s: std_logic;

-- Siganlen matched filter
signal seq_det_s: std_logic;

-- Siganelen van de zender
signal up_s, down_s: std_logic := '0';
signal sel_s: std_logic_vector(1 downto 0) := "01"; --Keurze pn code
signal sevenseg_s: std_logic_vector(6 downto 0);
signal sdo_spread_s: std_logic;

signal present_count: std_logic_vector(3 downto 0);
signal next_count: std_logic_vector(3 downto 0);

begin
    --Transmittor linken
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

    --Dpll linken
    dpll_comp: dpll port map(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,
        sdi_spread => sdo_spread_s,
        chip_sample => chip_sample_s,
        chip_sample1 => chip_sample1_s,
        chip_sample2 => chip_sample2_s
    );

    --Matched filter linken
    uut: matchedFilter port map(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,
        sel => sel_s,
        chip_sample => chip_sample_s,
        sdi_spread => sdo_spread_s,
        seq_det => seq_det_s
    );

    --KLok genereren
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

    --vertraagde klok
    counter_comb: process(present_count)
    begin
        if(present_count = "0000") then
            clk_16_s <= '1';
        else
            clk_16_s <= '0';
        end if;

        next_count <= present_count + 1;
    end process counter_comb;
 
    --Tel funties 
    tb : process
    procedure count_up(constant wait_time : in time) is
    begin
        -- Counter +1 + wait long for transmittion
        up_s <= '1';
        wait for 4*period*16;
        up_s <= '0';
        wait for wait_time*16;
    end count_up;

    procedure count_down(constant wait_time : in time) is
    begin
        -- Counter +1 + wait long for transmittion
        down_s <= '1';
        wait for 4*period*16;
        down_s <= '0';
        wait for wait_time*16;
    end count_down;

    begin
        clk_en_s <= '1';        -- Clk always enable
        
        -- Reset
        rst_s <= '1';
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