-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Tue Mar 24 23:42:11 2020
-- Host        : DESKTOP-COH2PDD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/marcs/OneDrive/Escritorio/Codes/vhd/Temperature_Sensor/Temperature_Sensor.srcs/sources_1/ip/DS18S20_simulation_model_0_2/DS18S20_simulation_model_0_stub.vhdl
-- Design      : DS18S20_simulation_model_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DS18S20_simulation_model_0 is
  Port ( 
    one_wire_input : in STD_LOGIC;
    one_wire_output : out STD_LOGIC
  );

end DS18S20_simulation_model_0;

architecture stub of DS18S20_simulation_model_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "one_wire_input,one_wire_output";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "DS18S20_simulation_model,Vivado 2019.2";
begin
end;
