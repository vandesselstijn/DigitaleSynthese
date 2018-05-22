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
	        pn_start: out std_logic;

	        shdata1_out: out std_logic_vector(4 DOWNTO 0);
        	shdata2_out: out std_logic_vector(4 DOWNTO 0)
		);
	END COMPONENT;

	FOR uut : pngen USE ENTITY work.pngen(behav);
 
 	--Klok signalen
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

	--Interne signalen aangegeven _t om duidelijk te maken dat deze niet aanstuurbaar zijn
	SIGNAL rst_t:  std_logic;      
	SIGNAL clk_t:  std_logic;
	SIGNAL clk_en_t: std_logic;
	
	SIGNAL	pn_ml1_t: std_logic;
	SIGNAL  pn_ml2_t : std_logic;
	SIGNAL  pn_gold_t: std_logic;
	SIGNAL  pn_start_t: std_logic;

	SIGNAL shdata1_t: std_logic_vector(4 DOWNTO 0);
	SIGNAL shdata2_t: std_logic_vector(4 DOWNTO 0);

BEGIN

	--Tb signalen mappen aan effectieve siganlen
	uut: pngen PORT MAP(
		rst => rst_t,
 		clk => clk_t,
		clk_en => clk_en_t,

		pn_ml1 => pn_ml1_t,
	    pn_ml2 => pn_ml2_t,
	    pn_gold=> pn_gold_t,
	    pn_start => pn_start_t,

	    shdata1_out => shdata1_t,
	    shdata2_out => shdata2_t
	);

	--Klok genenreren
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

		wait for 200*period; --Pn gen heeft geen input nodig en wijzigt elke klok cycle

		end_of_sim <= true; --einde simulatie
		wait;
	END PROCESS;

END;
