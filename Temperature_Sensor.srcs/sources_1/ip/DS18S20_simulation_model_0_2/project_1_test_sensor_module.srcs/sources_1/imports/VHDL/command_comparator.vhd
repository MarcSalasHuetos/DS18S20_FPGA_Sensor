----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Luis Manuel Perez  lptelecom92@gmail.com
-- 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity command_comparator is
  port (
    go       : in std_logic;  
    error_in : in std_logic;

    error_out : out std_logic;  

    Skip_ROM_command_detected     : out std_logic;  
    Read_Scratch_command_detected : out std_logic;  
    Convert_command_detected      : out std_logic;  
    byte_received                 : in  std_logic_vector(7 downto 0));  
end command_comparator;

architecture Behavioral of command_comparator is


  signal error_out_s                     : std_logic := '0';
  signal Skip_ROM_command_detected_s     : std_logic := '0';
  signal Read_Scratch_command_detected_s : std_logic := '0';
  signal Convert_command_detected_s      : std_logic := '0';
  


  
begin

  comparator : process
  variable internal: boolean:=false;
  begin  
 
    wait until ((go'event and go='1')or(error_in'event and error_in = '1'));
    if (error_in = '1') then 
    internal := true;
    else 
    internal := false;
    end if; 
     wait until ((go'event and go='0')or(error_in'event and error_in = '0'));
    if internal= true then             
      wait for 10 ns; error_out_s <= '1'; wait for 10 ns; error_out_s <= '0'; internal := false;
    else
   
      case byte_received is
        when x"CC"  => wait for 10 ns; Skip_ROM_command_detected_s<='1'; wait for 10 ns; Skip_ROM_command_detected_s<='0';  
        when x"44"  => wait for 10 ns; Convert_command_detected_s      <= '1'; wait for 10 ns; Convert_command_detected_s <= '0';
        when x"BE"  => wait for 10 ns; Read_Scratch_command_detected_s <= '1'; wait for 10 ns; Read_Scratch_command_detected_s <= '0';  
        when others => wait for 10 ns; error_out_s<= '1'; wait for 10 ns; error_out_s <= '0';
      end case;
      
    end if;

  end process comparator;


 error_out<=    error_out_s;         
 Skip_ROM_command_detected<= Skip_ROM_command_detected_s;
 Read_Scratch_command_detected<= Read_Scratch_command_detected_s ;
 Convert_command_detected<=Convert_command_detected_s;


end Behavioral;
