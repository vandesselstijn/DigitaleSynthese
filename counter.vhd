-------------------------------------------------------------------
-- Project	: Counter voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 20/02/2018
-- bestand	: counter.vhd
-- info: teler om de zeven segment aan te sturen. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity counter  is
port (
  rst: in std_logic;
  clk: in std_logic;
  clk_en: in std_logic;
  cnt_up: in std_logic;
  cnt_down: in std_logic;
  cnt_out: out std_logic_vector(3 DOWNTO 0)
  );
end counter;

architecture behav of counter is
  
-- counter signalen
signal pres_cnt, next_cnt: std_logic_vector(3 DOWNTO 0);


begin
  
cnt_out <= pres_cnt;
  
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

com_count: process(pres_cnt, cnt_up, cnt_down)
begin
if(cnt_up = '1') then  -- count up
   next_cnt <= pres_cnt + 1;
else                   -- countdown
   next_cnt <= pres_cnt - 1;
end if;

end process com_count; 
    
end behav;
