-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity Write_Routines_FSM is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        routine         : in std_logic_vector(1 downto 0);
        en_WR           : in std_logic;
        pg_out          : in std_logic;
        WR_done         : out std_logic;
        en_tim_WR       : out std_logic;
        prescaler_WR    : out std_logic_vector(29 downto 0);
        out_line_WR     : out std_logic
    );
end Write_Routines_FSM;

architecture Behavioral of Write_Routines_FSM is

    TYPE State_type IS (S0,S1,S2,S3,S4,S5,S10,S6,S8); 
    signal state, next_state : state_type;
    
    signal count            : unsigned(3 downto 0);
    signal count_p          : unsigned(3 downto 0);
    signal mem_routine      : unsigned(1 downto 0);
    signal mem_routine_p    : unsigned(1 downto 0);
    
begin

    SR_flip_flop : process (clk,rst)
    begin
        if rst = '1' then
            count_p <= (others => '0');
            mem_routine_p <= (others => '0');
        elsif (clk'event and clk = '1') then
            count_p <= count;
            mem_routine_p <= mem_routine;
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
                count <= (others => '0');
                mem_routine <= unsigned(routine);
                prescaler_WR <= (others => '0');
                out_line_WR <= '1';
                WR_done <= '0';
                en_tim_WR <= '0';
            when S3 =>
                count <= count_p;
                mem_routine <= mem_routine_p;
                prescaler_WR <= "000000000000000000001111101000";
                out_line_WR <= '0';
                WR_done <= '0';
                en_tim_WR <= '1';
            when S4 =>
                count <= count_p;
                mem_routine <= mem_routine_p;
                prescaler_WR <= "000000000000000001011101110000";
                out_line_WR <= '1';
                WR_done <= '0';
                en_tim_WR <= '1';
            when S5 =>
                count <= count_p;
                mem_routine <= mem_routine_p;
                prescaler_WR <= "000000000000000000000111110100";
                out_line_WR <= '1';
                WR_done <= '0';
                en_tim_WR <= '1';
            when S6 =>
                count <= count_p+1;
                mem_routine <= mem_routine_p;
                prescaler_WR <= (others => '0');
                out_line_WR <= '1';
                WR_done <= '0';
                en_tim_WR <= '0';
            when S10 =>
                count <= count_p;
                mem_routine <= mem_routine_p;
                prescaler_WR <= "000000000000000001101101011000";
                out_line_WR <= '0';
                WR_done <= '0';
                en_tim_WR <= '1';
            when S8 =>
                count <= (others => '0');
                mem_routine <= (others => '0');
                prescaler_WR <= (others => '0');
                out_line_WR <= '1';
                WR_done <= '1';
                en_tim_WR <= '0';
            when others =>
                count <= count_p;
                mem_routine <= mem_routine_p;
                prescaler_WR <= (others => '0');
                out_line_WR <= '1';
                WR_done <= '0';
                en_tim_WR <= '0';
        end case;
    end process OUTPUT_DECODE;
    
    NEXT_STATE_DECODE : process(state,en_WR,routine,pg_out)
    begin
        case state is
            when S0 =>
                if en_WR = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when S1 =>
                    next_state <= S2;
            when S2 =>
                if ((mem_routine = "11") and (count = 2 or count = 3 or count = 6 or count = 7))or
                ((mem_routine = "10") and (count = 2 or count = 6))or
                ((mem_routine = "01") and (count = 1 or count = 2 or count = 3 or count = 4 or count = 5 or count = 7)) then --condition1
                    next_state <= S3;
                elsif ((mem_routine = "11") and (count = 0 or count = 1 or count = 4 or count = 5))or
                ((mem_routine = "01") and (count = 0 or count = 6))or
                ((mem_routine = "10") and (count = 0 or count = 1 or count = 3 or count = 4 or count = 5 or count = 7)) then --condition2
                    next_state <= S10;
                else 
                    next_state <= S8;
                end if;
            when S3 =>
                if pg_out = '1' then
                    next_state <= S4;
                else
                    next_state <= S3;
                end if;
            when S4 =>
                if pg_out = '1' then
                    next_state <= S5;
                else
                    next_state <= S4;
                end if;
            when S5 =>
                if pg_out = '1' then
                    next_state <= S6;
                else
                    next_state <= S5;
                end if;
            when S6 =>
                    next_state <= S2;
            when S10 =>
                if pg_out = '1' then
                    next_state <= S5;
                else
                    next_state <= S10;
                end if;
            when S8 =>
                next_state <= S0;
            when others =>
                next_state <= S0;
        end case;
    end process NEXT_STATE_DECODE;
end Behavioral;
