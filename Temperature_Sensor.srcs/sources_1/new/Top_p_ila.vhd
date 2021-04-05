
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity Top_p_ila is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        sel             : in std_logic;
        ow_line_in      : in std_logic;
        ow_line_out     : out std_logic;
        --st              : out std_logic_vector(3 downto 0);
        --temperature     : out std_logic_vector(7 downto 0);
        AN              : out std_logic_vector(7 downto 0);
        BCD             : out std_logic_vector(6 downto 0);
        dp              : out std_logic
    );
end Top_p_ila;

architecture Behavioral of Top_p_ila is

component Top_structure is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        sel             : in std_logic;
        ow_line_in      : in std_logic;
        ow_line_out     : out std_logic;
        --st              : out std_logic_vector(3 downto 0);
        --temperature     : out std_logic_vector(7 downto 0);
        AN              : out std_logic_vector(7 downto 0);
        BCD             : out std_logic_vector(6 downto 0);
        dp              : out std_logic
    );
end component;

COMPONENT ila_0

    PORT (
        clk : IN STD_LOGIC;
    
    
    
        probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
    );
    END COMPONENT  ;
    
    component IBUF
    port(
        I: in STD_LOGIC; 
        O: out STD_LOGIC
    );
    end component;
    
    signal ibuf_out : std_logic;
    signal ow_line_in_sig : std_logic;

begin

    ow_line_in_sig <= ow_line_in;

    TS : Top_structure port map(
        clk => clk,
        rst => rst,        
        sel => sel, 
        ow_line_in => ibuf_out,   
        ow_line_out => ow_line_out,
        AN => AN,             
        BCD => BCD,           
        dp => dp          
    );

    
    your_instance_name : ila_0
    PORT MAP (
        clk => clk,
    
    
    
        probe0(0) => ibuf_out
    );

    U1: IBUF port map (
    I => ow_line_in_sig,
    O => ibuf_out
    );

end Behavioral;
