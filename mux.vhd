-------------------------------------------------------------------
-- Project	: deMux voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 24/04/2018
-- bestand	: mux.vhd
-- info: deMultiplexer acces laag. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity demux  is
port (
	data: in std_logic_vector(3 downto 0);
	sel: in std_logic_vector(1 downto 0);
	demux_out: out std_logic
  );
end demux;

architecture behav of demux is
  
begin

	process(sel, data)
    begin
        case sel is
            when "00" => demux_out <= data(0);
            when "01" => demux_out <= data(1);
            when "10" => demux_out <= data(2);
            when others => demux_out <= data(3);
        end case;
    end process;

end architecture ;
