----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Luis Manuel Perez  lptelecom92@gmail.com
-- 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity command_comparator is
  port (
    go       : in std_logic;  --when rising edge trigger the execution of the block
    error_in : in std_logic;

    error_out : out std_logic;  --a positive pulse is generated  when either the command is not recognized or there was an error in the communication

    Skip_ROM_command_detected     : out std_logic;  --a positive pulse is generated when a skip_rom command has been read from the one wire channel
    Read_Scratch_command_detected : out std_logic;  --a positive pulse is generated when a Read_Scratchpad command has been read from the one wire channel
    Convert_command_detected      : out std_logic;  --a positive pulse is generated  when a Convert command has been read from the one wire channel
    byte_received                 : in  std_logic_vector(7 downto 0));  --byte read from the channel
end command_comparator;

architecture Behavioral of command_comparator is


  signal error_out_s                     : std_logic := '0';
  signal Skip_ROM_command_detected_s     : std_logic := '0';
  signal Read_Scratch_command_detected_s : std_logic := '0';
  signal Convert_command_detected_s      : std_logic := '0';
  


  
begin
-- purpose: waits a rising edge in go and then executes the comparison between the byte receivd and the accepted
-- commands, when finish generate a positive 10 ns pulse in the corresponding
-- command detected signal if there is not correspondence or communication
-- error then is the error_out which generates the positive pulse
-- type   : combinational
-- inputs : go,error_in
-- outputs: <[signal names]>
  comparator : process
  variable internal: boolean:=false;
  begin  -- process comparator
 
    wait until ((go'event and go='1')or(error_in'event and error_in = '1'));
    if (error_in = '1') then 
    internal := true;
    else 
    internal := false;
    end if; 
     wait until ((go'event and go='0')or(error_in'event and error_in = '0'));
    if internal= true then              --event because of error
      wait for 10 ns; error_out_s <= '1'; wait for 10 ns; error_out_s <= '0'; internal := false;
    else
      --event because of byte received correctly
      case byte_received is
        when x"CC"  => wait for 10 ns; Skip_ROM_command_detected_s<='1'; wait for 10 ns; Skip_ROM_command_detected_s<='0';  --skip rom detected
        when x"44"  => wait for 10 ns; Convert_command_detected_s      <= '1'; wait for 10 ns; Convert_command_detected_s <= '0';
        when x"BE"  => wait for 10 ns; Read_Scratch_command_detected_s <= '1'; wait for 10 ns; Read_Scratch_command_detected_s <= '0';  --skip rom detected
        when others => wait for 10 ns; error_out_s<= '1'; wait for 10 ns; error_out_s <= '0';
      end case;
      
    end if;

  end process comparator;


 error_out<=    error_out_s;         
 Skip_ROM_command_detected<= Skip_ROM_command_detected_s;
 Read_Scratch_command_detected<= Read_Scratch_command_detected_s ;
 Convert_command_detected<=Convert_command_detected_s;


end Behavioral;
