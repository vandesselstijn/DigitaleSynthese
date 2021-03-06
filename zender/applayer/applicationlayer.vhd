-------------------------------------------------------------------
-- Project	:  zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 06/03/2018
-- bestand	: applicationlayer.vhd
-- info: Samenvoegen van de verschilende componenten in de application layer. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--entity beschrijven (alle in en uitgangen van de volledige laag)
entity applayer is
port (
  clk: in std_logic;
  clk_en: in std_logic;
  rst: in std_logic;
  up: in std_logic;
  down: in std_logic;
  
  seg_out: out std_logic_vector(6 DOWNTO 0);
  cnt_out: out std_logic_vector(3 DOWNTO 0)
  );
end applayer;

--Alle verschillende onderdelen oproepen 
architecture structural of applayer is
    --component declaration
    Component debouncer is
    port (
      clk: in std_logic;
      clk_en: in std_logic;
      rst: in std_logic;
      cha: in std_logic;
      syncha: out std_logic
    );
    end Component;
    for debouncer_up: debouncer use entity work.debouncer(behav);
    for debouncer_down: debouncer use entity work.debouncer(behav);

    Component edge_detector is
    port (
      data: in std_logic;
      rst: in std_logic;
      clk: in std_logic;
      clk_en: in std_logic;
      puls: out std_logic
    );
    end Component;
    for edge_detector_up: edge_detector use entity work.edge_detector(behav);
    for edge_detector_down: edge_detector use entity work.edge_detector(behav);
    
    
    Component counter is
    port (
      rst: in std_logic;
      clk: in std_logic;
      clk_en: in std_logic;
      cnt_up: in std_logic;
      cnt_down: in std_logic;
      cnt_out: out std_logic_vector(3 DOWNTO 0)
    );
    end Component;
    for counter_i: counter use entity work.counter(behav);
    
    Component seven_seg_dec is
    port (
      data_in: in std_logic_vector(3 DOWNTO 0);
      data_out: out std_logic_vector(6 DOWNTO 0)
    );
    end Component;
    for seven_seg_dec_i: seven_seg_dec use entity work.seven_seg_dec(behav);
      
    
    signal deb_up: std_logic;
    signal deb_down: std_logic;
    
    signal edge_up: std_logic;
    signal edge_down: std_logic;
    
    signal count_i: std_logic_vector(3 DOWNTO 0);
  

--In en uitgangen van de verschillende componenten linken aan de in en uitgangen van de applaag component               
begin

    cnt_out <= count_i;

    debouncer_up: debouncer PORT MAP(
        	clk => clk,
 		      rst => rst,
		      cha => up,
		      clk_en => clk_en,
		      syncha => deb_up
    );
    
    debouncer_down: debouncer PORT MAP(
        	clk => clk,
 		      rst => rst,
		      cha => down,
		      clk_en => clk_en,
		      syncha => deb_down
    );
    
    edge_detector_up: edge_detector PORT MAP(
        	rst => rst,
 		      clk => clk,
		      clk_en => clk_en,
          data => deb_up,
          puls => edge_up
    );
    
    edge_detector_down: edge_detector PORT MAP(
        	rst => rst,
 		      clk => clk,
		      clk_en => clk_en,
          data => deb_down,
          puls => edge_down
    );
    
    counter_i: counter PORT MAP(
       	  rst => rst,
 		      clk => clk,
		      clk_en => clk_en,
		      cnt_up => edge_up,
		      cnt_down => edge_down,
		      cnt_out => count_i
    );
    
    seven_seg_dec_i: seven_seg_dec PORT MAP(
        		data_in => count_i,
		      data_out => seg_out
    );
                 
end structural;