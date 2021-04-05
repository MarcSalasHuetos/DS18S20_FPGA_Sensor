-- Digital Temperature sensor model
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Answer_while_waiting is
    port(
        aww_en                : in std_logic;
        ow_line_in_aww        : in std_logic;
        ow_line_out_aww       : out std_logic
    );
end Answer_while_waiting;

architecture Behavioral of Answer_while_waiting is
signal ow_line_out_aww_s:std_logic; 
begin

    process
        variable successful_aww : std_logic; -- variable that leads the success of the operation
    begin
        ow_line_out_aww_s   <= '1'; -- initializing variables and outputs
        successful_aww    := '0';
        wait until ow_line_in_aww'event and ow_line_in_aww = '0'; -- wait until the falling edge
        if aww_en = '1' then
            for c in 1 to 10 loop -- ensure that the pulse takes more than 1 us
                wait for 100 ns;
                if ow_line_in_aww = '1' then -- if you receive an incorrect pulse get out of the operation
                    successful_aww := '1';
                    exit;
                else
                    successful_aww := '0';
                end if;
            end loop;
            if successful_aww = '0' and aww_en = '1' then -- once we are sure that we received a correct init pulse write from LSB to MSB all the Bits of the scratchpad memory
                ow_line_out_aww_s <= '0';
                wait for 19 us;
                ow_line_out_aww_s <= '1';
                wait for 41 us;
            end if;
        end if;
    end process;
	ow_line_out_aww<=ow_line_out_aww_s;
end Behavioral;