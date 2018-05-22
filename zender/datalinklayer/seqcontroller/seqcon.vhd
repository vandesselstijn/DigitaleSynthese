-------------------------------------------------------------------
-- Project	: Sequentie controller voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 24/04/2018
-- bestand	: seqcon.vhd
-- info:	Sequentie generator. 
--		 	Component zal tellen hoe vaak er een pn_start puls is gegenereerd
--			Op elke pn_start puls zal de component een shift signaal generen
--			Na 10 pn_start pulsen zal een load puls genereerd woden. 
--			De volgende component zal dan nieuwe data moeten binnennemen
--
--			Doel: 	ruimte voorzien voor de 7 preamlbe bit naast de effectieve data bits.
-- 					preamble zal er voor zorgen dat data niet vlak achter elkaar zit
--					als ook het voorzien van de mogelijke synchronisatie 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--In en uitgangen component beschrijven
entity seqcon  is
port (
  rst: in std_logic;
  clk: in std_logic;
  clk_en: in std_logic;
  
  pn_start: in std_logic;
  load: out std_logic;
  shift: out std_logic
  );
end seqcon;

architecture behav of seqcon is
  
-- counter signalen
signal pres_cnt, next_cnt: std_logic_vector(3 DOWNTO 0);


begin
  
--Teller werking
syn_count: process(clk)
begin
	if (rising_edge(clk) and clk_en = '1') then
	    if rst = '1' then
	          pres_cnt <= "0000";   -- counter reseten
	    else
	          pres_cnt <= next_cnt;
	    end if;
	end if;
end process syn_count;

--na 10 keer terug op null zetten en datareg inladen
com_count: process(pres_cnt, pn_start)
begin
	if(pn_start = '1' and pres_cnt = "1010") then  -- Als 10, terug op 0000 zetten en load genereren
	   next_cnt <= "0000";				
	   load <= '1';
	   shift <= '0'; 
	elsif(pn_start = '1') then --normale tel opperatie als pn_start en is (PN heeft 31 exoren gedaan)
	   next_cnt <= pres_cnt + "0001";
	   load <= '0';
	   shift <= '1';
	else
	   next_cnt <= pres_cnt; --Default = latch vermijden
	   load <= '0';
	   shift <= '0';
	end if;
end process com_count; 
    
end behav;
