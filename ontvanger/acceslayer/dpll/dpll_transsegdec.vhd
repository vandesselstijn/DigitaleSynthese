-------------------------------------------------------------------
-- Project  : Trans seg decoder voor DPLL ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date : 27/04/2018
-- bestand  : tanssegdec.vhd
-- info:    transsegdecoder voor in de acces layer(DPLL). 
--          Het geneneren van het segment patroon voor het 
--          aligneren van de chip samples
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--In en uitgangen component beschrijven
entity transsegdecoder is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        seg: out std_logic_vector(4 downto 0);
        extb: in std_logic 
    );
end transsegdecoder;

architecture behav of transsegdecoder is

--Counter signalen beschrijven
signal pres_count: std_logic_vector(3 DOWNTO 0);
signal next_count: std_logic_vector(3 DOWNTO 0);

--Synchroon process
--Resetten en counter toewijzen
begin
    sync_transsegdecoder: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_count <= "0000";
            else
                pres_count <= next_count;
            end if;
        end if;
    end process sync_transsegdecoder;

    -- normale counter werking
    com_transSegDecoder: process(pres_count, extb)
    begin
        if(extb = '1') then
            next_count <= "0000"; --Nieuwe input is op 0 zetten
        elsif(pres_count = "1111") then
            next_count <= "1111"; -- Maximum waarde
        else
            next_count <= pres_count + 1; --Normale tel operatie
        end if;
    end process;
  
    -- decoder
    com_decoder: process(pres_count)
    begin
        if (pres_count <= "0100") then --    Counter groter dan 4 SEG A
            seg <= "10000";
        elsif (pres_count <= "0110") then -- Counter groter dan 6 SEG B
            seg <= "01000";
        elsif (pres_count <= "1000") then -- Counter groter dan SEG C
            seg <= "00100";
        elsif (pres_count <= "1010") then -- Counter groter dan SEG D
            seg <= "00010";
        elsif (pres_count <= "1111") then -- Counter groter dan SEG E
            seg <= "00001";
        else                              -- Default C latch vermijden
            seg <= "00100";
        end if;
    end process;
    
end behav;