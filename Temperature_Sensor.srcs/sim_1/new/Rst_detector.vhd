-- Digital Temperature sensor model
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Rst_detector is
    port(
        ow_line_in_rst  : in std_logic;
        ow_line_out_rst : out std_logic;
        rst_detected    : out std_logic
    );
end Rst_detector;

architecture Behavioral of Rst_detector is

begin

    process
        variable successful_rst : std_logic :='0';  -- This variable makes the succession of the facts easier.
    begin
        rst_detected    <= '0';
        ow_line_out_rst <= '1';
        
        wait until ow_line_in_rst'event and ow_line_in_rst = '0'; -- Waiting for the first falling edge.
        
        for c in 1 to 480 loop -- Making sure that the pulse is bigger than 480 us
            wait for 1 us;
            if ow_line_in_rst = '1' then -- If a rising edge bigger than 1 us occurs, get out of the reset detection.
                successful_rst := '1';
                exit;
            else
                successful_rst := '0';
            end if;
        end loop;
        
        if successful_rst = '0' then -- If it's a long enough pulse
            for c in 1 to 480 loop -- Making sure that the pulse is smaller than 960 us
                wait for 1 us;
                if ow_line_in_rst = '1' then -- If a rising edge bigger than 1 us occurs, pass to the next step.
                    successful_rst := '0';
                    exit;
                else
                    successful_rst := '1';
                end if;
            end loop;
        end if;
        
        if successful_rst = '0' then -- Making sure that there is a correct initialization pulse
            for c in 1 to 40 loop
                wait for 1 us;
                if ow_line_in_rst = '0' then 
                    successful_rst := '1'; -- If a rising edge bigger than 1 us occurs, get out of the reset detection.
                    exit;
                else
                    successful_rst := '0';
                end if;
            end loop;
        end if;
        
        if successful_rst = '0' then -- Writting the answer, in that case 100 us
            ow_line_out_rst <= '0';
            wait for 100 us;
            ow_line_out_rst <= '1';
        end if;
        
        if successful_rst = '0' then -- Making sure that the second part of the initialization routine takes minimum 480 us
            for c in 1 to 340 loop
                wait for 1 us;
                if ow_line_in_rst = '0' then
                    successful_rst := '1'; -- If a rising edge bigger than 1 us occurs, get out of the reset detection.
                    exit;
                else
                    successful_rst := '0';
                end if;
            end loop;
        end if;
        
        if successful_rst = '0' then -- A reset has been detected and correctly answered, prepare for a command.
            rst_detected <= '1';
            wait for 10 ns;
            rst_detected <= '0';
        end if;
    end process;

end Behavioral;
