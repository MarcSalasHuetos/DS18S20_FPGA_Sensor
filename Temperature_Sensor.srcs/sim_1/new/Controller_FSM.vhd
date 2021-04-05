-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller_FSM is
    port(
        rst_detect              : in std_logic;
        skip_ROM_detect         : in std_logic;
        convert_T_detect        : in std_logic;
        read_skratchpad_detect  : in std_logic;
        error_byte_detect       : in std_logic;
        en_atrts                : out std_logic;
        go_convert              : out std_logic;
        go_command_decoder      : out std_logic
    );
end Controller_FSM;

architecture Behavioral of Controller_FSM is

    
    
begin

    GENERIC_PROCESS : process
    
    type state_type is(init,waiting,rom_command,read_byte,transit,function_command,convert);
    variable state : state_type := init;
    
    begin
 
        case state is -- output decoder
            when rom_command =>
                go_command_decoder <= '1';
                go_convert <= '0';
                en_atrts <= '0';
            when read_byte =>
                go_command_decoder <= '0';
                go_convert <= '0';
                en_atrts <= '1';
            when transit =>
                go_command_decoder <= '0';
                go_convert <= '0';
                en_atrts <= '0';
                --wait for 10 ns;
            when function_command =>
                go_command_decoder <= '1';
                go_convert <= '0';
                en_atrts <= '0';
            when convert =>
                go_command_decoder <= '0';
                go_convert <= '1';
                en_atrts <= '0';
            when others =>
                go_command_decoder <= '0';
                go_convert <= '0';
                en_atrts <= '0';
        end case;
        
        wait for 10 ns;
        
        case state is -- next state decoder
            when init =>
                if rst_detect = '0' then
                    state := waiting;
                end if;
            when waiting =>
                if rst_detect = '1' then
                    state := rom_command;
                end if;
            when rom_command =>
                if rst_detect = '0' and (error_byte_detect = '1' or read_skratchpad_detect = '1' or convert_T_detect = '1') then
                    state := waiting;
                end if;
                if rst_detect = '0' and skip_ROM_detect = '1' then
                    state := transit;
                end if;
            when transit =>
                state := function_command;
            when function_command => 
                if rst_detect = '0' and (error_byte_detect = '1' or skip_ROM_detect = '1') then
                    state := waiting;
                end if;
                if rst_detect = '1' and (error_byte_detect = '1' or skip_ROM_detect = '1') then
                    state := init;
                end if;
                if rst_detect = '1' then
                    state := rom_command;
                end if;
                if convert_T_detect = '1' then
                    state := convert;
                end if;
                if read_skratchpad_detect = '1' then
                    state := read_byte;
                end if;
            when read_byte =>
                if rst_detect = '1' then
                    state := rom_command;
                end if;
            when convert =>
                if rst_detect = '1' then
                    state := init;
                else
                    state := waiting;
                end if;
            when others =>
                state := init;
        end case;
        
    end process GENERIC_PROCESS;

end Behavioral;
