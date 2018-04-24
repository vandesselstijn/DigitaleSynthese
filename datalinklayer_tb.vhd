-------------------------------------------------------------------
-- Project	:  zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 24/04/2018
-- bestand	: datalinklayer_tb.vhd
-- info: TB voor Samenvoegen van de verschilende componenten in de datalink layer. 
-------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY datalinklayer_tb IS
END datalinklayer_tb;

ARCHITECTURE structural OF datalinklayer_tb IS 

	-- Component Declaration
	COMPONENT datalinklayer 
		PORT (
      clk: in std_logic;
      clk_en: in std_logic;
      rst: in std_logic;
      data: in std_logic_vector(3 downto 0);
      pn_start: in std_logic;
      sdo_posenc: out std_logic
    );
	END COMPONENT;

	FOR uut : datalinklayer USE ENTITY work.datalinklayer(structural);
 
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;

	SIGNAL end_of_sim : boolean := false;

  --Interne signalen aangegeven _t om duidelijk te maken dat deze niet aanstuurbaar zijn
  SIGNAL clk_t: std_logic;
  SIGNAL clk_en_t: std_logic;
  SIGNAL rst_t: std_logic;
  SIGNAL data_t: std_logic_vector(3 downto 0) := "0000";
  SIGNAL pn_start_t: std_logic;
  SIGNAL sdo_posenc_t: std_logic;


--Verbinding maken tussen de signalen en de component
BEGIN
	uut: datalinklayer PORT MAP(
	  clk => clk_t,
    clk_en => clk_en_t,
    rst => rst_t,
    data => data_t,
    pn_start => pn_start_t,
    sdo_posenc => sdo_posenc_t
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

	  clk_en_t <= '1';
	  rst_t <= '1';
	  wait for 5*period;
	  rst_t <= '0';

    data_t <= "0001";
    for i in 1 to 15 loop
        pn_start_t <= '1';
        wait for period;
        pn_start_t <= '0';
        wait for period;
    end loop;

    wait for 5*period;

    data_t <= "0101";
    for i in 1 to 15 loop
        pn_start_t <= '1';
        wait for period;
        pn_start_t <= '0';
        wait for period;
    end loop;
    
		end_of_sim <= true;
		wait;
	END PROCESS;
END;