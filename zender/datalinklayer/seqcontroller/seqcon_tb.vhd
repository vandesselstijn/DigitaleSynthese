-------------------------------------------------------------------
-- Project	: sequence controller voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 24/04/2018
-- bestand	: seqcon_tb.vhd
-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY seqcom_tb IS
END seqcom_tb;

ARCHITECTURE structural OF seqcom_tb IS 

	-- Component Declaration
	COMPONENT seqcon
		PORT (
			rst: in std_logic;
			clk: in std_logic;
			clk_en: in std_logic;

			pn_start: in std_logic;
			load: out std_logic;
			shift: out std_logic
		);
	END COMPONENT;

	FOR uut : seqcon USE ENTITY work.seqcon(behav);
 
 	--Klok signalen
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

	--algemene signalen
	SIGNAL rst_t:  std_logic;      --Interne signalen aangegeven _t om duidelijk te maken dat deze niet aanstuurbaar zijn
	SIGNAL clk_t:  std_logic;
	SIGNAL clk_en_t: std_logic;

	--specifieke signalen voor deze component
	SIGNAL pn_start_t: std_logic;
	SIGNAL load_t: std_logic;
	SIGNAL shift_t: std_logic;

BEGIN

	--Tb signalen mappen aan efectieve in en uitgangen
	uut: seqcon PORT MAP(
 		rst => rst_t,
 		clk => clk_t,
		clk_en => clk_en_t,
		pn_start => pn_start_t,
		load => load_t,
		shift => shift_t
	);

	--Klok genereren
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
	-- reset
	
	clk_en_t <= '1';
	rst_t <= '1';

	wait for 4*period;
	rst_t <= '0';
	
	--testloop
	for i in 1 to 30 loop
	pn_start_t <= '1';
	wait for period;
	pn_start_t <= '0';
	wait for period;
	end loop;
	
	end_of_sim <= true;
	wait;

	END PROCESS;
END;