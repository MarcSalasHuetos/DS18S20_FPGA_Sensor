-- Digital Temperature sensor model
-- Design created by : Marc Salas Huetos    markytuss@gmail.com
library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Answer_to_read_time_slots is
  port(
    atrts_en                : in  std_logic;
    atrts_scratchpad_memory : in  std_logic_vector(71 downto 0);
    ow_line_in_atrts        : in  std_logic;
    ow_line_out_atrts       : out std_logic
    );
end Answer_to_read_time_slots;

architecture Behavioral of Answer_to_read_time_slots is
begin

  process
    variable successful_atrts : std_logic;  -- variable that leads the success of the operation
    variable edge_flag        : std_logic;  -- rising edge flag detector variable
  begin
    ow_line_out_atrts <= '1';           -- initializing variables and outputs
    successful_atrts  := '0';
    edge_flag         := '0';

    wait until atrts_en = '1';  -- wait until the enable of the operation
    wait until ow_line_in_atrts'event and ow_line_in_atrts = '0';  -- wait until the first falling edge
    for i in 0 to 71 loop               -- loop to write the 9 bytes
      for c in 1 to 10 loop     -- ensure that the pulse takes more than 1 us
        wait for 100 ns;
        if ow_line_in_atrts = '1' then  -- if you receive an incorrect pulse get out of the operation
          successful_atrts := '1';
          exit;
        else
          successful_atrts := '0';
        end if;
      end loop;

      if successful_atrts = '0' then  -- once we are sure that we received a correct init pulse write from LSB to MSB all the Bits of the scratchpad memory
        if atrts_scratchpad_memory(i) = '1' then  -- if the bit i is a '1'
          for c in 1 to 120 loop  -- just wait for the minimum of 60 us of the read time slot and the 1 us between read slots
            wait for 500 ns;
            if ow_line_in_atrts = '1' then  -- if we detect a falling edge between the first 61 us, get out of the operation
              edge_flag := '1';
              wait for 1 ns;
            end if;
            if edge_flag = '1' then
              if ow_line_in_atrts = '0' then
                successful_atrts := '1';
                exit;
              end if;
            end if;
          end loop;
          edge_flag := '0';             -- reset variable
        else                            -- if the bit i is a '0'
          exit when atrts_en = '0';     -- doing the routine of a '0' for 20 us
          ow_line_out_atrts <= '0';
          wait for 19 us;
          ow_line_out_atrts <= '1';
          for c in 1 to 82 loop  -- if we detect a falling edge between the next 41 us, get out of the operation
            wait for 500 ns;
            if ow_line_in_atrts = '1' then
              edge_flag := '1';
              wait for 1 ns;
            end if;
            if edge_flag = '1' then
              if ow_line_in_atrts = '0' then
                successful_atrts := '1';
                exit;
              end if;
            end if;
          end loop;
          edge_flag := '0';             -- reset variable
        end if;
      end if;
      if successful_atrts = '0' then
        for c in 1 to 600 loop  -- the maximum time for a read time slot is 120 us, if we pass that limit, get out of the operation
          wait for 100 ns;
          if ow_line_in_atrts = '0' then
            successful_atrts := '0';
            exit;
          else
            successful_atrts := '1';
          end if;
        end loop;
      end if;

      exit when successful_atrts = '1' or atrts_en = '0';  -- if the operation is externally or internally disabled.
    end loop;
    wait until atrts_en = '0';
  end process;
end Behavioral;
