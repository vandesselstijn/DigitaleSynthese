-------------------------------------------------------------------
-- Project  : Trans detector voor DPLL ontvanger Digitale Synthese
-- Author   : Stijn Van Dessel - campus De Nayer
-- Begin Date : 27/04/2018
-- bestand  : dpllS_tansdetect.vhd
-- info:    trans detector voor in de acces layer(DPLL).
--          het detecteren van edges op de sdio spread
-------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity transdetect is
    port (
      data: in std_logic;
      rst: in std_logic;
      clk: in std_logic;
      clk_en: in std_logic;
      puls: out std_logic
    );
end transdetect;

architecture behav of transdetect is
    --signals
    type state is (wf1, p1, wf0, p0);
    signal pres_state, next_state: state;

begin
    
    sync_transdetect: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_state <= wf1; --Reset
            else
                pres_state <= next_state;
            end if;
        end if;
    end process sync_transdetect;

    com_transDetect: process(pres_state, data)
    begin
        case pres_state is
            when wf1 => 
                puls <= '0';
                if(data = '1') then -- Wachten op rising edge
                    next_state <= p1;
                else
                    next_state <= wf1;
                end if;
            
            when p1 =>
                puls <= '1'; --Rising edge
                next_state <= wf0;

            when wf0 =>
                puls <= '0';
                if(data = '0') then --Wachten op faling edge
                    next_state <= p0;
                else
                    next_state <= wf0;
                end if;

            when p0 =>
                puls <= '1'; --Falling edge
                next_state <= wf1;

            when others =>
                puls <= '0'; --Latch vermijden
                next_state <= wf1;
        end case;
    end process;
end behav;