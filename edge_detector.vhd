-------------------------------------------------------------------
-- Project	: Edge detector voor zender Digitale Synthese
-- Author	: Stijn Van Dessel - campus De Nayer
-- Begin Date	: 27/02/2018
-- bestand	: edge_detector.vhd
-- info: edge detector voor in de aplication layer. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity edge_detector  is
port (
  data: in std_logic;
  rst_b: in std_logic;
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
  
syn_moore: PROCESS(clk)
  BEGIN
    IF rising_edge(clk)
      THEN present_state <= next_state;
  END IF;
END PROCESS syn_moore;
  
com_moore_out: PROCESS(present_state)
  BEGIN
    CASE present_state IS
      WHEN wf0 => puls <= '0';
      WHEN p1 => puls <= '1';
      WHEN wf1 => puls <= '0';
  END CASE;
END PROCESS com_moore_out;
  
com_moore_next: PROCESS(present_state, data, rst_b)
  BEGIN
    IF rst_b = '0'
      THEN next_state <= wf1;
      ELSE
        CASE present_state IS 
          WHEN wf1 => IF (data = '1')
                        THEN next_state <= p1;
                        ELSE next_state <= wf1;
                      END IF;
          WHEN p1  => next_state <= wf0;
          WHEN wf0 => IF (data = '1')
                        THEN next_state <= p1;
                        ELSE next_state <= wf1;
                      END IF;
        END CASE;
    END IF;
END PROCESS com_moore_next;
                    
end behav;