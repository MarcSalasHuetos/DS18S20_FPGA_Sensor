-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity Englov_struct is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        b1          : in std_logic;
        b2          : in std_logic;
        led_ind     : out std_logic
    ) ;
end Englov_struct;

architecture Structural of Englov_struct is
--    COMPONENT ila_0

--        PORT (
--            clk : IN STD_LOGIC;
        
        
        
--            probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
--            probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
--            probe2 : IN STD_LOGIC_VECTOR(29 DOWNTO 0);
--            probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
--        );
--    END COMPONENT  ;
--    COMPONENT vio_0
--        PORT (
--            clk : IN STD_LOGIC;
--            probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
--            probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
--        );
--    END COMPONENT;
    component prove_FSM is
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
    end component;
    component TIMER_FSM is
        port (
            clk         : in std_logic;
            rst         : in std_logic;
            en          : in std_logic;
            --prescaler   : in std_logic_vector(14 downto 0);
            prescaler   : in std_logic_vector(29 downto 0);
            pg_out      : out std_logic
        ) ;
    end component;
    
    signal en_sig           : std_logic;
    signal prescaler_sig    : std_logic_vector(29 downto 0);
    signal pg_out_sig       : std_logic;
--    signal b1_sig           : std_logic;
--    signal b2_sig           : std_logic;
--    signal led_ind_sig      : std_logic;
    
begin
    p_FSM : prove_FSM port map(
        clk         => clk,
        rst         => rst,
        en          => en_sig,
        prescaler   => prescaler_sig,
        pg_out      => pg_out_sig,
--        led_ind     => led_ind_sig,
--        b1          => b1_sig,
--        b2          => b2_sig
        led_ind     => led_ind,
        b1          => b1,
        b2          => b2
    );
    T_FSM : TIMER_FSM port map(
        clk         => clk,
        rst         => rst,
        en          => en_sig,
        prescaler   => prescaler_sig,
        pg_out      => pg_out_sig
    );
    
--    your_instance_name : ila_0 PORT MAP (
--        clk => clk,
    
    
    
--        probe0(0) => en_sig, 
--        probe1(0) => pg_out_sig, 
--        probe2 => prescaler_sig,
--        probe3(0) => led_ind_sig
--    );
--    your_instance_name1 : vio_0 PORT MAP (
--        clk => clk,
--        probe_out0(0) => b1_sig,
--        probe_out1(0) => b2_sig
--    );
end Structural;
