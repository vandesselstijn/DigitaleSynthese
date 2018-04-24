-------------------------------------------------------------------
-- Project	:  zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 24/03/2018
-- bestand	: datalinklayer.vhd
-- info: Samenvoegen van de verschilende componenten in de datalink layer. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--entity beschrijven
entity datalinklayer is
port (
  clk: in std_logic;
  clk_en: in std_logic;
  rst: in std_logic;
  
  data: in std_logic_vector(3 downto 0);
  pn_start: in std_logic;
  sdo_posenc: out std_logic
  );
end datalinklayer;


architecture behav of datalinklayer is
    --component declaration
    component datareg  is
      port (
        rst: in std_logic;
        clk: in std_logic;
        clk_en: in std_logic;
        data: in std_logic_vector(3 downto 0);
        load: in std_logic;
        shift: in std_logic;
        sdo_posenc: out std_logic
      );
  end component;

  component seqcon  is
    port (
      rst: in std_logic;
      clk: in std_logic;
      clk_en: in std_logic;
      
      pn_start: in std_logic;
      load: out std_logic;
      shift: out std_logic
      );
end component;

--interne signalen
signal load_t, shift_t: std_logic;

Begin

data_reg: datareg port map(
    rst => rst,
    clk => clk,
    clk_en => clk_en,
    data => data,
    load => load_t,
    shift => shift_t,
    sdo_posenc => sdo_posenc
  );

seq_con: seqcon port map(
    rst => rst,
    clk => clk,
    clk_en => clk_en,
    pn_start => pn_start,
    load => load_t,
    shift => shift_t
  );
                 
end behav;