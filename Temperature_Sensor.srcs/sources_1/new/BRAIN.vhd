-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity BRAIN is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        pg_out          : in std_logic;
        scratchpad      : in std_logic_vector(63 downto 0);
        init_success    : in std_logic;
        RSc_done        : in std_logic;
        WR_done         : in std_logic;
        init_done       : in std_logic;
        prescaler_B     : out std_logic_vector(29 downto 0);
        en_tim_B        : out std_logic;
        en_init         : out std_logic;
        en_WR           : out std_logic;
        en_RSc          : out std_logic;
        en_conv         : out std_logic;
        routine         : out std_logic_vector(1 downto 0);
        temperature     : out std_logic_vector(8 downto 0);
        count_rem       : out std_logic_vector(7 downto 0)
        --count_per_C     : out std_logic_vector(7 downto 0)
    );
end BRAIN;

architecture Behavioral of BRAIN is

TYPE State_type IS (S00,S0,S1,S3,S3_1,S5,S6,S6_1,S8,S9,S10,S10_1,S13,S13_1,S16,S17,S18); 
    signal state, next_state : state_type;

    signal flag             : std_logic;
    signal flag_p           : std_logic;
    signal scratchpad_mem   : unsigned(63 downto 0);
    signal scratchpad_mem_p : unsigned(63 downto 0);
    
begin

    SR_flip_flop : process (clk,rst)
    begin
        if rst = '1' then
            flag_p <= '0';
            scratchpad_mem_p <= (others => '0');
        elsif (clk'event and clk = '1') then
            flag_p <= flag;
            scratchpad_mem_p <= scratchpad_mem;
        end if ;
    end process SR_flip_flop ;
    
    SYNC_PROCESS : process (clk,rst)
    begin 
        if rst = '1' then                 
            state <= S00;
        elsif clk'event and clk = '1' then
            state <= next_state;
        end if;
    end process SYNC_PROCESS;
    
    OUTPUT_DECODE : process(state)
    begin
        case state is
            when S00 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000000000";
                flag <= '0';
                scratchpad_mem <= (others => '0');
                en_conv <= '0';
            when S1 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '1';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000000001";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S3 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '1';          
                en_RSc <= '0';
                routine <= "11";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000000011";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S3_1 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "11";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "100000011";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S6 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '1';          
                en_RSc <= '0';
                routine <= "10";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000000110";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S6_1 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "10";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "100000110";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S8 =>
                prescaler_B <= "000100101001100010111110000000";
                en_tim_B <= '1';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000001000";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S9 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000001001";
                flag <= not flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S10 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '1';          
                en_RSc <= '0';
                routine <= "01";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000001010";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S10_1 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "01";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "100001010";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S13 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '1';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000001101";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S13_1 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "100001101";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S16 =>
                prescaler_B <= "000000000001111010000100100000";
                en_tim_B <= '1';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000010000";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
            when S17 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "000010001";
                flag <= flag_p;
                scratchpad_mem <= unsigned(scratchpad);
                en_conv <= '0';
            when S18 =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "101010101";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '1';
            when others =>
                prescaler_B <= (others => '0');
                en_tim_B <= '0';
                en_init <= '0';
                en_WR <= '0';          
                en_RSc <= '0';
                routine <= "00";
                temperature <= std_logic_vector(scratchpad_mem_p(8 downto 0));
                count_rem <= std_logic_vector(scratchpad_mem_p(55 downto 48));
                --count_per_C <= std_logic_vector(scratchpad_mem_p(63 downto 56));
                --temperature <= "101010101";
                flag <= flag_p;
                scratchpad_mem <= scratchpad_mem_p;
                en_conv <= '0';
        end case;
    end process OUTPUT_DECODE;
    
    --NEXT_STATE_DECODE : process(state,pg_out,scratchpad,init_success,RSc_done,WR_done,init_done)
    NEXT_STATE_DECODE : process(state,pg_out,scratchpad,init_success,RSc_done,WR_done,init_done,flag)
    begin
        case state is
            when S00 =>
                    next_state <= S0;
            when S0 =>
                    next_state <= S1;
            when S1 =>
                if init_done = '1' and init_success = '0' then
                    next_state <= S3;
                else
                    next_state <= S1;
                end if;
--            when S2 =>
--                    next_state <= S3;
            when S3 =>
                    next_state <= S3_1;
            when S3_1 =>
                if WR_done = '1' then
                    next_state <= S5;
                else
                    next_state <= S3_1;
                end if;
--            when S5 =>
--                    next_state <= S5;
            when S5 =>
                if flag = '0' then
                    next_state <= S6;
                else
                    next_state <= S10;
                end if;
            when S6 =>
                    next_state <= S6_1;
            when S6_1 =>
                if WR_done = '1' then
                    next_state <= S8;
                else
                    next_state <= S6_1;
                end if;
            when S8 =>
                if pg_out = '1' then
                    next_state <= S9;
                else
                    next_state <= S8;
                end if;
            when S9 =>            
                    next_state <= S0;
            when S10 =>            
                    next_state <= S10_1;
            when S10_1 =>
                if WR_done = '1' then
                    next_state <= S13;
                else
                    next_state <= S10_1;
                end if;
--            when S11 =>
--                    next_state <= S12;
--            when S12 =>
--                    next_state <= S13;
            when S13 =>
                    next_state <= S13_1;
            when S13_1 =>
                if RSc_done = '1' then
                    next_state <= S16;
                else
                    next_state <= S13_1;
                end if;
--            when S14 =>
--                    next_state <= S16;
            when S16 =>
                if pg_out = '1' then
                    next_state <= S17;
                else
                    next_state <= S16;
                end if;
            when S17 =>
                    next_state <= S18;
            when S18 =>
                    next_state <= S9;
            when others =>
                next_state <= S00;
        end case;
    end process NEXT_STATE_DECODE;
end Behavioral;
