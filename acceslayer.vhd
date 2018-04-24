-------------------------------------------------------------------
-- Project	:  zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 06/03/2018
-- bestand	: acceslayer.vhd
-- info: Samenvoegen van de verschilende componenten in de acces layer. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;



--entity beschrijven
entity acceslayer is
  port (
    clk: in std_logic;
    clk_en: in std_logic;
    rst: in std_logic;
    sdo_posenc: in std_logic;
    sel: in std_logic_vector(1 downto 0);
    pn_start: out std_logic;
    sdo_spread: out std_logic
    );
end acceslayer;


architecture structural of acceslayer is

  --signalen
  signal pn_ml1_t: std_logic;
  signal pn_gold_t: std_logic;
  signal pn_ml2_t: std_logic;

  signal demux_t: std_logic_vector(3 downto 0);

  --component declaration
  component pngen  is
  port (
        rst: in std_logic;
        clk: in std_logic;
        clk_en: in std_logic;

        pn_ml1: out std_logic;
        pn_ml2: out std_logic;
        pn_gold: out std_logic;
        pn_start: out std_logic
    );
  end component;


  component demux  is
    port (
      data: in std_logic_vector(3 downto 0);
      sel: in std_logic_vector(1 downto 0);
      demux_out: out std_logic
      );
  end component;

begin

    demux_t(0) <= sdo_posenc;
    demux_t(1) <= sdo_posenc xor pn_ml1_t;
    demux_t(2) <= sdo_posenc xor pn_gold_t;
    demux_t(3) <= sdo_posenc xor pn_ml2_t;

-- Port maps
map_pngen: pngen port map (
    clk => clk,
    clk_en => clk_en,
    rst => rst,

    pn_start => pn_start,
    pn_ml1 => pn_ml1_t,
    pn_gold => pn_gold_t,
    pn_ml2 => pn_ml2_t
);

map_demux: demux port map (
    data => demux_t,
    sel => sel,
    demux_out => sdo_spread
);
       
end architecture;