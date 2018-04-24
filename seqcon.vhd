-------------------------------------------------------------------
-- Project	: Sequentie controller voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 24/04/2018
-- bestand	: seqcon.vhd
-- info: Sequentie generator. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

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
  

syn_count: process(clk)
begin
	if (rising_edge(clk) and clk_en = '1') then
	    if rst = '1' then
	          pres_cnt <= (others => '0');   -- reseten
	    else
	          pres_cnt <= next_cnt;
	    end if;
	end if;
end process syn_count;

com_count: process(pres_cnt, pn_start)
begin
	if(pn_start = '1' and pres_cnt = "1011") then  -- max value
	   next_cnt <= "0000";
	   load <= '0';
	   shift <= '0'; 
	elsif(pres_cnt = "0000") then -- load genereren
	   next_cnt <= pres_cnt + "0001";
	   load <= '1';
	   shift <= '0'; 
	elsif(pn_start = '1') then --normale tel opperatie
	   next_cnt <= pres_cnt + "0001";
	   load <= '0';
	   shift <= '1';
	else
	   next_cnt <= pres_cnt; --latch vermijden
	   load <= '0';
	   shift <= '0';
	end if;
end process com_count; 
    
end behav;
