-------------------------------------------------------------------
-- Project	: Pngenerator voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 27/03/2018
-- bestand	: pngen.vhd
-- info: Genenreren van het pn signaal. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity pngen  is
  port (
        rst: in std_logic;
        clk: in std_logic;
        clk_en: in std_logic;

        pn_ml1: out std_logic;
        pn_ml2: out std_logic;
        pn_gold: out std_logic;
        pn_start: out std_logic
    );
    signal pn_start_next: std_logic;
    signal shdata1, shdata2: std_logic_vector(4 DOWNTO 0);
    signal shdata1_next, shdata2_next: std_logic_vector(4 DOWNTO 0);
    signal feedback1, feedback2: std_logic;
end pngen;

--werken in 2 process
--syncroon en assyncroon deel (prev-next value)
--na 31 cobinaties(keer roteren puls geven) naar de datalink
--dit wordt daar gecheckt door de sequence controller

architecture behav of pngen is

begin

feedback1 <= (shdata1(0) XOR shdata1(3));
feedback2 <= ((shdata2(0) XOR shdata2(1)) XOR shdata2(3)) XOR shdata2(4);

pn_ml1 <= shdata1(0);
pn_ml2 <= shdata2(0);
pn_gold <= (shdata1(0) XOR shdata2(0));
pn_start <= pn_start_next;

pn_gen_syn: process(clk) --syncrone werking
begin

  if (rising_edge(clk) and clk_en = '1') then
      if rst = '1' then --reset -> default waarden inladen
            shdata1 <= "00010";
            shdata2 <= "00111";
            pn_start <= '1';
      else --normale werking
            pn_start <= pn_start_next;
            shdata1 <= shdata1_next;
            shdata2 <= shdata2_next;
      end if;
  end if;

end process pn_gen_syn;

pn_gen_comb : process (shdata1, shdata2, feedback1, feedback2)--cominatoriche werking
begin

  shdata1_next <= feedback1 & shdata1(4 DOWNTO 1);
  shdata2_next <= feedback2 & shdata2(4 DOWNTO 1);
  if (shdata1 = "00100") then -- startwaarde
      pn_start_next <= '1';
  else
      pn_start_next <= '0';
  end if; 

end process pn_gen_comb;
    
end behav;
