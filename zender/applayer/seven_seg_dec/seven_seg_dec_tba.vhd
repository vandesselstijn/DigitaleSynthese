-------------------------------------------------------------------
-- Project	: 7 seg deceder test voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 06/03/2018
-- bestand	: seven_seg_dec_tb.vhd
-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY seven_seg_dec_tb IS
END seven_seg_dec_tb;

ARCHITECTURE structural OF seven_seg_dec_tb IS 

	-- Component Declaration
	COMPONENT seven_seg_dec
		PORT (
      data_in: in std_logic_vector(3 DOWNTO 0);
      data_out: out std_logic_vector(6 DOWNTO 0)
    );
	END COMPONENT;

	FOR uut : seven_seg_dec USE ENTITY work.seven_seg_dec(behav);
 
    --Klok signalen beschrijven
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

    --Andere tb signalen beschrijven
	SIGNAL data_in_t: std_logic_vector(3 DOWNTO 0);
	SIGNAL data_out_t:  std_logic_vector(6 DOWNTO 0);

BEGIN

    --Effectieve in en uitgannen mappen aan tb signalen
	uut: seven_seg_dec PORT MAP(
		data_in => data_in_t,
		data_out => data_out_t
	);
	
	tb : PROCESS
	BEGIN

        --Verschillende ingang telwaarden aanleggen 
        data_in_t <= "0000";
        wait for 100 ns;
        data_in_t <= "0001";
        wait for 100 ns;
        data_in_t <= "0010";
        wait for 100 ns;
        data_in_t <= "0011";
        wait for 100 ns;
        data_in_t <= "0100";
        wait for 100 ns;
        data_in_t <= "0101";
        wait for 100 ns;
        data_in_t <= "0110";
        wait for 100 ns;
        data_in_t <= "0111";
        wait for 100 ns;
        data_in_t <= "1000";
        wait for 100 ns;
        data_in_t <= "1001";
        wait for 100 ns;
        data_in_t <= "1010";
        wait for 100 ns;
        data_in_t <= "1011";
        wait for 100 ns;
        data_in_t <= "1100";
        wait for 100 ns;
        data_in_t <= "1101";
        wait for 100 ns;
        data_in_t <= "1110";
        wait for 100 ns;
        data_in_t <= "1111";
        wait for 100 ns;
	
		end_of_sim <= true;
		wait;
	END PROCESS;
END;