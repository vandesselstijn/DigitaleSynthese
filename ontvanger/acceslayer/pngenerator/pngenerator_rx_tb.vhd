-------------------------------------------------------------------
-- Project  : tb pengen voor ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date   : 20/05/2018
-- bestand  : pngen_tb.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pnGenerator_rx_tb is
end pnGenerator_rx_tb;

architecture structural of pnGenerator_rx_tb is 

-- Beschrijven van component
component pnGenerator_rx is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        seq_det: in std_logic;
        chip_sample: in std_logic;

        full_seq: out std_logic;
        pn_ml1: out std_logic;
        pn_gold: out std_logic;
        pn_ml2: out std_logic
    );
end component;

for uut : pnGenerator_rx use entity work.pnGenerator_rx(behav);
 
--Klok beschrijven
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk_s:  std_logic;
signal clk_en_s:  std_logic;
signal rst_s:  std_logic;

-- Tb signalen beschrijven
signal seq_det_s: std_logic := '0';
signal chip_sample_s: std_logic := '0';
signal full_seq_s_s: std_logic;
signal pn_ml1_s: std_logic;
signal pn_gold_s: std_logic;
signal pn_ml2_s: std_logic;


begin
    --Mapppen van de tb signalen aan de component
    uut: pnGenerator_rx port map(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,
        seq_det => seq_det_s,
        chip_sample => chip_sample_s,
        full_seq => full_seq_s_s,
        pn_ml1 => pn_ml1_s,
        pn_gold => pn_gold_s,
        pn_ml2 => pn_ml2_s
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

    tb : process

    begin
        clk_en_s <= '1'; --Klok aanzetten
        
        rst_s <= '1'; --Resetten
        wait for 5*period;
        rst_s <= '0';
        wait for 5*period;

        seq_det_s <= '0'; 
        wait for 10*period;
        seq_det_s <= '1';
        wait for 2*period;
        seq_det_s <= '0';
        wait for 5*period;
                  
        end_of_sim <= true;
        wait;
    end process;
end;