-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity prove_FSM is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        pg_out      : in std_logic;
        b1          : in std_logic;
        b2          : in std_logic;
        en          : out std_logic;
        --prescaler   : out std_logic_vector(14 downto 0);
        prescaler   : out std_logic_vector(29 downto 0);
        led_ind     : out std_logic
    ) ;
end prove_FSM;

architecture Behavioral of prove_FSM is

    TYPE State_type IS (S0,S00,S01,S1,S2,S3,S4,S5); 
    signal state, next_state : state_type;

begin
    
    SYNC_PROCESS : process (clk,rst)
    begin 
        if rst = '1' then                 
            state <= S0;
        elsif clk'event and clk = '1' then
            state <= next_state;
        end if;
    end process SYNC_PROCESS;
    
    OUTPUT_DECODE : process(state)
    begin
        case state is
            when S00 => 
                en <= '0';
                prescaler <= "111111111111111000000000000000";
                --prescaler <= "000000111111111000000000000000";
                led_ind <= '0';
            when S01 => 
                en <= '0';
                prescaler <= "111111111111111000000000000000";
                --prescaler <= "000000111111111000000000000000";
                led_ind <= '0';
            when S1 => 
                en <= '1';
                prescaler <= "111111111111111000000000000000";
                --prescaler <= "000000111111111000000000000000";
                led_ind <= '0';
            when S2 =>
                en <= '0';
                prescaler <= (others => '0');
                led_ind <= '0';
            when S3 =>
                en <= '0';
                prescaler <= (others => '0');
                led_ind <= '1';
            when others =>
                en <= '0';
                prescaler <= (others => '0');
                led_ind <= '0';
        end case;
    end process OUTPUT_DECODE;
    
    NEXT_STATE_DECODE : process(state,b1,b2,pg_out)
    begin
        case state is
            when S0 =>
                if b1 = '1' then
                    next_state <= S00;
                else
                    next_state <= S0;
                end if;
            when S00 =>
                    next_state <= S1;
            when S1 =>
                    next_state <= S01;
            when S01 =>
                    next_state <= S2;
            when S2 =>
                if pg_out = '1' then
                    next_state <= S3;
                else
                    next_state <= S2;
                end if;
            when S3 =>
                if b2 = '1' then
                    next_state <= S0;
                else
                    next_state <= S3;
                end if;
            when others =>
                next_state <= S0;
        end case;
    end process NEXT_STATE_DECODE;
end Behavioral;
