-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity Read_Scratchpad_FSM is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        en_RSc          : in std_logic;
        pg_out          : in std_logic;
        in_line         : in std_logic;
        out_line_RSc    : out std_logic;
        en_tim_RSc      : out std_logic;
        RSc_done        : out std_logic;
        prescaler_RSc   : out std_logic_vector(29 downto 0);
        scratchpad_mem  : out std_logic_vector(63 downto 0)
    );
end Read_Scratchpad_FSM;

architecture Behavioral of Read_Scratchpad_FSM is

    TYPE State_type IS (S0,S1,S3,S4,S6,S7,S9,S10,S11); 
    signal state, next_state : state_type;

    signal count            : unsigned(5 downto 0);
    signal count_p          : unsigned(5 downto 0);
    signal scratch_mem      : std_logic_vector(63 downto 0);
    signal scratch_mem_p    : std_logic_vector(63 downto 0);
    
begin

    SR_flip_flop : process (clk,rst)
    begin
        if rst = '1' then
            count_p <= (others => '0');
            scratch_mem_p <= (others => '0');
        elsif (clk'event and clk = '1') then
            count_p <= count;
            scratch_mem_p <= scratch_mem;
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
            when S0 =>
                count <= (others => '0');
                scratch_mem <= scratch_mem_p;
                prescaler_RSc <= (others => '0');
                out_line_RSc <= '1';
                RSc_done <= '0';
                en_tim_RSc <= '0';
                scratchpad_mem <= scratch_mem_p;
            when S1 =>
                count <= count_p;
                scratch_mem <= scratch_mem_p;
                prescaler_RSc <= "000000000000000000000011001000";
                out_line_RSc <= '0';
                RSc_done <= '0';
                en_tim_RSc <= '1';
                scratchpad_mem <= scratch_mem_p;
            when S4 =>
                count <= count_p;
                scratch_mem <= scratch_mem_p;
                prescaler_RSc <= "000000000000000000010010110000";
                out_line_RSc <= '1';
                RSc_done <= '0';
                en_tim_RSc <= '1';
                scratchpad_mem <= scratch_mem_p;
            when S6 =>
                count <= count_p;
                scratch_mem(63) <= in_line;
                prescaler_RSc <= (others => '0');
                out_line_RSc <= '1';
                RSc_done <= '0';
                en_tim_RSc <= '0';
                scratchpad_mem <= scratch_mem_p;
            when S7 =>
                count <= count_p;
                scratch_mem <= scratch_mem_p;
                prescaler_RSc <= "000000000000000001010101111100";
                out_line_RSc <= '1';
                RSc_done <= '0';
                en_tim_RSc <= '1';
                scratchpad_mem <= scratch_mem_p;
            when S10 =>
                count <= count_p+1;
                scratch_mem <= '0'&scratch_mem_p(63 downto 1);
                prescaler_RSc <= (others => '0');
                out_line_RSc <= '1';
                RSc_done <= '0';
                en_tim_RSc <= '0';
                scratchpad_mem <= scratch_mem_p;
            when S11 =>
                count <= (others => '0');
                scratch_mem <= scratch_mem_p;
                prescaler_RSc <= (others => '0');
                out_line_RSc <= '1';
                RSc_done <= '1';
                en_tim_RSc <= '0';
                scratchpad_mem <= scratch_mem_p;
            when others =>
                count <= count_p;
                scratch_mem <= scratch_mem_p;
                prescaler_RSc <= (others => '0');
                out_line_RSc <= '1';
                RSc_done <= '0';
                en_tim_RSc <= '0';
                scratchpad_mem <= scratch_mem_p;
        end case;
    end process OUTPUT_DECODE;
    
    NEXT_STATE_DECODE : process(state,en_RSc,count,pg_out)
    begin
        case state is
            when S0 =>
                if en_RSc = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when S1 =>
                if pg_out = '1' then
                    next_state <= S3;
                else
                    next_state <= S1;
                end if;
            when S3 =>
                    next_state <= S4;
            when S4 =>
                if pg_out = '1' then
                    next_state <= S6;
                else
                    next_state <= S4;
                end if;
            when S6 =>
                    next_state <= S7;
            when S7 =>
                if pg_out = '1' then
                    next_state <= S9;
                else
                    next_state <= S7;
                end if;
            when S9 =>
                if count > 62 then
                    next_state <= S11;
                else
                    next_state <= S10;
                end if;
            when S11 =>
                    next_state <= S0;
            when S10 =>
                    next_state <= S1;
            when others =>
                next_state <= S0;
        end case;
    end process NEXT_STATE_DECODE;
end Behavioral;
