-------------------------------------------------------------------
-- Project  : datareg voor zender Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date   : 24/04/2018
-- bestand  : datareg_tb.vhd
-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY datareg_tb IS
END datareg_tb;

ARCHITECTURE structural OF datareg_tb IS 

    -- Component Declaration
    COMPONENT datareg
        PORT (
          rst: in std_logic;
          clk: in std_logic;
          clk_en: in std_logic;
          data: in std_logic_vector(3 downto 0);
          load: in std_logic;
          shift: in std_logic;
          sdo_posenc: out std_logic
        );
    END COMPONENT;

    FOR uut : datareg USE ENTITY work.datareg(behav);
 
    CONSTANT period : time := 100 ns;
    CONSTANT delay  : time :=  10 ns;

    SIGNAL end_of_sim : boolean := false;

    --algemene signalen
    SIGNAL rst_t:  std_logic;      --Interne signalen aangegeven _t om duidelijk te maken dat deze niet aanstuurbaar zijn
    SIGNAL clk_t:  std_logic;
    SIGNAL clk_en_t: std_logic;

    --specifieke signalen voor deze component
    SIGNAL data_t: std_logic_vector(3 downto 0);
    SIGNAL load_t: std_logic;
    SIGNAL shift_t: std_logic;
    SIGNAL sdo_posenc_t: std_logic;

BEGIN
    uut: datareg PORT MAP(
        rst => rst_t,
        clk => clk_t,
        clk_en => clk_en_t,
        load => load_t,
        shift => shift_t,
        data => data_t,
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
    -- reset
    clk_en_t <= '1';
    rst_t <= '1';

    wait for 5*period;
    rst_t <= '0';

    data_t <= "0000";
    load_t <= '1';
    wait for period;
    load_t <= '0';
    
    --testloop
    for i in 1 to 30 loop
        shift_t <= '1';
        wait for period;
        shift_t <= '0';
        wait for period;
    end loop;

    end_of_sim <= true;
    wait;

    END PROCESS;
END;