-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Tue Mar 24 23:42:11 2020
-- Host        : DESKTOP-COH2PDD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/marcs/OneDrive/Escritorio/Codes/vhd/Temperature_Sensor/Temperature_Sensor.srcs/sources_1/ip/DS18S20_simulation_model_0_2/DS18S20_simulation_model_0_sim_netlist.vhdl
-- Design      : DS18S20_simulation_model_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity DS18S20_simulation_model_0 is
  port (
    one_wire_input : in STD_LOGIC;
    one_wire_output : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of DS18S20_simulation_model_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of DS18S20_simulation_model_0 : entity is "DS18S20_simulation_model_0,DS18S20_simulation_model,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of DS18S20_simulation_model_0 : entity is "yes";
  attribute ip_definition_source : string;
  attribute ip_definition_source of DS18S20_simulation_model_0 : entity is "package_project";
  attribute x_core_info : string;
  attribute x_core_info of DS18S20_simulation_model_0 : entity is "DS18S20_simulation_model,Vivado 2019.2";
end DS18S20_simulation_model_0;

architecture STRUCTURE of DS18S20_simulation_model_0 is
  component DS18S20_simulation_model_0_DS18S20_simulation_model is
  port (
    one_wire_input : in STD_LOGIC;
    one_wire_output : out STD_LOGIC
  );
  end component DS18S20_simulation_model_0_DS18S20_simulation_model;
begin
U0: component DS18S20_simulation_model_0_DS18S20_simulation_model
     port map (
      one_wire_input => one_wire_input,
      one_wire_output => one_wire_output
    );
end STRUCTURE;
