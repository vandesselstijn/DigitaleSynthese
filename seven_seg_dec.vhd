-------------------------------------------------------------------
-- Project	: 7segment decode voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 27/02/2018
-- bestand	: seven_seg_dec.vhd
-- info: 7seg decoder voor in de aplication layer. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity seven_seg_dec is
port (
  data_in: in std_logic_vector(3 DOWNTO 0);
  data_out: out std_logic_vector(6 DOWNTO 0)
  );
end seven_seg_dec;

architecture behav of seven_seg_dec is

begin

  
com_7dec: PROCESS(data_in)
  BEGIN
        CASE data_in IS 
          WHEN "0000"  => data_out <= "1111110"; --0
          WHEN "0001"  => data_out <= "0110000"; --1 
          WHEN "0010"  => data_out <= "1101101"; --2
          WHEN "0011"  => data_out <= "1111001"; --3
          WHEN "0100"  => data_out <= "0110011"; --4
          WHEN "0101"  => data_out <= "1011011"; --5
          WHEN "0110"  => data_out <= "1011111"; --6
          WHEN "0111"  => data_out <= "1110000"; --7
          WHEN "1000"  => data_out <= "1111111"; --8
          WHEN "1001"  => data_out <= "1111011"; --9
          WHEN "1010"  => data_out <= "1111101";
          WHEN "1011"  => data_out <= "0011111";
          WHEN "1100"  => data_out <= "1001110";
          WHEN "1101"  => data_out <= "0111101";
          WHEN "1110"  => data_out <= "1001111";
          WHEN "1111"  => data_out <= "1000111"; 
          WHEN others  => data_out <= "0000000";                        
        END CASE;
END PROCESS com_7dec;
                    
end behav;
