-------------------------------------------------------------------
-- Project  : Transmittion segment decoder voor ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date : 20/05/2018
-- bestand  : dpll_transsegdecoder_tb.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity transsegdecoder_tb is
end transsegdecoder_tb;

architecture structural of transsegdecoder_tb is 

-- Component declareren
component transSegDecoder is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        seg: out std_logic_vector(4 downto 0);
        extb: in std_logic 
    );
end component;

for uut : transsegdecoder use entity work.transsegdecoder(behav);

--Klok signalen
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk_t:  std_logic; -- _t voor tb signalen
signal clk_en_t:  std_logic;
signal rst_t:  std_logic;

-- Signals here
signal extb_t: std_logic := '0';
signal seg_t: std_logic_vector(4 downto 0);
signal seg_decode_t: std_logic_vector(3 downto 0);

begin

    --Tb signalen linken
    uut: transsegdecoder port map(
        clk => clk_t,
        rst => rst_t,
        clk_en => clk_en_t,
        seg => seg_t,
        extb => extb_t        
    );

    --Klok genereren
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

    --Omzetten naar van de verschillende codes naar leesbaar hex formaat
    decode: process(seg_t)
    begin
        case seg_t is
            when "10000" => seg_decode_t <= "1010"; --A
            when "01000" => seg_decode_t <= "1011"; --B
            when "00100" => seg_decode_t <= "1100"; --C
            when "00010" => seg_decode_t <= "1101"; --D
            when others  => seg_decode_t <= "1111"; --E
        end case;
    end process;

    tb : process
    begin
        clk_en_t <= '1'; --clok aanzetten
        
        rst_t <= '1'; -- resetten
        wait for 3*period;
        rst_t <= '0';

        extb_t <= '1'; -- lang wachten op puls
        wait for 2*period;
        extb_t <= '0';
        wait for 20*period;
        extb_t <= '1'; --  kort wachten op puls
        wait for 2*period;
        extb_t <= '0';
        wait for 7*period;
        extb_t <= '1'; -- zeer kort wachten op puls
        wait for 2*period;
        extb_t <= '0';
        wait for 2*period;
        extb_t <= '1'; -- lang wachten op puls
        wait for 2*period;
        extb_t <= '0';
        wait for 12*period;
        extb_t <= '1'; -- lang wachten op puls
        wait for 2*period;
        extb_t <= '0';
        wait for 9*period;

                        
        end_of_sim <= true;
        wait;
    end process;
end;