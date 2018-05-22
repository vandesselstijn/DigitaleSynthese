-------------------------------------------------------------------
-- Project	: Edge detector voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 27/02/2018
-- bestand	: edge_detector.vhd
-- info:  edge detector voor in de aplication layer. 
--        zal een puls genereren bij het detecteren van een flank
-------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--In en uitgangen component beschrijven
entity edge_detector  is
port (
  data: in std_logic;
  rst: in std_logic;
  clk: in std_logic;
  clk_en: in std_logic;
  puls: out std_logic
  );
end edge_detector;

architecture behav of edge_detector is
  
-- Signalen en states opgeven
  TYPE state IS(wf0,wf1,p1);
  SIGNAL present_state, next_state: state;

begin
  
--Het synchroon prosses beschrijven    
syn_moore: PROCESS(clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF rst = '1' THEN
        present_state <= wf1;
      ELSE
        present_state <= next_state;
    END IF;
  END IF;
END PROCESS syn_moore;
  
--Puls generen wanneer we in state p1 zitten (kan maar 1 priode lang zijn)
com_moore_out: PROCESS(present_state)
  BEGIN
    CASE present_state IS
      WHEN wf0 => puls <= '0';
      WHEN p1 => puls <= '1';
      WHEN wf1 => puls <= '0';
  END CASE;
END PROCESS com_moore_out;
  
--beschrijven state machine met zijn verschillende overgangen
com_moore_next: PROCESS(present_state, data)
  BEGIN
    
        CASE present_state IS 
          WHEN wf1 =>   IF (data = '1') --Wachten op een rising edge
                          THEN next_state <= p1;
                          ELSE next_state <= wf1;
                        END IF;
          WHEN p1  =>   IF (data = '0') --Na het genereren van de puls terug naar wacht toestanden gaan 
                          THEN next_state <= wf1;
                          ELSE next_state <= wf0;
                        END IF;
          WHEN wf0 => IF (data = '1') --Wachten op een falling edge
                        THEN next_state <= wf0;
                        ELSE next_state <= wf1;
                      END IF;
        END CASE;
    
END PROCESS com_moore_next;
                    
end behav;