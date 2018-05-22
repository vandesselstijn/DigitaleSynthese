-------------------------------------------------------------------
-- Project	:  zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 21/03/2018
-- bestand	: applicationlayer_tb.vhd
-- info: TB voor Samenvoegen van de verschilende componenten in de application layer. 
-------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY applayer_tb IS
END applayer_tb;

ARCHITECTURE structural OF applayer_tb IS 

	-- Component Declaration
	COMPONENT applayer 
		PORT (
      clk: in std_logic;
      clk_en: in std_logic;
      rst: in std_logic;
      up: in std_logic;
      down: in std_logic;
  
      seg_out: out std_logic_vector(6 DOWNTO 0);
      cnt_out: out std_logic_vector(3 DOWNTO 0)
    );
	END COMPONENT;

	FOR uut : applayer USE ENTITY work.applayer(structural);
 
  --Klok signalen beschrijven
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

  --Interne signalen aangegeven _t om duidelijk te maken dat deze niet aanstuurbaar zijn
  SIGNAL clk_t: std_logic;
  SIGNAL clk_en_t: std_logic;
  SIGNAL rst_t: std_logic;
  SIGNAL up_t: std_logic;
  SIGNAL down_t: std_logic;
  
  SIGNAL seg_out_t: std_logic_vector(6 DOWNTO 0);
  SIGNAL cnt_out_t: std_logic_vector(3 DOWNTO 0);


--Verbinding maken tussen de signalen en de component
BEGIN
	uut: applayer PORT MAP(
	  clk => clk_t,
    clk_en => clk_en_t,
    rst => rst_t,
    up => up_t,
    down => down_t,
    seg_out => seg_out_t,
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
	
	
	tb : PROCESS
	BEGIN

    --Resetten
    up_t <= '0';
    down_t <= '0';
	  clk_en_t <= '1';
	  rst_t <= '1';
	  wait for 5*period;
	  rst_t <= '0';

    --Input genereren om zo corecte werking vd laag te chekken
    up_t <= '0';
    wait for 100 ns;
    up_t <= '1';
    wait for 100 ns;
    up_t <= '0';
    wait for 100 ns;
    up_t <= '1';
    wait for 100 ns;
    up_t <= '0';
    wait for 600 ns;
    up_t <= '1';
    wait for 600 ns;
    up_t <= '0';
    wait for 600 ns;
    up_t <= '1';
    wait for 600 ns;
    up_t <= '0';
    wait for 600 ns;
    up_t <= '1';
    wait for 600 ns;
    up_t <= '0';
    wait for 600 ns;
    up_t <= '1';
    wait for 600 ns;
    down_t <= '0';
    wait for 600 ns;
    down_t <= '1';
    wait for 600 ns;
    down_t <= '0';
    wait for 600 ns;
    down_t <= '1';
    wait for 600 ns;       
	  down_t <= '0';
    wait for 600 ns;
    down_t <= '1';
    wait for 600 ns;
    
    
		end_of_sim <= true;
		wait;
	END PROCESS;
END;