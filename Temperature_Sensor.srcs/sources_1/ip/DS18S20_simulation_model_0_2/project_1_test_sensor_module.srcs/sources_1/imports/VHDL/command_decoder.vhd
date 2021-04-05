----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Luis Manuel Perez  lptelecom92@gmail.com
-- 
-- Create Date: 21.03.2020 22:42:02
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity command_decoder is
  port (go                            : in  std_logic;  
        Skip_ROM_command_detected     : out std_logic;  
        Read_Scratch_command_detected : out std_logic;  
        Convert_command_detected      : out std_logic;  
        error_reading                 : out std_logic;  
        one_wire_input                : in  std_logic);
end command_decoder;

architecture Behavioral of command_decoder is
  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------
  component read_byte_V3
    port (go             : in  std_logic;
          rst            : in  std_logic;
          one_wire_input : in  std_logic;
          clk            : in  std_logic;
          byte_out       : out std_logic_vector (7 downto 0);
          read_done      : out std_logic;
          error_reading  : out std_logic);
  end component;

  component command_comparator
    port (
      go                            : in  std_logic;
      error_in                      : in  std_logic;
      error_out                     : out std_logic;
      Skip_ROM_command_detected     : out std_logic;
      Read_Scratch_command_detected : out std_logic;
      Convert_command_detected      : out std_logic;
      byte_received                 : in  std_logic_vector(7 downto 0));
  end component;


  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------

  signal go_s, go_decode_s               : std_logic;
  signal rst, clk                        : std_logic;
  signal one_wire_input_s                : std_logic;
  signal byte_out_s                      : std_logic_vector (7 downto 0);
  signal read_done_s                     : std_logic;
  signal error_reading_s                 : std_logic;
  signal error_in_s                      : std_logic;
  signal error_out_s                     : std_logic;
  signal Skip_ROM_command_detected_s     : std_logic;
  signal Read_Scratch_command_detected_s : std_logic;
  signal Convert_command_detected_s      : std_logic;
  signal byte_received_s                 : std_logic_vector(7 downto 0);


begin
--------------------------------------
  read_channel : read_byte_V3 port map (go             => go_s,
                                        clk            => clk,
                                        rst            => rst,
                                        one_wire_input => one_wire_input_s,
                                        byte_out       => byte_out_s,
                                        read_done      => go_decode_s,
                                        error_reading  => error_in_s);
  decode_byte_received : command_comparator port map (go                            => go_decode_s,
                                                      error_in                      => error_in_s,
                                                      error_out                     => error_reading_s,
                                                      Skip_ROM_command_detected     => Skip_ROM_command_detected_s,
                                                      Read_Scratch_command_detected => Read_Scratch_command_detected_s,
                                                      Convert_command_detected      => Convert_command_detected_s,
                                                      byte_received                 => byte_out_s);

-------------------------------------------------------------------------------
-- Combinational logic
-------------------------------------------------------------------------------
  go_s                          <= go;
  one_wire_input_s              <= one_wire_input;
  Skip_ROM_command_detected     <= Skip_ROM_command_detected_s;
  Read_Scratch_command_detected <= Read_Scratch_command_detected_s;
  Convert_command_detected      <= Convert_command_detected_s;
  error_reading                 <= error_reading_s;

-------------------------------------------------------------------------------

end Behavioral;
