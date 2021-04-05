
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity sensor is
end sensor;

architecture Behavioral of sensor is

component Top_structure is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        sel             : in std_logic;
        ow_line_in      : in std_logic;
        ow_line_out     : out std_logic;
        AN              : out std_logic_vector(7 downto 0);
        BCD             : out std_logic_vector(6 downto 0);
        dp              : out std_logic
    );
end component;

component DS18S20_simulation_model_0 IS
  PORT (
    one_wire_input : IN STD_LOGIC;
    one_wire_output : OUT STD_LOGIC
  );
END component;

component Answer_while_convert_T is
    port(
        awct_en                : in std_logic;
        ow_line_in_awct        : in std_logic;
        ow_line_out_awct       : out std_logic
    );
end component;


    signal clk_sig : std_logic:='0';
    signal rst_sig : std_logic:='1';
    signal sel_sig : std_logic:='1';
    signal ow_line_output_sensor : std_logic;
    signal ow_line_input_sensor : std_logic;
    signal AN_sig : std_logic_vector(7 downto 0);
    signal BCD_sig : std_logic_vector(6 downto 0);
    signal dp_sig : std_logic;
    signal ow_line_sig : std_logic;

--signal awct_en : std_logic := '0';
--signal ow_line_in_awct : std_logic := '1';
--signal ow_line_out_awct : std_logic; 

begin

TS : Top_structure port map(
    clk         => clk_sig,
    rst         => rst_sig,
    sel         => sel_sig,
    ow_line_in  => ow_line_output_sensor,
    ow_line_out => ow_line_input_sensor,
    AN          => AN_sig,
    BCD         => BCD_sig,   
    dp          => dp_sig
);

U0 : DS18S20_simulation_model_0 PORT MAP (
    one_wire_input => ow_line_input_sensor,
    one_wire_output => ow_line_output_sensor
);

--AWC : Answer_while_convert_T port map(
--    awct_en => awct_en,
--    ow_line_in_awct => ow_line_in_awct,
--    ow_line_out_awct => ow_line_out_awct
--);



clk_sig <= not clk_sig after 5 ns;
rst_sig <= '0' after 5 ns;
sel_sig <= '1';
ow_line_sig <= ow_line_output_sensor and ow_line_input_sensor;

    

end Behavioral;
