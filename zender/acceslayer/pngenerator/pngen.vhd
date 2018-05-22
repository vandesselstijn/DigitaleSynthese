-------------------------------------------------------------------
-- Project	: Pngenerator voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 27/03/2018
-- bestand	: pngen.vhd
-- info:  Genenreren van het pn signaal. 
--        Met het genereren van dit pn signaal worden verschillend channels gegenereerd.
--        Zo kunnnen er verschillende mensen op verschillende kanalen communiceren
--        Ook zorgt dit er voor dat de data geëncripteed is en dus de effectie doorgezonde 
--        waarden niet zomaar leesbaar de lucht in gaat.
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--Beschrijven in en uitgangen component
entity pngen  is
  port (
        rst: in std_logic;
        clk: in std_logic;
        clk_en: in std_logic;

        pn_ml1: out std_logic;
        pn_ml2: out std_logic;
        pn_gold: out std_logic;
        pn_start: out std_logic;

        shdata1_out: out std_logic_vector(4 DOWNTO 0);
        shdata2_out: out std_logic_vector(4 DOWNTO 0)
    );
    signal pn_start_next: std_logic;
    signal shdata1, shdata2: std_logic_vector(4 DOWNTO 0);
    signal shdata1_next, shdata2_next: std_logic_vector(4 DOWNTO 0);
    signal feedback1, feedback2: std_logic;
end pngen;

architecture behav of pngen is

begin

-- Generen van feedback bit voor de shift registers
-- 0de bit XORen met de 3de bit
feedback1 <= (shdata1(0) XOR shdata1(3));
-- 0de bit XORen met de 1ste bit
-- Resultaat XORen met de 3de bit
-- Resultaar XORen met de 4de bit
feedback2 <= ((shdata2(0) XOR shdata2(1)) XOR shdata2(3)) XOR shdata2(4);

--Uitgangen voor de verschillende bitcodes uit het schiftregister halen.
pn_ml1 <= shdata1(0);
pn_ml2 <= shdata2(0);
--Extra pn code waarbij 1ste en 2de ge XORD worden
pn_gold <= (shdata1(0) XOR shdata2(0));
--Pusl voor wanneer de PN sequentie rond is
pn_start <= pn_start_next;

--Shift vectoren naarbuiten brengen voor test
shdata1_out <= shdata1;
shdata2_out <= shdata2;


pn_gen_syn: process(clk) --syncrone werking
begin

  if (rising_edge(clk) and clk_en = '1') then
      if rst = '1' then --reset -> default waarden inladen
            shdata1 <= "00010"; --default waarden
            shdata2 <= "00111";
      else --normale werking
            shdata1 <= shdata1_next; --Shiften
            shdata2 <= shdata2_next;
      end if;
  end if;

end process pn_gen_syn;


--Nieuwe data vr het shuifregiste vormen
--Detecteren of de pn secuentie rond is en dan een puls geven
pn_gen_comb : process (shdata1, shdata2, feedback1, feedback2)--cominatoriche werking
begin
  shdata1_next <= feedback1 & shdata1(4 DOWNTO 1);
  shdata2_next <= feedback2 & shdata2(4 DOWNTO 1);
  if (shdata1 = "00010") then -- startwaarde (was 00100)
      pn_start_next <= '1';
  else
      pn_start_next <= '0';
  end if; 

end process pn_gen_comb;
    
end behav;
