-------------------------------------------------------------------
-- Project	: demux voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 24/04/2018
-- bestand	: mux_tb.vhd
-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY demux_tb IS
END demux_tb;

ARCHITECTURE structural OF demux_tb IS 

	-- Component Declaration
	COMPONENT demux
		PORT (
			data: in std_logic_vector(3 downto 0);
			sel: in std_logic_vector(1 downto 0);
			demux_out: out std_logic
		);
	END COMPONENT;

	FOR uut : demux USE ENTITY work.demux(behav);
 
 	--Klok beschijven
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

	--algemene signalen
	--geen algemene clk en reset signalen

	--specifieke signalen voor deze component
	SIGNAL data_t: std_logic_vector(3 downto 0);
	SIGNAL sel_t: std_logic_vector(1 downto 0);
	SIGNAL demux_out_t: std_logic;

BEGIN

	--Tb signalen aanleggen aan effectieve signalen
	uut: demux PORT MAP(
		data => data_t,
		sel => sel_t,
		demux_out => demux_out_t
	);
	

	tb : PROCESS

	BEGIN


		data_t <= "1000";
		sel_t <= "00";
		wait for 3*period;
		sel_t <= "01";
		wait for 3*period;
		sel_t <= "10";
		wait for 3*period;
		sel_t <= "11";
		wait for 3*period;

		data_t <= "0101";
		sel_t <= "00";
		wait for 3*period;
		sel_t <= "01";
		wait for 3*period;
		sel_t <= "10";
		wait for 3*period;
		sel_t <= "11";
		wait for 3*period;

	
		end_of_sim <= true;
		wait;

	END PROCESS;
END;