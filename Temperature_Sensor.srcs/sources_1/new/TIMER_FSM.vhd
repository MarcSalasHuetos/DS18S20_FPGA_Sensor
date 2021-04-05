-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity TIMER_FSM is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        --digital_rst : in std_logic;
        en          : in std_logic;
        --prescaler   : in std_logic_vector(14 downto 0);
        prescaler   : in std_logic_vector(29 downto 0);
        pg_out      : out std_logic
    ) ;
end TIMER_FSM;

architecture Behavioral of TIMER_FSM is

    TYPE State_type IS (S0,S1,S2,S3,S4,S5,S6); 
    signal state, next_state : state_type;
    
    signal count            : unsigned(29 downto 0);
    signal count_p          : unsigned(29 downto 0);
    signal mem_prescaler    : unsigned(29 downto 0);
    signal mem_prescaler_p  : unsigned(29 downto 0);

begin

    SR_flip_flop : process (clk,rst)
    begin
        if (rst = '1') then
            mem_prescaler_p <= (others => '0'); 
            count_p <= (others => '0');
        elsif (clk'event and clk = '1') then
            mem_prescaler_p <= mem_prescaler; 
            count_p <= count;
        end if ;
    end process SR_flip_flop ;
    
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
            when S1 => 
                count <= count_p;
                mem_prescaler <= unsigned(prescaler);
                --mem_prescaler <= unsigned(prescaler&"000000000000000");
                pg_out <= '0';
            when S2 =>
                count <= count_p;
                mem_prescaler <= mem_prescaler_p;
                pg_out <= '0';
            when S3 =>
                count <= count_p+1;
                mem_prescaler <= mem_prescaler_p;
                pg_out <= '0';
            when S4 =>
                count <= count_p+1;
                mem_prescaler <= mem_prescaler_p;
                pg_out <= '0';
            when S5 =>
                count <= count_p;
                mem_prescaler <= mem_prescaler_p;
                pg_out <= '1';
            when others =>
                count <= (others => '0');
                mem_prescaler <= mem_prescaler_p;
                pg_out <= '0';
                --pg_out <= '1';
        end case;
    end process OUTPUT_DECODE;
    
    NEXT_STATE_DECODE : process(state,en,mem_prescaler,count)
    begin
        case state is
            when S0 =>
                if en = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when S1 =>
                    next_state <= S2;
            when S2 =>
                if mem_prescaler = count then
                    next_state <= S5;
                else
                    next_state <= S3;
                end if;
            when S3 =>
                if mem_prescaler = count then
                    next_state <= S5;
                else
                    next_state <= S4;
                end if;
            when S4 =>
                if mem_prescaler = count then
                    next_state <= S5;
                else
                    next_state <= S3;
                end if;
            when S5 =>
                    next_state <= S6;
            when S6 =>
                    next_state <= S0;
            when others =>
                next_state <= S0;
        end case;
    end process NEXT_STATE_DECODE;

end Behavioral;
