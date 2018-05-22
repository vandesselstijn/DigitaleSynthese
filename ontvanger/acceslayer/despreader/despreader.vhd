-------------------------------------------------------------------
-- Project  : despreader ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date: 22/05/2018
-- bestand  : despereader.vhd
-- info:    Despreaden van de de pn sequentie van het pn_signaal
--          en het sdi_spread input signaal
--          principe van een geklokte XOR poort
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity despread is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        sdi_spread: in std_logic;
        pn_seq: in std_logic;
        chip_sample: in std_logic;
        despread: out std_logic
    );
end despread;

architecture behav of despread is

-- Beschrijven van signalen
signal comp1: std_logic;
signal comp1_next: std_logic;
signal comp2: std_logic;
signal comp2_next: std_logic;

begin

    --Deaspreaden van de 2 input signalen
    despread <= comp1 xor comp2;
    
    --Synchroon proces
    sync_despread: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                comp1 <= '0'; --Reseten
                comp2 <= '0';
            else
                comp1 <= comp1_next; --Input naar buiten brengen op de klok cycle
                comp2 <= comp2_next;
            end if;
        end if;
    end process sync_despread;


    comb_despread: process(sdi_spread, pn_seq, chip_sample, comp1, comp2)
    begin
        if(chip_sample = '1') then
            comp1_next <= sdi_spread; --Niewe data binnenhalen bij chip sample
            comp2_next <= pn_seq;
        else
            comp1_next <= comp1;
            comp2_next <= comp2;
        end if;
    end process comb_despread;  
    
end behav;