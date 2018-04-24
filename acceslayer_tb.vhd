-------------------------------------------------------------------
-- Project	:  zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 21/03/2018
-- bestand	: acceslayer_tb.vhd
-- info: TB voor Samenvoegen van de verschilende componenten in de application layer. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

ENTITY acceslayer_tb IS
END acceslayer_tb;

architecture structural of acceslayer_tb is 

component acceslayer is
    port (
    clk: in std_logic;
    clk_en: in std_logic;
    rst: in std_logic;
    sdo_posenc: in std_logic;
    sel: in std_logic_vector(1 downto 0);
    pn_start: out std_logic;
    sdo_spread: out std_logic
    );
end component;

for uut : acceslayer use entity work.acceslayer(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

-- algemen klok en reset signalen

signal clk_t:  std_logic;
signal clk_en_t:  std_logic;
signal rst_t:  std_logic;

--specifieke signalen 

signal sdo_posenc_t: std_logic;
signal sel_t: std_logic_vector(1 downto 0);
signal pn_start_t: std_logic;
signal sdo_spread_t: std_logic;

begin
    uut: acceslayer port map(
        clk => clk_t,
        rst => rst_t,
        clk_en => clk_en_t,

        sdo_posenc => sdo_posenc_t,
        sel => sel_t,
        pn_start => pn_start_t,
        sdo_spread => sdo_spread_t
    );

    clock : process
    begin 
        clk_t <= '0';
        wait for period/2;
        loop
            clk_t <= '0';
            wait for period/2;
            clk_t <= '1';
            wait for period/2;
            exit when end_of_sim;
        end loop;
        wait;
    end process clock;

  tb : process
    begin

    	--resetten
        clk_en_t <= '1';       
        rst_t <= '1';
        wait for 5*period;
        rst_t <= '0';

        sel_t <= "00";
        sdo_posenc_t <= '1';
        wait for 32*period;
        sdo_posenc_t <= '0';
        wait for 32*period; 

        sel_t <= "01";
        sdo_posenc_t <= '1';
        wait for 32*period;
        sdo_posenc_t <= '0';
        wait for 32*period; 

        sel_t <= "10";
        sdo_posenc_t <= '1';
        wait for 32*period;
        sdo_posenc_t <= '0';
        wait for 32*period; 

        sel_t <= "11";
        sdo_posenc_t <= '1';
        wait for 32*period;
        sdo_posenc_t <= '0';
        wait for 32*period; 

                        
        end_of_sim <= true;
        wait;
    end process;
end;