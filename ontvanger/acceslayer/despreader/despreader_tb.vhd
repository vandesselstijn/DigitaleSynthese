-------------------------------------------------------------------
-- Project  : preload voor ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date : 22/05/2018
-- bestand  : despreader_tb.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity despread_tb is
end despread_tb;

architecture structural of despread_tb is 

-- Component beschrijven
component despread is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        sdi_spread: in std_logic;
        pn_seq: in std_logic;
        chip_sample: in std_logic;
        despread: out std_logic
    );
end component;

for uut : despread use entity work.despread(behav);
 
--Klok beschrijven
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk_s:  std_logic;
signal clk_en_s:  std_logic;
signal rst_s:  std_logic;

-- Tb signalen beschrijven
signal sdi_spread_s: std_logic := '0';
signal pn_seq_s: std_logic := '0';
signal chip_sample_s: std_logic := '0';
signal despread_s: std_logic;

begin
    uut: despread port map(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,
        sdi_spread => sdi_spread_s,
        pn_seq => pn_seq_s,
        chip_sample => chip_sample_s,
        despread => despread_s
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

    tb : process

    begin
        clk_en_s <= '1';  --klok aanzetten
        
        -- Reset
        rst_s <= '1';
        wait for 3*period;
        rst_s <= '0';
        wait for 3*period;
        
        chip_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        wait for period;

        sdi_spread_s <= '1';    --input wijzigen
        pn_seq_s <= '0';        --input wijzigen
        
        chip_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        wait for period;

        sdi_spread_s <= '1';    --input wijzigen
        pn_seq_s <= '1';        --input wijzigen
        
        chip_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        wait for period;

        sdi_spread_s <= '0';    --input wijzigen
        pn_seq_s <= '1';        --input wijzigen
        
        chip_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        wait for period;

        sdi_spread_s <= '0';    --input wijzigen
        pn_seq_s <= '0';        --input wijzigen
        
        chip_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        wait for period;
                        
        end_of_sim <= true;
        wait;
    end process;
end;