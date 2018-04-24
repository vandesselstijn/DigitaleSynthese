-------------------------------------------------------------------
-- Project	:  zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 06/03/2018
-- bestand	: zender.vhd
-- info:  De volledige zender implementatie
--        het samenvoegen van alle lagen
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--in/uitgangen van de transmitter block bescrhrijven
entity transmitter is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        up: in std_logic;
        down: in std_logic;
        sel: in std_logic_vector(1 downto 0);
        sevenseg: out std_logic_vector(6 downto 0);
        sdo_spread: out std_logic
    );
end transmitter;

architecture behav of transmitter is

--component beschrijven
component acceslayer is
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

--component beschrijven
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








end architecture;