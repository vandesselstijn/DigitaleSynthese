-------------------------------------------------------------------
-- Project  : preload voor ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date   : 20/05/2018
-- bestand  : dpll_preload_tb.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity preload_tb is
end preload_tb;

architecture structural of preload_tb is 

-- Component beschrijven
component preload is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        sema: in std_logic_vector(4 downto 0);

        chip_sample: out std_logic;
        chip_sample1: out std_logic;
        chip_sample2: out std_logic
    );
end component;

for uut : preload use entity work.preload(behav);
 

--Klok beschrijven
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk_s:  std_logic;
signal clk_en_s:  std_logic;
signal rst_s:  std_logic;

-- Overige tb signalen
signal sema_s: std_logic_vector(4 downto 0);
signal chip_sample_s: std_logic;
signal chip_sample1_s: std_logic;
signal chip_sample2_s: std_logic;
signal sema_decode_s: std_logic_vector(3 downto 0);

begin
    --Tb signalen mappen aan component
    uut: preload port map(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,
        sema => sema_s,
        chip_sample => chip_sample_s,
        chip_sample1 => chip_sample1_s,
        chip_sample2 => chip_sample2_s
    );

    --Clock genereren
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

    --Sema decoderen zodat een leesbare hexwaarde te zien is op de output
    decode: process(sema_s)
    begin
        case sema_s is
            when "10000" => sema_decode_s <= "1010";
            when "01000" => sema_decode_s <= "1011";
            when "00100" => sema_decode_s <= "1100";
            when "00010" => sema_decode_s <= "1101";
            when others  => sema_decode_s <= "1110";
        end case;
    end process;

    tb : process

    begin
        clk_en_s <= '1';        -- Klok aanzetten
        
        rst_s <= '1'; -- Reset
        wait for 3*period;
        rst_s <= '0';

        sema_s <= "10000";       -- A
        wait for 20*period;
        sema_s <= "01000";       -- B
        wait for 20*period;
        sema_s <= "00100";       -- C
        wait for 20*period;
        sema_s <= "00010";       -- D
        wait for 20*period;
        sema_s <= "00001";       -- E
        wait for 20*period;
                        
        end_of_sim <= true;
        wait;
    end process;
end;