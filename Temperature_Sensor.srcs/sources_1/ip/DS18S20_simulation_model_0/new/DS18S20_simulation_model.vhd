----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2020 19:19:41
-- Design Name: 
-- Module Name: DS18S20_simulation_model - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DS18S20_simulation_model is
  port (one_wire_input   : in  std_logic;
         one_wire_output : out std_logic);
end DS18S20_simulation_model;

architecture Behavioral of DS18S20_simulation_model is
-------------------------------------------------------------------------------
-- Components
-------------------------------------------------------------------------------
  component Controller_FSM
    port(
      rst_detect             : in  std_logic;
      skip_ROM_detect        : in  std_logic;
      convert_T_detect       : in  std_logic;
      read_skratchpad_detect : in  std_logic;
      error_byte_detect      : in  std_logic;
      en_atrts               : out std_logic;
      go_convert             : out std_logic;
      go_command_decoder     : out std_logic);
     end component;
     component command_decoder
      port (
            go                            : in  std_logic;
            Skip_ROM_command_detected     : out std_logic;
            Read_Scratch_command_detected : out std_logic;
            Convert_command_detected      : out std_logic;
            error_reading                 : out std_logic;
            one_wire_input                : in  std_logic);
    end component;


  component Answer_to_read_time_slots
    port(
      atrts_en                : in  std_logic;
      atrts_scratchpad_memory : in  std_logic_vector(71 downto 0);
      ow_line_in_atrts        : in  std_logic;
      ow_line_out_atrts       : out std_logic
      );
  end component;

  component Rst_detector
    port(
      ow_line_in_rst  : in  std_logic;
      ow_line_out_rst : out std_logic;
      rst_detected    : out std_logic
      );
  end component;

  component conversion_and_storage
    port (go_convert : in  std_logic;
          scratchpad : out std_logic_vector (71 downto 0));
  end component;

-------------------------------------------------------------------------------
-- Signals
-------------------------------------------------------------------------------
  signal rst_detect_s             : std_logic;
  signal skip_ROM_detect_s        : std_logic;
  signal convert_T_detect_s       : std_logic;
  signal read_scratchpad_detect_s : std_logic;
  signal error_byte_detect_s      : std_logic;
  signal en_atrts_s               : std_logic;
  signal go_convert_s             : std_logic;
  signal go_command_decoder_s     : std_logic;

  signal atrts_en_s                          : std_logic;
  signal scratchpad                          : std_logic_vector(71 downto 0);
  signal one_wire_output_1_s,one_wire_output_2_s, one_wire_input_s : std_logic;


  
begin
-------------------------------------------------------------------------------
-- Instantiation
-------------------------------------------------------------------------------
  FSM : Controller_FSM port map (rst_detect             => rst_detect_s,
                                 skip_ROM_detect        => skip_ROM_detect_s,
                                 convert_T_detect       => convert_T_detect_s,
                                 read_skratchpad_detect => read_scratchpad_detect_s,
                                 error_byte_detect      => error_byte_detect_s,
                                 en_atrts               => en_atrts_s,
                                 go_convert             => go_convert_s,
                                 go_command_decoder     => go_command_decoder_s);


  command_decod : command_decoder port map (go                            => go_command_decoder_s,
                                              Skip_ROM_command_detected     => skip_ROM_detect_s,
                                              Read_Scratch_command_detected => read_scratchpad_detect_s,
                                              Convert_command_detected      => convert_T_detect_s,
                                              error_reading                 => error_byte_detect_s,
                                              one_wire_input                => one_wire_input_s);


  anwser_to_swcratchpad_read : Answer_to_read_time_slots port map (atrts_en                => en_atrts_s,
                                                                   atrts_scratchpad_memory => scratchpad,
                                                                   ow_line_in_atrts        => one_wire_input_s,
                                                                   ow_line_out_atrts       => one_wire_output_1_s);


  initialisation : Rst_detector port map (ow_line_in_rst  => one_wire_input_s,
                                          ow_line_out_rst => one_wire_output_2_s,
                                          rst_detected    => rst_detect_s);

  scratchpad_and_convert : conversion_and_storage port map (go_convert => go_convert_s,
                                                            scratchpad => scratchpad);

-------------------------------------------------------------------------------
-- Combinational logic
-------------------------------------------------------------------------------
  one_wire_input_s <= one_wire_input;
  one_wire_output  <= one_wire_output_1_s and one_wire_output_2_s;
end Behavioral;



