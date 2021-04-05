-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity Initialization_FSM is
    port(
        clk                 : in std_logic;
        rst                 : in std_logic;
        en_init             : in std_logic;
        in_line             : in std_logic;
        pg_out              : in std_logic;
        prescaler_init      : out std_logic_vector(29 downto 0);
        en_tim_init         : out std_logic;
        init_done           : out std_logic;
        init_success        : out std_logic;
        out_line_init       : out std_logic
    );
end Initialization_FSM;

architecture Behavioral of Initialization_FSM is

    TYPE State_type IS (S0,S1,S2,S3,S4,S5,S6,S7,S8); 
    signal state, next_state : state_type;
    
    signal mem_success_p : std_logic;
    signal mem_success : std_logic;

begin

    SR_flip_flop : process (clk,rst)
    begin
        if rst = '1' then
            mem_success_p <= '0';
        elsif (clk'event and clk = '1') then
            mem_success_p <= mem_success;
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
                prescaler_init <= "000000000000001100001101010000";     
                en_tim_init <= '1';    
                init_done <= '0';           
                init_success <= mem_success_p;        
                out_line_init <= '0';
                mem_success <= '0';
            when S2 =>
                prescaler_init <= "000000000000000001011101110000";     
                en_tim_init <= '1';    
                init_done <= '0';           
                init_success <= mem_success_p;        
                out_line_init <= '1';
                mem_success <= mem_success_p;
            when S4 =>
                prescaler_init <= "000000000000000001001110001000";     
                en_tim_init <= '1';    
                init_done <= '0';           
                init_success <= mem_success_p;        
                out_line_init <= '1';
                mem_success <= mem_success_p;
            when S6 =>
                prescaler_init <= "000000000000001010111111001000";     
                en_tim_init <= '1';    
                init_done <= '0';           
                init_success <= mem_success_p;        
                out_line_init <= '1';
                mem_success <= mem_success_p;
            when S7 =>
                prescaler_init <= (others => '0');     
                en_tim_init <= '0';    
                init_done <= '1';           
                init_success <= mem_success_p;        
                out_line_init <= '1';
                mem_success <= mem_success_p; 
            when S8 =>
                prescaler_init <= (others => '0');     
                en_tim_init <= '0';    
                init_done <= '0';           
                init_success <= mem_success_p;        
                out_line_init <= '1';
                mem_success <= '1';
            when others =>
                prescaler_init <= (others => '0');     
                en_tim_init <= '0';    
                init_done <= '0';           
                init_success <= mem_success_p;        
                out_line_init <= '1';
                mem_success <= mem_success_p;     
        end case;
    end process OUTPUT_DECODE;
    
    NEXT_STATE_DECODE : process(state,en_init,in_line,pg_out)
    --NEXT_STATE_DECODE : process(state,en_init,in_line,pg_out,button)
    begin
        case state is
            when S0 =>
                if en_init = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when S1 =>
                if pg_out = '1' then
                    next_state <= S2;
                else
                    next_state <= S1;
                end if;
            when S2 =>
                if pg_out = '1' then
                    next_state <= S3;
                else
                    next_state <= S2;
                end if;
            when S3 =>
                if in_line = '0' then
                    next_state <= S4;
                else
                    next_state <= S8;
                end if;
            when S4 =>
                if pg_out = '1' then
                    next_state <= S5;
                else
                    next_state <= S4;
                end if;
            when S5 =>
                if in_line = '0' then
                    next_state <= S6;
                else
                    next_state <= S8;
                end if;
            when S6 =>
                if pg_out = '1' then
                    next_state <= S7;
                else
                    next_state <= S6;
                end if;
            when S8 =>
                    next_state <= S6;
            when others =>
                    next_state <= S0;
        end case;
    end process NEXT_STATE_DECODE;

end Behavioral;
