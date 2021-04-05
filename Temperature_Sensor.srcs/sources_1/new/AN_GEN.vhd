--Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity AN_GEN is
    Port ( 
        clk    : in std_logic;
        rst    : in std_logic;
        AN     : out std_logic_vector(7 downto 0)
    );
end AN_GEN;

architecture Behavioral of AN_GEN is

    signal mid : std_logic;
    
    component clk_divider is
        port( 
            rst : in std_logic;
            clk : in std_logic;
            s  : out std_logic
        );
    end component;
    component an_counter is
        port( 
            midsig : in std_logic;
            clk    : in std_logic;
            rst    : in std_logic;
            AN     : out std_logic_vector(7 downto 0)
        );
    end component;
begin
    clk_divider1 : clk_divider port map(
        rst => rst,
        clk => clk,
        s => mid  
    );
    an_counter1 : an_counter port map(
        midsig => mid,
        clk => clk,    
        rst => rst,  
        AN => AN     
    );
end Behavioral;

