----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Luis Manuel Perez  lptelecom92@gmail.com
-- 
-- 
-- Create Date: 22.03.2020 00:18:55
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conversion_and_storage is
  port (go_convert : in  std_logic;
        scratchpad : out std_logic_vector (71 downto 0));
end conversion_and_storage;

architecture Behavioral of conversion_and_storage is
  signal internal_register   : std_logic_vector(8 downto 0) := "010101010";  -- current temperature data initialzed AAh
  signal temp                : std_logic_vector(7 downto 0);
  signal sign                : std_logic;
  signal internal_scratchpad : std_logic_vector(71 downto 0);  -- register with the data of the scratchpad, the intial vvalue of temperature is 00AA, which corresponds to +85 degrees

  --signal internal_scratchpad : std_logic_vector(71 downto 0) := x"FE100CFFFF104500AA";  -- register with the data of the scratchpad, the intial vvalue of temperature is 00AA, which corresponds to +85 degrees
begin





-- purpose: when rising edge in go_convert detected, starts the conversion, 750ms later the new temperature value is ready, the new temperature value is assumed to be 5 units greater then the previous one
-- type   : combinational
-- inputs : 
-- outputs: 
  conversion_register : process

  begin  -- process conversion_register
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
