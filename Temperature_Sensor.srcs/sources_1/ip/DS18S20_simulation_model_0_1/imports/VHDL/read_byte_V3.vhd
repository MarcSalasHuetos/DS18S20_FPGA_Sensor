
---------------------------------------------------------------------------------
-- Company: 
-- Engineer: Luis Manuel Perez  lptelecom92@gmail.com
-- 
-- Create Date: 19.03.2020 19:28:42
-- Design Name: 
-- Module Name: read_byte_V2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity read_byte_V3 is
  port (go             : in  std_logic;
        rst            : in  std_logic;
        clk            : in  std_logic;
        one_wire_input : in  std_logic;
        byte_out       : out std_logic_vector (7 downto 0);
        read_done      : out std_logic;
        error_reading  : out std_logic);
end read_byte_V3;

architecture Behavioral of read_byte_V3 is

  --triggers
  signal trigger_wait_falling_edge, trigger_falling_detection, trigger_measure_low_pulse_duration, trigger_minimum_time_slot_checking, trigger_maximum_time_slot_checking, trigger_next_bit_reading, trigger_byte_count_increase : std_logic           := '0';  -- signals used as triggers to enable next block in the execution loop
  signal delta_t_low_pulse, delta_t_remain1_theoretical, delta_t_remain2_theoretical, t1, t2 , delta_reg                                                                                                                         : signed(11 downto 0) := (others => '0');  -- counter to measure elpased times, in the same order as declared, low pulse duration after the falling edge,time required after the master realeases the channel to reach the minimum time slot(including recovery time)=61us,time required after the previous one to satisfy the maximum time which is 121us, t1 and t2 are the two times to compare the two remaining(or limit) theoretical delays
                                        --
                                        --is

  signal   byte_count                                                                                                                  : std_logic_vector(2 downto 0) := "000";
  signal   byte_register                                                                                                               : std_logic_vector(7 downto 0) := (others => '0');  -- register which stores the data received
                                        --
                                        --
  constant clock_period                                                                                                                : time                         := 10 ns;
  signal   stop_the_clock, break_loop1, break_loop2, break_loop3, error_detected1, error_detected2, error_detected3, read_done_boolean : boolean                      := false;
  --signal   clk                                                                                                      : std_logic;



  signal byte_out_s      : std_logic_vector (7 downto 0) := (others => '0');
  signal read_done_s     : std_logic                     := '0';
  signal error_reading_s : std_logic                     := '0';

  
begin


  main_process : process
    variable step_check             : std_logic := '0';
    variable number_of_bit_received : integer   := 0;
  begin
    step_check := '0';
    -- purpose: querying the enable signal(go) until it goes high 
    wait until (go'event and go = '1');
    --while (go = '0') loop   --stay here
    --wait for 10 ns;
    --end loop; 

    --start of reading the channel
    Byte_read : for c in 0 to 7 loop    --bit loop

      -- purpose: detection of the falling edge in the channel
      --wait until  one_wire_input='0';
      while (one_wire_input = '1') loop
        wait for 100 ns;
      end loop;


      -- purpose: low pulse measurement

      break_loop1       <= false;
      delta_t_low_pulse <= (others => '0');
      wait for 1 ns;
      while one_wire_input = '0' and break_loop1 = false loop
        wait for 100 ns;
        delta_t_low_pulse <= delta_t_low_pulse +1;  --duration in us
        wait for 1 ns;
        if delta_t_low_pulse >= 1200 then
          break_loop1            <= true;
          --delta_t_low_pulse <= delta_t_low_pulse+1;
          step_check             := '1';
          wait for 1 ns;
          --clear number of bits received
          number_of_bit_received := 0;
          
        end if;
        
      end loop;

      --getting the conversion between pulse duration and bit sent
      if delta_t_low_pulse >= 600 and delta_t_low_pulse <= 1200 then
        --zero has been written
        byte_out_s <= '0'& byte_out_s(7 downto 1);
      elsif delta_t_low_pulse >= 10 and delta_t_low_pulse <= 150 then
        --one has been written
        byte_out_s <= '1'& byte_out_s(7 downto 1);
      else
        byte_out_s <= byte_out_s;
      end if;

      wait for 1ns;

-- purpose: check that the channel remains in '1' in order to accomply the minimum time slot
      if(step_check = '0') then
        
        
        delta_t_remain1_theoretical <= 610 - delta_t_low_pulse;
        break_loop2                 <= false;
        t1                          <= (others => '0');
        wait for 1ns;
        while one_wire_input = '1' and break_loop2 = false loop
          wait for 100 ns;
          t1 <= t1+1;
          if t1 >= delta_t_remain1_theoretical then
            break_loop2 <= true;
          end if;
        end loop;
        wait for 1 ns;
        -- t1 <= t1-1;--correction
        wait for 1 ns;
        if(t1 < delta_t_remain1_theoretical) then
          --error time slot less than the minimum
          step_check := '1';

          -- elsif number_of_bit_received<8 then  --minimum time slot check ok, now check the last
        elsif c < 7 then  --minimum time slot check ok, now check all the bits excepto the last
          --bit in the byte, because the last bit in the byte is not maximum_duration_checked 

          --number_of_bit_received := 0;
          --then 
          -- purpose: checks that during the remaining time, the time slot is less than the maximum allowable, 121us(including recovery time)

          --  -get the diffrence delta_t_remain2_theoretical <= 121 - delta_t_low_pulse-t1;


          --delta_t_remain2_theoretical<= delta_reg-t1;
          delta_reg                   <= 1210-delta_t_low_pulse;
          --delta_reg<= x"4BA"+(not(delta_t_low_pulse))+1;  esto funciona es decir resta
          wait for 1 ns;
          delta_t_remain2_theoretical <= delta_reg-t1;
          break_loop3                 <= false;
          wait for 1 ns;
          t2                          <= (others => '0');

          while one_wire_input = '1' and break_loop3 = false loop
            wait for 100 ns;
            t2 <= t2+1;
            wait for 1 ns;
            if t2 > delta_t_remain2_theoretical then
              --maximum time slot exceded, break the loop and finish the reading by
              --error because of timeout
              break_loop3 <= true;

              step_check             := '1';
              --clear number of bits received
              number_of_bit_received := 0;
            end if;
          end loop;
          t2 <= t2+1;
          --else
          --last bit received in the whle byte, no need to check time slot max,
          --finish of the byte reading
          --trigger max time slot duration checking
          --do nothing
          
        end if;
        
        
        
      end if;
      wait for 1 ns;
      if(step_check = '1') then
        exit Byte_read;                 --break for loop
      end if;
      
    end loop Byte_read;

    -- purpose: generate the end of operation of reading or error detection
    --continue with next bit reading
    wait for 1 ns;
    if(step_check = '0') then
      while(one_wire_input = '0') loop
        wait for 10 ns;
      end loop;
      --generate the end of reading
      --number_of_bit_received := 0;
      read_done_s <= '1';
      wait for 10ns;
      read_done_s <= '0';
      
    elsif(step_check = '1') then
      --generate the reading error signal
      number_of_bit_received := 0;
      step_check             := '0';
      error_reading_s        <= '1';
      wait for 10ns;
      error_reading_s        <= '0';
      wait for 1 ns;
    end if;

    wait for 10 ns;
    
    
  end process;






  -------------------------------------------------------------------------------
  -- Combinational 
  -------------------------------------------------------------------------------
  --outputs
  read_done     <= read_done_s;
  error_reading <= error_reading_s;
  byte_out      <= byte_out_s;


  

  
end Behavioral;

