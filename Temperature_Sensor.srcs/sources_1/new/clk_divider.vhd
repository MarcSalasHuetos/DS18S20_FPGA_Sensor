--Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;
entity clk_divider is
    Port ( 
        rst : in std_logic;
        clk : in std_logic;
        s  : out std_logic
    );
end clk_divider;

architecture Behavioral of clk_divider is

    --signal cpt_temp : unsigned(27 downto 0);
    signal cpt_temp : unsigned(14 downto 0);
    signal ss : std_logic := '0';
begin

    process(clk,rst)
    begin
        if (rst = '1') then
            cpt_temp <= (others => '0');
        elsif(clk'event and clk = '1') then
            if cpt_temp >= "100111000100000" then
            --if cpt_temp >= "101111101011110000100000000" then
                ss <= '1';
                -- ss <= not ss;
                cpt_temp <= (others => '0');
            else
                ss <= '0';
                --ss <= ss;
                cpt_temp <= cpt_temp+1;
            end if;
        end if;
      
    end process;
    
      s <= ss;
end Behavioral;
