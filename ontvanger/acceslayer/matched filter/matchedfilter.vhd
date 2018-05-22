-------------------------------------------------------------------
-- Project  : matched filter ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date   : 19/05/2018
-- bestand  : matchedfilter.vhd
-- info:    matched filte checkt pn patroon met binnekomende data
--          het doel hiervan is het sycncroniseren van de pn generator
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--Component beschrijven
entity matchedFilter is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        sel: in std_logic_vector(1 downto 0);
        chip_sample: in std_logic;
        sdi_spread: in std_logic;
        seq_det: out std_logic
    );
end matchedFilter;

architecture behav of matchedFilter is

-- Signalen beschrijven
signal shiftreg: std_logic_vector(30 downto 0); 
signal shiftreg_next: std_logic_vector(30 downto 0);
signal pn_ptrn: std_logic_vector(30 downto 0);
signal pn_ptrn_b: std_logic_vector(30 downto 0);

-- Pn signalen genereen
constant no_ptrn: std_logic_vector(30 downto 0) := (others => '1');
constant ml1_ptrn: std_logic_vector(30 downto 0) := "1101001100000111001000101011110";
constant ml2_ptrn: std_logic_vector(30 downto 0) := "0110010000010111011010100111100";
constant gold_ptrn: std_logic_vector(30 downto 0) := ml1_ptrn xor ml2_ptrn;

begin
    pn_ptrn_b <= not pn_ptrn;

    -- Synchroon resetten + schiften
    sync_matchedFilter: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                shiftreg <= (others => '0');
            else
                shiftreg <= shiftreg_next;
            end if;
        end if;
    end process sync_matchedFilter;

    -- Shiftregister van input data
    comb_shiftreg: process(sdi_spread, chip_sample, shiftreg)
    begin
        if(chip_sample = '1') then
            shiftreg_next <= sdi_spread & shiftreg(30 downto 1);
        else
            shiftreg_next <= shiftreg;
        end if;
    end process comb_shiftreg;
  
    -- Selectie van de pn code
    comb_mux: process(sel)
    begin
        case sel is
            when "00" => pn_ptrn <= no_ptrn;
            when "01" => pn_ptrn <= ml1_ptrn;
            when "10" => pn_ptrn <= ml2_ptrn;
            when others => pn_ptrn <= gold_ptrn;
        end case;
    end process comb_mux;

    --Chekken op de patronen gelijk zijn
    comb_out: process(pn_ptrn, pn_ptrn_b, shiftreg)
    begin
        if(shiftreg = pn_ptrn) or (shiftreg = not pn_ptrn) then
            seq_det <= '1'; --Patronen zijn gelijk
        else
            seq_det <= '0';
        end if;

    end process;
    
end behav;