-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity T2Fd_FSM is
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        temperature : in std_logic_vector(8 downto 0);
        en_conv     : in std_logic;
        u           : out std_logic_vector(3 downto 0);
        d           : out std_logic_vector(3 downto 0);
        c           : out std_logic_vector(3 downto 0);
        sign        : out std_logic_vector(3 downto 0);
        --mem_num_o   : out std_logic_vector(7 downto 0);
        --st          : out std_logic_vector(3 downto 0);
        decimal     : out std_logic_vector(3 downto 0)
    );
end T2Fd_FSM;

architecture Behavioral of T2Fd_FSM is
TYPE State_type IS (S0,S1,S2,S3,S4,S5,S6,S7,S8); 
    signal state, next_state : state_type;

    signal mem_u            : unsigned(3 downto 0);
    signal mem_u_p          : unsigned(3 downto 0);
    signal mem_d            : unsigned(3 downto 0);
    signal mem_d_p          : unsigned(3 downto 0);
    signal mem_c            : unsigned(3 downto 0);
    signal mem_c_p          : unsigned(3 downto 0);
    signal mem_sign         : unsigned(3 downto 0);
    signal mem_sign_p       : unsigned(3 downto 0);
    signal mem_decimal      : unsigned(3 downto 0);
    signal mem_decimal_p    : unsigned(3 downto 0);
    signal mem_value        : unsigned(8 downto 0);
    signal mem_value_p      : unsigned(8 downto 0);
    signal counter          : unsigned(7 downto 0);
    signal counter_p        : unsigned(7 downto 0);
    
begin

    SR_flip_flop : process (clk,rst)
    begin
        if rst = '1' then
            mem_u_p <= (others => '0');
            mem_d_p <= (others => '0');
            mem_c_p <= (others => '0');
            mem_sign_p <= (others => '0');
            mem_decimal_p <= (others => '0');
            mem_value_p <= (others => '0');
            counter_p <= (others => '0');
        elsif (clk'event and clk = '1') then
            mem_u_p <= mem_u;
            mem_d_p <= mem_d;
            mem_c_p <= mem_c;
            mem_sign_p <= mem_sign;
            mem_decimal_p <= mem_decimal;
            mem_value_p <= mem_value;
            counter_p <= counter;
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
                mem_u <= mem_u_p;
                mem_d <= mem_d_p;
                mem_c <= mem_c_p;
                mem_sign <= mem_sign_p;
                mem_decimal <= mem_decimal_p;
                mem_value <= unsigned(temperature);
                counter <= (others => '0');
                u <= std_logic_vector(mem_u_p);
                if mem_value(8) = '0' then
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= "1110";
                    else
                        d <= std_logic_vector(mem_d_p);
                    end if;
                    if mem_c_p = "0000" then
                        c <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                    end if;
                    sign <= std_logic_vector(mem_sign_p);
                else
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= std_logic_vector(mem_sign_p);
                        c <= "1110";
                        sign <= "1110";
                    elsif mem_d_p /= "0000" and mem_c_p = "0000" then
                        c <= std_logic_vector(mem_sign_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= std_logic_vector(mem_sign_p);
                    end if;
                end if;  
                decimal <= std_logic_vector(mem_decimal_p); 
                --mem_num_o <= std_logic_vector(mem_value(7 downto 0));
            when S2 =>
                if mem_value(8) = '1' then
                    mem_value(7 downto 0) <= not mem_value_p(7 downto 0)+1;
                    mem_value(8) <= mem_value_p(8);
                else
                    mem_value <= mem_value_p;
                end if;
                mem_u <= mem_u_p;
                mem_d <= mem_d_p;
                mem_c <= mem_c_p;
                mem_sign <= mem_sign_p;
                mem_decimal <= mem_decimal_p;
                counter <= counter_p;
                u <= std_logic_vector(mem_u_p);
                if mem_value(8) = '0' then
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= "1110";
                    else
                        d <= std_logic_vector(mem_d_p);
                    end if;
                    if mem_c_p = "0000" then
                        c <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                    end if;
                    sign <= std_logic_vector(mem_sign_p);
                else
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= std_logic_vector(mem_sign_p);
                        c <= "1110";
                        sign <= "1110";
                    elsif mem_d_p /= "0000" and mem_c_p = "0000" then
                        c <= std_logic_vector(mem_sign_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= std_logic_vector(mem_sign_p);
                    end if;
                end if; 
                decimal <= std_logic_vector(mem_decimal_p); 
                --mem_num_o <= std_logic_vector(mem_value(7 downto 0));
            when S3 =>
                if mem_value(8) = '1' and (mem_value(7 downto 0) > "00100011") then
                    mem_value <= mem_value_p-36;
                    mem_sign <= "1010";
                    mem_decimal <= "0100";
                else
                    mem_value <= mem_value_p+35;
                    mem_sign <= "1110";
                    mem_decimal <= "0101";
                end if;
                mem_u <= (others => '0');
                mem_d <= (others => '0');
                mem_c <= (others => '0');
                --mem_value <= mem_value_p;
                counter <= counter_p;
                u <= std_logic_vector(mem_u_p);
                if mem_value(8) = '0' then
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= "1110";
                    else
                        d <= std_logic_vector(mem_d_p);
                    end if;
                    if mem_c_p = "0000" then
                        c <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                    end if;
                    sign <= std_logic_vector(mem_sign_p);
                else
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= std_logic_vector(mem_sign_p);
                        c <= "1110";
                        sign <= "1110";
                    elsif mem_d_p /= "0000" and mem_c_p = "0000" then
                        c <= std_logic_vector(mem_sign_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= std_logic_vector(mem_sign_p);
                    end if;
                end if;
                decimal <= std_logic_vector(mem_decimal_p); 
                --mem_num_o <= std_logic_vector(mem_value(7 downto 0));
            when S5 =>
                mem_u <= mem_u_p;
                mem_d <= mem_d_p;
                mem_c <= mem_c_p;
                mem_sign <= mem_sign_p;
                mem_decimal <= "1001";
                mem_value <= mem_value_p;
                counter <= counter_p+1;
                u <= std_logic_vector(mem_u_p);
                if mem_value(8) = '0' then
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= "1110";
                    else
                        d <= std_logic_vector(mem_d_p);
                    end if;
                    if mem_c_p = "0000" then
                        c <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                    end if;
                    sign <= std_logic_vector(mem_sign_p);
                else
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= std_logic_vector(mem_sign_p);
                        c <= "1110";
                        sign <= "1110";
                    elsif mem_d_p /= "0000" and mem_c_p = "0000" then
                        c <= std_logic_vector(mem_sign_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= std_logic_vector(mem_sign_p);
                    end if;
                end if;  
                decimal <= std_logic_vector(mem_decimal_p);
                --mem_num_o <= std_logic_vector(mem_value(7 downto 0));
            when S6 =>
                mem_u <= (others => '0');
                mem_d <= (others => '0');
                mem_c <= mem_c_p+1;
                mem_sign <= mem_sign_p;
                mem_decimal <= mem_decimal_p-1;
                mem_value <= mem_value_p;
                counter <= counter_p+1;
                u <= std_logic_vector(mem_u_p);
                if mem_value(8) = '0' then
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= "1110";
                    else
                        d <= std_logic_vector(mem_d_p);
                    end if;
                    if mem_c_p = "0000" then
                        c <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                    end if;
                    sign <= std_logic_vector(mem_sign_p);
                else
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= std_logic_vector(mem_sign_p);
                        c <= "1110";
                        sign <= "1110";
                    elsif mem_d_p /= "0000" and mem_c_p = "0000" then
                        c <= std_logic_vector(mem_sign_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= std_logic_vector(mem_sign_p);
                    end if;
                end if;  
                decimal <= std_logic_vector(mem_decimal_p); 
                --mem_num_o <= std_logic_vector(mem_value(7 downto 0));
            when S7 =>
                mem_u <= (others => '0');
                mem_d <= mem_d_p+1;
                mem_c <= mem_c_p;
                mem_sign <= mem_sign_p;
                mem_decimal <= mem_decimal_p-1;
                mem_value <= mem_value_p;
                counter <= counter_p+1;
                u <= std_logic_vector(mem_u_p);
                if mem_value(8) = '0' then
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= "1110";
                    else
                        d <= std_logic_vector(mem_d_p);
                    end if;
                    if mem_c_p = "0000" then
                        c <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                    end if;
                    sign <= std_logic_vector(mem_sign_p);
                else
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= std_logic_vector(mem_sign_p);
                        c <= "1110";
                        sign <= "1110";
                    elsif mem_d_p /= "0000" and mem_c_p = "0000" then
                        c <= std_logic_vector(mem_sign_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= std_logic_vector(mem_sign_p);
                    end if;
                end if;  
                decimal <= std_logic_vector(mem_decimal_p);
                --mem_num_o <= std_logic_vector(mem_value(7 downto 0));
            when S8 =>
                mem_u <= mem_u_p+1;
                mem_d <= mem_d_p;
                mem_c <= mem_c_p;
                mem_sign <= mem_sign_p;
                mem_decimal <= mem_decimal_p-1;
                mem_value <= mem_value_p;
                counter <= counter_p+1;
                u <= std_logic_vector(mem_u_p);
                if mem_value(8) = '0' then
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= "1110";
                    else
                        d <= std_logic_vector(mem_d_p);
                    end if;
                    if mem_c_p = "0000" then
                        c <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                    end if;
                    sign <= std_logic_vector(mem_sign_p);
                else
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= std_logic_vector(mem_sign_p);
                        c <= "1110";
                        sign <= "1110";
                    elsif mem_d_p /= "0000" and mem_c_p = "0000" then
                        c <= std_logic_vector(mem_sign_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= std_logic_vector(mem_sign_p);
                    end if;
                end if;  
                decimal <= std_logic_vector(mem_decimal_p);
                --mem_num_o <= std_logic_vector(mem_value(7 downto 0));
            when others =>
                mem_u <= mem_u_p;
                mem_d <= mem_d_p;
                mem_c <= mem_c_p;
                mem_sign <= mem_sign_p;
                mem_decimal <= mem_decimal_p;
                mem_value <= mem_value_p;
                counter <= counter_p;
                u <= std_logic_vector(mem_u_p);
                if mem_value(8) = '0' then
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= "1110";
                    else
                        d <= std_logic_vector(mem_d_p);
                    end if;
                    if mem_c_p = "0000" then
                        c <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                    end if;
                    sign <= std_logic_vector(mem_sign_p);
                else
                    if mem_d_p = "0000" and mem_c_p = "0000" then
                        d <= std_logic_vector(mem_sign_p);
                        c <= "1110";
                        sign <= "1110";
                    elsif mem_d_p /= "0000" and mem_c_p = "0000" then
                        c <= std_logic_vector(mem_sign_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= "1110";
                    else
                        c <= std_logic_vector(mem_c_p);
                        d <= std_logic_vector(mem_d_p);
                        sign <= std_logic_vector(mem_sign_p);
                    end if;
                end if;  
                decimal <= std_logic_vector(mem_decimal_p); 
                --mem_num_o <= std_logic_vector(mem_value(7 downto 0));
        end case;
    end process OUTPUT_DECODE;
    
    NEXT_STATE_DECODE : process(state,en_conv,temperature)
    begin
        case state is
            when S0 =>
                if en_conv = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when S1 =>
                    next_state <= S2;
            when S2 =>
                    next_state <= S3;
            when S3 =>
                    next_state <= S4;
            when S4 =>
                if mem_value(7 downto 0) = counter then
                    next_state <= S0;
                elsif mem_value(7 downto 0) /= counter and mem_decimal = "0000" then
                    next_state <= S5;
                elsif mem_value(7 downto 0) /= counter and mem_decimal /= "0000" and mem_u = "1001" and mem_d = "1001" then
                    next_state <= S6;
                elsif mem_value(7 downto 0) /= counter and mem_decimal /= "0000" and mem_u = "1001" and mem_d /= "1001" then
                    next_state <= S7;
                else
                    next_state <= S8;
                end if;
            when S5 =>
                    next_state <= S4;
            when S6 =>
                    next_state <= S4;
            when S7 =>
                    next_state <= S4;
            when S8 =>
                    next_state <= S4;
            when others =>
                next_state <= S0;
        end case;
    end process NEXT_STATE_DECODE;
end Behavioral;
