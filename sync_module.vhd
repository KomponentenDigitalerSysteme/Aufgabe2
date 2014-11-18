
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

    
    constant N: natural := 2**15;
    signal cnt: integer range 0 to N-1;
    signal enable: std_logic;
    
    signal inc_tmp: std_logic;
    signal dec_tmp: std_logic;
    signal load_tmp: std_logic;
    
    signal fedge_tmp_load :std_logic;
    signal redge_tmp_load :std_logic;
    
    signal fedge_tmp_inc :std_logic;
    signal redge_tmp_inc :std_logic;
    
    signal fedge_tmp_dec :std_logic;
    signal redge_tmp_dec :std_logic;

begin
   -- Modulo-2**15-Zaehler als Prozess
   process(rst, clk) begin
      if rst = RSTDEF then
         cnt <= 0;
         enable <= '0';
      elsif rising_edge(clk) then
         enable <= '0';
            if cnt=N-1 then
               enable <= '1';
               cnt <= 0;
            else
               cnt <= cnt +1;
            end if;
      end if;
   end process;
    
   u0: sync_buffer
   GENERIC MAP(RSTDEF => RSTDEF)
   PORT MAP(rst   => rst,
            clk   => clk,
            swrst => swrst,
            en => enable,
            din => BTN0,
            dout => load_tmp,
            fedge => fedge_tmp_load,
            redge => redge_tmp_load);
   
   u1: sync_buffer
   GENERIC MAP(RSTDEF => RSTDEF)
   PORT MAP(rst   => rst,
            clk   => clk,
            swrst => swrst,
            en => enable,
            din => BTN1,
            dout => dec_tmp,
            fedge => fedge_tmp_dec,
            redge => redge_tmp_dec);
    
   u2: sync_buffer
   GENERIC MAP(RSTDEF => RSTDEF)
   PORT MAP(rst   => rst,
            clk   => clk,
            swrst => swrst,
            en => enable,
            din => BTN2,
            dout => inc_tmp,
            fedge => fedge_tmp_inc,
            redge => redge_tmp_inc);
    
    
   load <= BTN0;--load_tmp when load_tmp = '0';-- and fedge_tmp_load = '1' else '0';
   inc <= BTN2;--inc_tmp when inc_tmp = '0';-- and redge_tmp_inc = '1' else '0';
   dec <= BTN1;--dec_tmp when dec_tmp = '0';-- and redge_tmp_dec = '1'else '0';

   
end;