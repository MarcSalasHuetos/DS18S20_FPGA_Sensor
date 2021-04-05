--Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;
entity BCD2SS is
    Port ( 
        data   : in std_logic_vector(3 downto 0);
        dp_int : in std_logic;
        BCD    : out std_logic_vector(6 downto 0);
        dp     : out std_logic 
    );
end BCD2SS;

architecture Behavioral of BCD2SS is

begin
    process(dp_int)
    begin
        case dp_int is
            when '0' => dp <= '0';
            when others => dp <= '1';
        end case;
    end process;
    
    process(data)
    begin
        case data is
            when "0000" => BCD <= "0000001";
            when "0001" => BCD <= "1001111";
            when "0010" => BCD <= "0010010";
            when "0011" => BCD <= "0000110";
            when "0100" => BCD <= "1001100";
            when "0101" => BCD <= "0100100";
            when "0110" => BCD <= "0100000";
            when "0111" => BCD <= "0001111";
            when "1000" => BCD <= "0000000";
            when "1001" => BCD <= "0001100";
            when "1010" => BCD <= "1111110";
            when "1011" => BCD <= "1100000";
            when "1100" => BCD <= "0110001";
            when "1101" => BCD <= "1000010";
            when "1110" => BCD <= "1111111";
            when "1111" => BCD <= "0111000";
            when others => BCD <= "1111111";
        end case;
    end process;
end Behavioral;
