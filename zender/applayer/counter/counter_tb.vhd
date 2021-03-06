-------------------------------------------------------------------
-- Project	: countertest voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 20/02/2018
-- bestand	: counter_tb.vhd
-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY counter_tb IS
END counter_tb;

ARCHITECTURE structural OF counter_tb IS 

	-- Component Declaration
	COMPONENT counter
		PORT (
        rst: in std_logic;
        clk: in std_logic;
        clk_en: in std_logic;
        cnt_up: in std_logic;
        cnt_down: in std_logic;
        cnt_out: out std_logic_vector(3 DOWNTO 0)
		);
	END COMPONENT;

	FOR uut : counter USE ENTITY work.counter(behav);
 
 	-- Klok signalen
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

	-- Interne signalen aangegeven _t om duidelijk te maken dat deze niet aanstuurbaar zijn
	SIGNAL rst_t:  std_logic;      
	SIGNAL clk_t:  std_logic;
	SIGNAL clk_en_t: std_logic;
  	SIGNAL cnt_up_t: std_logic;
  	SIGNAL cnt_down_t: std_logic;
  	SIGNAL cnt_out_t: std_logic_vector(3 DOWNTO 0);

BEGIN

	--Effectieve componetn linken aan tb signalen
	uut: counter PORT MAP(
 		rst => rst_t,
 		clk => clk_t,
		clk_en => clk_en_t,
		cnt_up => cnt_up_t,
		cnt_down => cnt_down_t,
		cnt_out => cnt_out_t
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
	
	--Testverctor met verschillende gecombineerde signalen genereren
	tb : PROCESS
   	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0))IS
	BEGIN
		cnt_up_t <= stimvect(0);
		cnt_down_t <= stimvect(1);
	END tbvector;

	BEGIN

		-- reset
		clk_en_t <= '1';
		rst_t <= '1';
		cnt_up_t <= '0';
		cnt_down_t <= '0';
		wait for 5*period;
		rst_t <= '0';
	
		--Test vector aanleggen
		tbvector ("01");
		wait for period;
		tbvector ("01");
		wait for period;
		tbvector ("01");
		wait for period;
		tbvector ("01");
		wait for period;
		tbvector ("01");
		wait for period;
		tbvector ("01");
		wait for period;
		tbvector ("01");
		wait for period;
		tbvector ("01");
		wait for period;
		tbvector ("01");
		wait for period;
		tbvector ("01");
		wait for period;
	
		end_of_sim <= true;
		wait;
	END PROCESS;

END;