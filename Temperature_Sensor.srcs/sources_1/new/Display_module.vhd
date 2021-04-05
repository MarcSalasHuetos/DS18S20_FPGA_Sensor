--Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;
entity display_module is
    Port ( 
        rst         : in std_logic;
        clk         : in std_logic;
        F0          : in std_logic_vector(3 downto 0);
        F1          : in std_logic_vector(3 downto 0);
        F2          : in std_logic_vector(3 downto 0);
        F3          : in std_logic_vector(3 downto 0);
        F4          : in std_logic_vector(3 downto 0);
        F5          : in std_logic_vector(3 downto 0);
        F6          : in std_logic_vector(3 downto 0);
        F7          : in std_logic_vector(3 downto 0);
        dp_vector   : in std_logic_vector(7 downto 0);
        AN          : out std_logic_vector(7 downto 0);
        BCD         : out std_logic_vector(6 downto 0);
        dp          : out std_logic 
    );
end display_module;

architecture Behavioral of display_module is

component data_control is
    Port ( 
        F0          : in std_logic_vector(3 downto 0);
        F1          : in std_logic_vector(3 downto 0);
        F2          : in std_logic_vector(3 downto 0);
        F3          : in std_logic_vector(3 downto 0);
        F4          : in std_logic_vector(3 downto 0);
        F5          : in std_logic_vector(3 downto 0);
        F6          : in std_logic_vector(3 downto 0);
        F7          : in std_logic_vector(3 downto 0);
        dp_vector   : in std_logic_vector(7 downto 0);
        AN          : in std_logic_vector(7 downto 0);
        data        : out std_logic_vector(3 downto 0);
        dp_int      : out std_logic
    );
end component;
component AN_GEN is
    Port ( 
        clk    : in std_logic;
        rst    : in std_logic;
        AN     : out std_logic_vector(7 downto 0)
    );
end component;
component BCD2SS is
    Port ( 
        data   : in std_logic_vector(3 downto 0);
        dp_int : in std_logic;
        BCD    : out std_logic_vector(6 downto 0);
        dp     : out std_logic 
    );
end component;
    
    signal AN_sig : std_logic_vector(7 downto 0); 
    signal data_sig : std_logic_vector(3 downto 0);
    signal dp_sig : std_logic;
    
begin

    AN <= AN_sig;
    d_co : data_control port map(
        F0 => F0,
        F1 => F1,
        F2 => F2,
        F3 => F3,
        F4 => F4,
        F5 => F5,
        F6 => F6,
        F7 => F7,
        dp_vector => dp_vector,
        AN => AN_sig,
        data => data_sig,     
        dp_int => dp_sig   
    );
    A_ge : AN_GEN port map(
        clk => clk,
        rst => rst,
        AN => AN_sig
    );
    de : BCD2SS port map(
        data => data_sig,
        dp_int => dp_sig,
        BCD => BCD,
        dp => dp
    );
end Behavioral;