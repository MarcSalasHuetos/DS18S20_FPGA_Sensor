-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Generic_timer is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        digital_rst : in std_logic;
        en          : in std_logic;
        prescaler   : in std_logic_vector(14 downto 0);
        --prescaler   : in std_logic_vector(19 downto 0);
        pg_out      : out std_logic
    ) ;
end Generic_timer;

architecture Behavioral of Generic_timer is

    --signal cpt_temp : unsigned(19 downto 0);
    signal cpt_temp : unsigned(29 downto 0);
    
begin

    process(clk,rst)
    begin
        if (rst = '1' or digital_rst = '1') then
            cpt_temp <= (others => '0');
            Pg_out <= '0';
        elsif(clk'event and clk = '1') then
            if(en = '0')then
                cpt_temp <= cpt_temp;
                Pg_out <= '0';
            elsif cpt_temp = unsigned(prescaler&"000000000000000") then
            --elsif cpt_temp = unsigned(prescaler) then
                cpt_temp <= cpt_temp;
                Pg_out <= '1';
            else
                cpt_temp <= cpt_temp+1;
                Pg_out <= '0';
            end if;
        end if;
    end process;
end Behavioral;
