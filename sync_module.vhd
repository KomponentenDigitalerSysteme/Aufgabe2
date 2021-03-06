
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY sync_module IS
   GENERIC(RSTDEF: std_logic := '1');
   PORT(rst:   IN  std_logic;  -- reset, active RSTDEF
        clk:   IN  std_logic;  -- clock, risign edge
        swrst: IN  std_logic;  -- software reset, active RSTDEF
        BTN0:  IN  std_logic;  -- push button -> load
        BTN1:  IN  std_logic;  -- push button -> dec
        BTN2:  IN  std_logic;  -- push button -> inc
        load:  OUT std_logic;  -- load,      high active
        dec:   OUT std_logic;  -- decrement, high active
        inc:   OUT std_logic); -- increment, high active
END sync_module;

--
-- Im Rahmen der 2. Aufgabe soll hier die Architekturbeschreibung
-- zur Entity sync_module implementiert werden.
--

ARCHITECTURE structure OF sync_module IS
    
    COMPONENT sync_buffer IS
        GENERIC(RSTDEF:  std_logic := '1');
        PORT(rst:    IN  std_logic;  -- reset, RSTDEF active
        clk:    IN  std_logic;  -- clock, rising edge
        en:     IN  std_logic;  -- enable, high active
        swrst:  IN  std_logic;  -- software reset, RSTDEF active
        din:    IN  std_logic;  -- data bit, input
        dout:   OUT std_logic;  -- data bit, output
        redge:  OUT std_logic;  -- rising  edge on din detected
        fedge:  OUT std_logic); -- falling edge on din detected
    END COMPONENT;

    
    constant N: natural := 15;
	 signal cnt: std_logic_vector (N-1 DOWNTO 0);
    signal enable: std_logic;
   

begin
-- Modulo-2**15-Zaehler als Prozess
   process(rst, clk) begin
      if rst = RSTDEF then
         cnt <= (OTHERS => '0');
         enable <= '0';
      elsif rising_edge(clk) then
			enable <= '0';
			if cnt=N-1 then
				enable <= '1';
			end if;
			cnt <= cnt + 1;
      end if;
   end process;
   -- Modulo-2**15-Zaehler als Prozess
   
    
   u0: sync_buffer
   GENERIC MAP(RSTDEF => RSTDEF)
   PORT MAP(rst   => rst,
            clk   => clk,
            swrst => swrst,
            en => enable,
            din => BTN0,
            --dout => load_tmp,
            --fedge => fedge_tmp_load,
            redge => load);
   
   u1: sync_buffer
   GENERIC MAP(RSTDEF => RSTDEF)
   PORT MAP(rst   => rst,
            clk   => clk,
            swrst => swrst,
            en => enable,
            din => BTN1,
            --dout => dec_tmp,
            fedge => dec);
            --redge => redge_tmp_dec
    
   u2: sync_buffer
   GENERIC MAP(RSTDEF => RSTDEF)
   PORT MAP(rst   => rst,
            clk   => clk,
            swrst => swrst,
            en => enable,
            din => BTN2,
            --dout => inc_tmp,
            fedge => inc);
            --redge => redge_tmp_inc
    
    
   --load <= load_tmp when redge_tmp_load = '1' else '0';
   --inc <= '1' when inc_tmp = '0' and fedge_tmp_inc = '1' else '0';
   --dec <= '1' when dec_tmp = '0' and fedge_tmp_dec = '1' else '0';

	--load <= '1' when redge_tmp_load = '1' else '0';
   --inc <= '1' when fedge_tmp_inc = '1' AND BTN2 = '0' else '0';
   --dec <= '1' when fedge_tmp_dec = '1' AND BTN1 = '0' else '0';
   
end;