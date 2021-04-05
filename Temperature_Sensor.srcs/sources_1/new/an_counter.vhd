--Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity an_counter is
    Port ( 
        midsig : in std_logic;
        clk    : in std_logic;
        rst    : in std_logic;
        AN     : out std_logic_vector(7 downto 0)
    );
end an_counter;

architecture Behavioral of an_counter is

    TYPE State_type IS (S0,S1,S2,S3,S4,S5,S6,S7);
    signal state, next_state : state_type;
    
begin

SYNC_PROCESS : process (clk, rst)
  begin
    if rst = '1' then                
      state <= S0;
    elsif clk'event and clk = '1' then  
      state <= next_state;
    end if;
  end process SYNC_PROCESS;

  OUTPUT_DECODE : process (state)
  begin  
    case state is
      when S0 =>
        AN <= "11111110";
      when S1 =>
        AN <= "11111101";
      when S2 =>
        AN <= "11111011";
      when S3 =>
        AN <= "11110111";
      when S4 =>
        AN <= "11101111";
      when S5 =>
        AN <= "11011111";
      when S6 =>
        AN <= "10111111";
      when S7 =>
        AN <= "01111111";
      when others =>
        AN <= "11111111";
    end case;
  end process OUTPUT_DECODE;


  NEXT_STATE_DECODE : process (state, midsig)
  begin
    --next_state <= S0;
    case state is
      when S0 =>
        if midsig = '1' then
          next_state <= S1;
        else
          next_state <= S0;
        end if;
      when S1 =>
        if midsig = '1' then
          next_state <= S2;
        else
          next_state <= S1;
        end if;
      when S2 =>
        if midsig = '1' then
          next_state <= S3;
        else
          next_state <= S2;
        end if;
      when S3 =>
        if midsig = '1' then
          next_state <= S4;
        else
          next_state <= S3;
        end if;
      when S4 =>
        if midsig = '1' then
          next_state <= S5;
        else
          next_state <= S4;
        end if;
      when S5 =>
        if midsig = '1' then
          next_state <= S6;
        else
          next_state <= S5;
        end if;
      when S6 =>
        if midsig = '1' then
          next_state <= S7;
        else
          next_state <= S6;
        end if;
      when S7 =>
        if midsig = '1' then
          next_state <= S0;
        else
          next_state <= S7;
        end if;
      when others =>
        next_state <= S0;
    end case;
  end process NEXT_STATE_DECODE;


end Behavioral;
