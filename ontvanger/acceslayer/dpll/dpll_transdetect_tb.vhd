-------------------------------------------------------------------
-- Project  : transition tetectror voor ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date   : 20/05/2018
-- bestand  : dpll_transdetect_tb.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity transDetect_tb is
end transDetect_tb;

architecture structural of transDetect_tb is 

-- Component beschrijving
component transDetect is
    port (
      data: in std_logic;
      rst: in std_logic;
      clk: in std_logic;
      clk_en: in std_logic;
      puls: out std_logic
    );
end component;

for uut : transDetect use entity work.transDetect(behav);
 

--Klok beschrijven
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk_t:  std_logic;
signal clk_en_t:  std_logic;
signal rst_t:  std_logic;

-- Signals
signal data_t: std_logic := '0';
signal puls_t: std_logic;


begin
    uut: transDetect port map(
        data => data_t,
        clk => clk_t,
        rst => rst_t,
        clk_en => clk_en_t,
        puls => puls_t
    );

    --klok genereren
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
    begin
        clk_en_t <= '1';   --klok aanzetten
        
        rst_t <= '1';  -- Reseten
        wait for 3*period;
        rst_t <= '0';

        --test input
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '1';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '0';
        wait for period;
        data_t <= '1';
        wait for period;

                        
        end_of_sim <= true;
        wait;
    end process;
end;