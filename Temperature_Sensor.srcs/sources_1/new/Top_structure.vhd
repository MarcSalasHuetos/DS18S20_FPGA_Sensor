-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity Top_structure is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        sel             : in std_logic_vector(1 downto 0);
        ow_line_in      : in std_logic;
        ow_line_out     : out std_logic;
        --st              : out std_logic_vector(3 downto 0);
        --temperature     : out std_logic_vector(8 downto 0);
        --count_rem       : out std_logic_vector(7 downto 0);
        --count_per_C     : out std_logic_vector(7 downto 0);
        AN              : out std_logic_vector(7 downto 0);
        BCD             : out std_logic_vector(6 downto 0);
        dp              : out std_logic
    );
end Top_structure;

architecture Structural of Top_structure is

    component BUFT is
        port(
            I   : in std_logic;
            T   : in std_logic;
            O   : out std_logic
        );
    end component;

    component Top_Comunications_Structure is
        port(
            clk                     : in std_logic;
            rst                     : in std_logic;
            ow_line_in              : in std_logic;
            temperature             : out std_logic_vector(8 downto 0);
            count_rem               : out std_logic_vector(7 downto 0);
            --count_per_C             : out std_logic_vector(7 downto 0);
            en_conv                 : out std_logic;
            out_line_BUFT_toggle    : out std_logic
        );
    end component;
    
    component display_module is
        Port ( 
            rst         : in std_logic;
            clk         : in std_logic;
            F0          : in std_logic_vector(3 downto 0);
            F1          : in std_logic_vector(3 downto 0);
            F2          : in std_logic_vector(3 downto 0);
            F3          : in std_logic_vector(3 downto 0);
            F4          : in std_logic_vector(3 downto 0);
            F5          : in std_logic_vector(3 downto 0);
            F6          : in std_logic_vector(3 downto 0);
            F7          : in std_logic_vector(3 downto 0);
            dp_vector   : in std_logic_vector(7 downto 0);
            AN          : out std_logic_vector(7 downto 0);
            BCD         : out std_logic_vector(6 downto 0);
            dp          : out std_logic 
        );
    end component;
    
    component CorF_MUX is
        port(
            sel         : in std_logic_vector(1 downto 0);
            F0C         : in std_logic_vector(3 downto 0);
            F1C         : in std_logic_vector(3 downto 0);
            F2C         : in std_logic_vector(3 downto 0);
            F3C         : in std_logic_vector(3 downto 0);
            F4C         : in std_logic_vector(3 downto 0);
            F5C         : in std_logic_vector(3 downto 0);
            F6C         : in std_logic_vector(3 downto 0);
            F7C         : in std_logic_vector(3 downto 0);
            dp_vectorC  : in std_logic_vector(7 downto 0);
            F0F         : in std_logic_vector(3 downto 0);
            F1F         : in std_logic_vector(3 downto 0);
            F2F         : in std_logic_vector(3 downto 0);
            F3F         : in std_logic_vector(3 downto 0);
            F4F         : in std_logic_vector(3 downto 0);
            F5F         : in std_logic_vector(3 downto 0);
            F6F         : in std_logic_vector(3 downto 0);
            F7F         : in std_logic_vector(3 downto 0);
            dp_vectorF  : in std_logic_vector(7 downto 0);
            F0P         : in std_logic_vector(3 downto 0);
            F1P         : in std_logic_vector(3 downto 0);
            F2P         : in std_logic_vector(3 downto 0);
            F3P         : in std_logic_vector(3 downto 0);
            F4P         : in std_logic_vector(3 downto 0);
            F5P         : in std_logic_vector(3 downto 0);
            F6P         : in std_logic_vector(3 downto 0);
            F7P         : in std_logic_vector(3 downto 0);
            dp_vectorP  : in std_logic_vector(7 downto 0);
            F0          : out std_logic_vector(3 downto 0);
            F1          : out std_logic_vector(3 downto 0);
            F2          : out std_logic_vector(3 downto 0);
            F3          : out std_logic_vector(3 downto 0);
            F4          : out std_logic_vector(3 downto 0);
            F5          : out std_logic_vector(3 downto 0);
            F6          : out std_logic_vector(3 downto 0);
            F7          : out std_logic_vector(3 downto 0);
            dp_vector   : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component T2Cd_FSM is
        port(
            clk         : in std_logic;
            rst         : in std_logic;
            temperature : in std_logic_vector(8 downto 0);
            en_conv     : in std_logic;
            --st          : out std_logic_vector(3 downto 0);
            --mem_num_o   : out std_logic_vector(7 downto 0);
            u           : out std_logic_vector(3 downto 0);
            d           : out std_logic_vector(3 downto 0);
            c           : out std_logic_vector(3 downto 0);
            sign        : out std_logic_vector(3 downto 0);
            decimal     : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component T2Fd_FSM is
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
    end component;
    
    signal temperature_sig : std_logic_vector(8 downto 0);
    signal en_conv_sig : std_logic;
    signal F0_sig : std_logic_vector(3 downto 0);
    signal F1_sig : std_logic_vector(3 downto 0);
    signal F2_sig : std_logic_vector(3 downto 0);
    signal F3_sig : std_logic_vector(3 downto 0);
    signal F4_sig : std_logic_vector(3 downto 0);
    signal F5_sig : std_logic_vector(3 downto 0);
    signal F6_sig : std_logic_vector(3 downto 0);
    signal F7_sig : std_logic_vector(3 downto 0);
    signal dp_vector_sig : std_logic_vector(7 downto 0);
    signal F0C_sig : std_logic_vector(3 downto 0);
    signal F1C_sig : std_logic_vector(3 downto 0);
    signal F2C_sig : std_logic_vector(3 downto 0);
    signal F3C_sig : std_logic_vector(3 downto 0);
    signal F4C_sig : std_logic_vector(3 downto 0);
    signal F5C_sig : std_logic_vector(3 downto 0);
    signal F6C_sig : std_logic_vector(3 downto 0);
    signal F7C_sig : std_logic_vector(3 downto 0);
    signal dp_vectorC_sig : std_logic_vector(7 downto 0); 
    signal F0F_sig : std_logic_vector(3 downto 0);
    signal F1F_sig : std_logic_vector(3 downto 0);
    signal F2F_sig : std_logic_vector(3 downto 0);
    signal F3F_sig : std_logic_vector(3 downto 0);
    signal F4F_sig : std_logic_vector(3 downto 0);
    signal F5F_sig : std_logic_vector(3 downto 0);
    signal F6F_sig : std_logic_vector(3 downto 0);
    signal F7F_sig : std_logic_vector(3 downto 0);
    signal dp_vectorF_sig : std_logic_vector(7 downto 0); 
    signal F0P_sig : std_logic_vector(3 downto 0);
    signal F1P_sig : std_logic_vector(3 downto 0);
    signal F2P_sig : std_logic_vector(3 downto 0);
    signal F3P_sig : std_logic_vector(3 downto 0);
    signal F4P_sig : std_logic_vector(3 downto 0);
    signal F5P_sig : std_logic_vector(3 downto 0);
    signal F6P_sig : std_logic_vector(3 downto 0);
    signal F7P_sig : std_logic_vector(3 downto 0);
    signal dp_vectorP_sig : std_logic_vector(7 downto 0);
        
    signal BUFT_I_sig : std_logic;
    signal BUFT_O_sig : std_logic;
    signal out_line_BUFT_toggle_sig : std_logic;
    
    signal count_rem_sig : std_logic_vector(7 downto 0);
    
begin

    F0C_sig <= "1100";
    F1C_sig <= "1110";
    F7C_sig <= "1110";
    dp_vectorC_sig <= "11110111";
    F0F_sig <= "1111";
    F1F_sig <= "1110";
    F7F_sig <= "1110";
    dp_vectorF_sig <= "11110111";
    BUFT_I_sig <= '0';
    ow_line_out <= BUFT_O_sig;
--    count_rem <= count_rem_sig;
--    ow_line_out <= out_line_BUFT_toggle_sig;
--    temperature <= temperature_sig;
--    F4P_sig <= "1110";
--    F5P_sig <= "1110";
--    F6P_sig <= "1110";
    F7P_sig <= "1110"; 
    dp_vectorP_sig <= "11101111";
    
    process(count_rem_sig)
    begin
        if temperature_sig(8) = '0' and not(F3C_sig = "0000" and F4C_sig = "1110" and F5C_sig = "1110") then
            if unsigned(count_rem_sig) > "00001100" then
                if F5C_sig /= "1110" and F4C_sig = "0000" and F3C_sig = "0000" then
                    if F5C_sig = "0001" then
                        F6P_sig <= "1110";
                    else
                        F6P_sig <= std_logic_vector(unsigned(F5C_sig)-1);
                    end if;
                    F5P_sig <= "1001";
                    F4P_sig <= "1001";
                elsif F5C_sig = "1110" and F4C_sig /= "1110" and F3C_sig = "0000" then
                    if F4C_sig = "0001" then
                        F5P_sig <= "1110";
                    else
                        F5P_sig <= std_logic_vector(unsigned(F4C_sig)-1);
                    end if;
                    F4P_sig <= "1001";
                    F6P_sig <= F5C_sig;
                else 
                    F4P_sig <= std_logic_vector(unsigned(F3C_sig)-1);
                    F6P_sig <= F5C_sig;
                    F5P_sig <= F4C_sig;
                end if;
--                F6P_sig <= "0000";
--                F5P_sig <= "0000";
--                F4P_sig <= "0000";
            else
                F6P_sig <= F5C_sig;
                F5P_sig <= F4C_sig;
                F4P_sig <= F3C_sig;
            end if;
        end if;
        if temperature_sig(8) = '0' and F3C_sig = "0000" and F4C_sig = "1110" and F5C_sig = "1110" then
            F6P_sig <= F5C_sig;
            F5P_sig <= F4C_sig;
            F4P_sig <= F3C_sig;
        end if;
        if temperature_sig(8) = '1' then
            if unsigned(count_rem_sig) > 12 then
                if F4C_sig = "1001" and F3C_sig = "1001" then
                    if F5C_sig = "1110" then
                        F6P_sig <= "0001";
                    else
                        F6P_sig <= std_logic_vector(unsigned(F5C_sig)+1);
                    end if;
                    F5P_sig <= "0000";
                    F4P_sig <= "0000";
                elsif  F4C_sig /= "1001" and F3C_sig = "1001" then
                    if F4C_sig = "1110" then
                        F5P_sig <= "0001";
                    else
                        F5P_sig <= std_logic_vector(unsigned(F4C_sig)+1);
                    end if;
                    F6P_sig <= F5C_sig;
                    F4P_sig <= "0000";
                else 
                    F6P_sig <= F5C_sig;
                    F5P_sig <= F4C_sig;
                    F4P_sig <= std_logic_vector(unsigned(F3C_sig)+1);
                end if; 
            else
                F6P_sig <= F5C_sig;
                F5P_sig <= F4C_sig;
                F4P_sig <= F3C_sig;
            end if;
        end if;  
    end process;
    
    
    process(temperature_sig(8),F3C_sig,F4C_sig,F5C_sig,count_rem_sig)
    begin
        if temperature_sig(8) = '1' or (temperature_sig(8) = '0' and F5C_sig /= "1110" and F4C_sig /= "1110" and F3C_sig /= "0000" and unsigned(count_rem_sig) > 12) then  
            F7P_sig <= "1010";
        else
            F7P_sig <= "1110";
        end if;
    end process;
    process(temperature_sig(8),F3C_sig,F4C_sig,F5C_sig,count_rem_sig)
    begin
        if temperature_sig(8) = '0' and not(F5C_sig = "1110" and F4C_sig = "1110" and F3C_sig = "0000") then 
            case count_rem_sig is
                when "00000001" => F3P_sig <= "0110"; F2P_sig <= "1000";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00000010" => F3P_sig <= "0110"; F2P_sig <= "0010";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00000011" => F3P_sig <= "0101"; F2P_sig <= "0110";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00000100" => F3P_sig <= "0101"; F2P_sig <= "0000";F1P_sig <= "0000";F0P_sig <= "0000";
                when "00000101" => F3P_sig <= "0100"; F2P_sig <= "0011";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00000110" => F3P_sig <= "0011"; F2P_sig <= "0111";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00000111" => F3P_sig <= "0011"; F2P_sig <= "0001";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00001000" => F3P_sig <= "0010"; F2P_sig <= "0101";F1P_sig <= "0000";F0P_sig <= "0000";
                when "00001001" => F3P_sig <= "0001"; F2P_sig <= "1000";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00001010" => F3P_sig <= "0001"; F2P_sig <= "0010";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00001011" => F3P_sig <= "0000"; F2P_sig <= "0110";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00001100" => F3P_sig <= "0000"; F2P_sig <= "0000";F1P_sig <= "0000";F0P_sig <= "0000";
                when "00001101" => F3P_sig <= "1001"; F2P_sig <= "0011";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00001110" => F3P_sig <= "1000"; F2P_sig <= "0111";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00001111" => F3P_sig <= "1000"; F2P_sig <= "0001";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00010000" => F3P_sig <= "0111"; F2P_sig <= "0101";F1P_sig <= "0000";F0P_sig <= "0000";
                when others =>     F3P_sig <= "1110"; F2P_sig <= "1110";F1P_sig <= "1110";F0P_sig <= "1110";
            end case;
        end if;
        if temperature_sig(8) = '0' and F5C_sig = "1110" and F4C_sig = "1110" and F3C_sig = "0000" then
           case count_rem_sig is
                when "00000001" => F3P_sig <= "0110"; F2P_sig <= "1000";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00000010" => F3P_sig <= "0110"; F2P_sig <= "0010";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00000011" => F3P_sig <= "0101"; F2P_sig <= "0110";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00000100" => F3P_sig <= "0101"; F2P_sig <= "0000";F1P_sig <= "0000";F0P_sig <= "0000";
                when "00000101" => F3P_sig <= "0100"; F2P_sig <= "0011";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00000110" => F3P_sig <= "0011"; F2P_sig <= "0111";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00000111" => F3P_sig <= "0011"; F2P_sig <= "0001";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00001000" => F3P_sig <= "0010"; F2P_sig <= "0101";F1P_sig <= "0000";F0P_sig <= "0000";
                when "00001001" => F3P_sig <= "0001"; F2P_sig <= "1000";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00001010" => F3P_sig <= "0001"; F2P_sig <= "0010";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00001011" => F3P_sig <= "0000"; F2P_sig <= "0110";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00001100" => F3P_sig <= "0000"; F2P_sig <= "0000";F1P_sig <= "0000";F0P_sig <= "0000";
                when "00001101" => F3P_sig <= "0000"; F2P_sig <= "0110";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00001110" => F3P_sig <= "0001"; F2P_sig <= "0010";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00001111" => F3P_sig <= "0001"; F2P_sig <= "1000";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00010000" => F3P_sig <= "0010"; F2P_sig <= "0101";F1P_sig <= "0000";F0P_sig <= "0000";
                when others =>     F3P_sig <= "1110"; F2P_sig <= "1110";F1P_sig <= "1110";F0P_sig <= "1110";
            end case;
        end if;
        if temperature_sig(8) = '1' then
            case count_rem_sig is
                when "00000001" => F3P_sig <= "0011"; F2P_sig <= "0001";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00000010" => F3P_sig <= "0011"; F2P_sig <= "0111";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00000011" => F3P_sig <= "0100"; F2P_sig <= "0011";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00000100" => F3P_sig <= "0101"; F2P_sig <= "0000";F1P_sig <= "0000";F0P_sig <= "0000";
                when "00000101" => F3P_sig <= "0101"; F2P_sig <= "0110";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00000110" => F3P_sig <= "0110"; F2P_sig <= "0010";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00000111" => F3P_sig <= "0110"; F2P_sig <= "1000";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00001000" => F3P_sig <= "0111"; F2P_sig <= "0101";F1P_sig <= "0000";F0P_sig <= "0000";
                when "00001001" => F3P_sig <= "1000"; F2P_sig <= "0001";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00001010" => F3P_sig <= "1000"; F2P_sig <= "0111";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00001011" => F3P_sig <= "1001"; F2P_sig <= "0011";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00001100" => F3P_sig <= "0000"; F2P_sig <= "0000";F1P_sig <= "0000";F0P_sig <= "0000";
                when "00001101" => F3P_sig <= "0000"; F2P_sig <= "0110";F1P_sig <= "0010";F0P_sig <= "0101";
                when "00001110" => F3P_sig <= "0001"; F2P_sig <= "0010";F1P_sig <= "0101";F0P_sig <= "0000";
                when "00001111" => F3P_sig <= "0001"; F2P_sig <= "1000";F1P_sig <= "0111";F0P_sig <= "0101";
                when "00010000" => F3P_sig <= "0010"; F2P_sig <= "0101";F1P_sig <= "0000";F0P_sig <= "0000";
                when others =>     F3P_sig <= "1110"; F2P_sig <= "1110";F1P_sig <= "1110";F0P_sig <= "1110";
            end case;
        end if; 
    end process;

    
    BU : BUFT port map(
        I => BUFT_I_sig,
        T => out_line_BUFT_toggle_sig,
        O => BUFT_O_sig
    );
    
    TCS : Top_Comunications_Structure port map(
        clk         => clk,
        rst         => rst,
        ow_line_in  => ow_line_in,
        temperature => temperature_sig,
        count_rem   => count_rem_sig,
        --count_per_C => count_per_C,
        en_conv     => en_conv_sig,
        out_line_BUFT_toggle => out_line_BUFT_toggle_sig
     );
     
     DM : display_module port map( 
        rst         => rst,
        clk         => clk,      
        F0          => F0_sig,
        F1          => F1_sig,     
        F2          => F2_sig,     
        F3          => F3_sig,     
        F4          => F4_sig,    
        F5          => F5_sig,       
        F6          => F6_sig,     
        F7          => F7_sig,  
        dp_vector   => dp_vector_sig, 
        AN          => AN,
        BCD         => BCD,
        dp          => dp
    );
    
    MUX : CorF_MUX port map(
        sel         => sel,
        F0C         => F0C_sig,
        F1C         => F1C_sig,        
        F2C         => F2C_sig,        
        F3C         => F3C_sig,        
        F4C         => F4C_sig,        
        F5C         => F5C_sig,      
        F6C         => F6C_sig,         
        F7C         => F7C_sig,    
        dp_vectorC  => dp_vectorC_sig,
        F0F         => F0F_sig,     
        F1F         => F1F_sig,         
        F2F         => F2F_sig,        
        F3F         => F3F_sig,    
        F4F         => F4F_sig,      
        F5F         => F5F_sig,       
        F6F         => F6F_sig,        
        F7F         => F7F_sig,       
        dp_vectorF  => dp_vectorF_sig,
        F0P         => F0P_sig,     
        F1P         => F1P_sig,         
        F2P         => F2P_sig,        
        F3P         => F3P_sig,    
        F4P         => F4P_sig,      
        F5P         => F5P_sig,       
        F6P         => F6P_sig,        
        F7P         => F7P_sig,       
        dp_vectorP  => dp_vectorP_sig,
        F0          => F0_sig,         
        F1          => F1_sig,        
        F2          => F2_sig,         
        F3          => F3_sig,    
        F4          => F4_sig,        
        F5          => F5_sig,      
        F6          => F6_sig,        
        F7          => F7_sig,         
        dp_vector   => dp_vector_sig  
    );
  
    T2C : T2Cd_FSM port map(
        clk         => clk,    
        rst         => rst, 
        temperature => temperature_sig,
        en_conv     => en_conv_sig,    
        u           => F3C_sig,       
        d           => F4C_sig,   
        c           => F5C_sig,   
        sign        => F6C_sig,  
        decimal     => F2C_sig 
    );
    
    T2F : T2Fd_FSM port map(
        clk         => clk,
        rst         => rst,
        temperature => temperature_sig,
        en_conv     => en_conv_sig,
        --mem_num_o   => temperature,
        u           => F3F_sig,
        d           => F4F_sig,
        c           => F5F_sig,
        sign        => F6F_sig,
        decimal     => F2F_sig
    );
    
end Structural;
