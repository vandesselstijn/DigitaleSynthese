-------------------------------------------------------------------
-- Project	: dpll ontvanger Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 08/05/2018
-- bestand	: dpll.vhd
-- info: dpll acceslayer -- samenvoegen van de verschillende onderdelen van de dpll
--
-- Doel:    Door het verzenden van de data zal het signaal geen mooie blockgolf meer vormen.
--          Met de dpll proberen we dit te compenceren door zo centraal mogelijk te sampelen. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--Component beschrijven
entity dpll is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        sdi_spread: in std_logic;
        extb: out std_logic;
        chip_sample: out std_logic;
        chip_sample1: out std_logic;
        chip_sample2: out std_logic
    );
end dpll;

--Verschillende componente beschrijven
architecture behav of dpll is

    component transDetect is
        port (
            data: in std_logic;
            rst: in std_logic;
            clk: in std_logic;
            clk_en: in std_logic;
            puls: out std_logic
        );
    end component;

    component transSegDecoder is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;
            seg: out std_logic_vector(4 downto 0);
            extb: in std_logic 
        );
    end component;

    component segSemDecoder is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;
            seg: in std_logic_vector(4 downto 0);
            extb: in std_logic;
            chip_sample: in std_logic;
            sema: out std_logic_vector(4 downto 0)
        );
    end component;

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

-- Signals
signal extb_s: std_logic;
signal chip_sample_s: std_logic;
signal seg_s: std_logic_vector(4 downto 0);
signal sema_s: std_logic_vector(4 downto 0);

--Linken van de uitgangen
begin

    chip_sample <= chip_sample_s;
    
    transdet: transDetect port map (
        clk => clk,
        clk_en => clk_en,
        rst => rst,
        data => sdi_spread,
        puls => extb_s
    );
  
    transSegDec: transSegDecoder port map (
        clk => clk,
        clk_en => clk_en,
        rst => rst,
        extb => extb_s,
        seg => seg_s
    );

    segSemDec: segSemDecoder port map (
        clk => clk,
        clk_en => clk_en,
        rst => rst,
        seg => seg_s,
        extb => extb_s,
        chip_sample => chip_sample_s,
        sema => sema_s
    );

    prload: preload port map (
        clk => clk,
        clk_en => clk_en,
        rst => rst,
        sema => sema_s,
        chip_sample => chip_sample_s,
        chip_sample1 => chip_sample1,
        chip_sample2 => chip_sample2
    );
    
end behav;