-------------------------------------------------------------------
-- Project  : pn generator ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date   : 19/05/2018
-- bestand  : pngenerator_rx.vhd
-- info:    Het genereren van de unieke pn codes allsook een puls
--          geven bij het volledig doorlopen van de sequentie
-------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


--Component beschrijven
entity pnGenerator_rx is
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
end pnGenerator_rx;

architecture behav of pnGenerator_rx is

-- Beschrijving edge detectror
component edgedetect is
    port (
      clk: in std_logic;
      clk_en: in std_logic;
      rst: in std_logic;
  
      data: in std_logic;
      puls: out std_logic
    );
end component; 

-- Signalen beschrijven
constant start_1: std_logic_vector(4 downto 0) := "00010"; --XOR patroon pngen
constant start_2: std_logic_vector(4 downto 0) := "00111";

signal shiftreg_1: std_logic_vector(4 downto 0) := start_1;
signal shiftreg_2: std_logic_vector(4 downto 0) := start_2;

signal shiftreg_1_next: std_logic_vector(4 downto 0);
signal shiftreg_2_next: std_logic_vector(4 downto 0);

signal full_seq_s: std_logic;

begin

    --Mappen van edgegeneratro
    edgedet: edgedetect port map (
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        data => full_seq_s,
        puls => full_seq
    );
    
    pn_ml1 <= shiftreg_1(0); --Buiten te schiften bit
    pn_ml2 <= shiftreg_2(0);
    pn_gold <= shiftreg_1(0) xor shiftreg_2(0); --Extra pncode door pn_ml1 en pn_ml2 te XOR-en


    shift: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                shiftreg_1 <= start_1; --Terug resetten op startwaarden
                shiftreg_2 <= start_2;
            else
                if chip_sample = '1' then
                    shiftreg_1 <= shiftreg_1_next; --Nextstate doorgeven statemachine
                    shiftreg_2 <= shiftreg_2_next;
                end if;
            end if;
        end if;
    end process;

    shift_comb: process(shiftreg_1, shiftreg_2, seq_det)
    begin
        if seq_det = '1' then
            shiftreg_1_next <= start_1; --Terug op nieuw starten bij het doorlopen van een voledige sequentie
            shiftreg_2_next <= start_2;
        else
            shiftreg_1_next <= (shiftreg_1(0) xor shiftreg_1(3)) & shiftreg_1(4 downto 1); --XOR pn uitvoeren
            shiftreg_2_next <= (shiftreg_2(1) xor shiftreg_2(3) xor shiftreg_2(4) xor shiftreg_2(0)) & shiftreg_2(4 downto 1);
        end if;

        if(shiftreg_1 = start_1) then
            full_seq_s <= '1'; --Detectie volle sequentie
        else
            full_seq_s <= '0';
        end if;
    end process;
end behav;