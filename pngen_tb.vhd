-------------------------------------------------------------------
-- Project	: Pngen test voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 27/03/2018
-- bestand	: pngen_tb.vhd
-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY pngen_tb IS
END pngen_tb;

ARCHITECTURE structural OF pngen_tb IS 

	-- Component Declaration
	COMPONENT pngen
		PORT (
			rst: in std_logic;
	        clk: in std_logic;
	        clk_en: in std_logic;

	        pn_ml1: out std_logic;
	        pn_ml2: out std_logic;
	        pn_gold: out std_logic;
	        pn_start: out std_logic
		);
	END COMPONENT;

	FOR uut : pngen USE ENTITY work.pngen(behav);
 
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

	SIGNAL rst_t:  std_logic;      --Interne signalen aangegeven _t om duidelijk te maken dat deze niet aanstuurbaar zijn
	SIGNAL clk_t:  std_logic;
	SIGNAL clk_en_t: std_logic;
	
	SIGNAL	pn_ml1_t: std_logic;
	SIGNAL  pn_ml2_t : std_logic;
	SIGNAL  pn_gold_t: std_logic;
	SIGNAL  pn_start_t: std_logic;

BEGIN

	uut: pngen PORT MAP(
		rst => rst_t,
 		clk => clk_t,
		clk_en => clk_en_t,

		pn_ml1 => pn_ml1_t,
	    pn_ml2 => pn_ml2_t,
	    pn_gold=> pn_gold_t,
	    pn_start => pn_start_t
	);

	clock : PROCESS
	BEGIN 
		clk_t <= '0';
		wait for period/2;
		LOOP
			clk_t <= '0';
			wait for period/2;
			clk_t <= '1';
			wait for period/2;
		EXIT WHEN end_of_sim;
		END LOOP;
		wait;
	END PROCESS clock;
	
	tb : PROCESS

	BEGIN		
		clk_en_t <= '1'; --clk aanzetten

		-- reset
		rst_t <= '1';
		wait for 5*period;
		rst_t <= '0';

		wait for 100*period;

		end_of_sim <= true; --einde simulatie
		wait;
	END PROCESS;

END;
