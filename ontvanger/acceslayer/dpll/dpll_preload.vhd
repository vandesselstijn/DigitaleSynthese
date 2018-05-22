-------------------------------------------------------------------
-- Project  : dpll preload ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date   : 16/05/2018
-- bestand  : dpll_preload.vhd
-- info:    Telwaarde ofset genereren
--          Daarnaast ook vertraagde chip samples naar buiten sturen
-------------------------------------------------------------------

library IEEE;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--Component beschrijven
entity preload is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        sema: in std_logic_vector(4 downto 0);
        chip_sample: out std_logic;
        chip_sample1: out std_logic;
        chip_sample2: out std_logic
    );
end preload;

architecture behav of preload is

-- Signalen beschrijven
signal start_count: integer range 0 to 18 := 15;
signal pres_count: std_logic_vector(4 downto 0);
signal next_count: std_logic_vector(4 downto 0);
signal chip_sample_s: std_logic;
signal chip_sample1_s: std_logic;
signal chip_sample2_s: std_logic;

begin

    --Chip sample signalen naar buiten brengen
    chip_sample <= chip_sample_s;
    chip_sample1 <= chip_sample1_s;
    chip_sample2 <= chip_sample2_s;
    

    sync_preload: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_count <= std_logic_vector(to_unsigned(start_count, pres_count'length)); --Int omvormen naar vector
            else
                pres_count <= next_count;
            end if;
        end if;
    end process sync_preload;

    -- Next state decoder
    com_preload: process(pres_count, start_count)
    begin
        chip_sample2_s <= chip_sample1_s; --vertraging van 1 cycle genereren
        chip_sample1_s <= chip_sample_s;

        if(pres_count = "0000") then
            next_count <= std_logic_vector(to_unsigned(start_count, next_count'length));--int naar vector
            chip_sample_s <= '1';
        else
            next_count <= pres_count - 1;
            chip_sample_s <= '0';
        end if;
    end process com_preload;

    -- Juiste teller startwaarde linken aan het semaphore dat binnen komt
    com_decoder: process(sema)
    begin
        case sema is
            when "10000"    => start_count <= 15 + 3; -- A
            when "01000"    => start_count <= 15 + 1; -- B
            when "00100"    => start_count <= 15 + 0; -- C
            when "00010"    => start_count <= 15 - 1; -- D
            when "00001"    => start_count <= 15 - 3; -- E
            when others     => start_count <= 15 + 0; -- C
        end case;
    end process;  
end behav;