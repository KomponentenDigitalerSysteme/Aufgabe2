
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY sync_buffer IS
   GENERIC(RSTDEF:  std_logic := '1');
   PORT(rst:    IN  std_logic;  -- reset, RSTDEF active
        clk:    IN  std_logic;  -- clock, rising edge
        en:     IN  std_logic;  -- enable, high active
        swrst:  IN  std_logic;  -- software reset, RSTDEF active
        din:    IN  std_logic;  -- data bit, input
        dout:   OUT std_logic;  -- data bit, output
        redge:  OUT std_logic;  -- rising  edge on din detected
        fedge:  OUT std_logic); -- falling edge on din detected
END sync_buffer;

--
-- Im Rahmen der 2. Aufgabe soll hier die Architekturbeschreibung
-- zur Entity sync_buffer implementiert werden.
--
ARCHITECTURE structure OF sync_buffer IS
    
    constant N_hysterese: natural := 32; -- 46???
    
    
    signal clk_hysterese: std_logic;
    signal cnt_hysterese : integer range 0 to N_hysterese - 1;
    signal din_old : std_logic;
BEGIN
 
   process(rst, clk) begin
      if rising_edge(clk) then -- wait until????
			if en = '1' then
				if din = '0' then
					dout <= '1';
				else
					dout <= '0';
				end if;
			end if;
         --if en = '1' then
         --    if din = '0' then -- button pressed
         --        if cnt_hysterese < N_hysterese then
         --            cnt_hysterese <= cnt_hysterese + 1;
         --           fedge <= '0';
         --            redge <= '0';  
         --        else 
         --           dout <= '1';
         --            if din_old = '1' then
         --                fedge <= '1';
         --            end if;
         --            din_old <= din;
                    -- fedge <= falling_edge(din);
                
                     
         --        end if;
         --    else
         --       if cnt_hysterese > 0 then 
         --          cnt_hysterese <= cnt_hysterese - 1; 
         --          fedge <= '0';
         --          redge <= '0';  
         --       else 
         --          dout <= '0';
         --          if din_old = '0' then
         --                redge <= '1';
                         
         --            end if;
         --            din_old <= din;
                   --redge <= rising_edge(din);
         --       end if;  
         --    end if;
         -- end if;
      end if;
   end process;
   
   
   
END;