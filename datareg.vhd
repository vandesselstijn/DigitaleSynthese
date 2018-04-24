-------------------------------------------------------------------
-- Project	: Dataregister voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 24/04/2018
-- bestand	: pngen.vhd
-- info: Dataregister voor datalink layer. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity datareg  is
port (
  rst: in std_logic;
  clk: in std_logic;
  clk_en: in std_logic;
  data: in std_logic_vector(3 downto 0);
  load: in std_logic;
  shift: in std_logic;
  sdo_posenc: out std_logic
  );
end datareg;

architecture behav of datareg is
  
-- signalen
signal pres_shiftreg: std_logic_vector(10 downto 0);
signal next_shiftreg: std_logic_vector(10 downto 0);
-- constante
constant preamble: std_logic_vector(6 downto 0) := "0111110";

begin
  
sdo_posenc <= pres_shiftreg(0);

syn_datareg: process(clk)
begin
	if (rising_edge(clk) and clk_en = '1') then
	    if rst = '1' then
	          pres_shiftreg <= (others => '0');   -- reseten
	    else
	          pres_shiftreg <= next_shiftreg;
	    end if;
	end if;
end process syn_datareg;

com_datareg: process(pres_shiftreg, load, shift, data)
begin
	if(load = '1') then  -- nieuwe data inladen
		next_shiftreg <= data & preamble;
	elsif(shift = '1') then -- schuiven
	   next_shiftreg <= '0' & pres_shiftreg(10 downto 1);
	else
	   next_shiftreg <= pres_shiftreg; --latch vermijden
	end if;
end process com_datareg; 
    
end behav;

