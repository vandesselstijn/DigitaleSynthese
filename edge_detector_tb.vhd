-------------------------------------------------------------------
-- Project	: edge detector test voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 27/02/2018
-- bestand	: edge_detector_tb.vhd
-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY edge_detector_tb IS
END edge_detector_tb;

ARCHITECTURE structural OF edge_detector_tb IS 

	-- Component Declaration
	COMPONENT edge_detector
		PORT (
      data: in std_logic;
      rst: in std_logic;
      clk:  in std_logic;
      clk_en: in std_logic;
      puls: out std_logic
		);
	END COMPONENT;

	FOR uut : edge_detector USE ENTITY work.edge_detector(behav);
 
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

	--Interne signalen aangegeven _t om duidelijk te maken dat deze niet aanstuurbaar zijn
  SIGNAL data_t: std_logic;
  SIGNAL rst_b_t: std_logic;
  SIGNAL rst_t:std_logic;
  SIGNAL clk_t: std_logic;
  SIGNAL clk_en_t: std_logic;
  SIGNAL puls_t: std_logic;

BEGIN
 rst_t <= not rst_b_t; --Fixen van probleem van actief hoge en lage rst
 
	uut: edge_detector PORT MAP(
 		rst => rst_t,
 		clk => clk_t,
		clk_en => clk_en_t,
    data => data_t,
    puls => puls_t
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
   	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic) IS
	BEGIN
		data_t <= stimvect;
	END tbvector;

	BEGIN
	-- reset
	
	   clk_en_t <= '1';
	   rst_b_t <= '0';
	   wait for 5*period;
	   rst_b_t <= '1';
	
	  tbvector ('0');
		wait for period;
 	  tbvector ('0');
		wait for period;
	  tbvector ('0');
		wait for period;
		tbvector ('0');
		wait for period;
		tbvector ('1');
		wait for period;
 	  tbvector ('1');
		wait for period;
	  tbvector ('0');
		wait for period;
		tbvector ('0');
		wait for period;
		tbvector ('0');
		wait for period;
 	  tbvector ('0');
		wait for period;
	  tbvector ('0');
		wait for period;
		tbvector ('0');
		wait for period;
	  tbvector ('1');
		wait for period;
 	  tbvector ('0');
		wait for period;
	  tbvector ('1');
		wait for period;
		tbvector ('0');
		wait for period;
		tbvector ('0');
		wait for period;
 	  tbvector ('0');
		wait for period;
	  tbvector ('1');
		wait for period;
		tbvector ('1');
		wait for period;
		tbvector ('1');
		wait for period;
 	  tbvector ('0');
		wait for period;
	  tbvector ('0');
		wait for period;
		tbvector ('0');
		wait for period;
		
	
		end_of_sim <= true;
		wait;
	END PROCESS;

END;