-------------------------------------------------------------------
-- Project	: Debouncertest voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 20/02/2018
-- bestand	: debouncer_tb.vhd
-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY debouncer_tb IS
END debouncer_tb;

ARCHITECTURE structural OF debouncer_tb IS 

	-- Component Declaration
	COMPONENT debouncer
		PORT (
			clk: IN std_logic;
			rst: IN std_logic;
			cha: IN std_logic;
			clk_en: IN std_logic;
			syncha: OUT std_logic
		);
	END COMPONENT;

	FOR uut : debouncer USE ENTITY work.debouncer(behav);
 
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

	SIGNAL clk:  std_logic;
	SIGNAL rst:  std_logic;
	SIGNAL cha_s:  std_logic;
	SIGNAL clk_en: std_logic;
	SIGNAL syncha: std_logic;

BEGIN

	uut: debouncer PORT MAP(
		clk => clk,
 		rst => rst,
		cha => cha_s,
		clk_en => clk_en,
		syncha => syncha
	);

	clock : PROCESS
	BEGIN 
		clk <= '0';
		wait for period/2;
		LOOP
			clk <= '0';
			wait for period/2;
			clk <= '1';
			wait for period/2;
		EXIT WHEN end_of_sim;
		END LOOP;
		wait;
	END PROCESS clock;
	
	tb : PROCESS
   	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0))IS
	BEGIN
		cha_s <= stimvect(0);
		clk_en <= stimvect(1);
		rst <= stimvect(2);
	END tbvector;

	BEGIN
	-- reset
		tbvector ("110");
		wait for 3*period;
  
		tbvector ("011");
		wait for 6*period;
	
	-- simulating bouncing
	 	tbvector("011");
		wait for period/3;
		tbvector("010");
		wait for period/2;
		tbvector("011");
		wait for period/2;
		tbvector("010");
		wait for period/6;	
		tbvector("011");
		wait for period/3;
		tbvector("010");
		wait for period/3;
		tbvector("011");
		wait for period/6;
		tbvector("010");
		wait for 2*period/3;
		-- done bouncing
  
		wait for 4*period;

		-- simulating bouncing
		tbvector("010");
		wait for period/2;
		tbvector("011");
		wait for period/3;
		tbvector("010");
		wait for 2*period/3;
		tbvector("011");
		wait for period/3;		
		tbvector("010");
		wait for period/2;
		tbvector("011");
		wait for period/2;
		tbvector("010");
		wait for period/3;
		tbvector("011");
		wait for 5*period/6;
	-- done bouncing
	
		wait for 5*period;

	-- simulating bouncing
		tbvector("011");
		wait for 2*period/3;
		tbvector("010");
		wait for period/2;
		tbvector("011");
		wait for period/6;
		tbvector("010");
		wait for 2*period/3;		
		tbvector("011");
		wait for period/6;
		tbvector("010");
		wait for 2*period/3;
		tbvector("011");
		wait for period/3;
		tbvector("010");
		wait for period/2;
	-- done bouncing
	
		wait for 2*period;

	-- simulating bouncing
    	tbvector("010");
		wait for period/2;
		tbvector("011");
		wait for period/3;
		tbvector("010");
		wait for 2*period/3;
		tbvector("011");
	
		end_of_sim <= true;
		wait;
	END PROCESS;
END;