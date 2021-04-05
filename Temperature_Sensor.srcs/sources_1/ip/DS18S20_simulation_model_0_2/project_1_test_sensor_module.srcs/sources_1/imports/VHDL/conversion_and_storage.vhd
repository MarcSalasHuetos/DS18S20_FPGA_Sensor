----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Luis Manuel Perez  lptelecom92@gmail.com
-- 
-- 
-- Create Date: 22.03.2020 00:18:55
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;



entity conversion_and_storage is
  port (go_convert : in  std_logic;
        scratchpad : out std_logic_vector (71 downto 0));
end conversion_and_storage;

architecture Behavioral of conversion_and_storage is
  signal internal_register   : std_logic_vector(8 downto 0) := "010101010";  
  signal temp                : std_logic_vector(7 downto 0);
  signal sign                : std_logic;
  signal internal_scratchpad : std_logic_vector(71 downto 0);  


begin






  conversion_register : process

  begin  
    wait until go_convert'event and go_convert = '1';
    wait for 750 ms;
    internal_register <= std_logic_vector(unsigned(internal_register)+5);
    
  end process conversion_register;



  process (temp, sign)
  begin
    --internal_scratchpad(7 downto 0) <= current_temp(7 downto 0);
    case sign is
      when '1'    => internal_scratchpad <= (x"FE100CFFFF1045")&(x"FF")&temp;
      when others => internal_scratchpad <= (x"FE100CFFFF1045")&(x"00")&temp;
    end case;
  end process;



  temp <= internal_register(7 downto 0);
  sign <= internal_register(8);

  scratchpad <= internal_scratchpad;
end Behavioral;
