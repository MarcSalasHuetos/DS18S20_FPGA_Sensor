-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity CorF_MUX is
    port(
        sel         : in std_logic_vector(1 downto 0);
        F0C         : in std_logic_vector(3 downto 0);
        F1C         : in std_logic_vector(3 downto 0);
        F2C         : in std_logic_vector(3 downto 0);
        F3C         : in std_logic_vector(3 downto 0);
        F4C         : in std_logic_vector(3 downto 0);
        F5C         : in std_logic_vector(3 downto 0);
        F6C         : in std_logic_vector(3 downto 0);
        F7C         : in std_logic_vector(3 downto 0);
        dp_vectorC  : in std_logic_vector(7 downto 0);
        F0F         : in std_logic_vector(3 downto 0);
        F1F         : in std_logic_vector(3 downto 0);
        F2F         : in std_logic_vector(3 downto 0);
        F3F         : in std_logic_vector(3 downto 0);
        F4F         : in std_logic_vector(3 downto 0);
        F5F         : in std_logic_vector(3 downto 0);
        F6F         : in std_logic_vector(3 downto 0);
        F7F         : in std_logic_vector(3 downto 0);
        dp_vectorF  : in std_logic_vector(7 downto 0);
        F0P         : in std_logic_vector(3 downto 0);
        F1P         : in std_logic_vector(3 downto 0);
        F2P         : in std_logic_vector(3 downto 0);
        F3P         : in std_logic_vector(3 downto 0);
        F4P         : in std_logic_vector(3 downto 0);
        F5P         : in std_logic_vector(3 downto 0);
        F6P         : in std_logic_vector(3 downto 0);
        F7P         : in std_logic_vector(3 downto 0);
        dp_vectorP  : in std_logic_vector(7 downto 0);
        F0          : out std_logic_vector(3 downto 0);
        F1          : out std_logic_vector(3 downto 0);
        F2          : out std_logic_vector(3 downto 0);
        F3          : out std_logic_vector(3 downto 0);
        F4          : out std_logic_vector(3 downto 0);
        F5          : out std_logic_vector(3 downto 0);
        F6          : out std_logic_vector(3 downto 0);
        F7          : out std_logic_vector(3 downto 0);
        dp_vector   : out std_logic_vector(7 downto 0)
    );
end CorF_MUX;

architecture Behavioral of CorF_MUX is

begin
    process(sel)
    begin
        case sel is
            when "01" =>
                F0          <= F0C;
                F1          <= F1C;
                F2          <= F2C;
                F3          <= F3C;
                F4          <= F4C;
                F5          <= F5C;
                F6          <= F6C;
                F7          <= F7C;
                dp_vector   <= dp_vectorC;
            when "00" =>
                F0          <= F0F;
                F1          <= F1F;
                F2          <= F2F;
                F3          <= F3F;
                F4          <= F4F;
                F5          <= F5F;
                F6          <= F6F;
                F7          <= F7F;
                dp_vector   <= dp_vectorF;
            when others =>
                F0          <= F0P;
                F1          <= F1P;
                F2          <= F2P;
                F3          <= F3P;
                F4          <= F4P;
                F5          <= F5P;
                F6          <= F6P;
                F7          <= F7P;
                dp_vector   <= dp_vectorP;
        end case;
    end process;
end Behavioral;
