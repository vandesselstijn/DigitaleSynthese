-------------------------------------------------------------------
-- Project  : SegSemaphore voor ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date : 20/05/2018
-- bestand  : dpll_semaphore_tb.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity semaphore_tb is
end semaphore_tb;

architecture structural of semaphore_tb is 

-- Component beschrijving
component semaphore is
    port (
        clk: in  std_logic;
        clk_en: in  std_logic;
        rst: in  std_logic;
        extb: in  std_logic;
        chip_sample: in  std_logic;
        seg: in  std_logic_vector(4 downto 0);
        sema: out std_logic_vector(4 downto 0)
    );
end component;

for uut : semaphore use entity work.semaphore(behav);
 
--Klok Beschrijven
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk_t:  std_logic;
signal clk_en_t:  std_logic;
signal rst_t:  std_logic;

-- Overige Tb signalen
signal seg_t: std_logic_vector(4 downto 0);
signal seg_decode_t: std_logic_vector(3 downto 0);
signal extb_t: std_logic := '0';
signal chip_sample_t: std_logic := '0';
signal sema_t: std_logic_vector(4 downto 0);
signal sema_decode_t: std_logic_vector(3 downto 0);


begin

    --Component aan tb linken
    uut: semaphore port map(
        clk => clk_t,
        rst => rst_t,
        clk_en => clk_en_t,
        extb => extb_t,
        chip_sample => chip_sample_t,
        seg => seg_t,
        sema => sema_t
    );

    --Klok generenen
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

    --Segmenten decoderen zodat een leesbare hex waarde te zien is in de wave
    decode_seg: process(seg_t)
    begin
        case seg_t is
            when "10000" => seg_decode_t <= "1010";
            when "01000" => seg_decode_t <= "1011";
            when "00100" => seg_decode_t <= "1100";
            when "00010" => seg_decode_t <= "1101";
            when others  => seg_decode_t <= "1110";
        end case;
    end process;
    
    --Semaphore decoderen zodat er een leesbare hex waarde te zien is in de wave
    decode_sema: process(sema_t)
    begin
        case sema_t is
            when "10000" => sema_decode_t <= "1010";
            when "01000" => sema_decode_t <= "1011";
            when "00100" => sema_decode_t <= "1100";
            when "00010" => sema_decode_t <= "1101";
            when others  => sema_decode_t <= "1110";
        end case;
    end process;

    tb : process
    begin
        clk_en_t <= '1';        -- Klok aanzetten
        
        rst_t <= '1';           -- Reseten
        wait for 3*period;
        rst_t <= '0';

        seg_t <= "10000";       -- A
        extb_t <= '1';
        wait for 2*period;
        extb_t <= '0';
        wait for 10*period;
        seg_t <= "00001";       -- E
        chip_sample_t <= '1';
        wait for 2*period;
        chip_sample_t <= '0';
        wait for 10*period;
        seg_t <= "01000";       -- B
        extb_t <= '1';
        wait for 2*period;
        extb_t <= '0';
        wait for 10*period;
        seg_t <= "00001";       -- C
        chip_sample_t <= '1';
        wait for 2*period;
        chip_sample_t <= '0';
        wait for 10*period;
        seg_t <= "01000";       -- D
        extb_t <= '1';
        wait for 2*period;
        extb_t <= '0';
        wait for 10*period;
        seg_t <= "10000";       -- A
        extb_t <= '1';
        wait for 2*period;
        extb_t <= '0';
        wait for 8*period;
        seg_t <= "00001";       -- E
        chip_sample_t <= '1';
        wait for 2*period;
        chip_sample_t <= '0';
        wait for 20*period;
        seg_t <= "01000";       -- B
        extb_t <= '1';
        wait for 2*period;
        extb_t <= '0';
        wait for 4*period;
        seg_t <= "00001";       -- C
        chip_sample_t <= '1';
        wait for 2*period;
        chip_sample_t <= '0';
        wait for 10*period;
        seg_t <= "01000";       -- D
        extb_t <= '1';
        wait for 2*period;
        extb_t <= '0';
        wait for 5*period;
                        
        end_of_sim <= true;
        wait;
    end process;
end;