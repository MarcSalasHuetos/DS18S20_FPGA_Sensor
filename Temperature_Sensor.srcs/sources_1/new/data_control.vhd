--Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;
entity data_control is
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
end data_control;

architecture Behavioral of data_control is
begin
    process(AN)
    begin
        case AN is
            when "11111110" =>
                data <= F0;
                dp_int <= dp_vector(0);
            when "11111101" =>
                data <= F1;
                dp_int <= dp_vector(1);
            when "11111011" =>
                data <= F2;
                dp_int <= dp_vector(2);
            when "11110111" =>
                data <= F3;
                dp_int <= dp_vector(3);
            when "11101111" =>
                data <= F4;
                dp_int <= dp_vector(4);
            when "11011111" =>
                data <= F5;
                dp_int <= dp_vector(5);
            when "10111111" =>
                data <= F6;
                dp_int <= dp_vector(6);
            when "01111111" =>
                data <= F7;
                dp_int <= dp_vector(7);
            when others =>
                data <= "1111";
                dp_int <= '1';
        end case;
    end process;
end Behavioral;