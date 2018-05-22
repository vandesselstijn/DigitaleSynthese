-------------------------------------------------------------------
-- Project	: dpll semaphore ontvanger Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 24/04/2018
-- bestand	: dpll_semaphore.vhd
-- info: Het juiste semaphore doorgeven als er een puls wordt gegeven
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


--Component beschrijven
entity semaphore is
  port (
        clk: in  std_logic;
        clk_en: in  std_logic;
        rst: in  std_logic;
        extb: in  std_logic;
        chip_sample: in  std_logic;
        seg: in  std_logic_vector(4 downto 0);
        sema: out std_logic_vector(4 downto 0)
     );
END semaphore;


architecture behav of semaphore is

constant seg_c : std_logic_vector(4 DOWNTO 0) := "00100"; --Standaard waarde voor segment C

--State machine beschrijving
type state is (wf_extb, wf_cs);
signal pres_state: state;
signal next_state: state;

begin
    
    --Synchroon gedeelte (reset + door state machine gaan)
    sync_semaphore: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_state <= wf_extb;
            else
                pres_state <= next_state;
            end if;
        end if;
    end process sync_semaphore;

    --Combinatoriche werking statemachine
    comb_semaphore: process(pres_state, extb, chip_sample)
    begin
        if(pres_state = wf_extb and extb = '1') then
            next_state <= wf_cs;
        elsif(pres_state = wf_cs and chip_sample = '1') then
            next_state <= wf_extb;
        else
            next_state <= pres_state;
        end if;
    end process comb_semaphore;

    --Juiste segment op de uitgang zetten afhankelijk van het segment.
    comb_output: process(seg, pres_state)
    begin
        case pres_state is
            when wf_cs =>
                sema <= seg;
            when wf_extb =>
                sema <= seg_c;
        end case;
    end process comb_output;  
    
end behav;
